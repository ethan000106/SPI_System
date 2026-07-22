`timescale 1ns / 1ps

module SPI_slave(
    input  logic       clk,      // System Clock (Reset용)
    input  logic       reset,    // Active High Reset
    input  logic       cpol,
    input  logic       cpha,
    input  logic [7:0] tx_data,  // Slave가 Master로 보낼 데이터
    input  logic       sclk,
    input  logic       mosi,
    input  logic       cs_n,
    output logic       miso,
    output logic [7:0] rx_data,  // Slave가 수신한 데이터
    output logic       done      // 수신 완료 펄스
);

    logic [2:0] bit_cnt;
    logic [7:0] shift_reg;
    
    // SPI 모드에 따른 샘플링 엣지 결정
    // CPOL=0, CPHA=0 -> posedge sclk
    // CPOL=0, CPHA=1 -> negedge sclk
    // CPOL=1, CPHA=0 -> negedge sclk
    // CPOL=1, CPHA=1 -> posedge sclk
    wire sample_clk = (cpol ^ cpha) ? 1'b0 : 1'b1; // 1이면 posedge, 0이면 negedge

    // ---------------------------------------------------------
    // 1. MOSI 샘플링 (Master -> Slave 수신)
    // ---------------------------------------------------------
    // cs_n이 High일 때 비동기 리셋되어 매번 새로운 전송을 준비함
    always_ff @(posedge sclk or posedge cs_n) begin
    if (cs_n) begin
        bit_cnt   <= 0;
        shift_reg <= 0;
        done      <= 0;
        // 💡 rx_data <= 0;  <-- 이 줄을 삭제하거나 주석 처리하여 데이터를 유지합니다.
    end else begin
        shift_reg <= {shift_reg[6:0], mosi};
        if (bit_cnt == 7) begin
            bit_cnt <= 0;
            rx_data <= {shift_reg[6:0], mosi};
            done    <= 1'b1;
        end else begin
            bit_cnt <= bit_cnt + 1;
        end
    end
end

    // ---------------------------------------------------------
    // 2. MISO 드라이빙 (Slave -> Master 송신)
    // ---------------------------------------------------------
    // 전송 엣지의 반대 엣지에서 데이터를 밀어내야 안정적입니다.
    logic [7:0] tx_load_reg;
    
    always_ff @(negedge sclk or posedge cs_n) begin
        if (cs_n) begin
            tx_load_reg <= tx_data;
            miso        <= tx_data[7];
        end else begin
            tx_load_reg <= {tx_load_reg[6:0], 1'b0};
            miso        <= tx_load_reg[6];
        end
    end

endmodule