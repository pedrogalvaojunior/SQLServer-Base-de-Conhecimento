/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Variaveis VECTOR.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a declaração e utilização de variáveis
 do tipo VECTOR introduzidas no SQL Server 2025.

 Contexto...:
 Em cenários envolvendo Inteligência Artificial,
 Machine Learning e Busca Semântica, é comum trabalhar
 com embeddings temporários durante consultas.

 As variáveis VECTOR permitem armazenar embeddings
 durante a execução de instruções T-SQL.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Declaração de variáveis VECTOR
 - Atribuição de valores
 - Utilização em consultas
 - Simulação de pesquisas semânticas
 - Preparação para cálculos de similaridade

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Habilitação dos Recursos Preview
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Variável VECTOR de 4 Dimensões
------------------------------------------------------------------------------

DECLARE @Embedding VECTOR(4);

SET @Embedding =
'[0.12, 0.45, 0.33, 0.88]';

SELECT
    @Embedding AS Embedding;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Variável Utilizando JSON_ARRAY
------------------------------------------------------------------------------

DECLARE @EmbeddingProduto VECTOR(4);

SET @EmbeddingProduto =
JSON_ARRAY
(
    0.91,
    0.25,
    0.33,
    0.44
);

SELECT
    @EmbeddingProduto AS EmbeddingProduto;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Embedding de Documento
------------------------------------------------------------------------------

DECLARE @EmbeddingDocumento VECTOR(8);

SET @EmbeddingDocumento =
'[
    0.01,
    0.12,
    0.20,
    0.35,
    0.44,
    0.78,
    0.80,
    0.99
]';

SELECT
    @EmbeddingDocumento AS EmbeddingDocumento;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Embedding de Consulta Semântica
------------------------------------------------------------------------------

DECLARE @ConsultaSemantica VECTOR(8);

SET @ConsultaSemantica =
'[
    0.09,
    0.18,
    0.21,
    0.32,
    0.48,
    0.75,
    0.81,
    0.97
]';

SELECT
    @ConsultaSemantica AS ConsultaSemantica;
GO

------------------------------------------------------------------------------
-- Ambiente de Demonstração
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.DocumentosVetoriais;
GO

CREATE TABLE dbo.DocumentosVetoriais
(
    IdDocumento      INT IDENTITY(1,1)
                     CONSTRAINT PK_DocumentosVetoriais
                     PRIMARY KEY,

    Titulo           VARCHAR(200)
                     NOT NULL,

    Categoria        VARCHAR(50)
                     NOT NULL,

    Embedding        VECTOR(8)
                     NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Embeddings
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosVetoriais
(
    Titulo,
    Categoria,
    Embedding
)
VALUES
(
    'Introducao ao SQL Server',
    'Banco de Dados',
    '[0.10,0.15,0.22,0.31,0.40,0.55,0.80,0.95]'
),
(
    'Power BI para Analistas',
    'BI',
    '[0.50,0.44,0.39,0.28,0.22,0.18,0.10,0.05]'
),
(
    'Machine Learning',
    'IA',
    '[0.08,0.19,0.23,0.30,0.45,0.60,0.82,0.98]'
);
GO

------------------------------------------------------------------------------
-- Consulta dos Dados
------------------------------------------------------------------------------

SELECT
    DV.IdDocumento,
    DV.Titulo,
    DV.Categoria,
    DV.Embedding
FROM dbo.DocumentosVetoriais AS DV;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Variável para Pesquisa
------------------------------------------------------------------------------

DECLARE @PesquisaIA VECTOR(8);

SET @PesquisaIA =
'[0.09,0.20,0.24,0.31,0.47,0.58,0.83,0.97]';

SELECT
    @PesquisaIA AS EmbeddingPesquisa;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Simulação de Procura por Categoria
------------------------------------------------------------------------------

DECLARE @Categoria VARCHAR(50);

SET @Categoria = 'IA';

SELECT
    DV.IdDocumento,
    DV.Titulo,
    DV.Categoria
FROM dbo.DocumentosVetoriais AS DV
WHERE DV.Categoria = @Categoria;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Vetor de 16 Dimensões
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
    @Embedding16 AS Vetor16Dimensoes;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Vetor de Produto
------------------------------------------------------------------------------

DECLARE @ProdutoNotebook VECTOR(4);

SET @ProdutoNotebook =
'[0.80,0.15,0.60,0.30]';

SELECT
    @ProdutoNotebook AS VetorProduto;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Vetor de Usuário
------------------------------------------------------------------------------

DECLARE @PerfilUsuario VECTOR(6);

SET @PerfilUsuario =
'[0.12,0.25,0.33,0.40,0.28,0.90]';

SELECT
    @PerfilUsuario AS PerfilUsuario;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Vetor de Recomendação
------------------------------------------------------------------------------

DECLARE @Recomendacao VECTOR(6);

SET @Recomendacao =
'[0.15,0.24,0.35,0.38,0.30,0.88]';

SELECT
    @Recomendacao AS VetorRecomendacao;
GO

------------------------------------------------------------------------------
-- Cenários de Utilização
--
-- Embeddings para IA
-- Busca por Similaridade
-- Recomendação de Produtos
-- Catálogo Inteligente
-- Pesquisa Semântica
-- RAG
-- Chatbots
-- Classificação de Conteúdo
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar a mesma dimensionalidade em vetores
--    comparáveis.
--
-- 2) Padronizar o modelo gerador de embeddings.
--
-- 3) Evitar misturar embeddings produzidos por
--    modelos distintos.
--
-- 4) Validar dimensões durante cargas de dados.
--
-- 5) Utilizar variáveis VECTOR para testes,
--    filtros e prototipagem.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeDocumentos
FROM dbo.DocumentosVetoriais;
GO

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.DocumentosVetoriais;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------