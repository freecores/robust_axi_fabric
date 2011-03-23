OUTFILE PREFIX_ic_dec.v

ITER MX   
ITER SX   

LOOP MX
ITER MMX_IDX
ENDLOOP MX
  
module PREFIX_ic_dec (PORTS);

   input [ADDR_BITS-1:0] 		      MMX_AADDR;
   input [ID_BITS-1:0] 			      MMX_AID;
   output [SLV_BITS-1:0] 		      MMX_ASLV;
   output 				      MMX_AIDOK;

   parameter 				      DEC_MSB =  ADDR_BITS - 1;
   parameter 				      DEC_LSB =  ADDR_BITS - MSTR_BITS;
   
   reg [SLV_BITS-1:0] 			      MMX_ASLV;
   reg 					      MMX_AIDOK;
   
   LOOP MX
     always @(MMX_AADDR or MMX_AIDOK)                       
       begin                                                  
	  case ({MMX_AIDOK, MMX_AADDR[DEC_MSB:DEC_LSB]})    
	    {1'b1, BIN(MX MSTR_BITS)} : MMX_ASLV = 'dSX;  
            default : MMX_ASLV = SERR;                     
	  endcase                                             
       end                                                    

   always @(MMX_AID)                                  
     begin                                             
	case (MMX_AID)                                
	  ID_MMX_IDMMX_IDX : MMX_AIDOK = 1'b1; 
	  default : MMX_AIDOK = 1'b0;                 
	endcase                                        
     end    
  
   ENDLOOP MX
      
     endmodule



