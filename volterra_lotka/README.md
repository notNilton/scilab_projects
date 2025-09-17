# Simulação do Modelo Predador-Presa de Lotka-Volterra em Scilab

Este projeto contém scripts em Scilab para simular o modelo de Lotka-Volterra, que descreve a dinâmica de populações de predadores e presas. As simulações incluem um exemplo teórico clássico e uma aplicação a dados reais das populações de alces e lobos da Isle Royale.

## Conteúdo do Projeto

O repositório inclui os seguintes scripts:

- **`volterra_lotka_simple.sci`**: Uma implementação simples do modelo Lotka-Volterra com parâmetros genéricos para demonstrar o comportamento cíclico clássico das populações.
- **`volterra_lotka_realdata.sci`**: Uma aplicação do modelo a dados históricos reais de alces (presas) e lobos (predadores) da Isle Royale (1959-1998). Este script utiliza parâmetros calibrados para tentar ajustar o modelo aos dados observados.

## O Modelo de Lotka-Volterra

O modelo é descrito por um par de equações diferenciais ordinárias (EDOs):

1.  **Equação da Presa:**
    ```
    dx/dt = αx - βxy
    ```
2.  **Equação do Predador:**
    ```
    dy/dt = δxy - γy
    ```

Onde:
- `x` é a população de presas.
- `y` é a população de predadores.
- `t` representa o tempo.
- `α` (alpha): taxa de crescimento intrínseca da população de presas.
- `β` (beta): taxa de predação (mortalidade das presas por encontro com predadores).
- `δ` (delta): eficiência com que os predadores convertem presas consumidas em novos predadores.
- `γ` (gamma): taxa de mortalidade intrínseca da população de predadores.

## Requisitos

- **Scilab**: Os scripts foram desenvolvidos e testados no ambiente Scilab. É necessário ter o Scilab instalado para executá-los.

## Como Executar

1.  Abra o Scilab.
2.  Navegue até o diretório onde os arquivos `.sci` estão localizados usando o comando `cd`:
    ```scilab
    cd('caminho/para/o/projeto/volterra_lotka');
    ```
3.  Execute o script desejado usando o comando `exec`:

    - Para a simulação simples:
      ```scilab
      exec('volterra_lotka_simple.sci');
      ```
    - Para a simulação com dados reais:
      ```scilab
      exec('volterra_lotka_realdata.sci');
      ```

## Descrição dos Scripts

### `volterra_lotka_simple.sci`

Este script demonstra a dinâmica fundamental do modelo predador-presa.

**Funcionalidades:**
- Utiliza um conjunto de parâmetros teóricos (`alpha = 0.4`, `beta = 0.4`, `delta = 0.09`, `gamma = 2.0`).
- Define as condições iniciais para as populações de presas e predadores.
- Resolve as EDOs e gera dois gráficos:
  1.  **Populações vs. Tempo**: Mostra as oscilações cíclicas das populações de presas e predadores ao longo do tempo.
  2.  **Plano de Fase**: Exibe a trajetória do sistema no espaço de fase (População de Presas vs. População de Predadores), mostrando o ciclo limite e o ponto de equilíbrio.

### `volterra_lotka_realdata.sci`

Este script tenta modelar um ecossistema real usando os dados de alces e lobos da Isle Royale.

**Fonte dos Dados:**
As populações de alces e lobos foram registradas anualmente de 1959 a 1998.

**Funcionalidades:**
- Utiliza dados reais como condições iniciais e para comparação.
- Emprega um conjunto de parâmetros (`alpha = 0.25`, `beta = 0.007`, `delta = 0.00025`, `gamma = 0.3`) que foram ajustados para melhor corresponder às tendências e magnitudes dos dados reais, especificamente para reduzir a amplitude das oscilações do modelo padrão.
- Gera três saídas principais:
  1.  **Tabela no Console**: Imprime uma comparação ano a ano entre os dados reais e os valores simulados pelo modelo para as populações de alces e lobos.
  2.  **Gráficos de Simulação**:
      - **Figura 1**: Populações simuladas de alces e lobos ao longo do tempo.
      - **Figura 2**: Plano de fase para a simulação.
  3.  **Gráfico de Comparação (Figura 3)**: Sobrepõe os dados da simulação (linhas contínuas) com os dados reais (pontos), permitindo uma avaliação visual da precisão do modelo.

---

Este projeto serve como um excelente estudo de caso para a aplicação de modelos matemáticos a problemas ecológicos, ilustrando tanto a beleza teórica do modelo de Lotka-Volterra quanto os desafios de ajustá-lo a dados do mundo real.
