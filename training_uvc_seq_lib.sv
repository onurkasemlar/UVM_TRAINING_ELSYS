//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_seq_lib.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_SEQ_LIB_SV
`define TRAINING_UVC_SEQ_LIB_SV

class training_uvc_seq extends uvm_sequence #(training_uvc_item);
  
   // fields
  rand bit[31:0]    s_paddr;
  rand bit[31:0]    s_pwdata;
  rand pwrite_op_e  s_pwrite;
  rand int          s_delay;
  rand delay_kind_e s_delay_kind;  

  // registration macro
  `uvm_object_utils_begin(training_uvc_seq)
  	`uvm_field_int(s_paddr, UVM_DEFAULT)
  	`uvm_field_int(s_pwdata, UVM_DEFAULT)
    `uvm_field_int(s_delay, UVM_DEFAULT)
    `uvm_field_enum(pwrite_op_e, s_pwrite, UVM_DEFAULT)
    `uvm_field_enum(delay_kind_e, s_delay_kind, UVM_DEFAULT)
  `uvm_object_utils_end


  // sequencer pointer macro
  `uvm_declare_p_sequencer(training_uvc_sequencer)

  // constraints
    // constraints
  constraint s_delay_order_c {solve s_delay_kind before s_delay;}
  constraint s_delay_c 
  					        {
                      //Implement a delay ‘knob’ which you can later use to delay transaction in driver
                      (s_delay_kind == ZERO )  -> s_delay == 0;
                      (s_delay_kind == SHORT)  -> s_delay inside{[0:10]};
                      //Delay should be random value of  0 - 10 pclks
                  		soft s_delay >= 0;        
                  		soft s_delay <=10;     
                    }
  constraint s_paddr_c
                    {
                      //paddr should be byte address but word aligned (1 word is 4 bytes, think of writing/reading 4 bytes at once to/from byte memory)
                      s_paddr[1:0] == 2'b00;   
                      s_paddr >  32'h0;
                      s_paddr <= 32'hFFFF_FFFF;  
                    }
  constraint s_write_c
                    {
                      //Write is always with wait states
                      (s_pwrite == WRITE) -> s_delay > 0;     
                    }
  
  // constructor
  extern function new(string name = "training_uvc_seq");
  // body task
  extern virtual task body();

endclass : training_uvc_seq





/*************************************************************************
*  PPT3 - LAB1
*  Implement APB sequence library:
*     - Master write sequence
**************************************************************************/

/*************************************************************************
*  PPT3 - LAB2
*     - Fill TODO sections of training_uvc_seq_lib.sv and training_uvc_driver.sv 
*     - Observe signals on the waveform to see weather transactions are being
*       sent according to protocol and with random delay in pclk numbers.
*     - Use additional constraints in sequence to narrow paddr signal values 
*       to less than 32’hFF. Again observe signals on waveform
**************************************************************************/


/*class m_wr_uvc_seq extends uvm_sequence #(training_uvc_item);*/
class m_wr_uvc_seq extends training_uvc_seq;
    // registration macro
     `uvm_object_utils(m_wr_uvc_seq)

    // sequencer pointer macro
    `uvm_declare_p_sequencer(training_uvc_sequencer)



  constraint bonus_s_paddr_c
                    {
                     // PPT03_Lab2: Use additional constraints in sequence to narrow paddr signal values 
                     //to less than 32’hFF. Again observe signals on waveform
                      soft s_paddr <= 32'hFF;  
                    }
   constraint s_pwrite_c
                    {s_pwrite == WRITE;}

  // constructor
  extern function new(string name = "m_wr_uvc_seq");
  // body task
  extern virtual task body();

endclass : m_wr_uvc_seq




/*************************************************************************
*  PPT3 - LAB1
*  Implement APB sequence library:
*     - Master read sequence
**************************************************************************/

class m_rd_uvc_seq extends training_uvc_seq;
  
  // registration macro
  `uvm_object_utils(m_rd_uvc_seq)
  
  // sequencer pointer macro
  `uvm_declare_p_sequencer(training_uvc_sequencer)
  
  // constraints
  constraint s_pwrite_c
                    {s_pwrite == READ;}
  
  constraint s_delay_c
                    {
                       s_delay_kind == ZERO;    
                    }
  
  // constructor
  extern function new(string name = "m_rd_uvc_seq");
  // body task
  extern virtual task body();

endclass : m_rd_uvc_seq






/*************************************************************************
*  PPT3 - LAB1
*  Implement APB sequence library:
*     - Slave responder sequence
**************************************************************************/

class s_rspd_uvc_seq extends uvm_sequence #(training_uvc_item);
    
  // fields
  rand bit[31:0]    s_prdata; 

  // registration macro
  `uvm_object_utils_begin(s_rspd_uvc_seq)
  	`uvm_field_int(s_prdata, UVM_DEFAULT)
  `uvm_object_utils_end

  
  
  // constraints
  // TODO TODO TODO
  constraint experimenting_s_prdata_c
                    {                    
                      s_prdata <= 32'hFF; 
                      s_prdata >= 32'hFA;  
                    }
  
  // constructor
  extern function new(string name = "s_rspd_uvc_seq");
  // body task
  extern virtual task body();

endclass : s_rspd_uvc_seq



















/***************************************************
*
*              training_uvc_seq
*
***************************************************/

// constructor
function training_uvc_seq::new(string name = "training_uvc_seq");
  super.new(name);
endfunction : new

// body task
task training_uvc_seq::body();
  req = training_uvc_item::type_id::create("req");
  
  start_item(req);
  
  if(!req.randomize() with {
                              paddr  == s_paddr; 
                              pwdata == s_pwdata; 
                              pwrite == s_pwrite; 
  }) begin
    `uvm_fatal(get_type_name(), "Failed to randomize.")
  end  
  
  finish_item(req);

endtask : body


/***************************************************
*
*              m_wr_uvc_seq
*
***************************************************/
// constructor
function m_wr_uvc_seq::new(string name = "m_wr_uvc_seq");
  super.new(name);
endfunction : new

// body task
task m_wr_uvc_seq::body();
  req = training_uvc_item::type_id::create("req");
  
  start_item(req);
  
  if(!req.randomize() with {
                              paddr  == s_paddr; 
                              pwdata == s_pwdata; 
                              pwrite == s_pwrite; 
  }) begin
    `uvm_fatal(get_type_name(), "Failed to randomize.")
  end  
  
  finish_item(req);

endtask : body



/***************************************************
*
*              m_rd_uvc_seq
*
***************************************************/
// constructor
function m_rd_uvc_seq::new(string name = "m_rd_uvc_seq");
  super.new(name);
endfunction : new

// body task
task m_rd_uvc_seq::body();
  req = training_uvc_item::type_id::create("req");
  
  start_item(req);
  
  if(!req.randomize() with {
                              paddr  == s_paddr; 
                              pwrite == s_pwrite;  
  }) begin
    `uvm_fatal(get_type_name(), "Failed to randomize.")
  end  
  
  finish_item(req);

endtask : body




/***************************************************
*
*              s_rspd_uvc_seq
*
***************************************************/
// constructor
function s_rspd_uvc_seq::new(string name = "s_rspd_uvc_seq");
  super.new(name);
endfunction : new

// body task
task s_rspd_uvc_seq::body();
  req = training_uvc_item::type_id::create("req");
  
  start_item(req);
  
  if(!req.randomize() with { prdata == s_prdata; }) begin
    `uvm_fatal(get_type_name(), "Failed to randomize.")
  end  
  
  finish_item(req);

endtask : body


`endif // TRAINING_UVC_SEQ_LIB_SV
