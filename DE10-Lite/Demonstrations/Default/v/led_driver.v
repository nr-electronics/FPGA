module led_driver (iRSTN, iCLK, iDIG, iG_INT2, oLED);
input				       iRSTN;
input				       iCLK;
input		    [9:0]  iDIG;
input		           iG_INT2;
output	    [9:0]  oLED;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire				[4:0]  select_data;
wire               signed_bit;
wire				[3:0]  abs_select_high;
reg				  [1:0]  int2_d;
reg	        [23:0] int2_count;
reg	               int2_count_en;

//=======================================================
//  Structural coding
//=======================================================
assign select_data = iG_INT2 ? iDIG[9:5] :  // +-2g resolution : 10-bit
                               (iDIG[9]?(iDIG[8]?iDIG[8:4]:5'h10):(iDIG[8]?5'hf:iDIG[8:4])); // +-g resolution : 9-bit                               
assign signed_bit = select_data[4];
assign abs_select_high = signed_bit ? ~select_data[3:0] : select_data[3:0]; // the negitive number here is the 2's complement - 1

/*assign oLED = int2_count[23] ? ((abs_select_high[3:1] == 3'h0) ? 8'h18 :
				                        (abs_select_high[3:1] == 3'h1) ? (signed_bit?8'h8:8'h10) :
				                        (abs_select_high[3:1] == 3'h2) ? (signed_bit?8'hc:8'h30) :
				                        (abs_select_high[3:1] == 3'h3) ? (signed_bit?8'h4:8'h20) :
				                        (abs_select_high[3:1] == 3'h4) ? (signed_bit?8'h6:8'h60) :
				                        (abs_select_high[3:1] == 3'h5) ? (signed_bit?8'h2:8'h40) :
				                        (abs_select_high[3:1] == 3'h6) ? (signed_bit?8'h3:8'hc0) :
				                                                         (signed_bit?8'h1:8'h80)):
				                        (int2_count[20] ? 8'h0 : 8'hff); // Activity*/
												
assign oLED = int2_count[23] ? ((abs_select_high[3:0] == 3'h0) ? 10'h030 :
				                        (abs_select_high[3:0] == 3'h1) ? (signed_bit?10'h020:10'h010) :
				                        (abs_select_high[3:0] == 3'h2) ? (signed_bit?10'h060:10'h018) :
				                        (abs_select_high[3:0] == 3'h3) ? (signed_bit?10'h040:10'h8) :
				                        (abs_select_high[3:0] == 3'h4) ? (signed_bit?10'h0C0:10'hC) :
				                        (abs_select_high[3:0] == 3'h5) ? (signed_bit?10'h080:10'h4) :
				                        (abs_select_high[3:0] == 3'h6) ? (signed_bit?10'h180:10'h6) :
				                        (abs_select_high[3:0] == 3'h7) ? (signed_bit?10'h100:10'h2) :
				                        (abs_select_high[3:0] == 3'h8) ? (signed_bit?10'h300:10'h3) :
				                                                         (signed_bit?10'h200:10'h1)):
				                        (int2_count[20] ? 10'h0 : 10'h3ff); // Activity												
												
												
												

always@(posedge iCLK or negedge iRSTN)
	if (!iRSTN)
  begin
    int2_count_en	<= 1'b0;	
    int2_count <= 24'h800000;
  end
	else
	begin
		int2_d <= {int2_d[0], iG_INT2};

		if (!int2_d[1] && int2_d[0])
    begin
      int2_count_en	<= 1'b1;		
	    int2_count <= 24'h0;
	  end
	  else if (int2_count[23])
	  	int2_count_en	<= 1'b0; 	
    else
	  	int2_count <= int2_count + 1;
	end

endmodule