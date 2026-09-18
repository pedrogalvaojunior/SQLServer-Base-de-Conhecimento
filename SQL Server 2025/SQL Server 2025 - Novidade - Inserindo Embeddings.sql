/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Inserindo Embeddings.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar o armazenamento de embeddings utilizando
 o novo tipo de dados VECTOR do SQL Server 2025.

 Contexto...:
 Embeddings são representações numéricas produzidas
 por modelos de Inteligência Artificial que permitem
 comparar similaridade semântica entre documentos,
 produtos, imagens e outros conteúdos.

 Este script demonstra a criação de uma base de
 conhecimento vetorial e a inserção de embeddings
 simulados para fins didáticos.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Criação de estruturas vetoriais
 - Inserção de embeddings
 - Catálogo de conhecimento
 - Base para RAG
 - Base para busca vetorial

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Habilitação de Recursos Experimentais
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.BaseConhecimento;
GO

DROP TABLE IF EXISTS dbo.ProdutosVetoriais;
GO

DROP TABLE IF EXISTS dbo.DocumentosTecnicos;
GO

------------------------------------------------------------------------------
-- Base de Conhecimento
------------------------------------------------------------------------------

CREATE TABLE dbo.BaseConhecimento
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_BaseConhecimento
                      PRIMARY KEY,

    Titulo            VARCHAR(200)
                      NOT NULL,

    Categoria         VARCHAR(100)
                      NOT NULL,

    Conteudo          VARCHAR(MAX)
                      NOT NULL,

    Embedding         VECTOR(8)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Catálogo Vetorial de Produtos
------------------------------------------------------------------------------

CREATE TABLE dbo.ProdutosVetoriais
(
    IdProduto         INT IDENTITY(1,1)
                      CONSTRAINT PK_ProdutosVetoriais
                      PRIMARY KEY,

    NomeProduto       VARCHAR(150)
                      NOT NULL,

    Categoria         VARCHAR(100)
                      NOT NULL,

    Embedding         VECTOR(8)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Documentação Técnica
------------------------------------------------------------------------------

CREATE TABLE dbo.DocumentosTecnicos
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_DocumentosTecnicos
                      PRIMARY KEY,

    Titulo            VARCHAR(200)
                      NOT NULL,

    Embedding         VECTOR(8)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Base de Conhecimento
------------------------------------------------------------------------------

INSERT INTO dbo.BaseConhecimento
(
    Titulo,
    Categoria,
    Conteudo,
    Embedding
)
VALUES
(
    'Introducao ao SQL Server',
    'Banco de Dados',
    'Conceitos fundamentais da plataforma SQL Server.',
    '[0.11,0.22,0.33,0.44,0.55,0.66,0.77,0.88]'
),
(
    'Modelagem Dimensional',
    'Data Warehouse',
    'Conceitos de fatos, dimensoes e indicadores.',
    '[0.18,0.26,0.39,0.47,0.58,0.64,0.79,0.83]'
),
(
    'Engenharia de Software',
    'Desenvolvimento',
    'Processos, requisitos e qualidade.',
    '[0.29,0.35,0.42,0.50,0.61,0.72,0.81,0.94]'
);
GO

------------------------------------------------------------------------------
-- Inserindo Produtos
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosVetoriais
(
    NomeProduto,
    Categoria,
    Embedding
)
VALUES
(
    'Notebook Dell Inspiron',
    'Informatica',
    '[0.80,0.12,0.33,0.41,0.59,0.68,0.71,0.91]'
),
(
    'Monitor LG 27',
    'Monitores',
    '[0.34,0.22,0.55,0.61,0.45,0.29,0.63,0.77]'
),
(
    'Mouse Logitech',
    'Perifericos',
    '[0.92,0.15,0.48,0.36,0.25,0.11,0.71,0.80]'
);
GO

------------------------------------------------------------------------------
-- Inserindo Documentos Técnicos
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosTecnicos
(
    Titulo,
    Embedding
)
VALUES
(
    'Guia SQL Server 2025',
    '[0.09,0.15,0.27,0.39,0.52,0.66,0.79,0.95]'
),
(
    'Inteligencia Artificial Aplicada',
    '[0.41,0.38,0.33,0.61,0.72,0.79,0.84,0.98]'
);
GO

------------------------------------------------------------------------------
-- Inserção Utilizando JSON_ARRAY
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosVetoriais
(
    NomeProduto,
    Categoria,
    Embedding
)
VALUES
(
    'Teclado Microsoft',
    'Perifericos',

    JSON_ARRAY
    (
        0.75,
        0.12,
        0.55,
        0.28,
        0.18,
        0.22,
        0.66,
        0.83
    )
);
GO

------------------------------------------------------------------------------
-- Consulta da Base de Conhecimento
------------------------------------------------------------------------------

SELECT
    BC.IdDocumento,
    BC.Titulo,
    BC.Categoria,
    BC.Embedding
FROM dbo.BaseConhecimento AS BC
ORDER BY
    BC.Titulo;
GO

------------------------------------------------------------------------------
-- Consulta de Produtos
------------------------------------------------------------------------------

SELECT
    PV.IdProduto,
    PV.NomeProduto,
    PV.Categoria,
    PV.Embedding
FROM dbo.ProdutosVetoriais AS PV
ORDER BY
    PV.NomeProduto;
GO

------------------------------------------------------------------------------
-- Consulta dos Documentos Técnicos
------------------------------------------------------------------------------

SELECT
    DT.IdDocumento,
    DT.Titulo,
    DT.Embedding
FROM dbo.DocumentosTecnicos AS DT
ORDER BY
    DT.Titulo;
GO

------------------------------------------------------------------------------
-- Simulação de Embedding de Consulta
------------------------------------------------------------------------------

DECLARE @EmbeddingPesquisa VECTOR(8);

SET @EmbeddingPesquisa =
'[
    0.10,
    0.21,
    0.30,
    0.43,
    0.56,
    0.68,
    0.78,
    0.90
]';

SELECT
    @EmbeddingPesquisa AS EmbeddingPesquisa;
GO

------------------------------------------------------------------------------
-- Cenário RAG
--
-- Este vetor poderia representar a pergunta enviada
-- por um usuário para um modelo de IA.
------------------------------------------------------------------------------

DECLARE @PerguntaUsuario VECTOR(8);

SET @PerguntaUsuario =
'[
    0.12,
    0.25,
    0.34,
    0.46,
    0.58,
    0.67,
    0.81,
    0.93