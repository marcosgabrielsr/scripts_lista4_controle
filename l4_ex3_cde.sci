// =====================================================================
// Lista 4 - Exercicio 3 (tanques) - letras c, d, e
// Convencao do professor: u = K(M r + x), malha fechada A + BK
// Observador: xh' = A xh + B u + L (C xh - y)  ->  erro: A + LC
// =====================================================================
clear; clc; xdel(winsid());

// ---------------- Dados ja obtidos (letras a e b) ----------------
A = [-1/3, 1/3; 5/8, -25/24];
B = [2/3; 0];
C = [0 1];                      // saida y = h2
K = [0.2625, -1.8322];          // letra b (polos -0,6 +- j0,6)
M = [0.1324; -0.9242];          // letra b (erro estatico nulo)
q = 0.1;                        // vazao de entrada (m3/s), malha aberta
r = 0.3;                        // referencia de nivel (m)

// =====================================================================
// LETRA c: projeto do observador
// =====================================================================
// Polos do observador 2x mais a esquerda que -0,6: -1,2 (duplo)
// Po(s) = (s + 1,2)^2 = s^2 + 2,4 s + 1,44
Ob   = obsv_mat(A, C);                     // O = [C; CA]
PoAt = A'^2 + 2.4*A' + 1.44*eye(2,2);      // Po(A')
L    = (-[0 1]*inv(Ob')*PoAt)';            // Ackermann dual
// esperado: L = [-1,5351; -1,0250]

// Sistema completo, estados [x ; xh]
//  x'  = A x  + B K (M r + xh)
//  xh' = A xh + B K (M r + xh) + L (C xh - C x)
Amf_b = A + B*K;                           // so realimentacao de estado
Amf_c = [ A,     B*K;
         -L*C,   A + L*C + B*K ];
Bmf_c = [B*K*M; B*K*M];
Cmf_c = [C, zeros(1,2)];

// =====================================================================
// LETRA d: simulacao e comparacao
// =====================================================================
t  = 0:0.01:40;                            // 40 s, passo 10 ms
x0 = [0.1; 0.1];                           // tanques comecam com 10 cm

sis_ma = syslin('c', A,     B,     C,     0);   // malha aberta
sis_b  = syslin('c', Amf_b, B*K*M, C,     0);   // letra b
sis_c  = syslin('c', Amf_c, Bmf_c, Cmf_c, 0);   // letra c

// Caso 1: condicoes iniciais nulas
y_ma        = csim(q*ones(t), t, sis_ma);
[y_b,  X_b] = csim(r*ones(t), t, sis_b);
[y_c,  X_c] = csim(r*ones(t), t, sis_c);

// Caso 2: x(0) = 0,1 m e observador comecando em xh(0) = 0
[y_b2, X_b2] = csim(r*ones(t), t, sis_b, x0);
[y_c2, X_c2] = csim(r*ones(t), t, sis_c, [x0; 0; 0]);
erro = X_c2(3:4,:) - X_c2(1:2,:);          // xh - x

// Sinal de controle u (vazao), caso 2
u_b2 = K*M*r + K*X_b2;                     // u = K(Mr + x)
u_c2 = K*M*r + K*X_c2(3:4,:);              // u = K(Mr + xh)

// ---- Figura 1: h2, caso 1 (b e c coincidem) ----
scf(1); clf();
plot(t, y_ma, 'k', t, y_b, 'b', t, y_c, 'r--');
xgrid(); xlabel("t (s)"); ylabel("h2 (m)");
legend(["Malha aberta"; "Realim. de estado (b)"; "Com observador (c)"], 4);
title("Resposta ao degrau - condicoes iniciais nulas");
xs2png(gcf(), "fig1_h2_ci_nulas.png");

// ---- Figura 2: h2, caso 2 ----
scf(2); clf();
plot(t, y_b2, 'b', t, y_c2, 'r--');
xgrid(); xlabel("t (s)"); ylabel("h2 (m)");
legend(["Realim. de estado (b)"; "Com observador (c)"], 4);
title("Resposta ao degrau - x(0) = [0,1; 0,1], xh(0) = 0");
xs2png(gcf(), "fig2_h2_ci_nao_nulas.png");

// ---- Figura 3: erro de estimacao ----
scf(3); clf();
plot(t, erro(1,:), 'm', t, erro(2,:), 'g');
xgrid(); xlabel("t (s)"); ylabel("erro (m)");
legend(["h1 estimado - h1"; "h2 estimado - h2"], 1);
title("Erro de estimacao do observador");
xs2png(gcf(), "fig3_erro_observador.png");

// ---- Figura 4: sinal de controle ----
scf(4); clf();
plot(t, u_b2, 'b', t, u_c2, 'r--');
xgrid(); xlabel("t (s)"); ylabel("u = q (m3/s)");
legend(["Realim. de estado (b)"; "Com observador (c)"], 1);
title("Sinal de controle - x(0) = [0,1; 0,1], xh(0) = 0");
xs2png(gcf(), "fig4_controle.png");

// =====================================================================
// LETRA e: funcoes de Lyapunov  V = x' P x
// lyap(A, Q, 'c') resolve  A' P + P A = Q   (Q = -I)
// =====================================================================
P_b = lyap(Amf_b, -eye(2,2), 'c');
P_c = lyap(Amf_c, -eye(4,4), 'c');

// V(t) ao longo da resposta livre (r = 0), partindo de x0
[yl_b, Xl_b] = csim(zeros(t), t, sis_b, x0);
[yl_c, Xl_c] = csim(zeros(t), t, sis_c, [x0; 0; 0]);
V_b = sum(Xl_b .* (P_b*Xl_b), 'r');       // x' P x em cada instante
V_c = sum(Xl_c .* (P_c*Xl_c), 'r');

// ---- Figura 5: V(t) decrescente ----
scf(5); clf();
plot(t, V_b, 'b', t, V_c, 'r--');
xgrid(); xlabel("t (s)"); ylabel("V(t)");
legend(["V = x''P_b x (b)"; "V = z''P_c z (c)"], 1);
title("Funcoes de Lyapunov ao longo da resposta livre");
xs2png(gcf(), "fig5_lyapunov.png");

// =====================================================================
// RESULTADOS NO CONSOLE
// =====================================================================
function [Mp, ts] = desempenho(t, y, yf)
    Mp   = max(0, (max(y) - yf)/yf*100);         // overshoot (%)
    fora = find(abs(y - yf) > 0.05*abs(yf));     // fora da faixa de 5%
    if fora == [] then ts = 0; else ts = t(fora($)); end
endfunction

clc();
mprintf("========== LETRA c ==========\n");
mprintf("L = [%.4f ; %.4f]\n", L(1), L(2));
mprintf("Polos de A+LC:\n");                 disp(spec(A + L*C));
mprintf("Polos do sistema completo:\n");     disp(spec(Amf_c));

mprintf("\n========== LETRA d ==========\n");
[Mp1,ts1] = desempenho(t, y_ma, 3*q);   // regime MA: h2 = R2 q = 0,3
[Mp2,ts2] = desempenho(t, y_b,  r);
[Mp3,ts3] = desempenho(t, y_c,  r);
[Mp4,ts4] = desempenho(t, y_b2, r);
[Mp5,ts5] = desempenho(t, y_c2, r);
mprintf("%-24s %9s %9s %9s\n", "Caso", "h2 final", "Mp (%)", "ts5% (s)");
mprintf("%-24s %9.4f %9.2f %9.2f\n", "Malha aberta",      y_ma($), Mp1, ts1);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "b, CI nulas",       y_b($),  Mp2, ts2);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "c, CI nulas",       y_c($),  Mp3, ts3);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "b, x(0)=0,1",       y_b2($), Mp4, ts4);
mprintf("%-24s %9.4f %9.2f %9.2f\n", "c, x(0)=0,1",       y_c2($), Mp5, ts5);

mprintf("\n========== LETRA e ==========\n");
mprintf("P_b =\n");             disp(P_b);
mprintf("autovalores P_b:\n");  disp(spec(P_b));
mprintf("P_c =\n");             disp(P_c);
mprintf("autovalores P_c:\n");  disp(spec(P_c));
mprintf("\nFiguras salvas em: %s\n", pwd());
