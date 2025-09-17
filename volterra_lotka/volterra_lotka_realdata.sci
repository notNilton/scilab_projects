clear;clc;

// === DADOS REAIS DE ISLE ROYALE ===
Anos_reais = 1959:1:1998;
Alces_reais = [522, 573, 597, 603, 639, 726, 762, 900, 1008, 1176, 1191, 1320, 1323, 1194, 1137, 1026, 915, 708, 573, 905, 738, 705, 544, 972, 900, 1041, 1062, 1025, 1380, 1653, 1397, 1216, 1313, 1596, 1880, 1770, 2422, 1200, 500, 700];
Lobos_reais = [20, 22, 22, 23, 20, 26, 28, 26, 22, 22, 17, 18, 20, 13, 24, 31, 41, 44, 34, 40, 43, 50, 30, 14, 23, 24, 22, 20, 16, 12, 11, 15, 12, 12, 13, 17, 16, 22, 24, 14];

// === PARÂMETROS CALIBRADOS PARA REDUZIR A AMPLITUDE ===
params.alpha = 0.25;      // Taxa de crescimento da presa (alces)
params.beta = 0.007;      // Taxa de mortalidade da presa (predação mais efetiva)
params.delta = 0.00035;   // Taxa de crescimento do predador
params.gamma = 0.3;       // Taxa de morte do predador (mortalidade maior)

// Definição da função ODE
function dydt=lotka_volterra_eqs(t, y, params)
    dydt = zeros(2,1);
    dydt(1) = params.alpha*y(1) - params.beta*y(1)*y(2);
    dydt(2) = params.delta*y(1)*y(2) - params.gamma*y(2);
endfunction

// Implementação do solver Runge-Kutta de 4ª Ordem (RK4)
function y_out = rk4_solver(ode_func, y0, t_vector, params)
    n_steps = length(t_vector);
    y_out = zeros(length(y0), n_steps);
    y_out(:, 1) = y0;
    
    for i = 1:(n_steps - 1)
        h = t_vector(i+1) - t_vector(i);
        t_n = t_vector(i);
        y_n = y_out(:, i);
        
        k1 = h * ode_func(t_n, y_n, params);
        k2 = h * ode_func(t_n + h/2, y_n + k1/2, params);
        k3 = h * ode_func(t_n + h/2, y_n + k2/2, params);
        k4 = h * ode_func(t_n + h, y_n + k3, params);
        
        y_out(:, i+1) = y_n + (k1 + 2*k2 + 2*k3 + k4) / 6;
    end
endfunction

// Função principal para executar a simulação e plotar os resultados
function run_simulation(Anos_reais, Alces_reais, Lobos_reais, params)
    // === Condições iniciais e tempo de simulação ===
    t0 = 0;
    tfinal = length(Anos_reais) - 1; // 39 anos
    y0 = [Alces_reais(1); Lobos_reais(1)]; // População inicial de 1959

    // Vetor de tempo com passo de 0.1 anos para boa resolução
    t = t0:0.1:tfinal;

    // === SOLUÇÃO 1: Solver embutido do Scilab (lsoda) ===
    y_ode = ode(y0, t0, t, list(lotka_volterra_eqs, params));

    // === SOLUÇÃO 2: Solver Runge-Kutta de 4ª Ordem (RK4) ===
    y_rk4 = rk4_solver(lotka_volterra_eqs, y0, t, params);

    // === GRÁFICO 1: Populações ao longo do tempo (Simulado) ===
    figure(1);
    clf();
    plot(t, y_rk4', "LineWidth", 3);
    title("Simulação RK4 das Populações de Alces vs. Lobos");
    xlabel("Anos (a partir de 1959)");
    ylabel("População");
    legend(["Alces (Presa)", "Lobos (Predador)"], "location", "northwest");

    // === GRÁFICO 2: Plano de Fases (Simulado) ===
    figure(2);
    clf();
    plot(y_rk4(1,:), y_rk4(2,:), "r-", "LineWidth", 2);
    title("Plano de Fase (RK4): Alces vs Lobos");
    xlabel("População de Alces");
    ylabel("População de Lobos");
    legend("Trajetória", "location", "northwest");

    // === IMPRIMIR COMPARAÇÃO NO CONSOLE ===
    printf("=======================================================================\n");
    printf("    Ano   | Alces (Real) | Alces (Simulado) | Lobos (Real) | Lobos (Simulado)\n");
    printf("=======================================================================\n");
    for i=1:length(Anos_reais)
        ano_corrente = i - 1;
        // Encontra o índice mais próximo no vetor de tempo simulado
        sim_index = find(t >= ano_corrente, 1);
        alces_sim = y_rk4(1, sim_index);
        lobos_sim = y_rk4(2, sim_index);
        printf("    %d  |     %4d     |       %7.1f      |      %2d      |        %5.1f\n", Anos_reais(i), Alces_reais(i), alces_sim, Lobos_reais(i), lobos_sim);
    end
    printf("=======================================================================\n");

    // === GRÁFICO 3: COMPARAÇÃO VISUAL - DADOS REAIS vs. SIMULADOS ===
    figure(3);
    clf();
    // Plot dos dados reais
    anos_plot = Anos_reais - Anos_reais(1);
    plot(anos_plot, Alces_reais, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
    plot(anos_plot, Lobos_reais, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 5);
    // Plot da simulação RK4
    plot(t, y_rk4(1,:), 'b-', 'LineWidth', 2);
    plot(t, y_rk4(2,:), 'g-', 'LineWidth', 2);
    // Plot da simulação ODE (lsoda) para comparação
    plot(t, y_ode(1,:), 'c--', 'LineWidth', 1.5);
    plot(t, y_ode(2,:), 'm--', 'LineWidth', 1.5);
    title("Comparação: Dados Reais vs. Simulações (RK4 e Scilab ODE)");
    xlabel("Anos (a partir de 1959)");
    ylabel("População");
    legend(["Alces Real", "Lobos Real", "Alces (RK4)", "Lobos (RK4)", "Alces (Scilab ODE)", "Lobos (Scilab ODE)"], "location", "north");
    
endfunction

// Chamar a função para executar, passando os dados reais
run_simulation(Anos_reais, Alces_reais, Lobos_reais, params);
