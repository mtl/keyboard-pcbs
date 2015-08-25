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
Sheet 2 4
Title ""
Date "25 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5550 4100 0    60   BiDi ~ 0
LC0
Text HLabel 6650 4250 2    60   BiDi ~ 0
LR1
Text HLabel 5550 4250 0    60   BiDi ~ 0
LR0
Text HLabel 6650 4100 2    60   BiDi ~ 0
LC1
$Sheet
S 5800 4000 600  350 
U 55DBAE59
F0 "led" 39
F1 "led.sch" 39
F2 "LC0" B L 5800 4100 60 
F3 "LR0" B L 5800 4250 60 
F4 "LC1" B R 6400 4100 60 
F5 "LR1" I R 6400 4250 60 
$EndSheet
$Sheet
S 5800 3300 600  350 
U 55DBAE5B
F0 "switch" 39
F1 "switch.sch" 39
F2 "SC0" B L 5800 3400 60 
F3 "SR1" B R 6400 3550 60 
F4 "SR0" B L 5800 3550 60 
F5 "SC1" B R 6400 3400 60 
$EndSheet
Wire Wire Line
	6650 4100 6400 4100
Wire Wire Line
	6400 4250 6650 4250
Wire Wire Line
	5800 4250 5550 4250
Wire Wire Line
	5550 4100 5800 4100
Text HLabel 5500 3400 0    60   Input ~ 0
SC0
Text HLabel 6700 3400 2    60   Input ~ 0
SC1
Text HLabel 6700 3550 2    60   Input ~ 0
SR1
Text HLabel 5500 3550 0    60   Input ~ 0
SR0
Wire Wire Line
	6700 3400 6400 3400
Wire Wire Line
	6400 3550 6700 3550
Wire Wire Line
	5800 3550 5500 3550
Wire Wire Line
	5500 3400 5800 3400
$EndSCHEMATC
