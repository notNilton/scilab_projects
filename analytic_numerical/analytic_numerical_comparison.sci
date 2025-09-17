clear 
clc 

// ===========================================================================
// FUNÇÃO: numerico_crank_nicolson
// 
// DESCRIÇÃO:
//   Resolve numericamente a equação de difusão 1D usando o método de Crank-Nicolson
//   para múltiplos pares gasosos e tempos desejados. Considera condição inicial 
//   simétrica em degrau e fronteiras impermeáveis (Neumann nulas).
//
// PARÂMETROS DE ENTRADA (internos):
//   Dab_lista             - Lista de coeficientes de difusão (cm²/s)
//   L                     - Comprimento total do domínio espacial (cm)
//   N                     - Número de pontos no semi-domínio [0, L]
//   tempos_desejados_horas - Tempos de simulação (horas)
//   num_passos_tempo      - Número de passos temporais por simulação
//
// RETORNO:
//   z_total              - Vetor de posições espaciais (de -L a L)
//   solucoes_por_tempo   - Lista de listas: solucoes_por_tempo[t_idx][gas_idx] = perfil(z) no tempo t
//   tempos_desejados_horas - Vetor de tempos (horas) para referência
//   Dab_lista            - Lista dos coeficientes de difusão usados
//
// ===========================================================================
function [z_total, solucoes_por_tempo, tempos_desejados_horas, Dab_lista] = numerico_crank_nicolson()
    N_Dab = length(Dab_lista);
    N_tempos = length(tempos_desejados_horas);
    L = 100; 
    N = 11;  
    passo = L / (N-1); 
    ca = 0.5;
    CI = 0;  
    CI2 = 1; 
    coefd1 = 4/3;
    coefd2 = -1/3;
    z_total = linspace(-L, L, 2*N - 1);

    function Matriz = matriz_problema(coef1,coef2,coef3,coefd1,coefd2)
        Matriz = zeros(N-1, N-1);
        for i = 1:N-1
            for j = 1:N-1
                if (i == j) then
                    Matriz(i,j) = coef2;
                    if (j+1 <= N-1) then
                        Matriz(i,j+1) = -coef1;
                    end
                    if (i+1 <= N-1) then 
                        Matriz(i+1,j) = -coef1;
                    end
                    if (i == N-1 & j == N-1) then
                        Matriz(i,j) = coef2 - (coef1 * coefd1);
                        Matriz(i,j-1) = -coef1 - coef1 * coefd2;
                    end
                end
            end
        end
    endfunction

    solucoes_por_tempo = list();
    for t = 1:N_tempos
        solucoes_por_tempo(t) = list(); 
    end

    for t_idx = 1:N_tempos
        tempo_total = tempos_desejados_horas(t_idx) * 3600; 
        num_passos_tempo = 70; 
        dt = tempo_total / num_passos_tempo;

        for idx = 1:N_Dab
            Dab = Dab_lista(idx);
            coef1 = (Dab * dt) / (passo^2);
            coef2 = 2*(coef1 + 1);
            coef3 = 2*(1 - coef1);

            Matriz = zeros(N-1, N-1);
            fz     = zeros(N-1, 1);
            fz2    = zeros(N-1, 1);
            diadif = zeros(N, num_passos_tempo);
            diadif2= zeros(N, num_passos_tempo);
            mataux = zeros(N-1, num_passos_tempo);
            mataux2= zeros(N-1, num_passos_tempo);

            Mat_eq = matriz_problema(coef1,coef2,coef3,coefd1,coefd2);

            // f(z,t) - parte superior
            fz(1,1) = (coef1*ca) + (coef1*CI) + (coef3*CI);
            for i = 2:N-1
                if (i < N-1) then
                    fz(i,1) = (coef1*CI) + (coef3*CI) + (coef1*CI);
                elseif (i == N-1) then
                    fz(i,1) = (coef1*CI) + (coef3*CI) + (coef1*((coefd1*CI) + (coefd2*CI)));
                end
            end

            inversa = inv(Mat_eq);

            // Difusão parte superior
            diadif(1,:) = ca;
            for j = 1:num_passos_tempo
                for i = 1:N-1
                    if (j == 1) then
                        a = inversa * fz;
                        diadif(i+1,j) = a(i);
                    else
                        a = inversa * mataux(:,j-1);
                        diadif(i+1,j) = a(i);
                    end
                end
                for k = 1:N-1
                    if (k == 1) then
                        mataux(k,j) = (coef1*ca) + (coef1*ca) + (coef3*diadif(k+1,j)) + (coef1*diadif(k+2,j));
                    elseif (k < N-1) then
                        mataux(k,j) = (coef1*diadif(k,j)) + (coef3*diadif(k+1,j)) + (coef1*diadif(k+2,j));
                    elseif (k == N-1) then
                        mataux(k,j) = (coef1*diadif(k,j)) + (coef3*diadif(k+1,j)) + (coefd1*diadif(k+1,j) + coefd2*diadif(k,j)) * coef1;
                    end
                end
            end

            // f(z,t) - parte inferior
            fz2(1,1) = (coef1*ca) + (coef1*CI2) + (coef3*CI2);
            for i = 2:N-1
                if (i < N-1) then
                    fz2(i,1) = (coef1*CI2) + (coef3*CI2) + (coef1*CI2);
                elseif (i == N-1) then
                    fz2(i,1) = (coef1*CI2) + (coef3*CI2) + (coef1*((coefd1*CI2) + (coefd2*CI2)));
                end
            end

            // Difusão parte inferior
            diadif2(1,:) = ca;
            for j = 1:num_passos_tempo
                for i = 1:N-1
                    if (j == 1) then
                        a = inversa * fz2;
                        diadif2(i+1,j) = a(i);
                    else
                        a = inversa * mataux2(:,j-1);
                        diadif2(i+1,j) = a(i);
                    end
                end
                for k = 1:N-1
                    if (k == 1) then
                        mataux2(k,j) = (coef1*ca) + (coef1*ca) + (coef3*diadif2(k+1,j)) + (coef1*diadif2(k+2,j));
                    elseif (k < N-1) then
                        mataux2(k,j) = (coef1*diadif2(k,j)) + (coef3*diadif2(k+1,j)) + (coef1*diadif2(k+2,j));
                    elseif (k == N-1) then
                        mataux2(k,j) = (coef1*diadif2(k,j)) + (coef3*diadif2(k+1,j)) + (coefd1*diadif2(k+1,j) + coefd2*diadif2(k,j)) * coef1;
                    end
                end
            end

            // Normalização
            difusdiasup = diadif ./ ca;
            difusdiainf = diadif2 ./ ca;

            // Montagem da solução completa
            B = difusdiasup($:-1:1, :);
            matcon = zeros(2*N-1, num_passos_tempo);
            for j = 1:num_passos_tempo
                for i = 1:2*N-1
                    if (i == N) then
                        matcon(i,j) = 1.0;
                    elseif (i < N) then
                        matcon(i,j) = B(i,j);
                    else
                        matcon(i,j) = difusdiainf(i-N+1,j);
                    end
                end
            end

            solucoes_por_tempo(t_idx)(idx) = matcon(:, num_passos_tempo);
        end 
    end 
