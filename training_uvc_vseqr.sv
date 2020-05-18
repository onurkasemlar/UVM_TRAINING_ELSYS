


`ifndef TRAINING_UVC_VSEQR_SV
`define TRAINING_UVC_VSEQR_SV





class training_uvc_rd_wr_vseqr extends uvm_sequencer;

    // registration macro
     `uvm_component_utils(training_uvc_rd_wr_vseqr)

      training_uvc_sequencer m_seqr;
      training_uvc_sequencer s_seqr;



  // constructor
    extern function new(string name, uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
endclass : training_uvc_rd_wr_vseqr


// constructor
function training_uvc_rd_wr_vseqr::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new



// build phase
function void training_uvc_rd_wr_vseqr::build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction : build_phase

`endif //TRAINING_UVC_VSEQR_SV