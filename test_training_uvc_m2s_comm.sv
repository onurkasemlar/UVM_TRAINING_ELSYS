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
  int num_of_trans = 30;

  // sequences
   training_uvc_seq   m_wr_seq;
   s_rspd_uvc_seq s_rspd_seq;
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
endfunction : build_phase

// run phase
task test_training_uvc_m2s_comm::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  phase.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
   m_wr_seq = training_uvc_seq::type_id::create("m_wr_seq", this); 
   s_rspd_seq = s_rspd_uvc_seq::type_id::create("s_rspd_seq", this);  

  for (int i=0; i<num_of_trans; i++) 
  begin  
    if(!this.randomize()) // randomize t_pwdata
       `uvm_fatal(get_type_name(), "Failed to randomize this.")

    if(!m_wr_seq.randomize() && !s_rspd_seq.randomize()) 
        begin
          `uvm_fatal(get_type_name(), "Failed to randomize.")
        end    

    fork
        begin
            m_wr_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);
        end
        begin
            s_rspd_seq.start(m_training_uvc_env_top.m_training_uvc_env.s_agent.m_sequencer);
        end
    join
        
  end//for 
      
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
