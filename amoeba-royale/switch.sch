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
$Comp
L amoeba-royale-rescue:MX1A-amoeba-rescue S0
U 1 1 55DBAE7F
P 5200 4000
AR Path="/55DBAE7F" Ref="S0"  Part="1" 
AR Path="/55D92FDB/55DBAE5B/55DBAE7F" Ref="S0"  Part="1" 
F 0 "S0" H 5050 4250 60  0000 C CNN
F 1 "MX1A" H 5200 4100 60  0000 C CNN
F 2 "amoeba-modules:Kailh_MX_Socket" H 5200 4000 60  0001 C CNN
F 3 "~" H 5200 4000 60  0000 C CNN
	1    5200 4000
	1    0    0    -1  
$EndComp
$Comp
L amoeba-royale-rescue:DIODE-amoeba-rescue D1
U 1 1 55DBAE85
P 5200 3550
AR Path="/55DBAE85" Ref="D1"  Part="1" 
AR Path="/55D92FDB/55DBAE5B/55DBAE85" Ref="D1"  Part="1" 
F 0 "D1" H 5200 3650 40  0000 C CNN
F 1 "DIODE" H 5200 3450 40  0000 C CNN
F 2 "Diode_SMD:D_0805_2012Metric_Pad1.15x1.40mm_HandSolder" H 5200 3550 60  0001 C CNN
F 3 "~" H 5200 3550 60  0000 C CNN
	1    5200 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 3200 5000 3550
Text HLabel 5600 2750 1    60   BiDi ~ 0
SC0
Text HLabel 5800 2950 2    60   BiDi ~ 0
SR1
Text HLabel 4800 2950 0    60   BiDi ~ 0
SR0
Text HLabel 5600 4050 3    60   BiDi ~ 0
SC1
$Comp
L amoeba-royale-rescue:DIODE-amoeba-rescue D0
U 1 1 55DBAE93
P 5200 3200
AR Path="/55DBAE93" Ref="D0"  Part="1" 
AR Path="/55D92FDB/55DBAE5B/55DBAE93" Ref="D0"  Part="1" 
F 0 "D0" H 5200 3300 40  0000 C CNN
F 1 "DIODE" H 5200 3100 40  0000 C CNN
F 2 "Diode_THT:D_DO-35_SOD27_P10.16mm_Horizontal" H 5200 3200 60  0001 C CNN
F 3 "~" H 5200 3200 60  0000 C CNN
	1    5200 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5400 2950 5400 3200
Connection ~ 5400 2950
Connection ~ 5400 3200
Connection ~ 5000 3550
Wire Wire Line
	4800 2950 5400 2950
Wire Wire Line
	5600 2750 5600 3850
Wire Wire Line
	5400 3850 5600 3850
Connection ~ 5600 3850
Text Label 5000 3500 1    60   ~ 0
N-SD0
Wire Wire Line
	5400 2950 5800 2950
Wire Wire Line
	5400 3200 5400 3550
Wire Wire Line
	5000 3550 5000 3600
Wire Wire Line
	5600 3850 5600 4050
$EndSCHEMATC
