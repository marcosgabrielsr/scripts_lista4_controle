// =====================================================================
//  Lista 4 - Exercício 2, item (c): simulação com u(t) = sen(sqrt(2) t)
//  Malha fechada com c(s) = 6: gmf(s) = 6/(s^3 + 3s^2 + 2s + 6)
// =====================================================================
clear; clc;

s = %s;
K = 6;
gmf  = K/(s^3 + 3*s^2 + 2*s + K);       // FTMF = L/(1+L)
sysT = syslin('c', gmf);
disp("Polos de malha fechada:"); disp(roots(gmf.den));

w0 = sqrt(2);                            // frequência da entrada (rad/s)
deff('ut = uf(t)', 'ut = sin(sqrt(2)*t)');   // entrada como função contínua

// ---------------- critério de amostragem -----------------------------
T0   = 2*%pi/w0;                         // período da entrada
dtNy = T0/2;                             // limite de Nyquist-Shannon
mprintf("Periodo da entrada T0 = %.4f s  ->  passo maximo dt < %.4f s\n", T0, dtNy);
mprintf("Constante de tempo do polo -3: %.4f s\n", 1/3);

// ---------------- simulação com passo adequado -----------------------
dt = 0.01; tf = 60;
t  = 0:dt:tf;
y  = csim(uf, t, sysT);

// solução analítica (transformada inversa de Y(s) = 6*sqrt(2)/((s^2+2)^2 (s+3)))
yan = -3/11*t.*sin(w0*t) - 9*sqrt(2)/22*t.*cos(w0*t) ..
      + 135/242*sin(w0*t) - 6*sqrt(2)/121*cos(w0*t) + 6*sqrt(2)/121*exp(-3*t);
mprintf("Erro maximo simulacao x analitica: %.3e\n", max(abs(y - yan)));

A = 3/sqrt(22);                          // inclinação da envoltória
mprintf("Inclinacao da envoltoria: %.4f  ->  |y| ~ %.2f em t = %d s\n", A, A*tf, tf);
mprintf("|y| maximo nos ultimos 5 s: %.4f\n", max(abs(y(t > tf-5))));

scf(1); clf();
plot(t, uf(t), 'k-');
plot(t, y, 'b-', 'LineWidth', 2);
plot(t,  A*t, 'r--');
plot(t, -A*t, 'r--');
xgrid(color("gray"));
xlabel("t [s]"); ylabel("amplitude");
title("Resposta da malha fechada (K = 6) a u(t) = sen(sqrt(2) t)");
legend(["u(t)"; "y(t)"; "envoltoria +-0,64 t"], "in_upper_left");
xs2png(gcf(), "fig_ex2c_simulacao.png");

// ---------------- efeito de violar o teorema da amostragem ------------
dtc = 3;                                 // 3 s > T0/2 = 2,22 s
tc  = 0:dtc:tf;
yc  = csim(uf, tc, sysT);
wa  = abs(w0 - 2*%pi/dtc);               // frequência aparente (alias)
mprintf("dt = %d s: frequencia aparente = %.4f rad/s (periodo %.2f s)\n", dtc, wa, 2*%pi/wa);

scf(2); clf();
plot(t,  y,  'b-', 'LineWidth', 1);
plot(tc, yc, 'ro-', 'LineWidth', 2, 'MarkerSize', 6);
xgrid(color("gray"));
xlabel("t [s]"); ylabel("y(t)");
title("Amostragem da saida: dt = 0,01 s x dt = 3 s");
legend(["dt = 0,01 s"; "dt = 3 s (viola Nyquist)"], "in_upper_left");
xs2png(gcf(), "fig_ex2c_amostragem.png");
