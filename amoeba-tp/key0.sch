EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:aker
LIBS:amoeba-cache
LIBS:atmega
LIBS:atmega32u4
LIBS:component
LIBS:components
LIBS:crystal
LIBS:dtsjw
LIBS:ErgoDOX-cache
LIBS:KB_common
LIBS:keyboard-cache
LIBS:mcp23xx8
LIBS:mcp23018
LIBS:mechanical
LIBS:mx1a
LIBS:mx1a-simple
LIBS:oupiin_usb
LIBS:Pin
LIBS:tactile_switch
LIBS:TeensyShield-cache
LIBS:tutorial-cache
LIBS:usb_ports
LIBS:mtl
LIBS:amoeba-tp-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 6
Title ""
Date "22 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MX1A S0:0
U 1 1 55D7BDA8
P 5600 3900
AR Path="/55D7BD97/55D7BDA8" Ref="S0:0"  Part="1" 
AR Path="/55D8588F/55D7BDA8" Ref="S0:1"  Part="1" 
AR Path="/55D88595/55D7BDA8" Ref="S1:0"  Part="1" 
AR Path="/55D8859F/55D7BDA8" Ref="S1:1"  Part="1" 
AR Path="/55D89165/55D7BDA8" Ref="S2:1"  Part="1" 
F 0 "S1:0" H 5450 4150 60  0000 C CNN
F 1 "MX1A" H 5600 4000 60  0000 C CNN
F 2 "~" H 5600 3900 60  0000 C CNN
F 3 "~" H 5600 3900 60  0000 C CNN
	1    5600 3900
	1    0    0    -1  
$EndComp
$Comp
L DIODE D0:0
U 1 1 55D7BDAE
P 5600 3450
AR Path="/55D7BD97/55D7BDAE" Ref="D0:0"  Part="1" 
AR Path="/55D8588F/55D7BDAE" Ref="D0:1"  Part="1" 
AR Path="/55D88595/55D7BDAE" Ref="D1:0"  Part="1" 
AR Path="/55D8859F/55D7BDAE" Ref="D1:1"  Part="1" 
AR Path="/55D89165/55D7BDAE" Ref="D2:1"  Part="1" 
F 0 "D1:0" H 5600 3550 40  0000 C CNN
F 1 "DIODE" H 5600 3350 40  0000 C CNN
F 2 "~" H 5600 3450 60  0000 C CNN
F 3 "~" H 5600 3450 60  0000 C CNN
	1    5600 3450
	1    0    0    -1  
$EndComp
$Comp
L LED L0:0
U 1 1 55D7BDE4
P 5800 4150
AR Path="/55D7BD97/55D7BDE4" Ref="L0:0"  Part="1" 
AR Path="/55D8588F/55D7BDE4" Ref="L0:1"  Part="1" 
AR Path="/55D88595/55D7BDE4" Ref="L1:0"  Part="1" 
AR Path="/55D8859F/55D7BDE4" Ref="L1:1"  Part="1" 
AR Path="/55D89165/55D7BDE4" Ref="L2:1"  Part="1" 
F 0 "L1:0" H 5800 4250 50  0000 C CNN
F 1 "LED" H 5800 4050 50  0000 C CNN
F 2 "~" H 5800 4150 60  0000 C CNN
F 3 "~" H 5800 4150 60  0000 C CNN
	1    5800 4150
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR R0:0
U 1 1 55D7BDEA
P 5350 4150
AR Path="/55D7BD97/55D7BDEA" Ref="R0:0"  Part="1" 
AR Path="/55D8588F/55D7BDEA" Ref="R0:1"  Part="1" 
AR Path="/55D88595/55D7BDEA" Ref="R1:0"  Part="1" 
AR Path="/55D8859F/55D7BDEA" Ref="R1:1"  Part="1" 
AR Path="/55D89165/55D7BDEA" Ref="R2:1"  Part="1" 
F 0 "R1:0" H 5350 4050 50  0000 C CNN
F 1 "RESISTOR" H 5350 4250 50  0000 C CNN
F 2 "~" H 5350 4150 60  0000 C CNN
F 3 "~" H 5350 4150 60  0000 C CNN
	1    5350 4150
	0    1    1    0   
$EndComp
Connection ~ 5400 3500
Connection ~ 5800 3750
Connection ~ 5100 3250
Connection ~ 6200 3150
Connection ~ 6000 3150
Connection ~ 6000 4350
Connection ~ 5800 3450
Connection ~ 5600 4150
Wire Wire Line
	5100 4150 5100 3950
Connection ~ 5100 3950
Connection ~ 5100 4150
Connection ~ 6000 4150
Wire Wire Line
	5800 3750 6200 3750
Connection ~ 6200 3750
Connection ~ 6350 3950
Connection ~ 5800 3250
Connection ~ 6200 4350
Wire Wire Line
	6000 4350 6000 3150
Wire Wire Line
	6200 3150 6200 4350
Wire Wire Line
	5100 3250 6350 3250
Connection ~ 6350 3250
Wire Wire Line
	5100 3950 6350 3950
Wire Wire Line
	5400 3450 5400 3500
Wire Wire Line
	5800 3450 5800 3250
Connection ~ 5400 3450
Text HLabel 6200 3150 1    60   BiDi ~ 0
SC0
Text HLabel 6000 3150 1    60   BiDi ~ 0
LC0
Text HLabel 6350 3250 2    60   BiDi ~ 0
SR1
Text HLabel 5100 3250 0    60   BiDi ~ 0
SR0
Text HLabel 6350 3950 2    60   BiDi ~ 0
LR1
Text HLabel 5100 3950 0    60   BiDi ~ 0
LR0
Text HLabel 6000 4350 3    60   BiDi ~ 0
LC1
Text HLabel 6200 4350 3    60   BiDi ~ 0
SC1
$EndSCHEMATC
