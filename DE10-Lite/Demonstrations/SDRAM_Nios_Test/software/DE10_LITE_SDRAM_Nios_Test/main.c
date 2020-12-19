// --------------------------------------------------------------------
// Copyright (c) 2014 by Terasic Technologies Inc.
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------


#include "terasic_includes.h"
#include "mem_verify.h"
#include "system.h"
#include "alt_types.h"

int main()
{
	bool bPass, bLoop;
	int TestIndex ;
	alt_u32 InitValue = 0x01;
	bool bShowMessage = TRUE;
	alt_u32 TimeStart, TimeElapsed;
	alt_u8 Status,ButtonStatus;
	const alt_u8 ButtonMask = 0x03; // 2 button

    printf("===== SDRAM Test! Size=%dMB (CPU Clock:%d) =====\r\n", SDRAM_SPAN/1024/1024, ALT_CPU_CPU_FREQ);

    while(1){
        printf("\n==========================================================\n");
        printf("Press any KEY to start test [KEY0 for continued test] \n");
        ButtonStatus = ButtonMask;
        while((ButtonStatus & ButtonMask) == ButtonMask){

        	ButtonStatus = IORD(KEY_BASE, 0);
        }

        if ((ButtonStatus & 0x01) == 0x00){
            bLoop = TRUE;
        }else{
            bLoop = FALSE;
        }

		//
        bPass = TRUE;
        TestIndex = 0;

        do{
        	TestIndex++;
        	printf("=====> SDRAM Testing, Iteration: %d\n", TestIndex);
        	TimeStart = alt_nticks();

        	if (bPass)
        		bPass = TMEM_Verify(SDRAM_BASE, SDRAM_SPAN, InitValue,  bShowMessage);

        	TimeElapsed = alt_nticks() - TimeStart;
        	printf("SDRAM test:%s, %d seconds\r\n", bPass?"Pass":"NG", (int)(TimeElapsed/alt_ticks_per_second()));

            usleep(500*1000);
            if (bPass && bLoop){  // is abort loop?
            	ButtonStatus = IORD(KEY_BASE, 0);
            	if ((ButtonStatus & ButtonMask) != ButtonMask)
            		bLoop = FALSE; // press any key to abort continued test
            }
            usleep(600*1000);
        }while(bLoop && bPass);
	} // while(1)


    return 0;
}

