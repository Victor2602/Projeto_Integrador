CREATE TYPE "funcao_usuario" AS ENUM (
  'discente',
  'docente',
  'funcionario',
  'administrador',
  'fornecedor'
);

CREATE TYPE "status_discente" AS ENUM (
  'ativo',
  'trancado',
  'formado',
  'desligado'
);

CREATE TYPE "titulacao_docente" AS ENUM (
  'pos_graduado',
  'mestre',
  'doutor'
);

CREATE TYPE "contratacao" AS ENUM (
  'contrato',
  'clt'
);

CREATE TYPE "status_fornecedor" AS ENUM (
  'pendente',
  'aprovado',
  'rejeitado'
);

CREATE TYPE "status_matricula" AS ENUM (
  'pendente',
  'regular'
);

CREATE TYPE "status_pedido" AS ENUM (
  'enviado',
  'confirmado',
  'recebido',
  'cancelado'
);

CREATE TABLE "usuario" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(150),
  "email" varchar(150) UNIQUE,
  "senha_hash" varchar(255),
  "telefone" varchar(20),
  "endereco" text,
  "ativo" boolean,
  "criado_em" timestamp
);

CREATE TABLE "funcao_usuario" (
  "usuario_id" UUID,
  "funcao_id" UUID
);

CREATE TABLE "funcao" (
  "id" UUID PRIMARY KEY,
  "nome" funcao_usuario
);

CREATE TABLE "discente" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE,
  "matricula" varchar(20) UNIQUE,
  "curso_id" UUID,
  "semestres_inativos" integer,
  "status" status_discente,
  "ira" decimal(4,2)
);

CREATE TABLE "docente" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE,
  "departamento_id" UUID,
  "titulacao" titulacao_docente,
  "regime" contratacao,
  "salario" decimal(10,2)
);

CREATE TABLE "fornecedor" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE,
  "nome_empresa" varchar(150),
  "cnpj" varchar(18) UNIQUE,
  "documentos_pendentes" boolean,
  "status" status_fornecedor,
  "data_cadastro" timestamp,
  "data_atualizacao" timestamp
);

CREATE TABLE "funcionario" (
  "id" uuid PRIMARY KEY,
  "usuario_id" UUID UNIQUE,
  "departamento_id" UUID,
  "cargo" varchar(100),
  "data_admissao" date,
  "salario" decimal(10,2),
  "regime" contratacao
);

CREATE TABLE "administrador" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE,
  "pode_gerenciar_usuarios" boolean DEFAULT true,
  "pode_gerenciar_financas" boolean DEFAULT true,
  "pode_gerenciar_departamentos" boolean DEFAULT true,
  "ultimo_acesso" timestamp
);

CREATE TABLE "sessao" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID,
  "refresh_token" text,
  "criado_em" timestamp,
  "expira_em" timestamp,
  "ip" varchar(50),
  "user_agent" text
);

CREATE TABLE "departamento" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(150),
  "sigla" varchar(20) UNIQUE
);

CREATE TABLE "curso" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(150),
  "departamento_id" UUID,
  "codigo" varchar(20) UNIQUE,
  "carga_horaria" integer,
  "ativo" boolean
);

CREATE TABLE "disciplina" (
  "id" UUID PRIMARY KEY,
  "codigo" varchar(20) UNIQUE,
  "nome" varchar(150),
  "carga_horaria" integer,
  "curso_id" UUID
);

CREATE TABLE "turma" (
  "id" UUID PRIMARY KEY,
  "disciplina_id" UUID,
  "docente_id" UUID,
  "horario" varchar(100),
  "sala" varchar(50),
  "vagas" integer
);

CREATE TABLE "pre_requisito" (
  "disciplina_id" UUID,
  "pre_requisito" UUID,
  PRIMARY KEY ("disciplina_id", "pre_requisito")
);

CREATE TABLE "historico_escolar" (
  "id" UUID PRIMARY KEY,
  "discente_id" UUID,
  "disciplina_id" UUID,
  "semestre" varchar(20),
  "nota_final" decimal(4,2)
);

CREATE TABLE "matricula_semestre" (
  "id" UUID PRIMARY KEY,
  "discente_id" UUID,
  "semestre" varchar(20),
  "data_matricula" timestamp,
  "status" status_matricula
);

