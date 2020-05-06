`ifndef TRAINING_UVC_SCOREBOARD_SV
`define TRAINING_UVC_SCOREBOARD_SV








class training_uvc_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(training_uvc_scoreboard)

    training_uvc_item loc_item;

    uvm_analysis_export #(training_uvc_item) m_aexport_in;
    uvm_analysis_export #(training_uvc_item) m_aexport_out;

    protected uvm_tlm_analysis_fifo #(training_uvc_item) m_afifo_in;
    protected uvm_tlm_analysis_fifo #(training_uvc_item) m_afifo_out;



    // constructor  
    extern function new(string name, uvm_component parent);

    extern virtual function void build_phase   (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual task          run_phase     (uvm_phase phase);

endclass : training_uvc_scoreboard





// constructor
function training_uvc_scoreboard::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new




function void training_uvc_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);

  m_aexport_in   =  new("m_aexport_in"  , this);
  m_aexport_out  =  new("m_aexport_out" , this);

  m_afifo_in  =  new("m_afifo_in" , this);
  m_afifo_out =  new("m_afifo_out", this);

  loc_item =  training_uvc_item::type_id::create("loc_item", this);

endfunction : build_phase




function void training_uvc_scoreboard::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  m_aexport_in.connect(m_afifo_in.analysis_export);
  m_aexport_out.connect(m_afifo_out.analysis_export);

endfunction : connect_phase





// connect phase
task training_uvc_scoreboard::run_phase(uvm_phase phase);
  super.run_phase(phase);
  
  forever begin
    
    m_afifo_in.get(loc_item);

    `uvm_info(get_type_name(), "######################################", UVM_HIGH)
    `uvm_info(get_type_name(), "######################################", UVM_HIGH)
    `uvm_info(get_type_name(), "######################################", UVM_HIGH)
    `uvm_info(get_type_name(), "SCOREBOARD IS RUNNING!! YEEEEAAAYY!!", UVM_HIGH)
    `uvm_info(get_type_name(), $sformatf("loc_item: \n%s", loc_item.sprint()), UVM_HIGH)
    `uvm_info(get_type_name(), "######################################", UVM_HIGH)
    `uvm_info(get_type_name(), "######################################", UVM_HIGH)
    `uvm_info(get_type_name(), "######################################", UVM_HIGH)   
  end

endtask : run_phase



`endif // TRAINING_UVC_SCOREBOARD_SV
