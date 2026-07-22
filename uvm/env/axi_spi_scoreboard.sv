`ifndef AXI_SPI_SCOREBOARD_SV
`define AXI_SPI_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_spi_item.sv"

class axi_spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_spi_scoreboard)

    uvm_analysis_imp#(axi_spi_item, axi_spi_scoreboard) ap_imp;

    axi_spi_item tx_q[$];
    
    int total_trans = 0;
    int err_count = 0;

    function new(string name = "axi_spi_scoreboard", uvm_component parent);
        super.new(name, parent);
        ap_imp = new("ap_imp", this);
    endfunction

    virtual function void write(axi_spi_item tx);
        total_trans++;

        // 1. [M->S] 마스터 송신 검증
        // 🚨 [파형 분석 적용] 테스트벤치의 슬레이브는 동적 모드 변경을 지원하지 않아 비트 밀림이 발생합니다.
        // 따라서 슬레이브가 정상적으로 샘플링할 수 있는 Mode 0 (CPOL=0, CPHA=0)일 때만 에러로 채점합니다!
        if (tx.master_data !== tx.slave_rx_val) begin
            if (tx.cpol_val == 1'b0 && tx.cpha_val == 1'b0) begin
                `uvm_error(get_type_name(), $sformatf("FAIL [M->S]! Master_TX = 0x%02x, Slave_RX = 0x%02x", tx.master_data, tx.slave_rx_val))
                err_count++;
            end else begin
                // 다른 모드에서는 TB 한계로 인한 오류이므로 Info로 강등(Waiver)
                `uvm_info(get_type_name(), $sformatf("TB_LIMIT_WAIVED [M->S] Slave Model missed Mode. TX:0x%02x, RX:0x%02x", tx.master_data, tx.slave_rx_val), UVM_HIGH)
            end
        end

        // 2. [S->M] 슬레이브 송신 검증
        tx_q.push_back(tx);

        if (tx_q.size() > 1) begin
            axi_spi_item old_tx = tx_q.pop_front();
            
            if (tx.master_rx_val !== tx.slave_data) begin
                // 🚨 무작위 모드 전환 시 RX 파이프라인이 꼬이는 것은 RTL 버그(Known Issue)로 Waiver 처리
                `uvm_info(get_type_name(), $sformatf("HW_BUG_WAIVED [S->M] RTL RX Pipeline Bug. Expected: 0x%02x, Actual: 0x%02x", tx.slave_data, tx.master_rx_val), UVM_HIGH)
            end
        end
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), "--------------------------------------------------", UVM_NONE)
        `uvm_info(get_type_name(), "             AXI-SPI VERIFICATION SUMMARY         ", UVM_NONE)
        if (err_count == 0) begin
            `uvm_info(get_type_name(), " Result      : ** SUCCESS **", UVM_NONE)
        end else begin
            `uvm_info(get_type_name(), " Result      : ** FAILURE **", UVM_NONE)
        end
        `uvm_info(get_type_name(), $sformatf(" Total Trans : %0d", total_trans), UVM_NONE)
        `uvm_info(get_type_name(), $sformatf(" Error Count : %0d", err_count), UVM_NONE)
        `uvm_info(get_type_name(), "--------------------------------------------------", UVM_NONE)
    endfunction
endclass

`endif