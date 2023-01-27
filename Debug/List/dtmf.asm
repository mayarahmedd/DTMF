
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16A
;Program type           : Application
;Clock frequency        : 12.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x2C:
	.DB  0x45,0x72,0x72,0x6F,0x72,0x0,0x0,0x0
	.DB  0x0,0x0
_0x2F:
	.DB  0x53,0x75,0x63,0x63,0x65,0x73,0x73,0x0
	.DB  0x0,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 5/13/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;//Fdlnaaa bs n3ml lcd w nshtreeeha
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <delay.h>
;// Declare your global variables here
;eeprom int inputLength=0;
;eeprom int lockSemaphore=0;
;eeprom char lock[50];
;eeprom char checkLock[50];
;eeprom int checkLength=0;
;char getNum(){
; 0000 0022 char getNum(){

	.CSEG
_getNum:
; .FSTART _getNum
; 0000 0023     char num;
; 0000 0024 	if(PINC.7==1&&PINC.6==0&&PINC.5==1&&PINC.4==0)num='0';
	ST   -Y,R17
;	num -> R17
	SBIS 0x13,7
	RJMP _0x4
	SBIC 0x13,6
	RJMP _0x4
	SBIS 0x13,5
	RJMP _0x4
	SBIS 0x13,4
	RJMP _0x5
_0x4:
	RJMP _0x3
_0x5:
	LDI  R17,LOW(48)
; 0000 0025 	else if(PINC.7==0&&PINC.6==0&&PINC.5==0&&PINC.4==1)num='1';
	RJMP _0x6
_0x3:
	SBIC 0x13,7
	RJMP _0x8
	SBIC 0x13,6
	RJMP _0x8
	SBIC 0x13,5
	RJMP _0x8
	SBIC 0x13,4
	RJMP _0x9
_0x8:
	RJMP _0x7
_0x9:
	LDI  R17,LOW(49)
; 0000 0026 	else if(PINC.7==0&&PINC.6==0&&PINC.5==1&&PINC.4==0)num='2';
	RJMP _0xA
_0x7:
	SBIC 0x13,7
	RJMP _0xC
	SBIC 0x13,6
	RJMP _0xC
	SBIS 0x13,5
	RJMP _0xC
	SBIS 0x13,4
	RJMP _0xD
_0xC:
	RJMP _0xB
_0xD:
	LDI  R17,LOW(50)
; 0000 0027 	else if(PINC.7==0&&PINC.6==0&&PINC.5==1&&PINC.4==1)num='3';
	RJMP _0xE
_0xB:
	SBIC 0x13,7
	RJMP _0x10
	SBIC 0x13,6
	RJMP _0x10
	SBIS 0x13,5
	RJMP _0x10
	SBIC 0x13,4
	RJMP _0x11
_0x10:
	RJMP _0xF
_0x11:
	LDI  R17,LOW(51)
; 0000 0028 	else if(PINC.7==0&&PINC.6==1&&PINC.5==0&&PINC.4==0)num='4';
	RJMP _0x12
_0xF:
	SBIC 0x13,7
	RJMP _0x14
	SBIS 0x13,6
	RJMP _0x14
	SBIC 0x13,5
	RJMP _0x14
	SBIS 0x13,4
	RJMP _0x15
_0x14:
	RJMP _0x13
_0x15:
	LDI  R17,LOW(52)
; 0000 0029 	else if(PINC.7==0&&PINC.6==1&&PINC.5==0&&PINC.4==1)num='5';
	RJMP _0x16
_0x13:
	SBIC 0x13,7
	RJMP _0x18
	SBIS 0x13,6
	RJMP _0x18
	SBIC 0x13,5
	RJMP _0x18
	SBIC 0x13,4
	RJMP _0x19
_0x18:
	RJMP _0x17
_0x19:
	LDI  R17,LOW(53)
; 0000 002A 	else if(PINC.7==0&&PINC.6==1&&PINC.5==1&&PINC.4==0)num='6';
	RJMP _0x1A
_0x17:
	SBIC 0x13,7
	RJMP _0x1C
	SBIS 0x13,6
	RJMP _0x1C
	SBIS 0x13,5
	RJMP _0x1C
	SBIS 0x13,4
	RJMP _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
	LDI  R17,LOW(54)
; 0000 002B 	else if(PINC.7==0&&PINC.6==1&&PINC.5==1&&PINC.4==1)num='7';
	RJMP _0x1E
_0x1B:
	SBIC 0x13,7
	RJMP _0x20
	SBIS 0x13,6
	RJMP _0x20
	SBIS 0x13,5
	RJMP _0x20
	SBIC 0x13,4
	RJMP _0x21
_0x20:
	RJMP _0x1F
_0x21:
	LDI  R17,LOW(55)
; 0000 002C 	else if(PINC.7==1&&PINC.6==0&&PINC.5==0&&PINC.4==0)num='8';
	RJMP _0x22
_0x1F:
	SBIS 0x13,7
	RJMP _0x24
	SBIC 0x13,6
	RJMP _0x24
	SBIC 0x13,5
	RJMP _0x24
	SBIS 0x13,4
	RJMP _0x25
_0x24:
	RJMP _0x23
_0x25:
	LDI  R17,LOW(56)
; 0000 002D 	else if(PINC.7==1&&PINC.6==0&&PINC.5==0&&PINC.4==1)num='9';
	RJMP _0x26
_0x23:
	SBIS 0x13,7
	RJMP _0x28
	SBIC 0x13,6
	RJMP _0x28
	SBIC 0x13,5
	RJMP _0x28
	SBIC 0x13,4
	RJMP _0x29
_0x28:
	RJMP _0x27
_0x29:
	LDI  R17,LOW(57)
; 0000 002E 	return num;
_0x27:
_0x26:
_0x22:
_0x1E:
_0x1A:
_0x16:
_0x12:
_0xE:
_0xA:
_0x6:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 002F }
; .FEND
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0032 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0033 
; 0000 0034     //int flag=0;
; 0000 0035     //int i=0;
; 0000 0036     char c=getNum();
; 0000 0037     lcd_putchar(c);
	ST   -Y,R17
;	c -> R17
	RCALL _getNum
	MOV  R17,R30
	MOV  R26,R17
	RCALL _lcd_putchar
; 0000 0038 // Place your code here
; 0000 0039     //mafrood hna haread ba2a mn dtmf w a7oot fl eeprom 77ot 7gteen array w length
; 0000 003A     if(PINB.1==0){     //normal mode
	SBIC 0x16,1
	RJMP _0x2A
; 0000 003B         //mafrood hna a5od l input mn dtmf
; 0000 003C         //GICR&=~(1<<INT0);
; 0000 003D 
; 0000 003E         //if(checkLength==0)
; 0000 003F         //{
; 0000 0040         //for(i=0;i<50;i++){
; 0000 0041         //    checkLock[i]=0;
; 0000 0042         //} }
; 0000 0043 
; 0000 0044 
; 0000 0045         checkLock[checkLength] = c;
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_checkLock)
	SBCI R31,HIGH(-_checkLock)
	MOVW R26,R30
	MOV  R30,R17
	CALL __EEPROMWRB
; 0000 0046 
; 0000 0047         if(lock[checkLength] != checkLock[checkLength]){
	RCALL SUBOPT_0x0
	MOVW R22,R30
	SUBI R30,LOW(-_lock)
	SBCI R31,HIGH(-_lock)
	MOVW R26,R30
	CALL __EEPROMRDB
	MOV  R0,R30
	MOVW R26,R22
	SUBI R26,LOW(-_checkLock)
	SBCI R27,HIGH(-_checkLock)
	CALL __EEPROMRDB
	CP   R30,R0
	BREQ _0x2B
; 0000 0048         char buf[10]="Error";
; 0000 0049             delay_ms(200);
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2C*2)
	LDI  R31,HIGH(_0x2C*2)
	CALL __INITLOCB
;	buf -> Y+0
	RCALL SUBOPT_0x1
; 0000 004A             lcd_clear();
; 0000 004B 
; 0000 004C             //DISPLAY Error IN LCD
; 0000 004D 
; 0000 004E             PORTC|=(1<<PORTC1);
	SBI  0x15,1
; 0000 004F             lcd_puts(buf);
	RJMP _0x3E
; 0000 0050             delay_ms(1000);
; 0000 0051             PORTC&=(0<<PORTC1);
; 0000 0052             //buf="Error";
; 0000 0053             checkLength=0;
; 0000 0054             //lcd_puts(buf);
; 0000 0055             //delay_ms(1000);
; 0000 0056              lcd_clear();
; 0000 0057         } else {
_0x2B:
; 0000 0058             checkLength++;
	RCALL SUBOPT_0x0
	ADIW R30,1
	CALL __EEPROMWRW
; 0000 0059             if(checkLength == inputLength) {
	RCALL SUBOPT_0x0
	MOVW R0,R30
	RCALL SUBOPT_0x2
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x2E
; 0000 005A                 char buf[10]="Success";
; 0000 005B                 delay_ms(200);
	SBIW R28,10
	LDI  R24,10
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2F*2)
	LDI  R31,HIGH(_0x2F*2)
	CALL __INITLOCB
;	buf -> Y+0
	RCALL SUBOPT_0x1
; 0000 005C                 lcd_clear();
; 0000 005D 
; 0000 005E                 //DISPLAY Success IN LCD
; 0000 005F 
; 0000 0060                 PORTC|=(1<<PORTC2);
	SBI  0x15,2
; 0000 0061                 lcd_puts(buf);
_0x3E:
	MOVW R26,R28
	RCALL _lcd_puts
; 0000 0062                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0063                 PORTC&=(0<<PORTC2);
	IN   R30,0x15
	ANDI R30,LOW(0x0)
	OUT  0x15,R30
; 0000 0064                 checkLength=0;
	RCALL SUBOPT_0x3
; 0000 0065                 //buf="Success";
; 0000 0066                 //lcd_puts(buf);
; 0000 0067                 //delay_ms(1000);
; 0000 0068                 lcd_clear();
	RCALL _lcd_clear
; 0000 0069             }
	ADIW R28,10
