`ifndef AXI_SPI_SEQUENCE_SV
`define AXI_SPI_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_spi_item.sv"

class axi_spi_base_seq extends uvm_sequence#(axi_spi_item);
    `uvm_object_utils(axi_spi_base_seq)

    function new(string name = "axi_spi_base_seq");
        super.new(name);
    endfunction

    task do_transfer(bit [7:0] m_data, bit [7:0] s_data, bit [7:0] div = 8'd49, bit pol = 0, bit pha = 0);
        axi_spi_item item = axi_spi_item::type_id::create("item");
        start_item(item);
        if (!item.randomize() with { 
            master_data == m_data; 
            slave_data  == s_data;
            clk_div_val == div;
            cpol_val    == pol;
            cpha_val    == pha;
        }) `uvm_fatal(get_type_name(), "Randomize FAIL!")
        finish_item(item);
    endtask
endclass

// ==========================================
// Scenario 1: Sanity & Random Data
// ==========================================
class axi_spi_sanity_seq extends axi_spi_base_seq;
    `uvm_object_utils(axi_spi_sanity_seq)
    int num_loop = 20;

    function new(string name = "axi_spi_sanity_seq");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Scenario: Sanity Random Test Start", UVM_LOW)
        repeat(num_loop) begin
            axi_spi_item item = axi_spi_item::type_id::create("item");
            start_item(item);
            if (!item.randomize()) `uvm_fatal(get_type_name(), "Randomize FAIL!")
            finish_item(item);
        end
    endtask
endclass

// (이외에 Mode Sweep, Stress 시퀀스 등도 기존 코드를 그대로 복사하시고 
// 클래스 이름만 axi_spi_mode_sweep_seq 등으로 바꿔주시면 완벽합니다!)

`endif