//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_monitor.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_MONITOR_SV
`define TRAINING_UVC_MONITOR_SV

class training_uvc_monitor extends uvm_monitor;

  int tr_counter = 0;
  
  // registration macro
  `uvm_component_utils(training_uvc_monitor)
  
  // analysis port
  uvm_analysis_port #(training_uvc_item) m_aport;
  
  // virtual interface reference
  virtual interface training_uvc_if m_vif;
  
  // configuration reference
  training_uvc_agent_cfg m_cfg;
  
  // monitor item
  training_uvc_item m_item;
  training_uvc_item m_item_cloned;  // secure the data by cloning, so scoreboard is not affected by changes.
  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // handle reset
  extern virtual task handle_reset();
  // collect item
  extern virtual task collect_item();
  // print item
  extern virtual function void print_item(training_uvc_item item);

  // coverage fields 
  // TODO TODO TODO
  
  // coverage groups
  // TODO TODO TODO

/*************************************************************************
*  PPT4 - LAB2 - Part II
*      Implement coverage for simplified APB protocol (picture below):
*      Fill TODO sections of training_uvc_monitor.sv
*      Define transaction cover group that will cover relevant info about received transactions (ranges and/or cross coverage can be used were necessary)
**************************************************************************/
  covergroup training_uvc_cg;

    cov_operation: coverpoint m_item.pwrite
                  {
                    bins pwrite_wr = {WRITE};
                    bins pwrite_rd = {READ};
                  }

    cov_addr     : coverpoint m_item.paddr
                  {
                    option.auto_bin_max=32;
                  }
    
    cov_op_cross_addr: cross cov_operation, cov_addr;

  endgroup : training_uvc_cg 
  

  
/*************************************************************************
*  PPT4 - LAB2 - Part II
*      Bonus:
*       Define, implement and sample cover group for reset signal
**************************************************************************/
 covergroup training_uvc_reset_cg @(posedge m_vif.PCLK);
    cov_rst: coverpoint m_vif.PRESETn
                  {
                    bins rst_asserted   = {0};
                    bins rst_deasserted = {1};
                  }
  endgroup : training_uvc_reset_cg 


endclass : training_uvc_monitor

// constructor
function training_uvc_monitor::new(string name, uvm_component parent);
  super.new(name, parent);
  // TODO TODO TODO create cover groups
  training_uvc_cg = new();
  training_uvc_reset_cg = new();
  training_uvc_cg.set_inst_name("training_uvc_cg");
  training_uvc_reset_cg.set_inst_name("training_uvc_reset_cg");
endfunction : new

// build phase
function void training_uvc_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // create port
  m_aport = new("m_aport", this);
  
  // create item
  m_item = training_uvc_item::type_id::create("m_item", this);
  m_item_cloned = training_uvc_item::type_id::create("m_item_cloned", this);
endfunction : build_phase

// connect phase
task training_uvc_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  forever begin
    fork : run_phase_fork_block
      begin
        handle_reset();
      end
      begin
        collect_item();    
      end
    join_any // run_phase_fork_block
    disable fork;
  end
endtask : run_phase

// handle reset
task training_uvc_monitor::handle_reset();
  // wait reset assertion
  // TODO TODO TODO remove next line if necessary
  @(posedge m_vif.PRESETn);

  `uvm_info(get_type_name(), "Reset asserted.", UVM_HIGH)
endtask : handle_reset





/*************************************************************************
*  PPT4 - LAB2 - Part II
*      Fill TODO sections of training_uvc_monitor.sv
*      Reconstruct sequence items (transactions) from protocol signals
*      Compare received transactions with one being sent through driver
**************************************************************************/


// collect item
task training_uvc_monitor::collect_item();  
  // wait until reset is de-asserted
  // TODO TODO TODO
  `uvm_info(get_type_name(), "Reset de-asserted. Starting to collect items...", UVM_HIGH)
  
  forever begin    
    // wait signal change
    // TODO TODO TODO remove next line if necessary
    //@(posedge m_vif.PCLK && m_vif.PRESETn == 1'b1)
    @(posedge m_vif.PREADY)


    // collect item
    // TODO TODO TODO
    m_item.paddr  = m_vif.PADDR;
    m_item.pwrite = m_vif.PWRITE;
    m_item.pwdata = m_vif.PWDATA;
    m_item.prdata = m_vif.PRDATA;

    // print item
    // TODO TODO TODO
    this.print_item(m_item);
     `uvm_info(get_type_name(), $sformatf("MON: Transaction Counter: %d", ++tr_counter), UVM_MEDIUM)
    

    // sample coverage 
    // TODO TODO TODO
    
    // write analysis port
    // secure the data by cloning, so scoreboard is not affected by possible modifications.
    $cast(m_item_cloned, m_item.clone());
    m_aport.write(m_item_cloned);  

    //sample coverage:
    training_uvc_cg.sample();

  end // forever begin  
endtask : collect_item

// print item
function void training_uvc_monitor::print_item(training_uvc_item item);
  `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", item.sprint()), UVM_HIGH)
endfunction : print_item

`endif // TRAINING_UVC_MONITOR_SV