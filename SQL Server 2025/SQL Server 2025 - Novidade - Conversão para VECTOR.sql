/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Conversao para VECTOR.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar técnicas de conversão de estruturas JSON
 para o tipo de dados VECTOR introduzido no
 SQL Server 2025.

 Contexto...:
 A maioria dos provedores de IA devolve embeddings
 no formato JSON.

 Antes do armazenamento, esses valores precisam ser
 convertidos para o tipo VECTOR para permitir buscas
 semânticas e consultas vetoriais.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos Preview habilitados

 Resultado..:
 - Conversão de JSON para VECTOR
 - Validação de embeddings
 - Inserção em tabelas vetoriais
 - Cenários de IA
 - Preparação para busca vetorial

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

DROP TABLE IF EXISTS dbo.EmbeddingsConvertidos;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.EmbeddingsConvertidos
(
    IdEmbedding      INT IDENTITY(1,1)
                     CONSTRAINT PK_EmbeddingsConvertidos
                     PRIMARY KEY,

    OrigemDados      VARCHAR(100)
                     NOT NULL,

    Embedding        VECTOR(8)
                     NOT NULL
);
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- JSON Recebido de API de IA
------------------------------------------------------------------------------

DECLARE @EmbeddingJSON VARCHAR(MAX);

SET @EmbeddingJSON =
'[
    0.12,
    0.24,
    0.36,
    0.48,
    0.52,
    0.64,
    0.78,
    0.91
]';

SELECT
    @EmbeddingJSON AS EmbeddingRecebido;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Conversão para VECTOR
------------------------------------------------------------------------------

DECLARE @EmbeddingVetorial VECTOR(8);

SET @EmbeddingVetorial =
'[
    0.12,
    0.24,
    0.36,
    0.48,
    0.52,
    0.64,
    0.78,
    0.91
]';

SELECT
    @EmbeddingVetorial AS EmbeddingConvertido;
GO

------------------------------------------------------------------------------
-- Inserção do Embedding Convertido
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsConvertidos
(
    OrigemDados,
    Embedding
)
VALUES
(
    'API OpenAI',
    '[0.12,0.24,0.36,0.48,0.52,0.64,0.78,0.91]'
);
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Conversão Utilizando JSON_ARRAY()
------------------------------------------------------------------------------

DECLARE @EmbeddingGerado VECTOR(8);

SET @EmbeddingGerado =
JSON_ARRAY
(
    0.10,
    0.20,
    0.30,
    0.40,
    0.50,
    0.60,
    0.70,
    0.80
);

SELECT
    @EmbeddingGerado AS EmbeddingGerado;
GO

------------------------------------------------------------------------------
-- Inserindo Vetor Gerado
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsConvertidos
(
    OrigemDados,
    Embedding
)
VALUES
(
    'JSON_ARRAY',
    JSON_ARRAY
    (
        0.10,
        0.20,
        0.30,
        0.40,
        0.50,
        0.60,
        0.70,
        0.80
    )
);
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Embedding de Documento
------------------------------------------------------------------------------

DECLARE @DocumentoVetorial VECTOR(8);

SET @DocumentoVetorial =
'[
    0.91,
    0.83,
    0.74,
    0.66,
    0.55,
    0.44,
    0.32,
    0.20
]';

SELECT
    @DocumentoVetorial AS DocumentoVetorial;
GO

------------------------------------------------------------------------------
-- Inserindo Documento
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsConvertidos
(
    OrigemDados,
    Embedding
)
VALUES
(
    'Documento Tecnico',
    '[0.91,0.83,0.74,0.66,0.55,0.44,0.32,0.20]'
);
GO

------------------------------------------------------------------------------
-- Consulta dos Embeddings
------------------------------------------------------------------------------

SELECT
    EC.IdEmbedding,
    EC.OrigemDados,
    EC.Embedding
FROM dbo.EmbeddingsConvertidos AS EC
ORDER BY
    EC.IdEmbedding;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Estrutura Simulando Resposta de API
------------------------------------------------------------------------------

DECLARE @RespostaAPI VARCHAR(MAX);

SET @RespostaAPI =
'
{
    "model":"text-embedding",
    "embedding":
    [
        0.22,
        0.33,
        0.44,
        0.55,
        0.66,
        0.77,
        0.88,
        0.99
    ]
}
';

SELECT
    @RespostaAPI AS RespostaAPI;
GO

------------------------------------------------------------------------------
-- Exemplo Conceitual
--
-- Extração do array e conversão posterior
-- para armazenamento vetorial.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Vetor de Produto
------------------------------------------------------------------------------

DECLARE @EmbeddingProduto VECTOR(8);

SET @EmbeddingProduto =
'[
    0.78,
    0.65,
    0.53,
    0.41,
    0.36,
    0.28,
    0.19,
    0.10
]';

SELECT
    @EmbeddingProduto AS EmbeddingProduto;
GO

------------------------------------------------------------------------------
-- Inserção de Produto
------------------------------------------------------------------------------

INSERT INTO dbo.EmbeddingsConvertidos
(
    OrigemDados,
    Embedding
)
VALUES
(
    'Catalogo Produto',
    '[0.78,0.65,0.53,0.41,0.36,0.28,0.19,0.10]'
);
GO

------------------------------------------------------------------------------
-- Vetor de Pergunta para RAG
------------------------------------------------------------------------------

DECLARE @PerguntaUsuario VECTOR(8);

SET @PerguntaUsuario =
'[
    0.15,
    0.29,
    0.37,
    0.49,
    0.61,
    0.70,
    0.84,
    0.93
]';

SELECT
    @PerguntaUsuario AS EmbeddingPergunta;
GO

------------------------------------------------------------------------------
-- Estatísticas do Ambiente
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeEmbeddings
FROM dbo.EmbeddingsConvertidos;
GO

------------------------------------------------------------------------------
-- Exemplo de Dimensionalidade Maior
------------------------------------------------------------------------------

DECLARE @Embedding16 VECTOR(16);

SET @Embedding16 =
'[
    0.01,0.02,0.03,0.04,
    0.05,0.06,0.07,0.08,
    0.09,0.10,0.11,0.12,
    0.13,0.14,0.15,0.16
]';

SELECT
    @Embedding16 AS Embedding16;
GO

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- Fontes comuns de embeddings:
--
-- OpenAI
-- Azure OpenAI
-- Azure AI Foundry
-- Hugging Face
-- Ollama
-- Modelos locais
--
-- Em ambientes reais é comum receber embeddings
-- em estruturas JSON e convertê-los posteriormente
-- para VECTOR.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- IA Generativa
-- Chatbots
-- RAG
-- Base de Conhecimento
-- Pesquisa Semântica
-- Classificação de Conteúdo
-- Catálogo Inteligente
-- Recomendação de Produtos
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Validar a dimensionalidade dos embeddings.
--
-- 2) Utilizar sempre o mesmo modelo gerador.
--
-- 3) Evitar misturar vetores de tamanhos diferentes.
--
-- 4) Manter metadados sobre a origem do embedding.
--
-- 5) Validar o JSON recebido antes da conversão.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.EmbeddingsConvertidos;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------