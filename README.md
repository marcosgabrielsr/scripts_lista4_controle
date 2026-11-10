# scripts_lista4_controle

Scripts em Scilab da Lista de Exercícios 4 de Controle.

## Scripts

### Exercício 1: sistema G(s) = (0.5s + 0.244)/(s² + 0.5s + 0.244)

| Script | Descrição |
| --- | --- |
| `l4_ex1_b.sci` | Resposta em frequência com `horner` para 10 e 20 rad/s (amplitude e fase da saída) |
| `l4_ex1_c.sci` | Diagrama de Bode |
| `l4_ex1_d.sci` | Simulação com entradas sen(10t) e sen(20t) |

### Exercício 2: planta g(s) = 1/(s(s+1)(s+2)), realimentação unitária, K = 6

| Script | Descrição |
| --- | --- |
| `l4_ex2_a.sci` | Diagrama de Nyquist |
| `l4_ex2_b.sci` | Diagrama de Black |
| `l4_ex2_c.sci` | Simulação da malha fechada com u(t) = sen(√2 t) |

### Exercício 3: sistema de tanques (x1 = h1, x2 = h2, u = q, y = h2)

| Script | Descrição |
| --- | --- |
| `l4_ex3_a.sci` | Controlabilidade e observabilidade |
| `l4_ex3_b.sci` | Projeto da realimentação de estado u = K(Mr + x) |
| `l4_ex3_c.sci` | Projeto do observador de estados |
| `l4_ex3_d.sci` | Simulação e comparação: realimentação com x e com x̂ |
| `l4_ex3_e.sci` | Funções de Lyapunov V = x'Px |
