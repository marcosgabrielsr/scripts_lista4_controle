// Lista de Exercicios 4
clear;
clc;

// Definindo Variaveis do Sistema
m = 400;
b = 200;
k = 97.66;

// Definindo funcao de transferencia
s = %s;
G = syslin('c',0.5*s + 0.244,s**2+0.5*s+0.244);
mprintf("Funcao de Transferencia:\n");
disp(G);

// PLotando Diagrama de Bode
bode(G,"rad");
