//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_env_top.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_ENV_TOP_SV
`define TRAINING_UVC_ENV_TOP_SV

class training_uvc_env_top extends uvm_env;
  
  // registration macro
  `uvm_component_utils(training_uvc_env_top)

  // configuration reference
  training_uvc_cfg_top m_cfg;
  training_uvc_cfg_top s_cfg;
  // component instance
  training_uvc_env m_training_uvc_env;
  training_uvc_rd_wr_vseqr m_rd_wr_vseqr;

  
  // constructor
  extern function new(string name, uvm_component parent);
  // build phase
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass : training_uvc_env_top

// constructor
function training_uvc_env_top::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

// build phase
function void training_uvc_env_top::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // get configuration
  if(!uvm_config_db #(training_uvc_cfg_top)::get(this, "", "m_cfg", m_cfg)) begin
    `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
  end
   `ifdef M2S_MODE
        if(!uvm_config_db #(training_uvc_cfg_top)::get(this, "", "s_cfg", s_cfg)) begin
          `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
        end
        m_rd_wr_vseqr = training_uvc_rd_wr_vseqr::type_id::create("m_rd_wr_vseqr", this);
    `endif

  // set configuration
  uvm_config_db#(training_uvc_cfg)::set(this, "m_training_uvc_env", "m_cfg", m_cfg.m_training_uvc_cfg);
  `ifdef M2S_MODE
    uvm_config_db#(training_uvc_cfg)::set(this, "m_training_uvc_env", "s_cfg", s_cfg.m_training_uvc_cfg);
  `endif

  // create component
  m_training_uvc_env = training_uvc_env::type_id::create("m_training_uvc_env", this);
endfunction : build_phase


// build phase
function void training_uvc_env_top::connect_phase (uvm_phase phase);
  super.connect_phase(phase);
    `ifdef M2S_MODE
        m_rd_wr_vseqr.m_seqr = m_training_uvc_env.m_agent.m_sequencer;
        m_rd_wr_vseqr.s_seqr = m_training_uvc_env.s_agent.m_sequencer;
    `endif
endfunction : connect_phase 

`endif // TRAINING_UVC_ENV_TOP_SV
