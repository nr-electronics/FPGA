module	reset_delay(iRSTN, iCLK, oRST);
input		    iRSTN;
input		    iCLK;
output reg	oRST;

reg  [20:0] cont;

always @(posedge iCLK or negedge iRSTN)
  if (!iRSTN) 
  begin
    cont     <= 21'b0;
    oRST     <= 1'b1;
  end
  else if (!cont[20]) 
  begin
    cont <= cont + 21'b1;
    oRST <= 1'b1;
  end
  else
    oRST <= 1'b0;
  
endmodule