CREATE TABLE "matricula_disciplina" (
  "id" UUID PRIMARY KEY,
  "matricula_id" UUID,
  "disciplina_id" UUID,
  "turma_id" UUID,
  "nota" decimal(4,2),
  "faltas" integer,
  "status" status_matricula
);

CREATE TABLE "tarefa" (
  "id" UUID PRIMARY KEY,
  "disciplina_id" UUID,
  "titulo" varchar(150),
  "descricao" text,
  "prazo" date,
  "criado_em" timestamp
);

CREATE TABLE "pedido" (
  "id" UUID PRIMARY KEY,
  "fornecedor_id" UUID,
  "numero" varchar(30) UNIQUE,
  "criado_por" UUID,
  "valor_total" decimal(10,2),
  "status" status_pedido,
  "data_pedido" timestamp,
  "data_recebimento" date,
  "prazo_entrega" date
);

CREATE TABLE "item_pedido" (
  "id" UUID PRIMARY KEY,
  "pedido_id" UUID,
  "descricao" text,
  "quantidade" integer,
  "valor_unitario" decimal(10,2)
);

CREATE TABLE "notificacao" (
  "id" uuid PRIMARY KEY,
  "titulo" varchar(150),
  "mensagem" text,
  "criado_em" timestamp
);

CREATE TABLE "usuario_notificacao" (
  "usuario_id" UUID,
  "notificacao_id" UUID,
  "lida" boolean,
  PRIMARY KEY ("usuario_id", "notificacao_id")
);

CREATE TABLE "permissao" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(100),
  "descricao" text
);

CREATE TABLE "funcao_permissao" (
  "funcao_id" UUID,
  "permissao_id" UUID,
  PRIMARY KEY ("funcao_id", "permissao_id")
);

CREATE TABLE "calendario_academico" (
  "id" UUID PRIMARY KEY,
  "departamento_id" UUID,
  "data_inicio" date,
  "data_fim" date
);

CREATE TABLE "avaliacao" (
  "id" UUID PRIMARY KEY,
  "disciplina_id" UUID,
  "tipo" varchar(30),
  "peso" double,
  "nota_maxima" double,
  "data" date,
  "descricao" text
);

CREATE TABLE "grade_curricular" (
  "id" UUID PRIMARY KEY,
  "curso_id" UUID,
  "disciplina_id" UUID,
  "periodo" integer,
  "obrigatoria" boolean
);

ALTER TABLE "funcao_usuario" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcao_usuario" ADD FOREIGN KEY ("funcao_id") REFERENCES "funcao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "discente" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "discente" ADD FOREIGN KEY ("curso_id") REFERENCES "curso" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "docente" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "docente" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fornecedor" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcionario" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcionario" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "administrador" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "sessao" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "curso" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "disciplina" ADD FOREIGN KEY ("curso_id") REFERENCES "curso" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "turma" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "turma" ADD FOREIGN KEY ("docente_id") REFERENCES "docente" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pre_requisito" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pre_requisito" ADD FOREIGN KEY ("pre_requisito") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "historico_escolar" ADD FOREIGN KEY ("discente_id") REFERENCES "discente" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "historico_escolar" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_semestre" ADD FOREIGN KEY ("discente_id") REFERENCES "discente" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_disciplina" ADD FOREIGN KEY ("matricula_id") REFERENCES "matricula_semestre" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_disciplina" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_disciplina" ADD FOREIGN KEY ("turma_id") REFERENCES "turma" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "tarefa" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pedido" ADD FOREIGN KEY ("fornecedor_id") REFERENCES "fornecedor" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pedido" ADD FOREIGN KEY ("criado_por") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "item_pedido" ADD FOREIGN KEY ("pedido_id") REFERENCES "pedido" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "usuario_notificacao" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "usuario_notificacao" ADD FOREIGN KEY ("notificacao_id") REFERENCES "notificacao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcao_permissao" ADD FOREIGN KEY ("funcao_id") REFERENCES "funcao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcao_permissao" ADD FOREIGN KEY ("permissao_id") REFERENCES "permissao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "calendario_academico" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "avaliacao" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "grade_curricular" ADD FOREIGN KEY ("curso_id") REFERENCES "curso" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "grade_curricular" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;
