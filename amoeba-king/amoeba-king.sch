EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 4
Title ""
Date "15 sep 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Entry Wire Line
	4650 2950 4750 3050
Entry Wire Line
	4650 3100 4750 3200
Entry Wire Line
	4650 3250 4750 3350
Entry Wire Line
	4650 3400 4750 3500
$Sheet
S 5000 2950 700  650 
U 55D92FDB
F0 "key" 39
F1 "key.sch" 39
F2 "VDD0" B L 5000 3050 50 
F3 "DIN0" I L 5000 3200 50 
F4 "DOUT0" O L 5000 3350 50 
F5 "VSS0" B L 5000 3500 50 
F6 "SC0" B R 5700 3200 50 
F7 "SR0" B R 5700 3350 50 
$EndSheet
Wire Wire Line
	5000 3350 4750 3350
Wire Wire Line
	5000 3500 4750 3500
Entry Wire Line
	5950 3350 6050 3250
Entry Wire Line
	5950 3200 6050 3100
Wire Wire Line
	5950 3200 5700 3200
Wire Wire Line
	5950 3350 5700 3350
Wire Wire Line
	4750 3050 5000 3050
Wire Wire Line
	4750 3200 5000 3200
Text Label 5800 3200 0    50   ~ 0
C
Text Label 5800 3350 0    50   ~ 0
R
Text Label 4800 3050 0    50   ~ 0
VDD
Text Label 4800 3200 0    50   ~ 0
DIN
Text Label 4800 3350 0    50   ~ 0
DOUT
Text Label 4800 3500 0    50   ~ 0
GND
Entry Wire Line
	4550 3250 4650 3350
Entry Wire Line
	4550 3050 4650 3150
Entry Wire Line
	4550 3350 4650 3450
Entry Wire Line
	4550 2600 4650 2700
Text Label 4450 3050 0    50   ~ 0
R
Text Label 4550 3000 0    50   ~ 0
DIN
Text Label 4500 2600 0    50   ~ 0
DOUT
Text Label 4450 3350 0    50   ~ 0
GND
Text Label 4450 3250 0    50   ~ 0
VDD
$Comp
L Connector:Conn_01x01_Male J5
U 1 1 5EC458E5
P 4800 2200
F 0 "J5" V 4862 2244 50  0000 L CNN
F 1 "Conn_01x01_Male" V 4953 2244 50  0000 L CNN
F 2 "amoeba-modules:Header_1x01_P1.27mm" H 4800 2200 50  0001 C CNN
F 3 "~" H 4800 2200 50  0001 C CNN
	1    4800 2200
	0    1    1    0   
$EndComp
$Comp
L Connector:Conn_01x01_Male J6
U 1 1 5EC464E7
P 4750 4400
F 0 "J6" V 4904 4312 50  0000 R CNN
F 1 "Conn_01x01_Male" V 4813 4312 50  0000 R CNN
F 2 "amoeba-modules:Header_1x01_P1.27mm" H 4750 4400 50  0001 C CNN
F 3 "~" H 4750 4400 50  0001 C CNN
	1    4750 4400
	0    -1   -1   0   
$EndComp
Entry Wire Line
	4750 4050 4850 3950
Entry Wire Line
	4700 2600 4800 2500
Wire Wire Line
	4800 2500 4800 2400
Wire Wire Line
	4750 4200 4750 4050
Text Label 4800 2500 1    50   ~ 0
C
Text Label 4750 4200 1    50   ~ 0
C
$Comp
L Jumper:SolderJumper_3_Bridged12 JP1
U 1 1 5ECEDDD1
P 4500 2800
F 0 "JP1" V 4546 2868 50  0000 L CNN
F 1 "SolderJumper_3_Bridged12" V 4455 2868 50  0000 L CNN
F 2 "amoeba-modules:SolderJumper-3_P1.3mm_Open_RoundedPad1.0x1.5mm" H 4500 2800 50  0001 C CNN
F 3 "~" H 4500 2800 50  0001 C CNN
	1    4500 2800
	0    1    -1   0   
$EndComp
$Comp
L Connector:Conn_01x04_Male J1
U 1 1 5ECF294A
P 4100 3150
F 0 "J1" H 4208 3431 50  0000 C CNN
F 1 "Conn_01x04_Male" H 4208 3340 50  0000 C CNN
F 2 "amoeba-modules:Header_1x04_P1.27mmL" H 4100 3150 50  0001 C CNN
F 3 "~" H 4100 3150 50  0001 C CNN
	1    4100 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	4300 3350 4550 3350
Entry Wire Line
	5750 2600 5850 2500
Text Label 5850 2500 1    50   ~ 0
VDD
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 5ED091AF
P 5750 2050
F 0 "J2" V 5812 1762 50  0000 R CNN
F 1 "Conn_01x04_Male" V 5903 1762 50  0000 R CNN
F 2 "amoeba-modules:Header_1x04_P1.27mm" H 5750 2050 50  0001 C CNN
F 3 "~" H 5750 2050 50  0001 C CNN
	1    5750 2050
	0    -1   1    0   
