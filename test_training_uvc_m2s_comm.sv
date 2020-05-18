//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_training_uvc_m2s_comm.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

//+UVM_TESTNAME=test_training_uvc_m2s_comm
`ifndef test_training_uvc_m2s_comm_SV
`define test_training_uvc_m2s_comm_SV

// example test
class test_training_uvc_m2s_comm extends test_training_uvc_m2s_base;
  
  // registration macro
  `uvm_component_utils(test_training_uvc_m2s_comm)

  // fields
  int num_of_trans = 34;

  // sequences
   training_uvc_rd_wr_vseq   my_rd_wr_vseq;
   

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_training_uvc_m2s_comm

// constructor
function test_training_uvc_m2s_comm::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void test_training_uvc_m2s_comm::build_phase(uvm_phase phase);
  super.build_phase( phase );

   my_rd_wr_vseq = training_uvc_rd_wr_vseq::type_id::create("my_rd_wr_vseq", this); 


endfunction : build_phase

// run phase
task test_training_uvc_m2s_comm::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  phase.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
   
  for (int i=0; i<num_of_trans; i++) 
      my_rd_wr_vseq.start(m_training_uvc_env_top.m_rd_wr_vseqr); 
           

      
  phase.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)
endtask : run_phase

// set default configuration
function void test_training_uvc_m2s_comm::set_default_configuration();
  super.set_default_configuration();

    s_cfg.m_training_uvc_cfg.m_agent_cfg.is_slave = 1;
    m_cfg.m_training_uvc_cfg.has_slave=1;
  // redefine configuration
  // TODO TODO TODO ???
endfunction : set_default_configuration

`endif // test_training_uvc_m2s_comm_SV
