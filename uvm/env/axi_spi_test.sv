`ifndef AXI_SPI_TEST_SV
`define AXI_SPI_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_spi_env.sv"
`include "axi_spi_sequence.sv"

// ==========================================
// 1. Base Test (모든 테스트의 부모)
// ==========================================
class axi_spi_base_test extends uvm_test;
    `uvm_component_utils(axi_spi_base_test)
    
    axi_spi_env env;

    function new(string name = "axi_spi_base_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi_spi_env::type_id::create("env", this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "============= UVM 계층 구조 (AXI-SPI) ===========", UVM_MEDIUM)
        uvm_top.print_topology();
    endfunction
endclass

// ==========================================
// 2. Sanity Test (기본 랜덤 테스트)
// ==========================================
class axi_spi_sanity_test extends axi_spi_base_test;
    `uvm_component_utils(axi_spi_sanity_test)

    function new(string name = "axi_spi_sanity_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        axi_spi_sanity_seq seq;
        phase.raise_objection(this);
        
        seq = axi_spi_sanity_seq::type_id::create("seq");
        seq.num_loop = 1000; // 시뮬레이션 속도에 따라 조절
        
        `uvm_info(get_type_name(), "AXI-SPI Sanity Test 시작...", UVM_LOW)
        seq.start(env.agt.sqr); 
        
        phase.drop_objection(this);
    endtask
endclass

// (필요에 따라 mode_sweep_test, stress_test 등도 
// 기존 코드처럼 base_test를 상속받아 추가해주시면 됩니다!)

`endif