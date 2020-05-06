//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_cov.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_COV_SV
`define TRAINING_UVC_COV_SV

class training_uvc_cov extends uvm_subscriber #(training_uvc_item);
  
  // registration macro
  `uvm_component_utils(training_uvc_cov)
  
  // configuration reference
  training_uvc_agent_cfg m_cfg;
  training_uvc_item m_item;
  // virtual interface reference
  virtual interface training_uvc_if m_vif;
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


  
  // constructor
  extern function new(string name, uvm_component parent);
  // analysis implementation port function
  extern virtual function void write(training_uvc_item t);

endclass : training_uvc_cov

// constructor
function training_uvc_cov::new(string name, uvm_component parent);
  super.new(name, parent);
	// TODO TODO TODO
  training_uvc_cg = new();
  training_uvc_reset_cg = new();
  training_uvc_cg.set_inst_name("training_uvc_cg");
  training_uvc_reset_cg.set_inst_name("training_uvc_reset_cg");
endfunction : new

// analysis implementation port function
function void training_uvc_cov::write(training_uvc_item t);
	// TODO TODO TODO
  //sample coverage:
   m_item = t;
    training_uvc_cg.sample();
     `uvm_info(get_type_name(), $sformatf("COV : Coverage Sampled!"), UVM_MEDIUM)
     `uvm_info(get_type_name(), $sformatf("COV : Coverage Sampled! paddr: %h", m_item.paddr), UVM_MEDIUM)
endfunction : write

`endif // TRAINING_UVC_COV_SV
