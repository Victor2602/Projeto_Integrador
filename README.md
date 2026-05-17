# Projeto Integrador — Sistema Educacional

![Status](https://img.shields.io/badge/status-concluído-brightgreen)
![Curso](https://img.shields.io/badge/curso-ADS-blue)
![Instituição](https://img.shields.io/badge/Senac-EAD-orange)
![Licença](https://img.shields.io/badge/license-MIT-lightgrey)

## Sobre o Projeto

Este repositório apresenta as soluções desenvolvidas para a segunda etapa do Projeto Integrador do curso de Análise e Desenvolvimento de Sistemas da instituição Senac EAD.

O projeto teve como objetivo a elaboração de um protótipo de sistema educacional, bem como a modelagem de sua estrutura de dados, utilizando ferramentas modernas de prototipação e modelagem relacional.

---

## Sumário

- [Metodologia](#metodologia)
- [Ferramentas Utilizadas](#ferramentas-utilizadas)
- [Resultados](#resultados)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Autores](#autores)
- [Licença](#licença)

---

## Metodologia

Devido ao avanço das tecnologias de Inteligência Artificial (IA), o desenvolvimento desta etapa do projeto foi dividido em dois processos principais:

### 1. Prototipação

A interface do sistema foi desenvolvida utilizando o [Figma](https://www.figma.com), com apoio da ferramenta Figma Make e posteriores ajustes manuais realizados pela equipe.

### 2. Modelagem da Estrutura de Dados

A modelagem do banco de dados foi realizada com o auxílio da ferramenta open-source [dbdiagram.io](https://dbdiagram.io), seguida da implementação prática utilizando o DataGrip.

---

## Ferramentas Utilizadas

| Ferramenta | Finalidade |
|---|---|
| Figma | Prototipação da interface |
| Figma Make | Geração inicial de componentes |
| dbdiagram.io | Modelagem do banco de dados |
| DataGrip | Implementação e gerenciamento SQL |
| GitHub | Versionamento do projeto |

---

## Resultados

A utilização do Figma Make permitiu que a equipe concentrasse esforços na arquitetura do design e na experiência de navegação do usuário, possibilitando a construção de um protótipo interativo, funcional e visualmente consistente.

Entretanto, em razão da eficiência e flexibilidade da ferramenta, o escopo inicial do sistema evoluiu significativamente, tornando parte da documentação inicial defasada. Dessa forma, foram necessárias algumas alterações estruturais:

### Alterações Realizadas

1. O diagrama inicial de casos de uso foi revisado, uma vez que as responsabilidades do ator especializado **"Funcionário (Compras)"** puderam ser incorporadas ao ator **"Administrador Operacional"**;

2. O ator **"Administrador"** passou a possuir três especializações:
   - Administrador Operacional;
   - Administrador Gestor;
   - Superadministrador;

3. Os cenários inicialmente definidos tornaram-se insuficientes para representar toda a navegação interativa do sistema, exigindo ampliação da documentação funcional.

---

## Estrutura do Projeto

```text
Projeto_Integrador/
│
├── banco_de_dados/
│   ├── diagramas/
│   ├── scripts_sql/
│
├── documentos/
│   ├── Projeto_Integrador.pdf
|
├── prototipo/
│   ├── prototipo.zip
│   └── README.md
└── README.md #global
```
---
## Autores
Projeto desenvolvido pelos alunos do curso de Análise e Desenvolvimento de Sistemas — Senac EAD:
- Victor Hugo Nascimento Silva
- Raissa Anne Ribeiro
- Isabelly Franklin Silva
- Izabela Rodrigues Costa
- 
  

---
## Licença
Este projeto está licenciado sob a licença MIT. Consulte o arquivo LICENSE para mais informações.

