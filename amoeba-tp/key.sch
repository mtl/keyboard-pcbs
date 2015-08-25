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
Sheet 14 16
Title ""
Date "25 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5400 2950 1    60   BiDi ~ 0
LC0
Text HLabel 5400 3450 2    60   BiDi ~ 0
LR1
Text HLabel 4300 3450 0    60   BiDi ~ 0
LR0
Text HLabel 5400 3950 3    60   BiDi ~ 0
LC1
$Sheet
S 4550 3200 600  500 
U 55DBAE59
F0 "led" 39
F1 "led.sch" 39
F2 "LC0" B R 5150 3300 60 
F3 "LR0" B L 4550 3450 60 
F4 "LC1" B R 5150 3600 60 
F5 "LR1" I R 5150 3450 60 
$EndSheet
$Sheet
S 6400 3200 600  500 
U 55DBAE5B
F0 "switch" 39
F1 "switch.sch" 39
F2 "SC0" B L 6400 3300 60 
F3 "SR1" B R 7000 3450 60 
F4 "SR0" B L 6400 3450 60 
F5 "SC1" B L 6400 3600 60 
$EndSheet
Wire Wire Line
	4550 3450 4300 3450
Text HLabel 6100 2950 1    60   BiDi ~ 0
SC0
Text HLabel 6100 3950 3    60   BiDi ~ 0
SC1
Text HLabel 7250 3450 2    60   BiDi ~ 0
SR1
Text HLabel 6100 3450 0    60   BiDi ~ 0
SR0
Wire Wire Line
	6400 3450 6100 3450
Wire Wire Line
	5150 3300 5400 3300
Wire Wire Line
	5400 3300 5400 2950
Wire Wire Line
	5150 3450 5400 3450
Wire Wire Line
	5150 3600 5400 3600
Wire Wire Line
	5400 3600 5400 3950
Wire Wire Line
	7250 3450 7000 3450
Wire Wire Line
	6400 3300 6100 3300
Wire Wire Line
	6100 3300 6100 2950
Wire Wire Line
	6100 3950 6100 3600
Wire Wire Line
	6100 3600 6400 3600
$EndSCHEMATC
