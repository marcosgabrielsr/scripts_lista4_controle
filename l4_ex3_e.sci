// Lista 4 - Ex. 3 (tanques) - LETRA e: funcoes de Lyapunov V = x' P x
// lyap(A, Q, 'c') resolve  A' P + P A = Q   (Q = -I)
clear; clc; xdel(winsid());

A = [-1/3, 1/3; 5/8, -25/24];
B = [2/3; 0];
C = [0 1];
K = [0.2625, -1.8322];          // letra b
M = [0.1324; -0.9242];          // letra b
L = [-1.5351; -1.0250];         // letra c

Amf_b = A + B*K;
Amf_c = [ A,     B*K;
         -L*C,   A + L*C + B*K ];

P_b = lyap(Amf_b, -eye(2,2), 'c');
P_c = lyap(Amf_c, -eye(4,4), 'c');

// V(t) ao longo da resposta livre (r = 0), partindo de x0
t  = 0:0.01:40;
x0 = [0.1; 0.1];
sis_b = syslin('c', Amf_b, B*K*M, C, 0);
sis_c = syslin('c', Amf_c, [B*K*M; B*K*M], [C, zeros(1,2)], 0);
[yl_b, Xl_b] = csim(zeros(t), t, sis_b, x0);
[yl_c, Xl_c] = csim(zeros(t), t, sis_c, [x0; 0; 0]);
V_b = sum(Xl_b .* (P_b*Xl_b), 'r');
V_c = sum(Xl_c .* (P_c*Xl_c), 'r');

scf(5); clf();
plot(t, V_b, 'b', t, V_c, 'r--');
xgrid(); xlabel("t (s)"); ylabel("V(t)");
legend(["V = x''P_b x (b)"; "V = z''P_c z (c)"], 1);
title("Funcoes de Lyapunov ao longo da resposta livre");
xs2png(gcf(), "fig5_lyapunov.png");

mprintf("========== LETRA e ==========\n");
mprintf("P_b =\n");             disp(P_b);
mprintf("autovalores P_b:\n");  disp(spec(P_b));
mprintf("P_c =\n");             disp(P_c);
mprintf("autovalores P_c:\n");  disp(spec(P_c));
mprintf("\nFigura salva em: %s\n", pwd());
