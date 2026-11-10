// Lista 4 - Ex. 3 (tanques) - LETRA c: projeto do observador
// Observador: xh' = A xh + B u + L (C xh - y)  ->  erro: A + LC
clear; clc;

A = [-1/3, 1/3; 5/8, -25/24];
B = [2/3; 0];
C = [0 1];
K = [0.2625, -1.8322];          // letra b
M = [0.1324; -0.9242];          // letra b

// Polos do observador 2x mais a esquerda que -0,6: -1,2 (duplo)
// Po(s) = (s + 1,2)^2 = s^2 + 2,4 s + 1,44
Ob   = obsv_mat(A, C);                     // O = [C; CA]
PoAt = A'^2 + 2.4*A' + 1.44*eye(2,2);      // Po(A')
L    = (-[0 1]*inv(Ob')*PoAt)';            // Ackermann dual

// Sistema completo, estados [x ; xh]
Amf_c = [ A,     B*K;
         -L*C,   A + L*C + B*K ];

mprintf("========== LETRA c ==========\n");
mprintf("Posto de O = %d\n", rank(Ob));
mprintf("L = [%.4f ; %.4f]\n", L(1), L(2));
mprintf("A + LC =\n");                       disp(A + L*C);
mprintf("Polos de A+LC:\n");                 disp(spec(A + L*C));
mprintf("Polos do sistema completo:\n");     disp(spec(Amf_c));
