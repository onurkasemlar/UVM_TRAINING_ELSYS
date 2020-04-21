

/***********************************************************************************************
*  PPT2 - LAB1
*    Create new class that implements sequence item for APB protocol based on APB specification
*    Try to make sure it can model all APB transfers
*    Use rand where applicable
*    Use enum where applicable
*    Add couple of control ‘knobs’ (ie. Wait state duration)
*    Add couple of default constraints (soft or not?)
*    Register item with factory (don’t forget fields)
************************************************************************************************/

 typedef enum bit {READ, WRITE} pwrite_op_e;
 typedef enum     {ZERO, SHORT} delay_kind_e;

class my_lab1_uvc_item extends uvm_sequence_item;
   
  // item fields
  rand bit[31:0]    paddr;
  rand bit[31:0]    pwdata;
  rand pwrite_op_e  pwrite;
       bit[31:0]    prdata; 
  rand int          delay;
  rand delay_kind_e delay_kind;  
   
  // registration macro
  `uvm_object_utils_begin(training_uvc_item)
  	`uvm_field_int(paddr, UVM_DEFAULT)
  	`uvm_field_int(pwdata, UVM_DEFAULT)
  	`uvm_field_int(prdata, UVM_DEFAULT)
  	`uvm_field_int(delay, UVM_DEFAULT)
    `uvm_field_enum(pwrite_op_e, pwrite, UVM_DEFAULT)
    `uvm_field_enum(delay_kind_e, delay_kind, UVM_DEFAULT)
  `uvm_object_utils_end

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
                      paddr >= 32'h0;
                      paddr <= 32'hFFFF_FFFF;  
                    }
  constraint write_c
                    {
                      //Write is always with wait states
                      (pwrite == WRITE) -> delay > 0;     
                    }

    

    // constructor
    function my_lab1_uvc_item::new(string name = "my_lab1_uvc_item");
        super.new(name);
    endfunction : new
  
endclass : my_lab1_uvc_item




/******************************************************************************
*  PPT2 - LAB1
*  Extend this class to create new sequence item that does not have wait state
*******************************************************************************/
class my_lab1_noDelay_uvc_item extends my_lab1_uvc_item;

    //uvm_object not component!
    `uvm_object_utils(my_lab1_noDelay_uvc_item)   

    delay_kind.rand_mode(0);
    delay_kind == ZERO;

    function my_lab1_noDelay_uvc_item::new(string name = "my_lab1_noDelay_uvc_item");
        super.new(name);
    endfunction : new

endclass : my_lab1_noDelay_uvc_item











