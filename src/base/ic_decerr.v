OUTFILE PREFIX_ic_decerr.v

module PREFIX_ic_decerr(PORTS);

   input                          clk;
   input 			  reset;

   input 			  AWIDOK;
   input 			  ARIDOK;
   port 			  GROUP_IC_AXI;

   
   parameter 			  RESP_SLVERR = 2'b10;
   parameter 			  RESP_DECERR = 2'b11;
   
   
   reg 				  AWREADY;
   reg [ID_BITS-1:0] 		  BID;
   reg [1:0] 			  BRESP;
   reg 				  BVALID;
   reg 				  ARREADY;
   reg [ID_BITS-1:0] 		  RID;
   reg [1:0] 			  RRESP;
   reg 				  RVALID;
   reg [4-1:0] 		  rvalid_cnt;
   

   assign 			  BUSER = 'd0;
   assign 			  RUSER = 'd0;
   assign 			  RDATA = {DATA_BITS{1'b0}};


   //WRITE
   assign 			  WREADY = 1'b1;
   
   always @(posedge clk or posedge reset)
     if (reset)
       begin
	  AWREADY <= #FFD 1'b1;
	  BID     <= #FFD {ID_BITS{1'b0}};
	  BRESP   <= #FFD 2'b00;
       end
     else if (BVALID & BREADY)
       begin
	  AWREADY <= #FFD 1'b1;
       end
     else if (AWVALID & AWREADY)
       begin
	  AWREADY <= #FFD 1'b0;
	  BID     <= #FFD AWID;
	  BRESP   <= #FFD AWIDOK ? RESP_DECERR : RESP_SLVERR;
       end
   
   always @(posedge clk or posedge reset)
     if (reset)
       BVALID <= #FFD 1'b0;
     else if (WVALID & WREADY & WLAST)
       BVALID <= #FFD 1'b1;
     else if (BVALID & BREADY)
       BVALID <= #FFD 1'b0;

   
   //READ   
   always @(posedge clk or posedge reset)
     if (reset)
       begin
	  ARREADY <= #FFD 1'b1;
	  RID     <= #FFD {ID_BITS{1'b0}};
	  RRESP   <= #FFD 2'b00;
       end
     else if (RVALID & RREADY & RLAST)
       begin
	  ARREADY <= #FFD 1'b1;
       end
     else if (ARVALID & ARREADY)
       begin
	  ARREADY <= #FFD 1'b0;
	  RID     <= #FFD ARID;
	  RRESP   <= #FFD ARIDOK ? RESP_DECERR : RESP_SLVERR;
       end


   always @(posedge clk or posedge reset)
     if (reset)
       rvalid_cnt <= #FFD {4{1'b0}};
     else if (RVALID & RREADY & RLAST)
       rvalid_cnt <= #FFD {4{1'b0}};
     else if (RVALID & RREADY)
       rvalid_cnt <= #FFD rvalid_cnt - 1'b1;
     else if (ARVALID & ARREADY)
       rvalid_cnt <= #FFD ARLEN;

   
   always @(posedge clk or posedge reset)
     if (reset)
       RVALID <= #FFD 1'b0;
     else if (RVALID & RREADY & RLAST)
       RVALID <= #FFD 1'b0;
     else if (ARVALID & ARREADY)
       RVALID <= #FFD 1'b1;
   
   assign RLAST = (rvalid_cnt == 'd0) & RVALID;
     
   
   
   
   
   
endmodule

   
