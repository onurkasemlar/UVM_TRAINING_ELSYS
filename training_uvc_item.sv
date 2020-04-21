//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_item.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_ITEM_SV
`define TRAINING_UVC_ITEM_SV

 typedef enum bit {READ, WRITE} pwrite_op_e;
 typedef enum     {ZERO, SHORT} delay_kind_e;

class training_uvc_item extends uvm_sequence_item;
  
 
  
  // item fields
  //rand bit          reset; //To be used later.
  rand bit[31:0]    paddr;
  rand bit[31:0]    pwdata;
  rand pwrite_op_e  pwrite;
       bit[31:0]    prdata; 
  rand int          delay;
  rand delay_kind_e delay_kind;    
  
  
  
  
  // registration macro
  // TODO: register needed fields instead of dummy one
  `uvm_object_utils_begin(training_uvc_item)
  	`uvm_field_int(paddr, UVM_DEFAULT)
  	`uvm_field_int(pwdata, UVM_DEFAULT)
  	`uvm_field_int(prdata, UVM_DEFAULT)
    //`uvm_field_int(reset, UVM_DEFAULT)
  	`uvm_field_int(delay, UVM_DEFAULT)
     `uvm_field_enum(pwrite_op_e, pwrite, UVM_DEFAULT)
    `uvm_field_enum(delay_kind_e, delay_kind, UVM_DEFAULT)
  `uvm_object_utils_end
  
/*****************************************************************************************************************************************
*  PPT2 - LAB2
*  Implement constraints:
*    paddr should be byte address but word aligned (1 word is 4 bytes, think of writing/reading 4 bytes at once to/from byte memory)
*    Delay should be random value of  0 - 10 pclks
*    Write should always have wait states
*****************************************************************************************************************************************/

  // constraints
  constraint delay_order_c {solve delay_kind before delay;}
  constraint delay_c 
  					        {
                      //Implement a delay ‘knob’ which you can later use to delay transaction in driver
                      (delay_kind == ZERO )  -> delay == 0;
                      (delay_kind == SHORT)  -> delay inside{[0:10]};
                      //Delay should be random value of  0 - 10 pclks
                  		soft delay >= 0;        
                  		soft delay <=10;     
                    }
  constraint paddr_c
                    {
                      //paddr should be byte address but word aligned (1 word is 4 bytes, think of writing/reading 4 bytes at once to/from byte memory)
                      paddr[1:0] == 2'b00;   
                      paddr >  32'h0;
                      paddr <= 32'hFFFF_FFFF;  
                    }
  constraint write_c
                    {
                      //Write is always with wait states
                      (pwrite == WRITE) -> delay > 0;     
                    }

    


  // constructor  
  extern function new(string name = "training_uvc_item");
  
endclass : training_uvc_item

// constructor
function training_uvc_item::new(string name = "training_uvc_item");
  super.new(name);
endfunction : new










/*************************************************************************
*  PPT2 - LAB2
*  Create a new class of items that will be always have data that is odd
**************************************************************************/

class onur_oddData_uvc_item extends training_uvc_item;  
 // registration macro
  `uvm_object_utils(onur_oddData_uvc_item)

 constraint pwdata_c
                    {
                      //Create a new class of items that will be always have data that is odd
                      (pwdata %2 == 1);     
                    }


   extern function new(string name = "onur_oddData_uvc_item");
endclass : onur_oddData_uvc_item

function onur_oddData_uvc_item::new(string name = "onur_oddData_uvc_item");
  super.new(name);
endfunction : new


/*
  In BUILD_PHASE:
  set_type_override_by_type(training_uvc_item::get_type(), onur_oddData_uvc_item::get_type());
function void test_training_uvc_example::build_phase(uvm_phase phase);
  super.build_phase( phase );
  set_type_override_by_type(training_uvc_item::get_type(), onur_oddData_uvc_item::get_type());
endfunction : build_phase
*/


`endif // TRAINING_UVC_ITEM_SV









