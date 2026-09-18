/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Vetores Float16.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização de vetores FLOAT16 no
 SQL Server 2025 para armazenamento otimizado
 de embeddings.

 Contexto...:
 Embeddings normalmente utilizam FLOAT32, porém
 aplicações de IA podem armazenar milhões de vetores.

 O suporte a FLOAT16 permite reduzir consumo de
 armazenamento e memória, tornando o ambiente mais
 eficiente para aplicações de Busca Vetorial,
 IA Generativa e RAG.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos Preview habilitados

 Resultado..:
 - Utilização de VECTOR FLOAT16
 - Inserção de embeddings
 - Catálogo vetorial
 - Base de conhecimento
 - Comparação conceitual FLOAT32 x FLOAT16

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Habilitando Recursos Preview
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.EmbeddingsFloat32;
GO

DROP TABLE IF EXISTS dbo.EmbeddingsFloat16;
GO

DROP TABLE IF EXISTS dbo.CatalogoIA;
GO

------------------------------------------------------------------------------
-- Tabela Utilizando FLOAT32
------------------------------------------------------------------------------

CREATE TABLE dbo.EmbeddingsFloat32
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_EmbeddingsFloat32
                      PRIMARY KEY,

    NomeDocumento     VARCHAR(200)
                      NOT NULL,

    Embedding         VECTOR(8)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Tabela Utilizando FLOAT16
------------------------------------------------------------------------------

CREATE TABLE dbo.EmbeddingsFloat16
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_EmbeddingsFloat16
                      PRIMARY KEY,

    NomeDocumento     VARCHAR(200)
                      NOT NULL,

    Embedding         VECTOR(8, FLOAT16)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Estrutura de Catálogo IA
------------------------------------------------------------------------------

CREATE TABLE dbo.CatalogoIA
(
    IdItem            INT IDENTITY(1,1)
                      CONSTRAINT PK_CatalogoIA
                      PRIMARY KEY,

    Categoria         VARCHAR(100)
                      NOT NULL,

    Titulo            VARCHAR(200)
                      NOT NULL,

    Embedding         VECTOR(8, FLOAT16)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Dados FLOAT32
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsFloat32
(
    NomeDocumento,
    Embedding
)
VALUES
(
    'SQL Server',
    '[0.12,0.22,0.35,0.44,0.51,0.68,0.77,0.88]'
),
(
    'Power BI',
    '[0.14,0.25,0.38,0.45,0.55,0.64,0.79,0.91]'
),
(
    'Azure',
    '[0.18,0.28,0.41,0.53,0.60,0.74,0.83,0.95]'
);
GO

------------------------------------------------------------------------------
-- Inserindo Dados FLOAT16
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsFloat16
(
    NomeDocumento,
    Embedding
)
VALUES
(
    'SQL Server',
    '[0.12,0.22,0.35,0.44,0.51,0.68,0.77,0.88]'
),
(
    'Power BI',
    '[0.14,0.25,0.38,0.45,0.55,0.64,0.79,0.91]'
),
(
    'Azure',
    '[0.18,0.28,0.41,0.53,0.60,0.74,0.83,0.95]'
);
GO

------------------------------------------------------------------------------
-- Inserindo Catálogo de IA
------------------------------------------------------------------------------

INSERT INTO dbo.CatalogoIA
(
    Categoria,
    Titulo,
    Embedding
)
VALUES
(
    'Banco de Dados',
    'Introducao ao SQL Server',
    '[0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80]'
),
(
    'Analytics',
    'Power BI para Analistas',
    '[0.11,0.23,0.32,0.45,0.56,0.68,0.71,0.89]'
),
(
    'Cloud',
    'Fundamentos do Azure',
    '[0.09,0.19,0.29,0.43,0.57,0.63,0.78,0.92]'
),
(
    'Inteligencia Artificial',
    'Embeddings e Busca Vetorial',
    '[0.16,0.27,0.39,0.48,0.61,0.75,0.84,0.97]'
);
GO

------------------------------------------------------------------------------
-- Consulta FLOAT32
------------------------------------------------------------------------------

SELECT
    EF32.IdDocumento,
    EF32.NomeDocumento,
    EF32.Embedding
FROM dbo.EmbeddingsFloat32 AS EF32;
GO

------------------------------------------------------------------------------
-- Consulta FLOAT16
------------------------------------------------------------------------------

SELECT
    EF16.IdDocumento,
    EF16.NomeDocumento,
    EF16.Embedding
FROM dbo.EmbeddingsFloat16 AS EF16;
GO

------------------------------------------------------------------------------
-- Consulta do Catálogo
------------------------------------------------------------------------------

SELECT
    CI.IdItem,
    CI.Categoria,
    CI.Titulo,
    CI.Embedding
FROM dbo.CatalogoIA AS CI
ORDER BY
    CI.Categoria,
    CI.Titulo;
GO

------------------------------------------------------------------------------
-- Variável VECTOR FLOAT16
------------------------------------------------------------------------------

DECLARE @EmbeddingPesquisa VECTOR(8, FLOAT16);

SET @EmbeddingPesquisa =
'[
    0.13,
    0.24,
    0.36,
    0.47,
    0.58,
    0.69,
    0.79,
    0.90
]';

