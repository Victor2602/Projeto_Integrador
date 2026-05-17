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
├── prototipo/
│   ├── figma/
│   └── documentacao/
│
├── banco_de_dados/
│   ├── diagramas/
│   ├── scripts_sql/
│   └── modelo_relacional/
│
├── documentos/
│   ├── casos_de_uso/
│   ├── requisitos/
│   └── relatorios/
│
└── README.md
```
Normalização do Banco de Dados

O banco de dados apresentado foi estruturado seguindo os princípios de normalização, visando reduzir redundâncias, evitar inconsistências e garantir integridade dos dados. A modelagem atende principalmente à Primeira, Segunda e Terceira Forma Normal (1FN, 2FN e 3FN).

1ª Forma Normal (1FN)

A Primeira Forma Normal determina que:

cada coluna possua valores atômicos;
não existam grupos repetitivos;
cada registro seja único.

O banco atende à 1FN porque:

todas as tabelas possuem chave primária (id);
os atributos armazenam apenas um valor por campo;
não existem listas ou múltiplos valores em uma mesma coluna.

Exemplos:

A tabela usuario armazena um único telefone por campo.
A tabela discente possui apenas um curso vinculado através de curso_id.
A tabela pedido possui os itens separados na tabela item_pedido, evitando repetição.
2ª Forma Normal (2FN)

A Segunda Forma Normal exige:

estar na 1FN;
todos os atributos dependerem totalmente da chave primária.

O banco atende à 2FN porque:

tabelas associativas utilizam chaves compostas corretamente;
atributos descritivos dependem integralmente da chave.

Exemplos:

Relação entre usuários e funções

A tabela funcao_usuario resolve o relacionamento N:N entre usuario e funcao.

usuario_id	funcao_id

A chave primária composta garante que:

um usuário possa possuir várias funções;
uma função possa pertencer a vários usuários.

Nenhum atributo depende parcialmente da chave composta.

Relação entre funções e permissões

A tabela funcao_permissao implementa o relacionamento N:N entre funcao e permissao.

funcao_id	permissao_id

Os dados dependem totalmente da chave composta.

Relação entre usuários e notificações

A tabela usuario_notificacao associa usuários às notificações recebidas.

| usuario_id | notificacao_id | lida |

O atributo lida depende da combinação entre usuário e notificação.

3ª Forma Normal (3FN)

A Terceira Forma Normal exige:

estar na 2FN;
não existir dependência transitiva.

O banco atende à 3FN porque informações foram separadas em tabelas específicas, evitando redundância.

Exemplos
Usuários e perfis

Os dados básicos ficam na tabela usuario, enquanto características específicas são separadas em:

discente
docente
funcionario
administrador
fornecedor

Isso evita repetição de:

nome;
email;
telefone;
endereço.
Cursos e departamentos

A tabela curso referencia departamento através de departamento_id.

Assim:

o nome do departamento não precisa ser repetido em cada curso;
alterações em departamentos são feitas em apenas um local.

Relacionamento:

Um departamento possui vários cursos (1:N).
Disciplinas e turmas

A tabela disciplina armazena os dados permanentes da disciplina, enquanto turma armazena:

semestre;
docente;
sala;
horário.

Relacionamento:

Uma disciplina pode possuir várias turmas (1:N).

Isso evita duplicidade de dados acadêmicos.

Pedidos e itens do pedido

A tabela pedido armazena informações gerais do pedido:

fornecedor;
status;
valor total.

Já a tabela item_pedido armazena os produtos/serviços individualmente.

Relacionamento:

Um pedido possui vários itens (1:N).

Essa separação elimina repetição de informações do pedido para cada item.

Relacionamentos Entre as Tabelas
Relacionamentos 1:N (Um para Muitos)
Tabela Principal	Tabela Relacionada	Relacionamento
departamento	curso	1:N
curso	disciplina	1:N
disciplina	turma	1:N
docente	turma	1:N
discente	matricula_semestre	1:N
matricula_semestre	matricula_disciplina	1:N
turma	tarefa	1:N
turma	avaliacao	1:N
fornecedor	pedido	1:N
pedido	item_pedido	1:N
usuario	sessao	1:N
Relacionamentos N:N (Muitos para Muitos)
Tabelas	Tabela Intermediária
usuario ↔ funcao	funcao_usuario
funcao ↔ permissao	funcao_permissao
usuario ↔ notificacao	usuario_notificacao
disciplina ↔ disciplina	pre_requisito
Integridade Referencial

O banco utiliza diversas chaves estrangeiras (FOREIGN KEY) para garantir integridade entre os dados.

Exemplos:

curso.departamento_id → departamento.id
discente.usuario_id → usuario.id
pedido.fornecedor_id → fornecedor.id
turma.docente_id → docente.id

Isso impede registros órfãos e mantém consistência no sistema.

Conclusão

O banco de dados foi modelado de maneira normalizada, reduzindo redundâncias e garantindo integridade dos dados. A estrutura atende às três primeiras formas normais (1FN, 2FN e 3FN), utilizando corretamente:

separação de entidades;
tabelas associativas;
chaves primárias;
chaves estrangeiras;
restrições de integridade.

A modelagem favorece:

manutenção do sistema;
escalabilidade;
segurança dos dados;
desempenho em consultas relacionais.

---
## Autores
Projeto desenvolvido pelos alunos do curso de Análise e Desenvolvimento de Sistemas — Senac EAD:
- Victor Hugo Nascimento Silva
- Raissa Anne Ribeiro
  

---
## Licença
Este projeto está licenciado sob a licença MIT. Consulte o arquivo LICENSE para mais informações.

