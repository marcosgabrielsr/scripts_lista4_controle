// Lista 4 - Ex. 3 (tanques) - LETRA d: simulacao e comparacao
// u = K(M r + x) (b)  e  u = K(M r + xh) (c)
clear; clc; xdel(winsid());

A = [-1/3, 1/3; 5/8, -25/24];
B = [2/3; 0];
C = [0 1];
K = [0.2625, -1.8322];          // letra b
M = [0.1324; -0.9242];          // letra b
L = [-1.5351; -1.0250];         // letra c
q = 0.1;                        // vazao de entrada (m3/s), malha aberta
r = 0.3;                        // referencia de nivel (m)

Amf_b = A + B*K;
Amf_c = [ A,     B*K;
         -L*C,   A + L*C + B*K ];
Bmf_c = [B*K*M; B*K*M];
Cmf_c = [C, zeros(1,2)];

t  = 0:0.01:40;
x0 = [0.1; 0.1];

sis_ma = syslin('c', A,     B,     C,     0);
sis_b  = syslin('c', Amf_b, B*K*M, C,     0);
sis_c  = syslin('c', Amf_c, Bmf_c, Cmf_c, 0);

// Caso 1: condicoes iniciais nulas
y_ma        = csim(q*ones(t), t, sis_ma);
[y_b,  X_b] = csim(r*ones(t), t, sis_b);
[y_c,  X_c] = csim(r*ones(t), t, sis_c);

// Caso 2: x(0) = 0,1 m e xh(0) = 0
[y_b2, X_b2] = csim(r*ones(t), t, sis_b, x0);
[y_c2, X_c2] = csim(r*ones(t), t, sis_c, [x0; 0; 0]);
erro = X_c2(3:4,:) - X_c2(1:2,:);          // xh - x

u_b2 = K*M*r + K*X_b2;
u_c2 = K*M*r + K*X_c2(3:4,:);

scf(1); clf();
plot(t, y_ma, 'k', t, y_b, 'b', t, y_c, 'r--');
xgrid(); xlabel("t (s)"); ylabel("h2 (m)");
legend(["Malha aberta"; "Realim. de estado (b)"; "Com observador (c)"], 4);
title("Resposta ao degrau - condicoes iniciais nulas");
xs2png(gcf(), "fig1_h2_ci_nulas.png");

scf(2); clf();
plot(t, y_b2, 'b', t, y_c2, 'r--');
xgrid(); xlabel("t (s)"); ylabel("h2 (m)");
legend(["Realim. de estado (b)"; "Com observador (c)"], 4);
title("Resposta ao degrau - x(0) = [0,1; 0,1], xh(0) = 0");
xs2png(gcf(), "fig2_h2_ci_nao_nulas.png");

scf(3); clf();
plot(t, erro(1,:), 'm', t, erro(2,:), 'g');
xgrid(); xlabel("t (s)"); ylabel("erro (m)");
legend(["h1 estimado - h1"; "h2 estimado - h2"], 1);
title("Erro de estimacao do observador");
xs2png(gcf(), "fig3_erro_observador.png");

scf(4); clf();
plot(t, u_b2, 'b', t, u_c2, 'r--');
xgrid(); xlabel("t (s)"); ylabel("u = q (m3/s)");
legend(["Realim. de estado (b)"; "Com observador (c)"], 1);
title("Sinal de controle - x(0) = [0,1; 0,1], xh(0) = 0");
xs2png(gcf(), "fig4_controle.png");

function [Mp, ts] = desempenho(t, y, yf)
    Mp   = max(0, (max(y) - yf)/yf*100);
    fora = find(abs(y - yf) > 0.05*abs(yf));
    if fora == [] then ts = 0; else ts = t(fora($)); end
endfunction

[Mp1,ts1] = desempenho(t, y_ma, 3*q);
[Mp2,ts2] = desempenho(t, y_b,  r);
[Mp3,ts3] = desempenho(t, y_c,  r);
[Mp4,ts4] = desempenho(t, y_b2, r);
[Mp5,ts5] = desempenho(t, y_c2, r);
mprintf("========== LETRA d ==========\n");
mprintf("%-24s %9s %9s %9s\n", "Caso", "h2 final", "Mp (%)", "ts5% (s)");
mprintf("%-24s %9.4f %9.2f %9.2f\n", "Malha aberta", y_ma($), Mp1, ts1);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "b, CI nulas",  y_b($),  Mp2, ts2);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "c, CI nulas",  y_c($),  Mp3, ts3);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "b, x(0)=0,1",  y_b2($), Mp4, ts4);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "c, x(0)=0,1",  y_c2($), Mp5, ts5);
mprintf("\nFiguras salvas em: %s\n", pwd());
