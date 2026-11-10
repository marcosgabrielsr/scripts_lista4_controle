// Lista de Exercicios 4
clear; clc;

// Definindo Variaveis do Sistema
m = 400;
b = 200;
k = 97.66;

// Definindo funcao de transferencia
s = %s;
G = syslin('c', 0.5*s + 0.244, s^2 + 0.5*s + 0.244);

mprintf("Funcao de Transferencia:\n");
disp(G);

// Definindo funcoes seno
deff('u=seno10rads(t)', 'u=0.05*sin(10*t)');
deff('u=seno20rads(t)', 'u=0.05*sin(20*t)');

// Simulação de 0 a 20s com resolução de 0.005s
t = 0:0.005:20;
y1 = csim(seno10rads, t, G);
y2 = csim(seno20rads, t, G);

// Plotando resultados
clf();

// Subplot Superior: Entrada 0.05*sin(10t)
subplot(2, 1, 1);
plot(t, y1, 'r');
xgrid();
title('Resposta para 0.05*sin(10t)');
xlabel('Tempo (s)');
ylabel('Amplitude');

// Subplot Inferior: Entrada 0.05*sin(20t)
subplot(2, 1, 2);
plot(t, y2, 'g');
xgrid();
title('Resposta para 0.05*sin(20t)');
xlabel('Tempo (s)');
ylabel('Amplitude');