SELECT
    @EmbeddingPesquisa AS EmbeddingPesquisa;
GO

------------------------------------------------------------------------------
-- Vetor de 16 Dimensões
------------------------------------------------------------------------------

DECLARE @EmbeddingGrande VECTOR(16, FLOAT16);

SET @EmbeddingGrande =
'[
    0.01,0.02,0.03,0.04,
    0.05,0.06,0.07,0.08,
    0.09,0.10,0.11,0.12,
    0.13,0.14,0.15,0.16
]';

SELECT
    @EmbeddingGrande AS EmbeddingGrande;
GO

------------------------------------------------------------------------------
-- Exemplo Utilizando JSON_ARRAY
------------------------------------------------------------------------------

DECLARE @EmbeddingJSON VECTOR(8, FLOAT16);

SET @EmbeddingJSON =
JSON_ARRAY
(
    0.50,
    0.44,
    0.38,
    0.32,
    0.26,
    0.20,
    0.14,
    0.08
);

SELECT
    @EmbeddingJSON AS EmbeddingJSON;
GO

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeFloat32
FROM dbo.EmbeddingsFloat32;
GO

SELECT
    COUNT(*) AS QuantidadeFloat16
FROM dbo.EmbeddingsFloat16;
GO

SELECT
    COUNT(*) AS QuantidadeCatalogo
FROM dbo.CatalogoIA;
GO

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- FLOAT32
--
-- Maior precisão.
-- Maior consumo de armazenamento.
-- Adequado para cenários analíticos.
--
-- FLOAT16
--
-- Menor consumo de armazenamento.
-- Menor consumo de memória.
-- Excelente para grandes coleções vetoriais.
--
-- Cenários reais normalmente utilizam:
--
-- VECTOR(384, FLOAT16)
-- VECTOR(768, FLOAT16)
-- VECTOR(1024, FLOAT16)
-- VECTOR(1536, FLOAT16)
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- IA Generativa
-- RAG
-- Busca Vetorial
-- Pesquisa Semântica
-- Catálogo Inteligente
-- Recomendação de Produtos
-- Classificação de Conteúdo
-- Chatbots Corporativos
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar FLOAT16 para grandes volumes.
--
-- 2) Avaliar a perda de precisão antes da adoção.
--
-- 3) Manter o mesmo modelo de embeddings.
--
-- 4) Padronizar dimensionalidades.
--
-- 5) Monitorar crescimento da base vetorial.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.EmbeddingsFloat32;
GO

DROP TABLE dbo.EmbeddingsFloat16;
GO

DROP TABLE dbo.CatalogoIA;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------