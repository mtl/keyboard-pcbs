EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title ""
Date "15 sep 2015"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 5600 3250 1    60   BiDi ~ 0
VDD0
Text HLabel 5200 3650 0    60   Input ~ 0
DIN0
Text HLabel 5600 4050 3    60   BiDi ~ 0
VSS0
Text HLabel 6000 3650 2    60   Output ~ 0
DOUT0
Wire Wire Line
	5600 3250 5600 3350
Wire Wire Line
	5900 3650 6000 3650
Wire Wire Line
	5200 3650 5300 3650
Wire Wire Line
	5600 3950 5600 4050
$Comp
L amoeba-royale-rescue:SK6812MINI_E LED1
U 1 1 5EC279EC
P 5600 3650
F 0 "LED1" H 5944 3696 50  0000 L CNN
F 1 "SK6812MINI_E" H 5944 3605 50  0000 L CNN
F 2 "amoeba-modules:LED_SK6812MINI_E_PLCC4_3.2x2.8mm_Shine_Through" H 5650 3350 50  0001 L TNN
F 3 "https://cdn-shop.adafruit.com/product-files/2686/SK6812MINI_REV.01-1-2.pdf" H 5700 3275 50  0001 L TNN
	1    5600 3650
	1    0    0    -1  
$EndComp
$EndSCHEMATC
