clear;clc;

// === DADOS REAIS DE ISLE ROYALE ===
Anos_reais = 1959:1:1998;
Alces_reais = [522, 573, 597, 603, 639, 726, 762, 900, 1008, 1176, 1191, 1320, 1323, 1194, 1137, 1026, 915, 708, 573, 905, 738, 705, 544, 972, 900, 1041, 1062, 1025, 1380, 1653, 1397, 1216, 1313, 1596, 1880, 1770, 2422, 1200, 500, 700];
Lobos_reais = [20, 22, 22, 23, 20, 26, 28, 26, 22, 22, 17, 18, 20, 13, 24, 31, 41, 44, 34, 40, 43, 50, 30, 14, 23, 24, 22, 20, 16, 12, 11, 15, 12, 12, 13, 17, 16, 22, 24, 14];

// === PARÂMETROS CALIBRADOS PARA REDUZIR A AMPLITUDE ===
alpha = 0.25;      // Taxa de crescimento da presa (alces)
beta = 0.007;      // Taxa de mortalidade da presa (predação mais efetiva)
delta = 0.00025;   // Taxa de crescimento do predador
gamma = 0.3;       // Taxa de morte do predador (mortalidade maior)

// Definição da função ODE
function dydt=myODE(t, y)
    dydt = zeros(2,1);
    dydt(1) = alpha*y(1) - beta*y(1)*y(2);
    dydt(2) = delta*y(1)*y(2) - gamma*y(2);
endfunction

// Função para resolver e plotar a solução
function run_myODE(Anos_reais, Alces_reais, Lobos_reais)
    // === Condições iniciais e tempo de simulação ===
    t0 = 0;
    tfinal = length(Anos_reais) - 1; // 39 anos
    y0 = [Alces_reais(1); Lobos_reais(1)]; // População inicial de 1959

    t = linspace(t0, tfinal, 1000);
    y = ode(y0, t0, t, myODE);

    // === GRÁFICO 1: Populações ao longo do tempo (Simulado) ===
    figure(1);
    clf();
    plot(t, y', "LineWidth", 3);
    title("Simulação Cíclica das Populações de Alces vs. Lobos");
    xlabel("Anos (a partir de 1959)");
    ylabel("População");
    legend(["Alces (Presa)", "Lobos (Predador)"], "location", "northwest");

    // === GRÁFICO 2: Plano de Fases (Simulado) ===
    figure(2);
    clf();
    plot(y(1,:), y(2,:), "r-", "LineWidth", 2);
    title("Plano de Fase: Alces vs Lobos");
    xlabel("População de Alces");
    ylabel("População de Lobos");
    legend("Trajetória", "location", "northwest");

    // === IMPRIMIR COMPARAÇÃO NO CONSOLE ===
    printf("=======================================================================\n");
    printf("    Ano   | Alces (Real) | Alces (Simulado) | Lobos (Real) | Lobos (Simulado)\n");
    printf("=======================================================================\n");
    for i=1:length(Anos_reais)
        ano_corrente = i - 1;
        sim_index = find(t >= ano_corrente, 1);
        alces_sim = y(1, sim_index);
        lobos_sim = y(2, sim_index);
        printf("    %d  |     %4d     |       %7.1f      |      %2d      |        %5.1f\n", Anos_reais(i), Alces_reais(i), alces_sim, Lobos_reais(i), lobos_sim);
    end
    printf("=======================================================================\n");

    // === GRÁFICO 3: COMPARAÇÃO VISUAL - DADOS REAIS vs. SIMULADOS ===
    figure(3);
    clf();
    plot(t, y(1,:), 'b-', 'LineWidth', 2);
    plot(t, y(2,:), 'g-', 'LineWidth', 2);
    anos_plot = Anos_reais - Anos_reais(1);
    plot(anos_plot, Alces_reais, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5);
    plot(anos_plot, Lobos_reais, 'gs', 'MarkerFaceColor', 'g', 'MarkerSize', 5);
    title("Comparação: Dados Reais vs. Dados da Simulação (Amplitude Ajustada)");
    xlabel("Anos (a partir de 1959)");
    ylabel("População");
    legend(["Alces Simulado", "Lobos Simulado", "Alces Real (dados)", "Lobos Real (dados)"], "location", "north");
    
endfunction

// Chamar a função para executar, passando os dados reais
run_myODE(Anos_reais, Alces_reais, Lobos_reais);