endfunction

// ===========================================================================
// FUNÇÃO: calcular_perfil_difusao
// 
// DESCRIÇÃO:
//   Calcula a solução analítica 1D da difusão usando série de Fourier para 
//   condição inicial em degrau simétrico com fronteiras impermeáveis.
//
// PARÂMETROS DE ENTRADA:
//   DAB        - Coeficiente de difusão (cm²/s)
//   L          - Semi-comprimento do domínio (domínio total = [-L, L]) [cm]
//   Nz         - Número de pontos espaciais
//   tempos     - Vetor com os tempos onde se quer a solução [s]
//   N_termos   - Número de termos na série de Fourier
//
// RETORNO:
//   z       - Vetor de posições espaciais (de -L a L)
//   perfis  - Matriz: cada linha é o perfil xA(z) em um tempo (len(tempos) x Nz)
//   tempos  - Vetor de tempos (retornado para conveniência no plot)
//
// ===========================================================================
function [z, perfis, tempos_out] = calcular_perfil_difusao(DAB, L, Nz, tempos, N_termos)
    z = linspace(-L, L, Nz);
    Nt = length(tempos);
    perfis = zeros(Nt, Nz);
    
    // =============================
    // FUNÇÃO AUXILIAR INTERNA: Solução Analítica
    // =============================
    function xA = solucao_analitica(z, t, DAB, L, N_termos)
        if t == 0
            xA = (z <= 0) * 1.0;
            return;
        end
        
        xA = 0.5 * ones(z);  // valor médio
        
        for k = 0:N_termos-1
            n = 2*k + 1;           // n ímpar: 1, 3, 5, ...
            kn = n * %pi / (2*L);
            coef = 2 * (-1)^k / (n * %pi);
            termo = coef * cos(kn * z) .* exp(-DAB * kn^2 * t);
            xA = xA + termo;
        end
    endfunction
    
    // --- Loop principal ---
    for i = 1:Nt
        t = tempos(i);
        xA = solucao_analitica(z, t, DAB, L, N_termos);
        perfis(i, :) = xA;
    end
    
    tempos_out = tempos;
