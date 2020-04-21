//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_training_uvc_base.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_TRAINING_UVC_BASE_SV
`define TEST_TRAINING_UVC_BASE_SV

class test_training_uvc_base extends uvm_test;
  
  // registration macro
  `uvm_component_utils(test_training_uvc_base)
  
  // component instance
  training_uvc_env_top m_training_uvc_env_top;
  
  // configuration instance
  training_uvc_cfg_top m_cfg;
  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  // end_of_elaboration phase
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  // set default configuration
  extern virtual function void set_default_configuration();
    
endclass : test_training_uvc_base 

// constructor
function test_training_uvc_base::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void test_training_uvc_base::build_phase(uvm_phase phase);
  super.build_phase(phase);    
  
  // create component
  m_training_uvc_env_top = training_uvc_env_top::type_id::create("m_training_uvc_env_top", this);
   
  // create and set configuration
  m_cfg = training_uvc_cfg_top::type_id::create("m_cfg", this);
  set_default_configuration();
  
  // set configuration in DB
  uvm_config_db#(training_uvc_cfg_top)::set(this, "m_training_uvc_env_top", "m_cfg", m_cfg);

  // enable monitor item recording
  set_config_int("*", "recording_detail", 1);
  
  // define verbosity
  uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
endfunction : build_phase

// end_of_elaboration phase
function void test_training_uvc_base::end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);

  // allow additional time before stopping
  uvm_test_done.set_drain_time(this, 10us);
endfunction : end_of_elaboration_phase

// set default configuration
function void test_training_uvc_base::set_default_configuration();
  // define default configuration
  m_cfg.m_training_uvc_cfg.m_agent_cfg.m_is_active = UVM_ACTIVE;
  m_cfg.m_training_uvc_cfg.m_agent_cfg.m_has_checks = 1;
  m_cfg.m_training_uvc_cfg.m_agent_cfg.m_has_coverage = 1;
endfunction : set_default_configuration

`endif // TEST_TRAINING_UVC_BASE_SV
