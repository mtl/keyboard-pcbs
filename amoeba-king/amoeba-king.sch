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
$Comp
L Connector:Conn_01x05_Male J2
U 1 1 5ED00D97
P 6500 3200
F 0 "J2" H 6472 3224 50  0000 R CNN
F 1 "Conn_01x05_Male" H 6472 3133 50  0000 R CNN
F 2 "amoeba-modules:Header_1x05_P1.27mm" H 6500 3200 50  0001 C CNN
F 3 "~" H 6500 3200 50  0001 C CNN
	1    6500 3200
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x05_Male J4
U 1 1 5ED02613
P 4200 3250
F 0 "J4" H 4150 3600 50  0000 C CNN
F 1 "Conn_01x05_Male" H 4200 2950 50  0000 C CNN
F 2 "amoeba-modules:Header_1x05_P1.27mm" H 4200 3250 50  0001 C CNN
F 3 "~" H 4200 3250 50  0001 C CNN
	1    4200 3250
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x05_Male J1
U 1 1 5ED03164
P 5400 2200
F 0 "J1" V 5462 1912 50  0000 R CNN
F 1 "Conn_01x05_Male" V 5553 1912 50  0000 R CNN
F 2 "amoeba-modules:Header_1x05_P1.27mm" H 5400 2200 50  0001 C CNN
F 3 "~" H 5400 2200 50  0001 C CNN
	1    5400 2200
	0    -1   1    0   
$EndComp
Entry Wire Line
	6050 3100 6150 3000
Entry Wire Line
	6050 3200 6150 3100
Entry Wire Line
	6050 3300 6150 3200
Entry Wire Line
	6050 3400 6150 3300
Entry Wire Line
	4550 3150 4650 3250
Entry Wire Line
	4550 3250 4650 3350
Entry Wire Line
	4550 3350 4650 3450
Entry Wire Line
	4550 3450 4650 3550
Entry Wire Line
	4550 3050 4650 3150
Entry Wire Line
	6050 3500 6150 3400
Entry Wire Line
	5100 2600 5200 2500
Entry Wire Line
	5200 2600 5300 2500
Entry Wire Line
	5300 2600 5400 2500
Entry Wire Line
	5400 2600 5500 2500
Entry Wire Line
	5500 2600 5600 2500
Entry Wire Line
	5150 4050 5250 3950
Entry Wire Line
	5250 4050 5350 3950
Entry Wire Line
	5350 4050 5450 3950
Entry Wire Line
	5450 4050 5550 3950
Entry Wire Line
	5550 4050 5650 3950
Wire Wire Line
	4400 3450 4550 3450
Wire Wire Line
	4550 3350 4400 3350
Wire Wire Line
	4550 3250 4400 3250
Wire Wire Line
	4550 3150 4400 3150
Wire Wire Line
	4550 3050 4400 3050
Wire Wire Line
	5200 2500 5200 2400
Wire Wire Line
	5300 2500 5300 2400
Wire Wire Line
	5400 2500 5400 2400
Wire Wire Line
	5500 2500 5500 2400
Wire Wire Line
	5600 2500 5600 2400
Wire Wire Line
	6150 3000 6300 3000
Wire Wire Line
	6150 3100 6300 3100
Wire Wire Line
	6150 3200 6300 3200
Wire Wire Line
	6150 3300 6300 3300
Wire Wire Line
	6150 3400 6300 3400
Wire Wire Line
	5550 4200 5550 4050
Wire Wire Line
	5450 4200 5450 4050
Wire Wire Line
	5350 4050 5350 4200
Wire Wire Line
	5250 4200 5250 4050
Wire Wire Line
	5150 4200 5150 4050
Text Label 6200 3400 0    50   ~ 0
DIN
Text Label 5200 2500 1    50   ~ 0
DIN
Text Label 5550 4050 3    50   ~ 0
DIN
Text Label 4450 3250 0    50   ~ 0
R
Text Label 6200 3200 0    50   ~ 0
R
Text Label 6200 3300 0    50   ~ 0
GND
Text Label 5500 2500 1    50   ~ 0
GND
Text Label 6200 3100 0    50   ~ 0
VDD
Text Label 5300 2500 1    50   ~ 0
VDD
Text Label 5600 2500 1    50   ~ 0
DOUT
Text Label 6200 3000 0    50   ~ 0
DOUT
Text Label 5150 4200 1    50   ~ 0
DOUT
Text Label 5350 4200 1    50   ~ 0
C
Text Label 5400 2500 1    50   ~ 0
C
Text Label 4450 3050 0    50   ~ 0
DIN
Text Label 4450 3450 0    50   ~ 0
DOUT
Text Label 5450 4200 1    50   ~ 0
GND
Text Label 5250 4200 1    50   ~ 0
VDD
Text Label 4450 3350 0    50   ~ 0
GND
Text Label 4450 3150 0    50   ~ 0
VDD
$Comp
L Connector:Conn_01x04_Male J3
U 1 1 5EC2A986
P 5250 4400
F 0 "J3" V 5404 4112 50  0000 R CNN
F 1 "Conn_01x04_Male" V 5313 4112 50  0000 R CNN
F 2 "amoeba-modules:Header_1x04_P1.27mm" H 5250 4400 50  0001 C CNN
F 3 "~" H 5250 4400 50  0001 C CNN
	1    5250 4400
	0    -1   -1   0   
$EndComp
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
Wire Bus Line
	6050 2600 6050 3950
Wire Bus Line
	4650 2600 6050 2600
Wire Bus Line
	4650 3950 6050 3950
Wire Bus Line
	4650 2600 4650 3950
$EndSCHEMATC
