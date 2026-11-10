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
 
// Aplicando comando horner
a1 = horner(G,10*%i);
a2 = horner(G,20*%i);

// Analisando resultados
// Resultados para frequencia de 10 rad/s
mprintf("\na1: %f + j*(%f)\n",real(a1),imag(a1));
mprintf("Amplitude de Saida: %f\n",0.05*abs(a1));
mprintf("Fase da Saida: = %f\n",atan(imag(a1)/real(a1))*180/%pi);
mprintf("Ganho da Saida: = %f\n",20*log10(abs(a1)));

// Resultados para frequencia de 20 rad/s
mprintf("\na2: %f + j*(%f)\n",real(a2),imag(a2));
mprintf("Amplitude de Saida: %f\n",0.05*abs(a2));
mprintf("Fase da Saida: %f\n",atan(imag(a2)/real(a2))*180/%pi);
mprintf("Ganho da Saida: = %f\n",20*log10(abs(a2)));
