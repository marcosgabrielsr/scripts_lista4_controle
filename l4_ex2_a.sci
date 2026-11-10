// =====================================================================
//  Lista 4 - Exercício 2, item (a): Diagrama de Nyquist
//  Planta g(s) = 1/(s(s+1)(s+2)), realimentação unitária, c(s) = K = 6
// =====================================================================
clear; clc;

s = %s;
g = 1/(s*(s+1)*(s+2));           // planta
K = 6;                           // compensador P
L = K*g;                         // FTMA  L(s) = c(s) g(s)

// ---------------- verificações numéricas -----------------------------
wf = sqrt(2);                    // cruzamento de fase previsto (rad/s)
Lwf = horner(L, %i*wf);
mprintf("L(j*sqrt(2)) = %.6f %+.6fj\n", real(Lwf), imag(Lwf));

sysL = syslin('c', L);
[MG, fMG] = g_margin(sysL);      // ATENÇÃO: o Scilab devolve frequência em Hz
[MF, fMF] = p_margin(sysL);
mprintf("Margem de ganho: %.4f dB em w = %.4f rad/s\n", MG, 2*%pi*fMG);
mprintf("Margem de fase : %.4f graus em w = %.4f rad/s\n", MF, 2*%pi*fMF);

pmf = roots(s^3 + 3*s^2 + 2*s + K);   // polos de malha fechada
disp("Polos de malha fechada (K = 6):"); disp(pmf);

// assíntota de baixa frequência: Re{L(jw)} quando w -> 0
mprintf("Re{L(j1e-5)} = %.4f  (assíntota vertical prevista: -4,5)\n", ..
        real(horner(L, %i*1e-5)));

// ---------------- resposta em frequência (rad/s) ---------------------
w   = logspace(-2, 2, 6000);     // 0,01 a 100 rad/s
Ljw = horner(L, %i*w);

// ---------------- Figura 1: Nyquist para K = 6 -----------------------
scf(1); clf();
plot(real(Ljw),  imag(Ljw), 'b-',  'LineWidth', 2);   // w > 0
plot(real(Ljw), -imag(Ljw), 'b--', 'LineWidth', 1);   // w < 0 (simétrico)
plot([-4.5 -4.5], [-10 10], 'k:');                    // assíntota Re = -4,5
plot(-1, 0, 'ro', 'MarkerSize', 8, 'LineWidth', 2);   // ponto crítico
a = gca(); a.data_bounds = [-5, -3; 1, 3]; a.tight_limits = "on";
xgrid(color("gray"));
xlabel("Re{L(jw)}"); ylabel("Im{L(jw)}");
title("Diagrama de Nyquist de L(s) = 6/(s(s+1)(s+2))");
legend(["w > 0"; "w < 0"; "assintota Re = -4,5"; "ponto -1 + j0"], "in_upper_left");
xs2png(gcf(), "fig_ex2a_nyquist.png");

// ---------------- Figura 2: comparação K = 4, 6, 8 (zoom) ------------
scf(2); clf();
plot(real(Ljw*4/6), imag(Ljw*4/6), 'g-', 'LineWidth', 2);
plot(real(Ljw),     imag(Ljw),     'b-', 'LineWidth', 2);
plot(real(Ljw*8/6), imag(Ljw*8/6), 'r-', 'LineWidth', 2);
plot(real(Ljw*4/6), -imag(Ljw*4/6), 'g--');
plot(real(Ljw),     -imag(Ljw),     'b--');
plot(real(Ljw*8/6), -imag(Ljw*8/6), 'r--');
plot(-1, 0, 'ko', 'MarkerSize', 8, 'LineWidth', 2);
a = gca(); a.data_bounds = [-2, -1; 0.5, 1]; a.tight_limits = "on";
xgrid(color("gray"));
xlabel("Re{L(jw)}"); ylabel("Im{L(jw)}");
title("Nyquist: efeito do ganho K sobre o ponto -1 + j0");
legend(["K = 4 (estavel)"; "K = 6 (marginal)"; "K = 8 (instavel)"], "in_upper_left");
xs2png(gcf(), "fig_ex2a_nyquist_k.png");