endfunction

// ===========================================================================
// FUNÇÃO: plotar_resultados_numericos
// 
// DESCRIÇÃO:
//   Plota os resultados numéricos em uma nova janela, com 4 subplots (2x2) 
//   para os tempos simulados. Cada subplot mostra os 3 gases.
//
// PARÂMETROS:
//   z_total              - Vetor de posições (cm)
//   solucoes_por_tempo   - Lista de perfis por tempo e gás
//   tempos_desejados_horas - Vetor de tempos (horas)
//   Dab_lista            - Lista de Dab (cm²/s)
//
// ===========================================================================
function plotar_resultados_numericos(z_total, solucoes_por_tempo, tempos_desejados_horas, Dab_lista)
    scf(0);  // Janela 0 para resultados numéricos
    clf();
    
    cores = ["b", "r", "g"]; 
    marcadores = ["-*", "-o", "-s"];
    fig = gcf();
    fig.axes_size = [800, 650]; 
    fig.figure_position = [50, 50];
    fig.figure_name = "Resultados Numéricos - Crank-Nicolson";

    N_tempos = length(tempos_desejados_horas);
    N_Dab = length(Dab_lista);

    for t_idx = 1:N_tempos
        subplot(2, 2, t_idx);
        for idx = 1:N_Dab
            plot(z_total, solucoes_por_tempo(t_idx)(idx), marcadores(idx), "Color", cores(idx), "markersize", 6);
        end
        xlabel('Posição z (cm)');
        ylabel('Fração molar normalizada (xA/ca)');
        title(msprintf("t = %.1f horas", tempos_desejados_horas(t_idx)));
        xgrid();
        
        if t_idx == N_tempos then
            legendas = [
                msprintf("CO₂–N₂O (D=%.3f cm²/s)", Dab_lista(1));
                msprintf("H₂–N₂ (D=%.3f cm²/s)", Dab_lista(2));
                msprintf("CO₂–CO (D=%.3f cm²/s)", Dab_lista(3))
            ];
            legend(legendas);
        end
    end
endfunction

// ===========================================================================
// FUNÇÃO: plotar_resultados_analiticos
// 
// DESCRIÇÃO:
//   Plota os resultados analíticos em uma nova janela, com curvas para cada tempo.
//   Inclui o valor de DAB no título para clareza.
//
// PARÂMETROS:
//   z          - Vetor de posições (cm)
//   perfis     - Matriz de perfis (tempos x posições)
//   tempos_plot - Vetor de tempos (s)
//   DAB        - Coeficiente de difusão usado (cm²/s) — ADICIONADO!
//
// ===========================================================================
function plotar_resultados_analiticos(z, perfis, tempos_plot, DAB)
    scf(1);  // Janela 1 para resultados analíticos
    clf();
    
    cores = ["k", "b", "r", "g"];
    marcadores = ["-", "-o", "-s", "-d"];
    fig = gcf();
    fig.axes_size = [800, 600];
    fig.figure_position = [50, 50];
    fig.figure_name = msprintf("Solução Analítica - D = %.3f cm²/s", DAB);  // <-- DAB no título da janela!

    legendas = [];
    for i = 1:length(tempos_plot)
        tempo_h = tempos_plot(i)/3600;
        plot(z, perfis(i,:), marcadores(i), "Color", cores(i), "LineWidth", 1.5);
        legendas(i) = sprintf("%.1fh", tempo_h);
    end

    xlabel("Posição z (cm)");
    ylabel("Fração molar x_A");
    title(msprintf("Solução Analítica (Fourier) - D = %.3f cm²/s", DAB));  // <-- DAB no título do gráfico!
    legend(legendas);
    xgrid();
