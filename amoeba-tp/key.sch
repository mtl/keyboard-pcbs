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
Sheet 6 6
Title ""
Date "23 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MX1A S0:0
U 1 1 55D93046
P 5650 3950
AR Path="/55D95A82/55D93046" Ref="S0:0"  Part="1" 
AR Path="/55D94306/55D93046" Ref="S0:1"  Part="1" 
AR Path="/55D936FC/55D93046" Ref="S1:0"  Part="1" 
AR Path="/55D94310/55D93046" Ref="S1:1"  Part="1" 
AR Path="/55D9491A/55D93046" Ref="S2:1"  Part="1" 
F 0 "S2:1" H 5500 4200 60  0000 C CNN
F 1 "MX1A" H 5650 4050 60  0000 C CNN
F 2 "~" H 5650 3950 60  0000 C CNN
F 3 "~" H 5650 3950 60  0000 C CNN
	1    5650 3950
	1    0    0    -1  
$EndComp
$Comp
L DIODE D0:0
U 1 1 55D9304C
P 5650 3500
AR Path="/55D95A82/55D9304C" Ref="D0:0"  Part="1" 
AR Path="/55D94306/55D9304C" Ref="D0:1"  Part="1" 
AR Path="/55D936FC/55D9304C" Ref="D1:0"  Part="1" 
AR Path="/55D94310/55D9304C" Ref="D1:1"  Part="1" 
AR Path="/55D9491A/55D9304C" Ref="D2:1"  Part="1" 
F 0 "D2:1" H 5650 3600 40  0000 C CNN
F 1 "DIODE" H 5650 3400 40  0000 C CNN
F 2 "~" H 5650 3500 60  0000 C CNN
F 3 "~" H 5650 3500 60  0000 C CNN
	1    5650 3500
	1    0    0    -1  
$EndComp
$Comp
L LED L0:0
U 1 1 55D93052
P 5850 4200
AR Path="/55D95A82/55D93052" Ref="L0:0"  Part="1" 
AR Path="/55D94306/55D93052" Ref="L0:1"  Part="1" 
AR Path="/55D936FC/55D93052" Ref="L1:0"  Part="1" 
AR Path="/55D94310/55D93052" Ref="L1:1"  Part="1" 
AR Path="/55D9491A/55D93052" Ref="L2:1"  Part="1" 
F 0 "L2:1" H 5850 4300 50  0000 C CNN
F 1 "LED" H 5850 4100 50  0000 C CNN
F 2 "~" H 5850 4200 60  0000 C CNN
F 3 "~" H 5850 4200 60  0000 C CNN
	1    5850 4200
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR R0:0
U 1 1 55D93058
P 5400 4200
AR Path="/55D95A82/55D93058" Ref="R0:0"  Part="1" 
AR Path="/55D94306/55D93058" Ref="R0:1"  Part="1" 
AR Path="/55D936FC/55D93058" Ref="R1:0"  Part="1" 
AR Path="/55D94310/55D93058" Ref="R1:1"  Part="1" 
AR Path="/55D9491A/55D93058" Ref="R2:1"  Part="1" 
F 0 "R2:1" V 5400 4100 50  0000 C CNN
F 1 "RESISTOR" H 5400 4300 50  0001 C CNN
F 2 "~" H 5400 4200 60  0000 C CNN
F 3 "~" H 5400 4200 60  0000 C CNN
	1    5400 4200
	0    1    1    0   
$EndComp
Connection ~ 5450 3550
Connection ~ 5850 3800
Connection ~ 5150 3300
Connection ~ 6250 3200
Connection ~ 6050 3200
Connection ~ 6050 4400
Connection ~ 5850 3500
Connection ~ 5650 4200
Wire Wire Line
	5150 4200 5150 4000
Connection ~ 5150 4000
Connection ~ 5150 4200
Connection ~ 6050 4200
Wire Wire Line
	5850 3800 6250 3800
Connection ~ 6250 3800
Connection ~ 6400 4000
Connection ~ 5850 3300
Connection ~ 6250 4400
Wire Wire Line
	6050 4400 6050 3200
Wire Wire Line
	6250 3200 6250 4400
Wire Wire Line
	5150 3300 6400 3300
Connection ~ 6400 3300
Wire Wire Line
	5150 4000 6400 4000
Wire Wire Line
	5450 3500 5450 3550
Wire Wire Line
	5850 3500 5850 3300
Connection ~ 5450 3500
Text HLabel 6250 3200 1    60   BiDi ~ 0
SC0
Text HLabel 6050 3200 1    60   BiDi ~ 0
LC0
Text HLabel 6400 3300 2    60   BiDi ~ 0
SR1
Text HLabel 5150 3300 0    60   BiDi ~ 0
SR0
Text HLabel 6400 4000 2    60   BiDi ~ 0
LR1
Text HLabel 5150 4000 0    60   BiDi ~ 0
LR0
Text HLabel 6050 4400 3    60   BiDi ~ 0
LC1
Text HLabel 6250 4400 3    60   BiDi ~ 0
SC1
$EndSCHEMATC
