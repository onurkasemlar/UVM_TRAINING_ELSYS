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
  
  
  initial
    begin
      PWRITE <= 0;
      
      `ifdef M2S_MODE
          PREADY <= 0;
      `endif
    end

  
  
  
  
    expect_pready_after_req:
    assert property (@(posedge PCLK) $changed(PADDR) |=> ##[0:5'hFF] PREADY)
    begin
           $display ("ASSERTION_PASS [expect_pready_after_req] -> Seems to be working as expected");
    end

      
    expect_pready_low_after_one_clk_high:
    assert property (@(posedge PCLK) ($rose(PREADY) |=> $fell(PREADY)))
    begin
      $display ("ASSERTION_PASS [expect_pready_low_after_one_clk_high] -> Seems to be working as expected");
    end
 
      
    expect_paddr_pwrite_pwdata_stable_until_pready_rec: 
    assert property (@(posedge PCLK)  
                     ($changed(PADDR) |=> ($stable(PADDR) && $stable(PWDATA) && $stable(PWRITE))
                      until $fell(PREADY))) 
    begin
      $display ("ASSERTION_PASS [expect_paddr_pwrite_pwdata_stable_until_pready_rec] -> Seems to be working as expected");
    end
      
      
    expect_prdata_cleared_after_read_op:  
    assert property (@(posedge PCLK) $rose(PREADY) |-> !PWRITE |=> (PRDATA==32'h00))
    begin
      $display ("ASSERTION_PASS [expect_prdata_cleared_after_read_op] -> Seems to be working as expected");
    end
      
      
    expect_pready_and_pwrite_should_always_be_known:
    assert property (@(posedge PCLK) disable iff (!PRESETn) (!$isunknown(PREADY) && !$isunknown(PWRITE)))
    begin
      $display ("ASSERTION_PASS [expect_pready_and_pwrite_should_always_be_known] -> Seems to be working as expected");
    end
      
      

  
endinterface : training_uvc_if

`endif // TRAINING_UVC_IF_SV
