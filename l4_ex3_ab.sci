// Exercício 3 - Tanques comunicantes
// Estados: x1 = h1, x2 = h2 | Entrada: u = q | Saída: y = h2
// Lei de controle: u = K*(M*r + x)  ->  malha fechada: A + B*K
clear; clc; close();

// ---------------- Parâmetros ----------------
q  = 0.1;            // m^3/s
C1 = 1.5;  C2 = 0.8; // m^2
R1 = 2;    R2 = 3;   // s/m^2

// ---------------- Modelo em espaço de estados ----------------
A = [-1/(R1*C1),            1/(R1*C1);
      1/(R1*C2), -(1/(R1*C2) + 1/(R2*C2))];
B = [1/C1; 0];
C = [0 1];
D = 0;

disp("A =", A); disp("B =", B); disp("C =", C);
disp("Polos de malha aberta:", spec(A));

// ---------------- a) Controlabilidade e observabilidade ----------------
Co = cont_mat(A, B);     // [B  AB]
Ob = obsv_mat(A, C);     // [C; CA]
disp("Matriz de controlabilidade:", Co);
mprintf("posto(Co) = %d | det(Co) = %.4f\n", rank(Co), det(Co));
disp("Matriz de observabilidade:", Ob);
mprintf("posto(Ob) = %d | det(Ob) = %.4f\n", rank(Ob), det(Ob));

// ---------------- b) Especificações ----------------
OS = 0.15;
zeta_min = -log(OS)/sqrt(%pi^2 + log(OS)^2);
mprintf("zeta mínimo (OS < 15%%): %.4f\n", zeta_min);
mprintf("Requisito ts(5%%) < 10 s  ->  sigma > %.2f\n", 3/10);

// Tempo de acomodação atual (malha aberta) pela fórmula
pma = spec(A);
sigma_ma = min(abs(real(pma)));
mprintf("Malha aberta: sigma = %.4f -> ts teórico = %.2f s\n", sigma_ma, 3/sigma_ma);

// Polos desejados: -0.6 +- j0.6 (zeta = 0.707, ts ~ 5 s)
// P(s) = s^2 + 1.2 s + 0.72
a1 = 1.2;  a0 = 0.72;

// ---------------- K pela fórmula de Ackermann ----------------
PA = A^2 + a1*A + a0*eye(2,2);   // eye(2,2): identidade 2x2
disp("inv(Co) =", inv(Co));
disp("P(A) =", PA);
K = -[0 1]*inv(Co)*PA;
disp("K =", K);
disp("Polos de malha fechada (A + BK):", spec(A + B*K));

// ---------------- M (erro estático nulo) ----------------
g0 = C*inv(-(A + B*K))*B;
nK2 = K*K';
M = K'/(g0*nK2);
mprintf("g0 = %.4f | ||K||^2 = %.4f\n", g0, nK2);
disp("M =", M);
mprintf("K*M = %.4f  (deve ser 1/g0 = %.4f)\n", K*M, 1/g0);

// ---------------- Simulação ----------------
t = 0:0.01:40;

// Malha aberta: degrau q = 0.1 m^3/s
sma = syslin('c', A, B, C, D);
yma = csim(q*ones(t), t, sma);

// ts medido da malha aberta (valor final teórico, pois em 40 s
// a malha aberta ainda não chegou ao regime)
yfa  = R2*q;
idxa = find(abs(yma - yfa) > 0.05*yfa);
mprintf("Malha aberta: ts(5%%) simulado = %.2f s\n", t(max(idxa)));

// Malha fechada: x' = (A + BK)x + BKM r ,  y = Cx
r = 0.3;
smf = syslin('c', A + B*K, B*K*M, C, 0);
ymf = csim(r*ones(t), t, smf);

yf  = ymf($);
OSm = (max(ymf) - yf)/yf*100;
idx = find(abs(ymf - yf) > 0.05*yf);
ts  = t(max(idx));
mprintf("Malha fechada: y final = %.4f m | erro = %.2e | OS = %.2f %% | ts(5%%) = %.2f s\n", ...
        yf, r - yf, OSm, ts);

// ---------------- Gráfico ----------------
scf(0);
plot(t, yma, 'b', t, ymf, 'r', t, r*ones(t), 'k--');
xgrid(); xlabel("t (s)"); ylabel("h2 (m)");
legend(["Malha aberta (q = 0,1)"; "Malha fechada"; "Referência"], 4);
title("Resposta ao degrau - nível h2");
