@ startup_rvmdk.S - Startup code for use with Keil's uVision.
@
@ Copyright (c) 2012 Texas Instruments Incorporated.  All rights reserved.
@ Software License Agreement
@ 
@ Texas Instruments (TI) is supplying this software for use solely and
@ exclusively on TI's microcontroller products. The software is owned by
@ TI and/or its suppliers, and is protected under applicable copyright
@ laws. You may not combine this software with "viral" open-source
@ software in order to form a larger program.
@ 
@ THIS SOFTWARE IS PROVIDED "AS IS" AND WITH ALL FAULTS.
@ NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
@ NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
@ A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. TI SHALL NOT, UNDER ANY
@ CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
@ DAMAGES, FOR ANY REASON WHATSOEVER.
@ 
@ This is part of revision 9453 of the EK-LM4F120XL Firmware Package.
@
@ Modified by Sameer Bibikar to provide necessary functions for gcc toolchain

@******************************************************************************
@
@ Useful functions.
@
@******************************************************************************
.global  DisableInterrupts
.global  EnableInterrupts
.global  StartCritical
.global  EndCritical
.global  WaitForInterrupt

@*********** DisableInterrupts ***************
@ disable interrupts
@ inputs:  none
@ outputs: none
DisableInterrupts:
        CPSID  I
        BX     LR

@*********** EnableInterrupts ***************
@ disable interrupts
@ inputs:  none
@ outputs: none
EnableInterrupts:
        CPSIE  I
        BX     LR

@*********** StartCritical ************************
@ make a copy of previous I bit, disable interrupts
@ inputs:  none
@ outputs: previous I bit
StartCritical:
        MRS    R0, PRIMASK  @ save old status
        CPSID  I            @ mask all (except faults)
        BX     LR

@*********** EndCritical ************************
@ using the copy of previous I bit, restore I bit to previous value
@ inputs:  previous I bit
@ outputs: none
EndCritical:
        MSR    PRIMASK, R0
        BX     LR

@*********** WaitForInterrupt ************************
@ go to low power mode while waiting for the next interrupt
@ inputs:  none
@ outputs: none
WaitForInterrupt:
        WFI
        BX     LR
