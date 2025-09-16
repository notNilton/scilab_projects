clear; clc; clf();

// === DADOS REAIS ===
anos = [1959:1998]';
dados = [
    522 20; 573 22; 597 22; 603 23; 639 20; 726 26; 762 28; 900 26; 1008 22; 1176 22;
    1191 17; 1320 18; 1323 20; 1194 13; 1137 24; 1026 31; 915 41; 708 44; 573 34; 905 40;
    738 43; 705 50; 544 30; 972 14; 900 23; 1041 24; 1062 22; 1025 20; 1380 16; 1653 12;
    1397 11; 1216 15; 1313 12; 1596 12; 1880 13; 1770 17; 2422 16; 1200 22; 500 24; 700 14
];

alces_reais = dados(:,1);
lobos_reais = dados(:,2);

// === PARÂMETROS PARA CICLO ESTÁVEL (não ajustados, apenas ilustrativos) ===
alpha = 0.2;     // crescimento alces
beta = 0.0002;   // predação
delta = 0.0001;  // conversão
gamma = 0.5;     // mortalidade lobos

// === MODELO ===
function dydt = modelo(t, y)
    N1 = y(1); N2 = y(2);
    dN1dt = alpha*N1 - beta*N1*N2;
    dN2dt = delta*N1*N2 - gamma*N2;
    dydt = [dN1dt; dN2dt];
endfunction

// === SIMULAÇÃO ===
t = 0:0.1:39;  // passo fino para curva suave
y0 = [alces_reais(1); lobos_reais(1)];
y = ode(y0, 0, t, modelo);
y = y';

// Interpolar para comparar apenas nos anos inteiros (opcional)
t_anos = 0:39;
y_anos = interp1(t, y, t_anos)';
alces_sim = y_anos(:,1);
lobos_sim = y_anos(:,2);

// === GRÁFICOS ===
figure(1); clf();
subplot(2,1,1);
plot(anos, alces_reais, 'bo', 'MarkerSize', 4);
plot(1959 + t, y(:,1), 'r-', 'LineWidth', 2);
title("Alces: Dados Reais vs Modelo (comportamento cíclico)");
xlabel("Ano"); ylabel("População");
legend(["Reais", "Modelo"], 2);

subplot(2,1,2);
plot(anos, lobos_reais, 'go', 'MarkerSize', 4);
plot(1959 + t, y(:,2), 'm-', 'LineWidth', 2);
title("Lobos: Dados Reais vs Modelo (comportamento cíclico)");
xlabel("Ano"); ylabel("População");
legend(["Reais", "Modelo"], 2);

figure(2); clf();
plot(alces_reais, lobos_reais, 'bo-', 'MarkerSize', 5, 'LineWidth', 2);
plot(y(:,1), y(:,2), 'r-', 'LineWidth', 2);
title("Plano de Fases: Comportamento Cíclico Esperado vs Real");
xlabel("Alces"); ylabel("Lobos");
legend(["Dados Reais", "Modelo Teórico"], 2);

// === ANÁLISE HONESTA ===
disp(" ");
disp("=== ANÁLISE ===");
disp("O modelo de Lotka-Volterra clássico NÃO reproduz quantitativamente os dados reais.");
disp("Motivos:");
disp(" - Dados reais têm eventos não modelados (epidemias, invernos rigorosos, etc.)");
disp(" - Modelo assume ciclos perfeitos e contínuos — a realidade é caótica.");
disp(" ");
disp("USO ADEQUADO DO MODELO:");
disp(" - Ilustrar o comportamento cíclico teórico presa-predador.");
disp(" - Mostrar defasagem: aumento de presas → aumento de predadores → colapso de presas → colapso de predadores.");
disp(" - Servir de base para modelos mais realistas (ex: com termo logístico).");
disp(" ");
disp("ERRO RELATIVO NÃO É RELEVANTE AQUI — o modelo não é preditivo, é qualitativo.");
