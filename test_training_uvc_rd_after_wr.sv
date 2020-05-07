//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_training_uvc_rd_after_wr.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef test_training_uvc_rd_after_wr_SV
`define test_training_uvc_rd_after_wr_SV

// example test
//+UVM_TESTNAME=test_training_uvc_rd_after_wr
class test_training_uvc_rd_after_wr extends test_training_uvc_base;
  
  // registration macro
  `uvm_component_utils(test_training_uvc_rd_after_wr)

  // fields
  int num_of_trans = 40;
  rand bit[31:0]    t_paddr_1;
  rand bit[31:0]    t_paddr_2;

/*************************************************************************
*  PPT3 - LAB2 
*  Bonus:
*    From dedicated test (test_training_uvc_rd_after_wr.sv ) send 25 simplified 
*    APB protocol write transactions to the DUT with pwdata containing 
*    only hex number letters (i.e. A,B,C,D,E,F)
**************************************************************************/
  
  constraint t_paddr_c
                    {
                      //paddr should be byte address but word aligned (1 word is 4 bytes, think of writing/reading 4 bytes at once to/from byte memory)
                      t_paddr_1[1:0] == 2'b00;   
                      t_paddr_1 >  32'h0;
                      t_paddr_1 <= 32'hFFFF_FFFF;  

                      t_paddr_2[1:0] == 2'b00;   
                      t_paddr_2 >  32'h0;
                      t_paddr_2 <= 32'hFFFF_FFFF;  
                    }
  // sequences
  m_wr_uvc_seq m_wr_seq;
  m_rd_uvc_seq m_rd_seq;
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern function void build_phase(uvm_phase phase);
  // run phase
  extern virtual task run_phase(uvm_phase phase);
  // set default configuration
  extern function void set_default_configuration();
  
endclass : test_training_uvc_rd_after_wr

// constructor
function test_training_uvc_rd_after_wr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void test_training_uvc_rd_after_wr::build_phase(uvm_phase phase);
  super.build_phase( phase );
endfunction : build_phase

// run phase
task test_training_uvc_rd_after_wr::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  phase.raise_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
   m_wr_seq = m_wr_uvc_seq::type_id::create("m_wr_seq", this); 
   m_rd_seq = m_rd_uvc_seq::type_id::create("m_rd_seq", this); 

  for (int i=0; i<num_of_trans; i++) 
  begin  
    if(!this.randomize() ) // randomize t_pwdata
       `uvm_fatal(get_type_name(), "Failed to randomize this.")

    if(!m_wr_seq.randomize() with{m_wr_seq.s_paddr == t_paddr_1; }) 
          `uvm_fatal(get_type_name(), "Failed to randomize m_wr_seq.")
    m_wr_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);

    if(!m_wr_seq.randomize() with{m_wr_seq.s_paddr == t_paddr_2; }) 
          `uvm_fatal(get_type_name(), "Failed to randomize m_wr_seq.")
    m_wr_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);

    if(!m_rd_seq.randomize() with{m_rd_seq.s_paddr == t_paddr_1; }) 
          `uvm_fatal(get_type_name(), "Failed to randomize m_rd_seq.")
    m_rd_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);

    if(!m_rd_seq.randomize() with{m_rd_seq.s_paddr == t_paddr_2; }) 
          `uvm_fatal(get_type_name(), "Failed to randomize m_rd_seq.")
    m_rd_seq.start(m_training_uvc_env_top.m_training_uvc_env.m_agent.m_sequencer);

  end//for 
      
  phase.drop_objection(this, get_type_name());    
  `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW)
endtask : run_phase

// set default configuration
function void test_training_uvc_rd_after_wr::set_default_configuration();
  super.set_default_configuration();

  // redefine configuration
  // TODO TODO TODO ???
endfunction : set_default_configuration

`endif // test_training_uvc_rd_after_wr_SV
