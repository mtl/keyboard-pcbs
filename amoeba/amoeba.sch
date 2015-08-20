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
LIBS:amoeba-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "20 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MX1A S1
U 1 1 55D0764C
P 5250 3250
F 0 "S1" H 5100 3500 60  0000 C CNN
F 1 "MX1A" H 5250 3350 60  0000 C CNN
F 2 "~" H 5250 3250 60  0000 C CNN
F 3 "~" H 5250 3250 60  0000 C CNN
	1    5250 3250
	1    0    0    -1  
$EndComp
$Comp
L DIODE D1
U 1 1 55D07664
P 5250 3350
F 0 "D1" H 5250 3450 40  0000 C CNN
F 1 "DIODE" H 5250 3250 40  0000 C CNN
F 2 "~" H 5250 3350 60  0000 C CNN
F 3 "~" H 5250 3350 60  0000 C CNN
	1    5250 3350
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 LR1
U 1 1 55D07696
P 6400 3100
F 0 "LR1" H 6480 3100 40  0000 L CNN
F 1 "CONN_1" H 6400 3155 30  0001 C CNN
F 2 "" H 6400 3100 60  0000 C CNN
F 3 "" H 6400 3100 60  0000 C CNN
	1    6400 3100
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 SR1
U 1 1 55D076A3
P 6400 3350
F 0 "SR1" H 6480 3350 40  0000 L CNN
F 1 "CONN_1" H 6400 3405 30  0001 C CNN
F 2 "" H 6400 3350 60  0000 C CNN
F 3 "" H 6400 3350 60  0000 C CNN
	1    6400 3350
	1    0    0    -1  
$EndComp
$Comp
L CONN_1 SC2
U 1 1 55D076A9
P 6000 4950
F 0 "SC2" H 6080 4950 40  0000 L CNN
F 1 "CONN_1" H 6000 5005 30  0001 C CNN
F 2 "" H 6000 4950 60  0000 C CNN
F 3 "" H 6000 4950 60  0000 C CNN
	1    6000 4950
	0    1    1    0   
$EndComp
$Comp
L CONN_1 LC2
U 1 1 55D076B1
P 5700 4950
F 0 "LC2" H 5780 4950 40  0000 L CNN
F 1 "CONN_1" H 5700 5005 30  0001 C CNN
F 2 "" H 5700 4950 60  0000 C CNN
F 3 "" H 5700 4950 60  0000 C CNN
	1    5700 4950
	0    1    1    0   
$EndComp
$Comp
L CONN_1 SC0
U 1 1 55D076B7
P 5400 2200
F 0 "SC0" H 5480 2200 40  0000 L CNN
F 1 "CONN_1" H 5400 2255 30  0001 C CNN
F 2 "" H 5400 2200 60  0000 C CNN
F 3 "" H 5400 2200 60  0000 C CNN
	1    5400 2200
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 LC0
U 1 1 55D076BD
P 5100 2200
F 0 "LC0" H 5180 2200 40  0000 L CNN
F 1 "CONN_1" H 5100 2255 30  0001 C CNN
F 2 "" H 5100 2200 60  0000 C CNN
F 3 "" H 5100 2200 60  0000 C CNN
	1    5100 2200
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 LR0
U 1 1 55D076C3
P 4000 3150
F 0 "LR0" H 4080 3150 40  0000 L CNN
F 1 "CONN_1" H 4000 3205 30  0001 C CNN
F 2 "" H 4000 3150 60  0000 C CNN
F 3 "" H 4000 3150 60  0000 C CNN
	1    4000 3150
	-1   0    0    1   
$EndComp
$Comp
L CONN_1 SR0
U 1 1 55D076C9
P 4000 3350
F 0 "SR0" H 4080 3350 40  0000 L CNN
F 1 "CONN_1" H 4000 3405 30  0001 C CNN
F 2 "" H 4000 3350 60  0000 C CNN
F 3 "" H 4000 3350 60  0000 C CNN
	1    4000 3350
	-1   0    0    1   
$EndComp
$Comp
L CONN_1 LC1
U 1 1 55D076CF
P 4400 4950
F 0 "LC1" H 4480 4950 40  0000 L CNN
F 1 "CONN_1" H 4400 5005 30  0001 C CNN
F 2 "" H 4400 4950 60  0000 C CNN
F 3 "" H 4400 4950 60  0000 C CNN
	1    4400 4950
	0    1    1    0   
