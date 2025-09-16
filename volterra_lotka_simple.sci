clear; clc; clf();

// === DADOS REAIS: Populações de Alces (N1) e Lobos (N2) de 1959 a 1998 ===
anos = [1959:1998]';
dados = [
    522 20; 573 22; 597 22; 603 23; 639 20; 726 26; 762 28; 900 26; 1008 22; 1176 22;
    1191 17; 1320 18; 1323 20; 1194 13; 1137 24; 1026 31; 915 41; 708 44; 573 34; 905 40;
    738 43; 705 50; 544 30; 972 14; 900 23; 1041 24; 1062 22; 1025 20; 1380 16; 1653 12;
    1397 11; 1216 15; 1313 12; 1596 12; 1880 13; 1770 17; 2422 16; 1200 22; 500 24; 700 14
];

alces_reais = dados(:,1);
lobos_reais = dados(:,2);

// === Parâmetros (FIXOS — não ajustados aos dados) ===
alpha = 0.4;   // Taxa de crescimento da presa
beta = 0.4;    // Taxa de mortalidade da presa devido ao predador
delta = 0.09;  // Taxa de crescimento do predador devido à presa
gamma = 2.0;   // Taxa de morte natural do predador

// Definição da função ODE
function dydt = myODE(t, y)
    dydt = zeros(2,1);
    dydt(1) = alpha*y(1) - beta*y(1)*y(2);  // Presa (Alces)
    dydt(2) = delta*y(1)*y(2) - gamma*y(2); // Predador (Lobos)
endfunction

// === SIMULAÇÃO ===
t0 = 0;
tfinal = 39;           // 40 anos: 1959 (t=0) a 1998 (t=39)
y0 = [alces_reais(1); lobos_reais(1)];  // Condição inicial = dados de 1959
t = t0:1:tfinal;       // Passo anual para comparar com dados reais

y = ode(y0, t0, t, myODE);  // y será 2x40 → transpor para 40x2
y = y';  // Agora: coluna 1 = alces simulados, coluna 2 = lobos simulados

alces_sim = y(:,1);
lobos_sim = y(:,2);

// === GRÁFICO 1: Populações ao longo do tempo (comparação opcional) ===
figure(1);
clf();
plot(anos, alces_reais, 'bo-', 'MarkerSize', 4, 'LineWidth', 2);
plot(anos, alces_sim, 'r--', 'LineWidth', 2);
title("População de Alces (Presa) - Dados Reais vs Simulação");
xlabel("Ano");
ylabel("População de Alces");
legend(["Dados Reais", "Simulação (parâmetros fixos)"], 2);

figure(2);
clf();
plot(anos, lobos_reais, 'go-', 'MarkerSize', 4, 'LineWidth', 2);
plot(anos, lobos_sim, 'm--', 'LineWidth', 2);
title("População de Lobos (Predador) - Dados Reais vs Simulação");
xlabel("Ano");
ylabel("População de Lobos");
legend(["Dados Reais", "Simulação (parâmetros fixos)"], 2);

// === GRÁFICO 3: Plano de Fases (Alces x Lobos) ===
figure(3);
clf();
plot(alces_reais, lobos_reais, 'bo-', 'MarkerSize', 5, 'LineWidth', 2);
plot(alces_sim, lobos_sim, 'r--', 'LineWidth', 2);
title("Plano de Fases: Alces vs Lobos (Real vs Simulação)");
xlabel("População de Alces");
ylabel("População de Lobos");
legend(["Dados Reais", "Simulação (parâmetros fixos)"], 2);

// Marcar ponto de equilíbrio teórico
if (delta > 0 & beta > 0)
    eq_alces = gamma / delta;   // ≈ 22.22
    eq_lobos = alpha / beta;    // = 1.0
    if (eq_alces > 0 & eq_lobos > 0)
        plot(eq_alces, eq_lobos, "ks", "MarkerSize", 8, "MarkerFaceColor", "k");
        xstring(eq_alces+50, eq_lobos+1, "Equilíbrio Teórico");
    end
end

// Ajustar limites
a = gca();
a.data_bounds = [min([alces_reais; alces_sim])*0.9, min([lobos_reais; lobos_sim])*0.9; ...
                 max([alces_reais; alces_sim])*1.1, max([lobos_reais; lobos_sim])*1.1];
a.isoview = "off";

// === SAÍDA DOS DADOS SIMULADOS (PARA RELATÓRIO OU EXPORTAÇÃO) ===
disp("SIMULAÇÃO CONCLUÍDA PARA O PERÍODO 1959–1998");
disp("Parâmetros utilizados (FIXOS, não ajustados):");
disp("alpha = " + string(alpha));
disp("beta = " + string(beta));
disp("delta = " + string(delta));
disp("gamma = " + string(gamma));

// Se quiser salvar os dados simulados:
// dados_sim = [anos, alces_sim, lobos_sim];
// write("simulacao_parte3.csv", dados_sim, "(%d, %f, %f)");

disp("Dados simulados disponíveis nas variáveis: alces_sim, lobos_sim");

// === LIMPAR FIGURA 0 SE EXISTIR ===
if exists("figure_0") == 1 then
    delete(figure(0));
end
