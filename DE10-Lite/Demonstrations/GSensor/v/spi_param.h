// Data MSB Bit
parameter	IDLE_MSB		=	14;
parameter	SI_DataL		=	15;
parameter	SO_DataL		=	7;

// Write/Read Mode 
parameter	WRITE_MODE		=	2'b00;
parameter	READ_MODE		  =	2'b10;

// Initial Reg Number 
parameter	INI_NUMBER	  =	4'd11;

// SPI State 
parameter	IDLE		      =	1'b0;
parameter	TRANSFER		  =	1'b1;

// Write Reg Address 
parameter	BW_RATE			  =	6'h2c;
parameter	POWER_CONTROL	=	6'h2d;
parameter	DATA_FORMAT		=	6'h31;
parameter	INT_ENABLE		=	6'h2E;
parameter	INT_MAP			  =	6'h2F;
parameter	THRESH_ACT		=	6'h24;
parameter	THRESH_INACT	=	6'h25;
parameter	TIME_INACT		=	6'h26;
parameter	ACT_INACT_CTL	=	6'h27;
parameter	THRESH_FF		  =	6'h28;
parameter	TIME_FF			  =	6'h29;

// Read Reg Address
parameter	INT_SOURCE		=	6'h30; // INT Status
parameter	X_LB 			    =	6'h32; // Low Byte
parameter	X_HB			    =	6'h33; // High Byte
parameter	Y_LB			    =	6'h34; // Low Byte 
parameter	Y_HB			    =	6'h35; // High Byte
parameter	Z_LB			    =	6'h36; // Low Byte 
parameter	Z_HB			    =	6'h37; // High Byte