$EndComp
$Comp
L CONN_1 SC1
U 1 1 55D076D7
P 4650 4950
F 0 "SC1" H 4730 4950 40  0000 L CNN
F 1 "CONN_1" H 4650 5005 30  0001 C CNN
F 2 "" H 4650 4950 60  0000 C CNN
F 3 "" H 4650 4950 60  0000 C CNN
	1    4650 4950
	0    1    1    0   
$EndComp
Wire Wire Line
	4150 3150 4150 2600
Wire Wire Line
	6250 2600 6250 3100
$Comp
L LED LED1
U 1 1 55D07715
P 5250 4250
F 0 "LED1" H 5250 4350 50  0000 C CNN
F 1 "LED" H 5250 4150 50  0000 C CNN
F 2 "~" H 5250 4250 60  0000 C CNN
F 3 "~" H 5250 4250 60  0000 C CNN
	1    5250 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5450 4250 5700 4250
Wire Wire Line
	5050 2850 4900 2850
Wire Wire Line
	6000 3100 5450 3100
Connection ~ 6000 3100
Wire Wire Line
	4650 4800 4650 4700
Wire Wire Line
	4650 4700 6000 4700
Connection ~ 5050 2850
Connection ~ 5450 3100
Connection ~ 5050 4250
Connection ~ 5450 4250
Connection ~ 4650 4800
Connection ~ 4400 4800
Connection ~ 6250 3350
Connection ~ 6250 3100
Connection ~ 4150 3150
Connection ~ 4150 3350
Connection ~ 11950 4500
Wire Wire Line
	4150 3350 4150 4000
Wire Wire Line
	6250 4000 6250 3350
Connection ~ 4400 4450
Connection ~ 4700 2600
Wire Wire Line
	4700 4250 5050 4250
Wire Wire Line
	5050 3350 4900 3350
Connection ~ 4900 3350
Connection ~ 5050 3350
Connection ~ 5450 3350
Connection ~ 6000 4700
Wire Wire Line
	5700 4250 5700 4800
Wire Wire Line
	5700 4450 4400 4450
Connection ~ 5700 4450
Wire Wire Line
	5400 2350 6000 2350
Wire Wire Line
	5100 2350 4400 2350
Connection ~ 5400 2350
Connection ~ 5100 2350
Connection ~ 5700 4800
Connection ~ 6000 4800
Wire Wire Line
	4900 3350 4900 2850
Wire Wire Line
	6000 2350 6000 4800
Wire Wire Line
	4400 2350 4400 4800
Wire Wire Line
	4150 2600 6250 2600
Wire Wire Line
	4150 4000 6250 4000
Text Notes 5500 2150 0    60   ~ 0
Switch\ncolumn
Text Notes 6350 3000 0    60   ~ 0
LED row
Text Notes 6350 3500 0    60   ~ 0
Switch row
Text Notes 5000 2150 2    60   ~ 0
LED\ncolumn
Text Notes 4050 3050 2    60   ~ 0
LED row
Text Notes 4050 3500 2    60   ~ 0
Switch row
Text Notes 6100 4950 0    60   ~ 0
Switch\ncolumn
Text Notes 4300 4950 2    60   ~ 0
LED\ncolumn
Text Notes 5500 3450 0    60   ~ 0
Switch\ndiode
Text Notes 4750 4950 0    60   ~ 0
Switch\ncolumn
Text Notes 5600 4950 2    60   ~ 0
LED\ncolumn
Text Notes 4950 4100 0    60   ~ 0
In-switch LED
Text Notes 5250 2900 0    60   ~ 0
Switch\n
$Comp
L RESISTOR R1
U 1 1 55D51261
P 4700 3650
F 0 "R1" H 4700 3550 50  0000 C CNN
F 1 "RESISTOR" H 4700 3750 50  0000 C CNN
F 2 "~" H 4700 3650 60  0000 C CNN
F 3 "~" H 4700 3650 60  0000 C CNN
	1    4700 3650
	-1   0    0    1   
$EndComp
Wire Wire Line
	4700 3400 4700 2600
Wire Wire Line
	4700 3900 4700 4250
Connection ~ 4700 3900
Connection ~ 4700 3400
Text Notes 4800 3600 0    60   ~ 0
LED\nresistor
Wire Wire Line
	6250 3350 5450 3350
$EndSCHEMATC
