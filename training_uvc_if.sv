//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_if.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TRAINING_UVC_IF_SV
`define TRAINING_UVC_IF_SV

interface training_uvc_if(input PCLK, input PRESETn);
  
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  
  time current_time;
  
  // signals
  logic [31:0] PADDR;
  logic        PWRITE;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic        PREADY;
  

  
    assert property (@(posedge PCLK) $changed(PADDR) |=> ##[0:5'hFF] PREADY)
    begin
           $display ("ASSERTION_PASS [expect_pready_after_req] -> Seems to be working as expected");
    end

    
    assert property (@(posedge PCLK) ($rose(PREADY) |=> $fell(PREADY)))
    begin
      $display ("ASSERTION_PASS [expect_pready_low_after_one_clk_high] -> Seems to be working as expected");
    end
 
      
    assert property (@(posedge PCLK) $rose(PREADY) |-> !PWRITE |=> (PRDATA==32'h00))
    begin
      $display ("ASSERTION_PASS [expect_prdata_cleared_after_read_op] -> Seems to be working as expected");
    end

    
   

  
endinterface : training_uvc_if

`endif // TRAINING_UVC_IF_SV
