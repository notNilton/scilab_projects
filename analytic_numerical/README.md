# Comparação de Soluções Analítica e Numérica para a Equação de Difusão 1D

Este projeto em Scilab implementa e compara duas abordagens para resolver a equação de difusão unidimensional (1D): uma solução analítica baseada em séries de Fourier e uma solução numérica utilizando o método de diferenças finitas de Crank-Nicolson.

O objetivo é validar a implementação numérica comparando seus resultados com a solução analítica exata para um caso de teste específico.

## Conteúdo do Projeto

O repositório contém um único script principal:

- **`analytic_numerical_comparison.sci`**: Script que define, resolve e visualiza o problema de difusão usando ambas as metodologias.

## O Modelo Físico

O problema modelado é a difusão de um gás em um domínio unidimensional, governado pela segunda lei de Fick:

```
∂C/∂t = D * ∂²C/∂z²
```

Onde:
- `C` é a concentração (ou fração molar) do gás.
- `t` é o tempo.
- `z` é a posição no domínio.
- `D` é o coeficiente de difusão.

### Condições do Problema

- **Domínio**: O problema é resolvido em um domínio `z` de `-L` a `L`.
- **Condição Inicial**: Uma condição de degrau simétrica no tempo `t=0`. A concentração é alta em uma metade do domínio (`z < 0`) e baixa na outra (`z > 0`).
- **Condições de Contorno**: As fronteiras em `z = -L` e `z = L` são impermeáveis (fluxo zero), o que é matematicamente representado por uma condição de Neumann nula: `∂C/∂z = 0`.

## Métodos de Solução Implementados

### 1. Solução Analítica (`calcular_perfil_difusao`)

Para as condições dadas, existe uma solução analítica exata na forma de uma série de Fourier. Esta função calcula o perfil de concentração em diferentes instantes de tempo somando um número definido de termos da série. Ela serve como a "verdade" para validar o método numérico.

### 2. Solução Numérica (`numerico_crank_nicolson`)

Esta função resolve a equação de difusão usando o método de diferenças finitas.
- **Discretização Espacial**: Derivadas espaciais são aproximadas por diferenças finitas centradas.
- **Discretização Temporal**: O esquema de Crank-Nicolson é utilizado. Ele é um método implícito que calcula a derivada espacial como a média entre o passo de tempo atual e o próximo, resultando em excelente estabilidade numérica.

A função é capaz de simular a difusão para múltiplos coeficientes de difusão (`Dab_lista`) simultaneamente.

## Requisitos

- **Scilab**: O script foi desenvolvido e testado no ambiente Scilab.

## Como Executar

1.  Abra o Scilab.
2.  Navegue até o diretório do projeto usando o comando `cd`:
    ```scilab
    cd('caminho/para/o/projeto/analytic_numerical');
    ```
3.  Execute o script principal com o comando `exec`:
    ```scilab
    exec('analytic_numerical_comparison.sci');
    ```

## Resultados Esperados

A execução do script irá gerar três janelas de gráfico distintas:

1.  **Figura 0: Resultados Numéricos - Crank-Nicolson**
    - Apresenta os perfis de concentração calculados pelo método numérico.
    - Contém 4 subplots, um para cada instante de tempo simulado (0.5h, 1h, 4h, 8h).
    - Cada subplot mostra as curvas para três pares de gases diferentes (com `D` distintos).

2.  **Figura 1: Solução Analítica**
    - Mostra os perfis de concentração calculados pela solução analítica (série de Fourier) para um único coeficiente de difusão (`D = 0.096 cm²/s`).
    - Todas as curvas para os diferentes instantes de tempo são plotadas no mesmo gráfico para facilitar a visualização da evolução temporal.

3.  **Figura 2: Comparação: Numérico vs Analítico**
    - O resultado mais importante do projeto.
    - Compara diretamente a solução numérica (pontos/marcadores) com a solução analítica (linhas contínuas) para o mesmo gás.
    - Os 4 subplots mostram que os resultados numéricos se sobrepõem quase perfeitamente aos analíticos, validando a precisão da implementação do método de Crank-Nicolson.

---

Este projeto é um excelente exercício para entender e visualizar as soluções da equação de difusão, além de demonstrar o poder e a precisão de esquemas numéricos bem estabelecidos como o de Crank-Nicolson.
