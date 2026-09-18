/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Conversao de VECTOR para JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar técnicas de conversão de dados do tipo
 VECTOR para estruturas JSON.

 Contexto...:
 Embora o armazenamento no SQL Server seja realizado
 utilizando o tipo VECTOR, aplicações modernas
 normalmente consomem embeddings no formato JSON.

 APIs REST, aplicações Web, microsserviços e
 ferramentas de IA frequentemente necessitam que os
 embeddings sejam serializados novamente no formato
 JSON para transmissão externa.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos VECTOR habilitados

 Resultado..:
 - Conversão de VECTOR para JSON
 - Geração de payloads para APIs
 - Estruturas para IA Generativa
 - Serialização de embeddings
 - Cenários de integração

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO


------------------------------------------------------------------------------
-- Habilitação de Recursos Preview
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO


------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Criação da Estrutura
------------------------------------------------------------------------------

CREATE TABLE dbo.EmbeddingsJSON
(
    IdEmbedding      INT IDENTITY(1,1)
                     CONSTRAINT PK_EmbeddingsJSON
                     PRIMARY KEY,

    Origem           VARCHAR(100)
                     NOT NULL,

    Embedding        VECTOR(8)
                     NOT NULL
);
GO


------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsJSON
(
    Origem,
    Embedding
)
VALUES
(
    'Documento IA',
    '[0.11,0.22,0.33,0.44,0.55,0.66,0.77,0.88]'
),
(
    'Catalogo Produto',
    '[0.18,0.25,0.37,0.48,0.59,0.67,0.79,0.91]'
),
(
    'FAQ Corporativo',
    '[0.09,0.16,0.29,0.42,0.54,0.68,0.83,0.95]'
);
GO


------------------------------------------------------------------------------
-- Consulta dos Dados Vetoriais
------------------------------------------------------------------------------

SELECT
    EJ.IdEmbedding,
    EJ.Origem,
    EJ.Embedding
FROM dbo.EmbeddingsJSON AS EJ;
GO


------------------------------------------------------------------------------
-- Exemplo 01
-- Conversão Conceitual para JSON
------------------------------------------------------------------------------

SELECT
    Origem,
    CAST(Embedding AS NVARCHAR(MAX)) AS EmbeddingJSON
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 02
-- Estrutura para API REST
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Origem':Origem,
        'Embedding':CAST(Embedding AS NVARCHAR(MAX))
    ) AS PayloadAPI
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 03
-- Estrutura Completa para IA
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Modelo':'text-embedding-3-large',
        'Origem':Origem,
        'Embedding':CAST(Embedding AS NVARCHAR(MAX))
    ) AS DocumentoJSON
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 04
-- Payload Simulando Resposta de API
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'success':TRUE,

        'data':
        JSON_OBJECT
        (
            'id':IdEmbedding,
            'origem':Origem,
            'embedding':CAST(Embedding AS NVARCHAR(MAX))
        )
    ) AS ApiResponse
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 05
-- Catálogo de Embeddings
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Documento IA',
        'Catalogo Produto',
        'FAQ Corporativo'
    ) AS CatalogoJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 06
-- Construindo Documento de Exportação
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'IdEmbedding':IdEmbedding,
        'Origem':Origem,
        'Embedding':CAST(Embedding AS NVARCHAR(MAX))
    ) AS ExportacaoJSON
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 07
-- Vetor Temporário
------------------------------------------------------------------------------

DECLARE @Embedding VECTOR(8);

SET @Embedding =
'[
    0.12,
    0.24,
    0.36,
    0.48,
    0.60,
    0.72,
    0.84,
    0.96
]';

SELECT
    CAST(@Embedding AS NVARCHAR(MAX)) AS EmbeddingComoJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 08
-- Vetor FLOAT16
------------------------------------------------------------------------------

DECLARE @EmbeddingFloat16 VECTOR(8, FLOAT16);

SET @EmbeddingFloat16 =
'[
    0.10,
    0.20,
    0.30,
    0.40,
    0.50,
    0.60,
    0.70,
    0.80
]';

SELECT
    CAST(@EmbeddingFloat16 AS NVARCHAR(MAX))
    AS EmbeddingFloat16JSON;
GO


------------------------------------------------------------------------------
-- Exemplo 09
-- Estrutura para Data Lake
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'DataExportacao':
            CONVERT
            (
                VARCHAR(19),
                GETDATE(),
                120
            ),

        'Origem':Origem,

        'Embedding':
            CAST
            (
                Embedding
                AS NVARCHAR(MAX)
            )
    ) AS RegistroExportacao
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Exemplo 10
-- Estrutura para RAG
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Tipo':'BaseConhecimento',

        'Identificador':IdEmbedding,

        'Embedding':
            CAST
            (
                Embedding
                AS NVARCHAR(MAX)
            )
    ) AS DocumentoRAG
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Consulta Consolidada
------------------------------------------------------------------------------

SELECT
    EJ.IdEmbedding,
    EJ.Origem,
    CAST
    (
        EJ.Embedding
        AS NVARCHAR(MAX)
    ) AS EmbeddingConvertido
FROM dbo.EmbeddingsJSON AS EJ;
GO


------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeEmbeddings
FROM dbo.EmbeddingsJSON;
GO


------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- 1) APIs normalmente trabalham com JSON.
--
-- 2) O SQL Server armazena embeddings em VECTOR.
--
-- 3) Em integrações é comum converter os vetores
--    novamente para JSON.
--
-- 4) Essa abordagem é útil para exportações,
--    replicação e integração entre sistemas.
--
-- 5) Muitos modelos de IA recebem ou devolvem
--    embeddings utilizando arrays JSON.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- APIs REST
-- Azure Functions
-- Microsserviços
-- IA Generativa
-- RAG
-- Data Lake
-- Integração de Sistemas
-- Catálogo Inteligente
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Armazenar internamente no formato VECTOR.
--
-- 2) Converter para JSON apenas quando necessário.
--
-- 3) Evitar conversões repetitivas em massa.
--
-- 4) Preservar dimensionalidade original.
--
-- 5) Monitorar tamanho dos payloads exportados.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.EmbeddingsJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------