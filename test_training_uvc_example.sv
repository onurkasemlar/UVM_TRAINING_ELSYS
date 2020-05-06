//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_training_uvc_example.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_TRAINING_UVC_EXAMPLE_SV
`define TEST_TRAINING_UVC_EXAMPLE_SV

// example test
class test_training_uvc_example extends test_training_uvc_base;
  
  // registration macro
  `uvm_component_utils(test_training_uvc_example)

  // fields
  int num_of_trans = 25;
  rand bit[31:0]    t_pwdata;

/*************************************************************************
*  PPT3 - LAB2 
*  Bonus:
*    From dedicated test (test_training_uvc_example.sv ) send 25 simplified 
*    APB protocol write transactions to the DUT with pwdata containing 
*    only hex number letters (i.e. A,B,C,D,E,F)
**************************************************************************/
  
  constraint t_pwdata_c
                    {
                      t_pwdata >= 32'hA;
                      t_pwdata <= 32'hF;
                    }
  // sequences
  training_uvc_seq m_seq;
  s_rspd_uvc_seq   s_seq;
  //m_wr_uvc_seq m_seq;

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_training_uvc_example

// constructor
function test_training_uvc_example::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void test_training_uvc_example::build_phase(uvm_phase phase);
  super.build_phase( phase );
  set_type_override_by_type(training_uvc_seq::get_type(), m_wr_uvc_seq::get_type());
endfunction : build_phase

// run phase
task test_training_uvc_example::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  phase.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
  if(!m_cfg.m_training_uvc_cfg.m_agent_cfg.is_slave)
    m_seq = training_uvc_seq::type_id::create("m_seq", this);
  else
    s_seq = s_rspd_uvc_seq::type_id::create("s_seq", this);
  //m_seq = m_wr_uvc_seq::type_id::create("m_seq", this);

  for (int i=0; i<num_of_trans; i++) 
  begin  
    if(!this.randomize()) // randomize t_pwdata
       `uvm_fatal(get_type_name(), "Failed to randomize this.")

    if(!m_cfg.m_training_uvc_cfg.m_agent_cfg.is_slave)
    begin
        if(!m_seq.randomize() with{m_seq.s_pwdata == t_pwdata; }) 
        begin
          `uvm_fatal(get_type_name(), "Failed to randomize.")
        end    
        m_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);
    end //if 
    else
    begin
      if(!s_seq.randomize()) 
        begin
          `uvm_fatal(get_type_name(), "Failed to randomize.")
        end    
        s_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);
    end
  end//for 
      
  phase.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)
endtask : run_phase

// set default configuration
function void test_training_uvc_example::set_default_configuration();
  super.set_default_configuration();
  
  m_cfg.m_training_uvc_cfg.m_agent_cfg.is_slave = 0;
  // redefine configuration
  // TODO TODO TODO ???
endfunction : set_default_configuration

`endif // TEST_TRAINING_UVC_EXAMPLE_SV
