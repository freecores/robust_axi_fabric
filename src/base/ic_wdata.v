OUTFILE PREFIX_ic_wdata.v

ITER MX
ITER SX

module PREFIX_ic_wdata (PORTS);

   parameter 				  STRB_BITS  = DATA_BITS/8;
   
   input 				      clk;
   input 				      reset;
   
   port 				      MMX_AWGROUP_IC_AXI_CMD;
   port 				      MMX_WGROUP_IC_AXI_W;
   revport 				      SSX_WGROUP_IC_AXI_W;
   input 				      SSX_AWVALID;
   input 				      SSX_AWREADY;
   input [MSTR_BITS-1:0]      SSX_AWMSTR;


   parameter 				  WBUS_WIDTH = GONCAT(GROUP_IC_AXI_W.IN.WIDTH +);

   
   wire [WBUS_WIDTH-1:0] 	  SSX_WBUS;
   
   wire [WBUS_WIDTH-1:0] 	  MMX_WBUS;
   
   wire [SLV_BITS-1:0] 		  MMX_WSLV;
   wire 				      MMX_WOK;
   
   wire 				      SSX_MMX;

   


   CREATE ic_registry_wr.v def_ic.txt
   PREFIX_ic_registry_wr
     PREFIX_ic_registry_wr (
			    .clk(clk),
			    .reset(reset),
			    .MMX_AWSLV(MMX_AWSLV),
			    .MMX_AWID(MMX_AWID),
			    .MMX_AWVALID(MMX_AWVALID),
			    .MMX_AWREADY(MMX_AWREADY),
			    .MMX_WID(MMX_WID),
			    .MMX_WVALID(MMX_WVALID),
			    .MMX_WREADY(MMX_WREADY),
			    .MMX_WLAST(MMX_WLAST),
			    .MMX_WSLV(MMX_WSLV),
			    .MMX_WOK(MMX_WOK),
    			.SSX_AWVALID(SSX_AWVALID),
    			.SSX_AWREADY(SSX_AWREADY),
			    .SSX_AWMSTR(SSX_AWMSTR),
    			.SSX_WVALID(SSX_WVALID),
    			.SSX_WREADY(SSX_WREADY),
    			.SSX_WLAST(SSX_WLAST),
			    STOMP ,
			    );


   
   assign 				SSX_MMX  = (MMX_WSLV == 'dSX) & MMX_WOK & MMX_WVALID;
   
   assign 				MMX_WBUS = {GONCAT(MMX_WGROUP_IC_AXI_W.IN ,)};

   assign 				SSX_WBUS = CONCAT((MMX_WBUS & {WBUS_WIDTH{SSX_MMX}}) |);

   assign                               {GONCAT(SSX_WGROUP_IC_AXI_W.IN ,)} = SSX_WBUS;
   
LOOP MX
   assign 				MMX_WREADY =           
					SSX_MMX ? SSX_WREADY : 
					1'b0;
   
ENDLOOP MX
   
endmodule