; 0000 006A         }
_0x2E:
; 0000 006B 
; 0000 006C 
; 0000 006D //        if(checkLength!=inputLength-1){
; 0000 006E //              checkLock[checkLength]=c;
; 0000 006F //              checkLength++;
; 0000 0070 //
; 0000 0071 //        }else{
; 0000 0072 //            checkLock[checkLength]=c;
; 0000 0073 //            checkLength++;
; 0000 0074 //            for(i=0;i<inputLength;i++){
; 0000 0075 //                if(lock[i]!=checkLock[i]){
; 0000 0076 //                    flag=1;
; 0000 0077 //                    break;
; 0000 0078 //                }
; 0000 0079 //            }
; 0000 007A //                lcd_clear();
; 0000 007B //                if(flag==1){
; 0000 007C //                    //DISPLAY Error IN LCD
; 0000 007D //                    char buf[10]="Error";
; 0000 007E //                    PORTC|=(1<<PORTC1);
; 0000 007F //                    delay_ms(1000);
; 0000 0080 //                    PORTC&=(0<<PORTC1);
; 0000 0081 //                    //buf="Error";
; 0000 0082 //                    checkLength=0;
; 0000 0083 //                    lcd_puts(buf);
; 0000 0084 //                    delay_ms(1000);
; 0000 0085 //                     lcd_clear();
; 0000 0086 //                }else{
; 0000 0087 //                    //DISPLAY Success IN LCD
; 0000 0088 //                     char buf[10]="Success";
; 0000 0089 //                    PORTC|=(1<<PORTC2);
; 0000 008A //                    delay_ms(1000);
; 0000 008B //                    PORTC&=(0<<PORTC2);
; 0000 008C //                    checkLength=0;
; 0000 008D //                    //buf="Success";
; 0000 008E //                    lcd_puts(buf);
; 0000 008F //                    delay_ms(1000);
; 0000 0090 //                    lcd_clear();
; 0000 0091 //                }
; 0000 0092 
; 0000 0093             //lcd_puts(buf);
; 0000 0094                  //delay_ms(1000);
; 0000 0095 
; 0000 0096 
; 0000 0097 //        }
; 0000 0098     }else{ //programming mode
	RJMP _0x30
_0x2A:
; 0000 0099     if(lockSemaphore==1){
	LDI  R26,LOW(_lockSemaphore)
	LDI  R27,HIGH(_lockSemaphore)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x31
; 0000 009A         lock[inputLength]=c;
	RCALL SUBOPT_0x2
	SUBI R30,LOW(-_lock)
	SBCI R31,HIGH(-_lock)
	MOVW R26,R30
	MOV  R30,R17
	CALL __EEPROMWRB
; 0000 009B         //DISPLAY in LCD
; 0000 009C         inputLength++;
	RCALL SUBOPT_0x2
	ADIW R30,1
	CALL __EEPROMWRW
; 0000 009D         checkLength=0;
	RCALL SUBOPT_0x3
; 0000 009E         }
; 0000 009F     }
_0x31:
_0x30:
; 0000 00A0 }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00A4 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A5 // Place your code here
; 0000 00A6     PORTC|=(1<<PORTC0);
	SBI  0x15,0
