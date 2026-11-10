// Exercício 3 - Item (a): Controlabilidade e observabilidade
// Estados: x1 = h1, x2 = h2 | Entrada: u = q | Saída: y = h2
clear; clc;

// ---------------- Parâmetros ----------------
C1 = 1.5;  C2 = 0.8; // m^2
R1 = 2;    R2 = 3;   // s/m^2

// ---------------- Modelo em espaço de estados ----------------
A = [-1/(R1*C1),            1/(R1*C1);
      1/(R1*C2), -(1/(R1*C2) + 1/(R2*C2))];
B = [1/C1; 0];
C = [0 1];

disp("A =", A); disp("B =", B); disp("C =", C);
disp("Polos de malha aberta:", spec(A));

// ---------------- Controlabilidade ----------------
Co = cont_mat(A, B);     // [B  AB]
disp("AB =", A*B);
disp("Matriz de controlabilidade [B AB]:", Co);
mprintf("posto(Co) = %d | det(Co) = %.4f\n", rank(Co), det(Co));

// ---------------- Observabilidade ----------------
Ob = obsv_mat(A, C);     // [C; CA]
disp("CA =", C*A);
disp("Matriz de observabilidade [C; CA]:", Ob);
mprintf("posto(Ob) = %d | det(Ob) = %.4f\n", rank(Ob), det(Ob));

// ---------------- Conclusão ----------------
n = size(A, 1);
if rank(Co) == n then
    mprintf("Posto(Co) = n = %d -> planta CONTROLÁVEL\n", n);
else
    mprintf("Posto(Co) < n -> planta NÃO controlável\n");
end
if rank(Ob) == n then
    mprintf("Posto(Ob) = n = %d -> planta OBSERVÁVEL\n", n);
else
    mprintf("Posto(Ob) < n -> planta NÃO observável\n");
end
