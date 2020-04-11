EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 2 4
Title ""
Date "15 sep 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5400 2950 1    60   BiDi ~ 0
VDD0
Text HLabel 5400 3450 2    60   Input ~ 0
DIN0
Text HLabel 4300 3450 0    60   Output ~ 0
DOUT0
Text HLabel 5400 3950 3    60   BiDi ~ 0
VSS0
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
$Sheet
S 4550 3200 600  500 
U 55DBAE59
F0 "led" 39
F1 "led.sch" 39
F2 "VDD0" B R 5150 3300 50 
F3 "DIN0" I R 5150 3450 50 
F4 "VSS0" B R 5150 3600 50 
F5 "DOUT0" O L 4550 3450 50 
$EndSheet
$EndSCHEMATC