; 0000 00A7     if(lockSemaphore==0){
	LDI  R26,LOW(_lockSemaphore)
	LDI  R27,HIGH(_lockSemaphore)
	CALL __EEPROMRDW
	SBIW R30,0
	BRNE _0x32
; 0000 00A8         inputLength=0;
	LDI  R26,LOW(_inputLength)
	LDI  R27,HIGH(_inputLength)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 00A9         checkLength=0;
	RCALL SUBOPT_0x3
; 0000 00AA         lockSemaphore=1;
	LDI  R26,LOW(_lockSemaphore)
	LDI  R27,HIGH(_lockSemaphore)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EEPROMWRW
; 0000 00AB     }
; 0000 00AC     //if((1<<ICES1)){
; 0000 00AD     //    PORTC|=(1<<PORTC1);
; 0000 00AE         //mafrood a7wl le falling edge 3shan awl m yfall atl3 mn loop
; 0000 00AF         //mafrood kman aread kol l ktbo w astore it fl eeprom
; 0000 00B0     //    TCCR1B &=(0<<ICES1);
; 0000 00B1 
; 0000 00B2 
; 0000 00B3         //inputLength=0;
; 0000 00B4         //GICR|=(1<<INT0);
; 0000 00B5     //}else{
; 0000 00B6         //GICR&=~(1<<INT0);
; 0000 00B7         //TCCR1B |=(1<<ICES1);
; 0000 00B8 
; 0000 00B9     //     OCR1AH=0x5B;
; 0000 00BA     //    OCR1AL=0x8D;
; 0000 00BB       //   PORTC&=(0<<PORTC1);
; 0000 00BC       //}
; 0000 00BD 
; 0000 00BE }
_0x32:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	RETI
; .FEND
;eeprom int clearSemaphore=0;
;void main(void)
; 0000 00C1 {
_main:
; .FSTART _main
; 0000 00C2 // Declare your local variables here
; 0000 00C3 
; 0000 00C4 // Input/Output Ports initialization
; 0000 00C5 // Port A initialization
; 0000 00C6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00C7 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 00C8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00C9 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 00CA 
; 0000 00CB // Port B initialization
; 0000 00CC // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00CD DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 00CE // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00CF PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 00D0 
; 0000 00D1 // Port C initialization
; 0000 00D2 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00D3 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 00D4 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00D5 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00D6 
; 0000 00D7 // Port D initialization
; 0000 00D8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00D9 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 00DA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00DB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 00DC 
; 0000 00DD 
; 0000 00DE // Timer/Counter 1 initialization
; 0000 00DF // Clock source: System Clock
; 0000 00E0 // Clock value: 11.719 kHz
; 0000 00E1 // Mode: CTC top=OCR1A
; 0000 00E2 // OC1A output: Disconnected
; 0000 00E3 // OC1B output: Disconnected
; 0000 00E4 // Noise Canceler: Off
; 0000 00E5 // Input Capture on Falling Edge
; 0000 00E6 // Timer Period: 2 s
; 0000 00E7 // Timer1 Overflow Interrupt: Off
; 0000 00E8 // Input Capture Interrupt: Off
; 0000 00E9 // Compare A Match Interrupt: On
; 0000 00EA // Compare B Match Interrupt: Off
; 0000 00EB TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00EC TCCR1B=(1<<ICNC1) | (1<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(207)
	OUT  0x2E,R30
; 0000 00ED TCNT1H=0xA4;
	LDI  R30,LOW(164)
	OUT  0x2D,R30
; 0000 00EE TCNT1L=0x72;
	LDI  R30,LOW(114)
	RCALL SUBOPT_0x4
; 0000 00EF ICR1H=0x00;
; 0000 00F0 ICR1L=0x00;
; 0000 00F1 OCR1AH=0x5A;
; 0000 00F2 OCR1AL=0x8D;
; 0000 00F3 OCR1BH=0x00;
; 0000 00F4 OCR1BL=0x00;
; 0000 00F5 
; 0000 00F6 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00F7 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 00F8 
; 0000 00F9 // External Interrupt(s) initialization
; 0000 00FA // INT0: On
; 0000 00FB // INT0 Mode: Rising Edge
; 0000 00FC // INT1: Off
; 0000 00FD // INT2: Off
; 0000 00FE GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00FF MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 0100 MCUCSR=(0<<ISC2);
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 0101 GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0102 
; 0000 0103 // Alphanumeric LCD initialization
; 0000 0104 // Connections are specified in the
; 0000 0105 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0106 // RS - PORTA Bit 0
; 0000 0107 // RD - PORTA Bit 1
; 0000 0108 // EN - PORTA Bit 2
; 0000 0109 // D4 - PORTA Bit 4
; 0000 010A // D5 - PORTA Bit 5
; 0000 010B // D6 - PORTA Bit 6
; 0000 010C // D7 - PORTA Bit 7
; 0000 010D // Characters/line: 16
; 0000 010E lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 010F 
; 0000 0110 // Global enable interrupts
; 0000 0111 #asm("sei")
	sei
; 0000 0112 DDRB.1=0;
	CBI  0x17,1
; 0000 0113 while (1)
_0x35:
; 0000 0114       {
; 0000 0115       // Place your code here
; 0000 0116 // Place your code here
; 0000 0117         if(PINB.1){
	SBIS 0x16,1
	RJMP _0x38
; 0000 0118             TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0119             TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(13)
	OUT  0x2E,R30
; 0000 011A             //TCCR1B    |= (1<<CS11);
; 0000 011B             //TCNT1H=0x00;
; 0000 011C             //TCNT1L=0x00;
; 0000 011D             //ICR1H=0x00;
; 0000 011E             //ICR1L=0x00;
; 0000 011F             //OCR1AH=0x5B;
; 0000 0120             //OCR1AL=0x8D;
; 0000 0121             //OCR1BH=0x00;
; 0000 0122             //OCR1BL=0x00;
; 0000 0123             //PORTC^=1<<PORTC0;
; 0000 0124         }
; 0000 0125         else{
	RJMP _0x39
_0x38:
; 0000 0126             lockSemaphore=0;
	LDI  R26,LOW(_lockSemaphore)
	LDI  R27,HIGH(_lockSemaphore)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 0127             PORTC&=0<<PORTC0;
	IN   R30,0x15
	ANDI R30,LOW(0x0)
	OUT  0x15,R30
; 0000 0128             lcd_clear();
	RCALL _lcd_clear
; 0000 0129             while(PINB.1==0){
_0x3A:
	SBIC 0x16,1
	RJMP _0x3C
; 0000 012A             //PORTC&=(0<<PORTC0);
; 0000 012B             TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 012C             TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (1<<CS11) | (1<<CS10);
	LDI  R30,LOW(15)
	OUT  0x2E,R30
; 0000 012D             //TCCR1B    |= (1<<CS11);
; 0000 012E             TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 012F             TCNT1L=0x00;
	RCALL SUBOPT_0x4
; 0000 0130             ICR1H=0x00;
; 0000 0131             ICR1L=0x00;
; 0000 0132             OCR1AH=0x5A;
; 0000 0133             OCR1AL=0x8D;
; 0000 0134             OCR1BH=0x00;
; 0000 0135             OCR1BL=0x00;
; 0000 0136              }
	RJMP _0x3A
_0x3C:
; 0000 0137 
; 0000 0138       }                       }
_0x39:
	RJMP _0x35
; 0000 0139 }
_0x3D:
	RJMP _0x3D
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 20
	SBI  0x1B,2
	__DELAY_USB 20
	CBI  0x1B,2
	__DELAY_USB 20
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 200
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 300
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.ESEG
_inputLength:
	.DB  0x0,0x0
_lockSemaphore:
	.DB  0x0,0x0
_lock:
	.BYTE 0x32
_checkLock:
	.BYTE 0x32
_checkLength:
	.DB  0x0,0x0

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_checkLength)
	LDI  R27,HIGH(_checkLength)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_inputLength)
	LDI  R27,HIGH(_inputLength)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_checkLength)
	LDI  R27,HIGH(_checkLength)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	OUT  0x2C,R30
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x26,R30
	LDI  R30,LOW(90)
	OUT  0x2B,R30
	LDI  R30,LOW(141)
	OUT  0x2A,R30
	LDI  R30,LOW(0)
	OUT  0x29,R30
	OUT  0x28,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 300
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xBB8
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
