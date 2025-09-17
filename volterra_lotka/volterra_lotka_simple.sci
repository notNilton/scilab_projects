clear;
clc;

// === Parâmetros globais ===
alpha = 0.4;   // Taxa de crescimento da presa
beta = 0.4;    // Taxa de mortalidade da presa devido ao predador
delta = 0.09;  // Taxa de crescimento do predador devido à presa
gamma = 2.0;   // Taxa de morte natural do predador

// Definição da função ODE
function dydt = myODE(t, y)
    dydt = zeros(2,1);
    dydt(1) = alpha*y(1) - beta*y(1)*y(2);  // Presa
    dydt(2) = delta*y(1)*y(2) - gamma*y(2); // Predador
endfunction

// Função para resolver e plotar a solução
function run_myODE()
    t0 = 0;
    tfinal = 40;
    y0 = [10; 10];
    t = t0:0.1:tfinal;

    y = ode(y0, t0, t, myODE);

    // === GRÁFICO 1: Populações ao longo do tempo ===
    figure(1);
    clf();  // Limpa a figura antes de plotar
    plot(t, y', "LineWidth", 3);
    title("Predator vs Prey Populations Over Time");
    xlabel("Time");
    ylabel("Population");
    legend(["Prey", "Predator"], 2);

    // === GRÁFICO 2: Plano de Fases (Presa x Predador) ===
    figure(2);
    clf();
    plot(y(1,:), y(2,:), "r-", "LineWidth", 2);
    title("Phase Plane: Prey vs Predator");
    xlabel("Prey Population");
    ylabel("Predator Population");
    legend("Trajectory", 2);

    // Marcar ponto de equilíbrio
    eq_x = gamma / delta;  // ≈ 22.22
    eq_y = alpha / beta;   // = 1.0
    plot(eq_x, eq_y, "ko", "MarkerSize", 8, "MarkerFaceColor", "k");
    xstring(eq_x+1, eq_y+0.5, "Equilibrium");

    // Ajustar limites com margem
    xmin = min(y(1,:)); xmax = max(y(1,:));
    ymin = min(y(2,:)); ymax = max(y(2,:));
    margem_x = (xmax - xmin) * 0.1;
    margem_y = (ymax - ymin) * 0.1;

    a = gca();
    a.data_bounds = [xmin - margem_x, ymin - margem_y; xmax + margem_x, ymax + margem_y];
    a.isoview = "off";  // Evita distorção visual
endfunction

// Chamar a função para executar
run_myODE();

// === LIMPAR FIGURA 0 SE EXISTIR ===
if exists("figure_0") == 1 then
    delete(figure(0));
end
