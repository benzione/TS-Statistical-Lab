clear all;
clear clc;
close all;

Z=[65,71;
    72,77;
    77,73;
    68,78;
    81,76;
    73,87];
Y=[63,67;
    70,70;
    72,70;
    75,72;
    89,88;
    76,77];
[data]=mvregressMy(Z,Y);
