module spi_controller (		
							iRSTN,
							iSPI_CLK,
							iSPI_CLK_OUT,
							iP2S_DATA,
							iSPI_GO,
							oSPI_END,					
							oS2P_DATA,							
							SPI_SDIO,
							oSPI_CSN,							
							oSPI_CLK);
	
`include "spi_param.h"	

//=======================================================
//  PORT declarations
//=======================================================
//	Host Side
input				              iRSTN;
input				              iSPI_CLK;
input				              iSPI_CLK_OUT;
input	      [SI_DataL:0]  iP2S_DATA; 
input	      			        iSPI_GO;
output	  			          oSPI_END;
output	reg [SO_DataL:0]	oS2P_DATA;
//	SPI Side              
inout				              SPI_SDIO;
output	   			          oSPI_CSN;
output				            oSPI_CLK;

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire          read_mode, write_address;
reg           spi_count_en;
reg  	[3:0]		spi_count;

//=======================================================
//  Structural coding
//=======================================================
assign read_mode = iP2S_DATA[SI_DataL];
assign write_address = spi_count[3];
assign oSPI_END = ~|spi_count;
assign oSPI_CSN = ~iSPI_GO;
assign oSPI_CLK = spi_count_en ? iSPI_CLK_OUT : 1'b1;
assign SPI_SDIO = spi_count_en && (!read_mode || write_address) ? iP2S_DATA[spi_count] : 1'bz;

always @ (posedge iSPI_CLK or negedge iRSTN) 
	if (!iRSTN)
	begin
		spi_count_en <= 1'b0;
		spi_count <= 4'hf;
	end
	else 
	begin
		if (oSPI_END)
			spi_count_en <= 1'b0;
		else if (iSPI_GO)
			spi_count_en <= 1'b1;
			
		if (!spi_count_en)	
  		spi_count <= 4'hf;		
		else
			spi_count	<= spi_count - 4'b1;

    if (read_mode && !write_address)
		  oS2P_DATA <= {oS2P_DATA[SO_DataL-1:0], SPI_SDIO};
	end

endmodule