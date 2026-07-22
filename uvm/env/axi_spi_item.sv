`ifndef AXI_SPI_ITEM_SV
`define AXI_SPI_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_spi_item extends uvm_sequence_item;
    // --- Randomized Fields (Inputs to DUT) ---
    rand bit [7:0] master_data;  // Master가 송신할 데이터 (slv_reg0)
    rand bit [7:0] slave_data;   // Dummy Slave가 송신할 데이터 (테스트 환경용)
    rand bit [7:0] clk_div_val;  // 클럭 분주비 (slv_reg1[15:8])
    rand bit       cpol_val;     // CPOL 설정 (slv_reg1[1])
    rand bit       cpha_val;     // CPHA 설정 (slv_reg1[2])

    // --- Non-randomized Fields (Outputs from DUT) ---
    bit [7:0] master_rx_val;     // Master가 최종 수신한 데이터 (slv_reg3)
    bit [7:0] slave_rx_val;      // Slave가 최종 수신한 데이터

    // --- Constraints ---
    constraint c_clk_div { clk_div_val inside {[2:100]}; }

    //constraint mode0_only_c {
    //    cpol_val == 1'b0;
    //    cpha_val == 1'b0;
    //}
    

    // --- UVM Field Macros ---
    `uvm_object_utils_begin(axi_spi_item)
        `uvm_field_int(master_data,   UVM_ALL_ON)
        `uvm_field_int(slave_data,    UVM_ALL_ON)
        `uvm_field_int(clk_div_val,   UVM_ALL_ON)
        `uvm_field_int(cpol_val,      UVM_ALL_ON)
        `uvm_field_int(cpha_val,      UVM_ALL_ON)
        `uvm_field_int(master_rx_val, UVM_ALL_ON)
        `uvm_field_int(slave_rx_val,  UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "axi_spi_item");
        super.new(name);
    endfunction

    function string convert2string();
        return $sformatf("Mode(P:%b,A:%b) Div:%0d | M_TX:0x%h, S_TX:0x%h | M_RX:0x%h, S_RX:0x%h", 
                         cpol_val, cpha_val, clk_div_val, 
                         master_data, slave_data, 
                         master_rx_val, slave_rx_val);
    endfunction
endclass

`endif