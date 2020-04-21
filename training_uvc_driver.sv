//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_driver.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_DRIVER_SV
`define TRAINING_UVC_DRIVER_SV

class training_uvc_driver extends uvm_driver #(training_uvc_item);
  
  // registration macro
  `uvm_component_utils(training_uvc_driver)
  
  // virtual interface reference
  virtual interface training_uvc_if m_vif;
  
  // configuration reference
  training_uvc_agent_cfg m_cfg;
  
  // request item
  REQ m_req;
   
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // process item
  extern virtual task process_item(training_uvc_item item);

endclass : training_uvc_driver

// constructor
function training_uvc_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void training_uvc_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

// run phase
task training_uvc_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  // init signals
  // TODO TODO TODO  

  forever begin
    seq_item_port.get_next_item(m_req);
    process_item(m_req);
    seq_item_port.item_done();
  end
endtask : run_phase

// process item
task training_uvc_driver::process_item(training_uvc_item item);
  // print item
  //TODO TODO TODO
  `uvm_info(get_type_name(), $sformatf("Item to be driven: \n%s", item.sprint()), UVM_MEDIUM)
  
  // wait until reset is de-asserted
  // TODO TODO TODO
 // @(posedge m_vif.PRESETn)

  repeat(item.delay) begin
    @(posedge m_vif.PCLK);
  end
    
  // drive signals
  // TODO TODO TODO
  m_vif.PADDR  <= item.paddr;
  m_vif.PWRITE <= item.pwrite;
  m_vif.PWDATA <= item.pwdata;
  m_vif.PRDATA <= item.prdata;

  // wait for ack:
  @(posedge m_vif.PCLK && m_vif.PRESETn == 1'b1)
  while(m_vif.PREADY==1'b0)
      @(posedge m_vif.PCLK);
  


endtask : process_item

`endif // TRAINING_UVC_DRIVER_SV
