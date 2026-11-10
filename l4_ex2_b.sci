// =====================================================================
//  Lista 4 - Exercício 2, item (b): Diagrama de Black
//  Planta g(s) = 1/(s(s+1)(s+2)), realimentação unitária, c(s) = K = 6
// =====================================================================
clear; clc;

s = %s;
g = 1/(s*(s+1)*(s+2));
K = 6;
L = K*g;

w   = logspace(-2, 2, 6000);            // rad/s
Ljw = horner(L, %i*w);
[fase, gdb] = phasemag(Ljw);            // fase contínua (graus) e ganho (dB)

// ---------------- leitura dos cruzamentos ----------------------------
[d1, i180] = min(abs(fase + 180));       // cruzamento de fase (-180°)
[d2, i0]   = min(abs(gdb));              // cruzamento de ganho (0 dB)
mprintf("Cruzamento de fase : w = %.4f rad/s, ganho = %.4f dB\n", w(i180), gdb(i180));
mprintf("Cruzamento de ganho: w = %.4f rad/s, fase  = %.4f graus\n", w(i0), fase(i0));
mprintf("MG = %.4f dB  |  MF = %.4f graus\n", -gdb(i180), 180 + fase(i0));

// ---------------- tabela de alguns pontos -----------------------------
wt = [0.2 0.5 1 sqrt(2) 2 5 10];
[ft, gt] = phasemag(horner(L, %i*wt));
mprintf("\n   w (rad/s)   ganho (dB)   fase (graus)\n");
for k = 1:size(wt, "*")
    mprintf("   %8.4f   %9.2f   %10.2f\n", wt(k), gt(k), ft(k));
end

// ---------------- Figura: Black para K = 4, 6, 8 ----------------------
scf(1); clf();
plot(fase, gdb + 20*log10(4/6), 'g-', 'LineWidth', 2);
plot(fase, gdb,                 'b-', 'LineWidth', 2);
plot(fase, gdb + 20*log10(8/6), 'r-', 'LineWidth', 2);
plot([-180 -180], [-60 60], 'k:');
plot([-280 -80], [0 0], 'k:');
plot(-180, 0, 'ko', 'MarkerSize', 8, 'LineWidth', 2);     // ponto crítico
a = gca(); a.data_bounds = [-270, -40; -90, 40]; a.tight_limits = "on";
xgrid(color("gray"));
xlabel("arg L(jw) [graus]"); ylabel("||L(jw)|| [dB]");
title("Diagrama de Black de L(s) = K/(s(s+1)(s+2))");
legend(["K = 4 (estavel)"; "K = 6 (marginal)"; "K = 8 (instavel)"], "in_upper_right");
xs2png(gcf(), "fig_ex2b_black.png");
