`ifndef AXI_SPI_AGENT_SV
`define AXI_SPI_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_spi_item.sv"
`include "axi_spi_driver.sv"
`include "axi_spi_monitor.sv"

// Sequencer를 클래스로 따로 빼지 않고 깔끔하게 typedef로 정의합니다.
typedef uvm_sequencer#(axi_spi_item) axi_spi_sequencer;

class axi_spi_agent extends uvm_agent;
    `uvm_component_utils(axi_spi_agent)

    // 에이전트의 3대장
    axi_spi_driver    drv;
    axi_spi_monitor   mon;
    axi_spi_sequencer sqr;

    function new(string name = "axi_spi_agent", uvm_component parent);
        super.new(name, parent);
    endfunction

    // 💡 Build Phase: 하위 컴포넌트들 생성
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        drv = axi_spi_driver::type_id::create("drv", this);
        mon = axi_spi_monitor::type_id::create("mon", this);
        sqr = axi_spi_sequencer::type_id::create("sqr", this);
    endfunction

    // 💡 Connect Phase: 시퀀서의 포트와 드라이버의 포트를 연결
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        drv.seq_item_port.connect(sqr.seq_item_export);
        `uvm_info(get_type_name(), "Driver와 Sequencer 연결 완료", UVM_MEDIUM)
    endfunction

endclass

`endif