$EndComp
Text Label 5650 2500 1    50   ~ 0
C
Text Label 5950 2500 1    50   ~ 0
GND
Entry Wire Line
	5850 2600 5950 2500
Entry Wire Line
	5550 2600 5650 2500
Entry Wire Line
	6150 3000 6050 2900
Entry Wire Line
	6150 3200 6050 3100
Entry Wire Line
	6150 2900 6050 2800
Entry Wire Line
	6150 3650 6050 3550
Entry Wire Line
	6150 3250 6050 3150
Text Label 6300 3200 2    50   ~ 0
R
Text Label 6150 3250 2    50   ~ 0
DIN
Text Label 6200 3650 2    50   ~ 0
DOUT
Text Label 6250 2900 2    50   ~ 0
GND
Text Label 6150 3000 2    50   ~ 0
VDD
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 5ED2E622
P 6600 3100
F 0 "J3" H 6708 3381 50  0000 C CNN
F 1 "Conn_01x04_Male" H 6708 3290 50  0000 C CNN
F 2 "amoeba-modules:Header_1x04_P1.27mm" H 6600 3100 50  0001 C CNN
F 3 "~" H 6600 3100 50  0001 C CNN
	1    6600 3100
	-1   0    0    1   
$EndComp
Wire Wire Line
	6400 2900 6150 2900
Entry Wire Line
	4550 3000 4650 3100
Wire Wire Line
	4500 2600 4550 2600
Wire Wire Line
	4550 3000 4500 3000
Wire Wire Line
	6350 3450 6400 3450
Wire Wire Line
	6200 3250 6150 3250
Wire Wire Line
	6200 3650 6150 3650
$Comp
L Jumper:SolderJumper_3_Bridged12 JP2
U 1 1 5ED2E618
P 6200 3450
F 0 "JP2" V 6246 3518 50  0000 L CNN
F 1 "SolderJumper_3_Bridged12" V 6155 3518 50  0000 L CNN
F 2 "amoeba-modules:SolderJumper-3_P1.3mm_Open_RoundedPad1.0x1.5mm" H 6200 3450 50  0001 C CNN
F 3 "~" H 6200 3450 50  0001 C CNN
	1    6200 3450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5950 2250 5950 2500
Entry Wire Line
	5350 3950 5250 4050
Text Label 5250 4050 3    50   ~ 0
VDD
$Comp
L Connector:Conn_01x04_Male J4
U 1 1 5ED66F35
P 5350 4500
F 0 "J4" V 5412 4212 50  0000 R CNN
F 1 "Conn_01x04_Male" V 5503 4212 50  0000 R CNN
F 2 "amoeba-modules:Header_1x04_P1.27mmL" H 5350 4500 50  0001 C CNN
F 3 "~" H 5350 4500 50  0001 C CNN
	1    5350 4500
	0    1    -1   0   
$EndComp
Text Label 5450 4050 3    50   ~ 0
C
Text Label 5150 4050 3    50   ~ 0
GND
Entry Wire Line
	5250 3950 5150 4050
Entry Wire Line
	5550 3950 5450 4050
Wire Wire Line
	5150 4300 5150 4050
Wire Wire Line
	6400 3450 6400 4250
Wire Wire Line
	5400 2300 5400 2150
Wire Wire Line
	5400 2150 4350 2150
Wire Wire Line
	4350 2150 4350 2800
Wire Wire Line
	5450 4300 5450 4050
Wire Wire Line
	5650 2500 5650 2250
Text Label 4500 2150 0    50   ~ 0
D1
Text Label 6300 4250 0    50   ~ 0
D2
Wire Wire Line
	6150 3200 6400 3200
Wire Wire Line
	4550 3050 4300 3050
Wire Wire Line
	5850 2500 5850 2250
Wire Wire Line
	5750 2250 5750 2300
Wire Wire Line
	5750 2300 5400 2300
Wire Wire Line
	4300 3150 4350 3150
Wire Wire Line
	4350 3150 4350 2800
Connection ~ 4350 2800
Wire Wire Line
	4550 3250 4300 3250
Wire Wire Line
	6150 3000 6400 3000
Wire Wire Line
	6400 3100 6350 3100
Wire Wire Line
	6350 3100 6350 3450
Connection ~ 6350 3450
Wire Wire Line
	5250 4300 5250 4050
Wire Wire Line
	5350 4300 5350 4250
Wire Wire Line
	5350 4250 6400 4250
Wire Bus Line
	4650 3950 6050 3950
Wire Bus Line
	4650 2600 6050 2600
Wire Bus Line
	6050 2600 6050 3950
Wire Bus Line
	4650 2600 4650 3950
$EndSCHEMATC
