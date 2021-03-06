//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_training_uvc_wr.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef test_training_uvc_wr_SV
`define test_training_uvc_wr_SV

// example test
//+UVM_TESTNAME=test_training_uvc_wr
class test_training_uvc_wr extends test_training_uvc_base;
  
  // registration macro
  `uvm_component_utils(test_training_uvc_wr)

  // fields
  int num_of_trans = 25;
  rand bit[31:0]    t_pwdata;

/*************************************************************************
*  PPT3 - LAB2 
*  Bonus:
*    From dedicated test (test_training_uvc_wr.sv ) send 25 simplified 
*    APB protocol write transactions to the DUT with pwdata containing 
*    only hex number letters (i.e. A,B,C,D,E,F)
**************************************************************************/
  
  constraint t_pwdata_c
                    {
                      t_pwdata >= 32'hA;
                      t_pwdata <= 32'hF;
                    }
  // sequences
  m_wr_uvc_seq m_seq;

  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_training_uvc_wr

// constructor
function test_training_uvc_wr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void test_training_uvc_wr::build_phase(uvm_phase phase);
  super.build_phase( phase );
endfunction : build_phase

// run phase
task test_training_uvc_wr::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  phase.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
   m_seq = m_wr_uvc_seq::type_id::create("m_seq", this); 

  for (int i=0; i<num_of_trans; i++) 
  begin  
    if(!this.randomize()) // randomize t_pwdata
       `uvm_fatal(get_type_name(), "Failed to randomize this.")

    if(!m_seq.randomize() with{m_seq.s_pwdata == t_pwdata; }) 
        begin
          `uvm_fatal(get_type_name(), "Failed to randomize.")
        end    
        m_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);
  end//for 
      
  phase.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)
endtask : run_phase

// set default configuration
function void test_training_uvc_wr::set_default_configuration();
  super.set_default_configuration();

  // redefine configuration
  // TODO TODO TODO ???
endfunction : set_default_configuration

`endif // test_training_uvc_wr_SV
