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
Sheet 3 4
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
L LED LED0
U 1 1 55DBAEC6
P 5700 3850
F 0 "LED0" H 5700 3950 50  0000 C CNN
F 1 "LED" H 5700 3750 50  0000 C CNN
F 2 "~" H 5700 3850 60  0000 C CNN
F 3 "~" H 5700 3850 60  0000 C CNN
	1    5700 3850
	1    0    0    -1  
$EndComp
$Comp
L RESISTOR R0
U 1 1 55DBAECC
P 5300 3600
F 0 "R0" V 5300 3500 50  0000 C CNN
F 1 "RESISTOR" H 5300 3700 50  0001 C CNN
F 2 "~" H 5300 3600 60  0000 C CNN
F 3 "~" H 5300 3600 60  0000 C CNN
	1    5300 3600
	-1   0    0    1   
$EndComp
Connection ~ 5900 3850
Text HLabel 5900 3150 1    60   BiDi ~ 0
LC0
Text HLabel 5100 3350 0    60   BiDi ~ 0
LR0
Text HLabel 5900 4050 3    60   BiDi ~ 0
LC1
$Comp
L RESISTOR R1
U 1 1 55DBAEDA
P 5500 3600
F 0 "R1" V 5500 3500 50  0000 C CNN
F 1 "RESISTOR" H 5500 3700 50  0001 C CNN
F 2 "~" H 5500 3600 60  0000 C CNN
F 3 "~" H 5500 3600 60  0000 C CNN
	1    5500 3600
	-1   0    0    1   
$EndComp
Connection ~ 5500 3850
Text HLabel 6100 3350 2    60   Input ~ 0
LR1
Wire Wire Line
	5300 3850 5500 3850
Wire Wire Line
	5900 3150 5900 4050
Wire Wire Line
	5100 3350 6100 3350
Connection ~ 5300 3350
Connection ~ 5500 3350
$EndSCHEMATC
