EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 3 4
Title ""
Date "15 sep 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4600 3350 4450 3350
Text Label 5000 3500 1    60   ~ 0
N-SD0
Wire Wire Line
	5000 3550 5000 3600
$Comp
L amoeba-royale-rescue:MX1A-amoeba-rescue S?
U 1 1 55DBAE7F
P 4800 3750
AR Path="/55DBAE7F" Ref="S?"  Part="1" 
AR Path="/55D92FDB/55DBAE5B/55DBAE7F" Ref="S1"  Part="1" 
F 0 "S1" H 4650 4000 60  0000 C CNN
F 1 "MX1A" H 4800 3850 60  0000 C CNN
F 2 "amoeba-modules:Kailh_MX_Socket" H 4800 3750 60  0001 C CNN
F 3 "~" H 4800 3750 60  0000 C CNN
	1    4800 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 3550 5600 3550
Wire Wire Line
	5600 2750 5600 3550
Text HLabel 5600 2750 1    60   BiDi ~ 0
SC0
Text HLabel 4450 3350 0    60   BiDi ~ 0
SR0
$Comp
L Device:D D1
U 1 1 5EC43574
P 5250 3550
F 0 "D1" H 5250 3334 50  0000 C CNN
F 1 "1N4148W-7-F" H 5250 3425 50  0000 C CNN
F 2 "Diode_SMD:D_SOD-323" H 5250 3550 50  0001 C CNN
F 3 "~" H 5250 3550 50  0001 C CNN
	1    5250 3550
	-1   0    0    1   
$EndComp
Wire Wire Line
	5100 3550 5000 3550
$EndSCHEMATC