endfunction

// ===========================================================================
// FUNÇÃO: plotar_comparacao_numerico_analitico
// 
// DESCRIÇÃO:
//   Plota em uma nova janela a comparação entre os resultados numéricos (Crank-Nicolson)
//   e analíticos (Série de Fourier) para o mesmo gás (DAB = 0.096 cm²/s) nos mesmos tempos.
//   Usa 4 subplots (2x2) — um para cada tempo. Inclui DAB no título de cada subplot.
//
// PARÂMETROS:
//   z_num              - Vetor de posições do método numérico
//   solucoes_por_tempo - Lista de perfis numéricos por tempo e gás
//   tempos_horas       - Vetor de tempos (horas) para os subplots
//   z_ana              - Vetor de posições do método analítico
//   perfis_ana         - Matriz de perfis analíticos (tempos x posições)
//   DAB                - Valor do coeficiente de difusão (cm²/s) — ADICIONADO!
//
// ===========================================================================
function plotar_comparacao_numerico_analitico(z_num, solucoes_por_tempo, tempos_horas, z_ana, perfis_ana, DAB)
    scf(2);  // Janela 2 para comparação
    clf();
    
    fig = gcf();
    fig.axes_size = [850, 700];
    fig.figure_position = [50, 50];
    fig.figure_name = msprintf("Comparação: Numérico vs Analítico (D = %.3f cm²/s)", DAB);

    N_tempos = length(tempos_horas);

    for t_idx = 1:N_tempos
        subplot(2, 2, t_idx);
        
        // Dados numéricos: primeiro gás (CO2-N2O, D=0.096)
        z_n = z_num;
        perfil_num = solucoes_por_tempo(t_idx)(1);  // índice 1 = primeiro gás
        
        // Dados analíticos: linha t_idx
        z_a = z_ana;
        perfil_ana = perfis_ana(t_idx, :);
        
        // Plot numérico (marcadores)
        plot(z_n, perfil_num, "-o", "Color", "blue", "MarkerSize", 5, "LineWidth", 1.2);
        
        // Plot analítico (linha contínua)
        plot(z_a, perfil_ana, "-", "Color", "red", "LineWidth", 2.0);
        
        xlabel("Posição z (cm)");
        ylabel("Fração molar normalizada");
        title(msprintf("t = %.1f h | D = %.3f cm²/s", tempos_horas(t_idx), DAB));  // <-- DAB adicionado aqui!
        xgrid();
        
        // Legenda apenas no primeiro subplot
        if t_idx == 1 then
            legend(["Numérico (Crank-Nicolson)", "Analítico (Fourier)"], "in_upper_right");
        end
    end
endfunction

// =============================
// PARÂMETROS DO PROBLEMA
// =============================
// Para o método numérico
 Dab_lista = [0.096, 0.674, 0.139]; 
 tempos_desejados_horas = [0.5, 1, 4, 8];

// Para o método analítico:
DAB = 0.096;                    // cm²/s
L = 100;                        // cm
Nz = 101;
tempos = [0.5*3600, 1*3600, 4*3600, 8*3600];  // 0.5h, 1h, 4h, 8h   
N_termos = 50;

// =============================
// CHAMADA DAS FUNÇÕES E PLOTS
// =============================

// --- Numérico ---
[z_total, solucoes_por_tempo, tempos_desejados_horas, Dab_lista] = numerico_crank_nicolson();
plotar_resultados_numericos(z_total, solucoes_por_tempo, tempos_desejados_horas, Dab_lista);

// --- Analítico ---
[z, perfis, tempos_plot] = calcular_perfil_difusao(DAB, L, Nz, tempos, N_termos);
plotar_resultados_analiticos(z, perfis, tempos_plot, DAB);  // <-- PASSANDO DAB

// --- Comparação ---
plotar_comparacao_numerico_analitico(z_total, solucoes_por_tempo, tempos_desejados_horas, z, perfis, DAB);  // <-- PASSANDO DAB
