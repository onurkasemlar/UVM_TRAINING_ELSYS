


`ifndef TRAINING_UVC_VSEQ_SV
`define TRAINING_UVC_VSEQ_SV





class training_uvc_rd_wr_vseq extends uvm_sequence #(training_uvc_item);
    // registration macro
     `uvm_object_utils(training_uvc_rd_wr_vseq)

    // sequencer pointer macro
    `uvm_declare_p_sequencer(training_uvc_rd_wr_vseqr)


      // sequences
   training_uvc_seq   m_wr_seq;
   s_rspd_uvc_seq     s_rspd_seq;

    //seqr
   training_uvc_rd_wr_vseqr vseqr;

  // constructor
  extern function new(string name = "training_uvc_rd_wr_vseq");
  // body task
  extern virtual task body();

endclass : training_uvc_rd_wr_vseq





// constructor
function training_uvc_rd_wr_vseq::new(string name = "training_uvc_rd_wr_vseq");
  super.new(name);
endfunction : new


// body task
task training_uvc_rd_wr_vseq::body();

   m_wr_seq = training_uvc_seq::type_id::create("m_wr_seq"); 
   s_rspd_seq = s_rspd_uvc_seq::type_id::create("s_rspd_seq");  

    if(!m_wr_seq.randomize()) // randomize t_pwdata
       `uvm_fatal(get_type_name(), "Failed to randomize m_wr_seq.")

    if(!s_rspd_seq.randomize()) 
          `uvm_fatal(get_type_name(), "Failed to randomize s_rspd_seq.")
   

    fork
        begin
            m_wr_seq.start(p_sequencer.m_seqr);
        end
        begin
            s_rspd_seq.start(p_sequencer.s_seqr);
        end
    join

endtask : body




`endif //TRAINING_UVC_VSEQ_SV