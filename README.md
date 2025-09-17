# Projetos de Computação Científica em Scilab

Este repositório é uma coleção de projetos desenvolvidos na plataforma Scilab, focados na simulação e resolução numérica de problemas clássicos da engenharia e das ciências. Cada diretório representa um estudo de caso independente, contendo seus próprios scripts e documentação detalhada.

## Projetos Contidos

Abaixo está uma lista dos projetos atualmente disponíveis neste repositório.

---

### 1. `analytic_numerical`

**Análise da Equação de Difusão 1D**

Este projeto resolve a equação de difusão unidimensional utilizando duas abordagens distintas:

- **Solução Analítica:** Baseada em séries de Fourier para um caso com condições de contorno de fluxo nulo.
- **Solução Numérica:** Implementada com o método de diferenças finitas de Crank-Nicolson, conhecido por sua estabilidade.

O objetivo principal é validar a precisão do modelo numérico comparando seus resultados diretamente com a solução analítica exata.

➡️ **Acesse a documentação do projeto**

---

### 2. `volterra_lotka`

**Modelo Predador-Presa de Lotka-Volterra**

Este projeto explora a dinâmica de populações de predadores e presas através do modelo de Lotka-Volterra. Ele inclui:

- **Simulação Teórica:** Uma implementação com parâmetros genéricos para demonstrar o comportamento cíclico clássico do modelo.
- **Aplicação com Dados Reais:** Uma simulação que utiliza dados históricos das populações de alces e lobos da Isle Royale (1959-1998) para comparar o modelo com um ecossistema real.

➡️ **Acesse a documentação do projeto**

## Como Utilizar

Para executar qualquer um dos projetos, navegue até o diretório correspondente e execute o script principal (`.sci`) no console do Scilab usando o comando `exec('nome_do_arquivo.sci')`. Requisitos específicos e instruções detalhadas estão nos arquivos `README.md` de cada projeto.
