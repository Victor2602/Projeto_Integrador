
CREATE TYPE "nivel_admin" AS ENUM (
    'operacional',
    'gestor',
    'superadmin'
);

CREATE TYPE "papel_usuario" AS ENUM (
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
    "nome" varchar(150) NOT NULL,
    "email" varchar(150) UNIQUE NOT NULL,
    "senha_hash" varchar(255) NOT NULL,
    "telefone" varchar(20) NOT NULL,
    "endereco" text NOT NULL,
    "ativo" boolean NOT NULL DEFAULT false,
    "criado_em" timestamp DEFAULT CURRENT_TIMESTAMP,
    CHECK (telefone.length == 11)
);

CREATE TABLE "funcao_usuario" (
    "usuario_id" UUID NOT NULL,
    "funcao_id" UUID NOT NULL,
    PRIMARY KEY ("usuario_id", "funcao_id")
);

CREATE TABLE "funcao" (
  "id" UUID PRIMARY KEY,
  "nome" papel_usuario UNIQUE NOT NULL
);

CREATE TABLE "discente" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE NOT NULL,
  "matricula" varchar(20) UNIQUE NOT NULL,
  "curso_id" UUID NOT NULL,
  "semestres_inativos" integer DEFAULT 0,
  "status" status_discente NOT NULL,
  "ira" decimal(5,2) DEFAULT 0
);

CREATE TABLE "docente" (
    "id" UUID PRIMARY KEY,
    "usuario_id" UUID UNIQUE NOT NULL,
    "departamento_id" UUID NOT NULL,
    "titulacao" titulacao_docente NOT NULL,
    "regime" contratacao NOT NULL,
    "salario" decimal(6,2) NOT NULL,
    CHECK(salario>=0)
);

CREATE TABLE "fornecedor" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID UNIQUE NOT NULL,
  "nome_empresa" varchar(150) NOT NULL,
  "cnpj" varchar(18) UNIQUE NOT NULL,
  "documentos_pendentes" boolean DEFAULT false,
  "status" status_fornecedor NOT NULL,
  "data_cadastro" timestamp DEFAULT CURRENT_TIMESTAMP,
  "data_atualizacao" timestamp DEFAULT BEFORE (UPDATE)
);

CREATE TABLE "funcionario" (
    "id" uuid PRIMARY KEY,
    "usuario_id" UUID UNIQUE NOT NULL,
    "departamento_id" UUID NOT NULL,
    "cargo" varchar(100) NOT NULL,
    "data_admissao" date NOT NULL,
    "salario" decimal(6,2) NOT NULL,
    "regime" contratacao NOT NULL,
    CHECK (salario >=0)
);

CREATE TABLE "administrador" (
    "id" UUID PRIMARY KEY,
    "usuario_id" UUID UNIQUE NOT NULL,
    "nivel" nivel_admin NOT NULL,
    "pode_gerenciar_usuarios" boolean DEFAULT true,
    "pode_gerenciar_financas" boolean DEFAULT true,
    "pode_gerenciar_departamentos" boolean DEFAULT true,
    "ultimo_acesso" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "sessao" (
  "id" UUID PRIMARY KEY,
  "usuario_id" UUID NOT NULL,
  "refresh_token" text NOT NULL,
  "criado_em" timestamp DEFAULT CURRENT_TIMESTAMP,
  "expira_em" timestamp NOT NULL,
  "ip" varchar(50) NOT NULL,
  "user_agent" text NOT NULL
);

CREATE TABLE "departamento" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(150) NOT NULL,
  "sigla" varchar(20) UNIQUE NOT NULL
);

CREATE TABLE "curso" (
  "id" UUID PRIMARY KEY,
  "nome" varchar(150) NOT NULL,
  "departamento_id" UUID NOT NULL,
  "codigo" varchar(20) UNIQUE NOT NULL,
  "carga_horaria" integer DEFAULT 0,
  "ativo" boolean DEFAULT true
);

CREATE TABLE "disciplina" (
    "id" UUID PRIMARY KEY,
    "codigo" varchar(20) UNIQUE NOT NULL,
    "nome" varchar(150) NOT NULL,
    "carga_horaria" integer DEFAULT 0,
    "curso_id" UUID NOT NULL,
    CHECK (carga_horaria>=0)
);

CREATE TABLE "turma" (
    "id" UUID PRIMARY KEY,
    "disciplina_id" UUID NOT NULL,
    "docente_id" UUID NOT NULL,
    "horario" varchar(100) NOT NULL,
    "sala" varchar(50) NOT NULL,
    "semestre" varchar(50) NOT NULL,
    "ano" INTEGER NOT NULL,
    "vagas" integer DEFAULT 100,
    UNIQUE("disciplina_id,""docente_id", "semestre", "ano"),
    CHECK (vagas >=0)
);

CREATE TABLE "pre_requisito" (
    "disciplina_id" UUID,
    "pre_requisito" UUID,
    PRIMARY KEY ("disciplina_id", "pre_requisito")
);

