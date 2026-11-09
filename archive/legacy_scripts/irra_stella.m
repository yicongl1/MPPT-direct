close all
clear
clc

irra = readtable('irradiation_stella.xlsx');
irra = table2array(irra);

rowsums = sum(irra, 2);

KWhjour = rowsums * 60 / 3600000

KWhan = sum(KWhjour)

disp(KWhjour)
plot(KWhjour)
disp(KWhan)