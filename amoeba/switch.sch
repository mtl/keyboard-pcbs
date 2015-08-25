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
LIBS:amoeba-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title ""
Date "25 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MX1A S0
U 1 1 55DBAE7F
P 5200 4000
F 0 "S0" H 5050 4250 60  0000 C CNN
F 1 "MX1A" H 5200 4100 60  0000 C CNN
F 2 "~" H 5200 4000 60  0000 C CNN
F 3 "~" H 5200 4000 60  0000 C CNN
	1    5200 4000
	1    0    0    -1  
$EndComp
$Comp
L DIODE D1
U 1 1 55DBAE85
P 5200 3550
F 0 "D1" H 5200 3650 40  0000 C CNN
F 1 "DIODE" H 5200 3450 40  0000 C CNN
F 2 "~" H 5200 3550 60  0000 C CNN
F 3 "~" H 5200 3550 60  0000 C CNN
	1    5200 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 3200 5000 3600
Text HLabel 5600 2750 1    60   BiDi ~ 0
SC0
Text HLabel 5800 2950 2    60   BiDi ~ 0
SR1
Text HLabel 4800 2950 0    60   BiDi ~ 0
SR0
Text HLabel 5600 4050 3    60   BiDi ~ 0
SC1
$Comp
L DIODE D0
U 1 1 55DBAE93
P 5200 3200
F 0 "D0" H 5200 3300 40  0000 C CNN
F 1 "DIODE" H 5200 3100 40  0000 C CNN
F 2 "~" H 5200 3200 60  0000 C CNN
F 3 "~" H 5200 3200 60  0000 C CNN
	1    5200 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 2950 5400 3550
Connection ~ 5400 2950
Connection ~ 5400 3200
Connection ~ 5000 3550
Wire Wire Line
	4800 2950 5800 2950
Wire Wire Line
	5600 2750 5600 4050
Wire Wire Line
	5400 3850 5600 3850
Connection ~ 5600 3850
Connection ~ 5400 3850
$EndSCHEMATC