CREATE TABLE "matricula_semestre" (
    "id" UUID PRIMARY KEY,
    "discente_id" UUID NOT NULL,
    "semestre" varchar(20) NOT NULL,
    "data_matricula" timestamp NOT NULL,
    "status" status_matricula NOT NULL,
    UNIQUE ("discente_id","semestre")
);

CREATE TABLE "matricula_disciplina" (
    "id" UUID PRIMARY KEY,
    "matricula_id" UUID NOT NULL,
    "turma_id" UUID NOT NULL,
    "nota" decimal(4,2) DEFAULT 0,
    "faltas" integer DEFAULT 0,
    "status" status_matricula NOT NULL,
    CHECK (nota >=0),
    CHECK (faltas >=0)
);

CREATE TABLE "tarefa" (
  "id" UUID PRIMARY KEY,
  "turma_id" UUID NOT NULL,
  "titulo" varchar(150) NOT NULL,
  "descricao" text NOT NULL,
  "prazo" date NOT NULL,
  "criado_em" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "pedido" (
    "id" UUID PRIMARY KEY,
    "fornecedor_id" UUID NOT NULL,
    "numero" varchar(30) UNIQUE NOT NULL,
    "criado_por" UUID NOT NULL,
    "valor_total" decimal(10,2) NOT NULL,
    "status" status_pedido NOT NULL,
    "data_pedido" timestamp DEFAULT CURRENT_TIMESTAMP,
    "data_recebimento" date NULL,
    "prazo_entrega" date NOT NULL,
    CHECK (valor_total >= 0)
);

CREATE TABLE "item_pedido" (
    "id" UUID PRIMARY KEY,
    "pedido_id" UUID NOT NULL,
    "descricao" text NOT NULL,
    "quantidade" integer NOT NULL,
    "valor_unitario" decimal(10,2) NOT NULL,
    CHECK (valor_unitario>=0)
);

CREATE TABLE "notificacao" (
  "id" uuid PRIMARY KEY,
  "titulo" varchar(150) NOT NULL,
  "mensagem" text NOT NULL,
  "criado_em" timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "usuario_notificacao" (
    "usuario_id" UUID NOT NULL,
    "notificacao_id" UUID NOT NULL,
    "lida" boolean DEFAULT false,
    PRIMARY KEY ("usuario_id", "notificacao_id")
);

CREATE TABLE "permissao" (
    "id" UUID PRIMARY KEY,
    "nome" varchar(100) NOT NULL,
    "descricao" text NOT NULL
);

CREATE TABLE "funcao_permissao" (
  "funcao_id" UUID NOT NULL,
  "permissao_id" UUID NOT NULL,
  PRIMARY KEY ("funcao_id", "permissao_id")
);

CREATE TABLE "calendario_academico" (
    "id" UUID PRIMARY KEY,
    "departamento_id" UUID NOT NULL,
    "data_inicio" date NOT NULL,
    "data_fim" date NOT NULL,
    CHECK (data_fim>data_inicio)
);

CREATE TABLE "avaliacao" (
    "id" UUID PRIMARY KEY,
    "turma_id" UUID NOT NULL,
    "tipo" varchar(30) NOT NULL,
    "peso" decimal(4,2) DEFAULT 1,
    "nota_maxima" decimal(4,2) DEFAULT 0,
    "data" date NOT NULL,
    "descricao" text NOT NULL,
    CHECK (nota_maxima>=0),
    CHECK (peso>0)
);

CREATE TABLE "grade_curricular" (
  "id" UUID PRIMARY KEY,
  "curso_id" UUID NOT NULL,
  "disciplina_id" UUID NOT NULL,
  "periodo" integer NOT NULL,
  "obrigatoria" boolean DEFAULT true
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

ALTER TABLE "matricula_semestre" ADD FOREIGN KEY ("discente_id") REFERENCES "discente" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_disciplina" ADD FOREIGN KEY ("matricula_id") REFERENCES "matricula_semestre" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "matricula_disciplina" ADD FOREIGN KEY ("turma_id") REFERENCES "turma" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "tarefa" ADD FOREIGN KEY ("turma_id") REFERENCES "turma" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pedido" ADD FOREIGN KEY ("fornecedor_id") REFERENCES "fornecedor" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "pedido" ADD FOREIGN KEY ("criado_por") REFERENCES "administrador" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "item_pedido" ADD FOREIGN KEY ("pedido_id") REFERENCES "pedido" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "usuario_notificacao" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "usuario_notificacao" ADD FOREIGN KEY ("notificacao_id") REFERENCES "notificacao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcao_permissao" ADD FOREIGN KEY ("funcao_id") REFERENCES "funcao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "funcao_permissao" ADD FOREIGN KEY ("permissao_id") REFERENCES "permissao" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "calendario_academico" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "avaliacao" ADD FOREIGN KEY ("turma_id") REFERENCES "turma" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "grade_curricular" ADD FOREIGN KEY ("curso_id") REFERENCES "curso" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "grade_curricular" ADD FOREIGN KEY ("disciplina_id") REFERENCES "disciplina" ("id") DEFERRABLE INITIALLY IMMEDIATE;
