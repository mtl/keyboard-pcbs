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
LIBS:switch-omron
LIBS:mouse-buttons-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "26 aug 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_1 PL0
U 1 1 55D71CAE
P 2800 2350
F 0 "PL0" H 2880 2350 40  0000 L CNN
F 1 "CONN_1" H 2800 2405 30  0001 C CNN
F 2 "" H 2800 2350 60  0000 C CNN
F 3 "" H 2800 2350 60  0000 C CNN
	1    2800 2350
	0    -1   -1   0   
$EndComp
$Comp
L 10-XX SL0
U 1 1 55DD04B8
P 3050 2950
F 0 "SL0" V 2765 2850 50  0000 L BNN
F 1 "10-XX" V 2865 3075 50  0000 L BNN
F 2 "switch-omron-B3F-10XX" H 3050 3100 50  0001 C CNN
F 3 "" H 3050 2950 60  0000 C CNN
	1    3050 2950
	0    1    1    0   
$EndComp
$Comp
L 10-XX SC0
U 1 1 55DD05BF
P 4100 2950
F 0 "SC0" V 3815 2850 50  0000 L BNN
F 1 "10-XX" V 3915 3075 50  0000 L BNN
F 2 "switch-omron-B3F-10XX" H 4100 3100 50  0001 C CNN
F 3 "" H 4100 2950 60  0000 C CNN
	1    4100 2950
	0    1    1    0   
$EndComp
$Comp
L 10-XX SR0
U 1 1 55DD05C5
P 5200 2950
F 0 "SR0" V 4915 2850 50  0000 L BNN
F 1 "10-XX" V 5015 3075 50  0000 L BNN
F 2 "switch-omron-B3F-10XX" H 5200 3100 50  0001 C CNN
F 3 "" H 5200 2950 60  0000 C CNN
	1    5200 2950
	0    1    1    0   
$EndComp
$Comp
L CONN_1 PR0
U 1 1 55DD05CB
P 4950 2350
F 0 "PR0" H 5030 2350 40  0000 L CNN
F 1 "CONN_1" H 4950 2405 30  0001 C CNN
F 2 "" H 4950 2350 60  0000 C CNN
F 3 "" H 4950 2350 60  0000 C CNN
	1    4950 2350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 PC0
U 1 1 55DD05D1
P 3850 2350
F 0 "PC0" H 3930 2350 40  0000 L CNN
F 1 "CONN_1" H 3850 2405 30  0001 C CNN
F 2 "" H 3850 2350 60  0000 C CNN
F 3 "" H 3850 2350 60  0000 C CNN
	1    3850 2350
	0    -1   -1   0   
$EndComp
$Comp
L CONN_1 GND0
U 1 1 55DD05D7
P 4100 3450
F 0 "GND0" H 4180 3450 40  0000 L CNN
F 1 "CONN_1" H 4100 3505 30  0001 C CNN
F 2 "" H 4100 3450 60  0000 C CNN
F 3 "" H 4100 3450 60  0000 C CNN
	1    4100 3450
	0    1    1    0   
$EndComp
Wire Wire Line
	3400 3300 5550 3300
Wire Wire Line
	5550 3300 5550 2950
Wire Wire Line
	5550 2950 5400 2950
Wire Wire Line
	3400 3300 3400 2950
Wire Wire Line
	3400 2950 3250 2950
Connection ~ 4100 3300
Wire Wire Line
	4300 2950 4450 2950
Wire Wire Line
	4450 2950 4450 3300
Connection ~ 4450 3300
Wire Wire Line
	3850 2500 3850 2950
Wire Wire Line
	3850 2950 3900 2950
Wire Wire Line
	2800 2500 2800 2950
Wire Wire Line
	2800 2950 2850 2950
Wire Wire Line
	4950 2500 4950 2950
Wire Wire Line
	4950 2950 5000 2950
NoConn ~ 5400 3050
NoConn ~ 5000 3050
NoConn ~ 4300 3050
NoConn ~ 3900 3050
NoConn ~ 3250 3050
NoConn ~ 2850 3050
$EndSCHEMATC
