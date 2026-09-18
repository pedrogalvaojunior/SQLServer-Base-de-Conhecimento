/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Tipo de Dados VECTOR.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a criação e utilização do novo tipo de dados
 VECTOR introduzido no SQL Server 2025.

 Contexto...:
 O tipo VECTOR foi criado para suportar aplicações
 relacionadas à Inteligência Artificial, Machine Learning
 e Busca Semântica.

 Os vetores normalmente representam embeddings gerados
 por modelos de IA, permitindo pesquisas por similaridade
 diretamente dentro do banco de dados.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Criação de colunas VECTOR
 - Inserção de embeddings
 - Utilização de JSON_ARRAY()
 - Variáveis VECTOR
 - Vetores FLOAT32
 - Estruturas preparadas para IA

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Recursos Preview
--
-- Alguns recursos vetoriais podem exigir habilitação
-- explícita dependendo da versão instalada.
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.ProdutosVetoriais;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.ProdutosVetoriais
(
    IdProduto           INT IDENTITY(1,1)
                        CONSTRAINT PK_ProdutosVetoriais
                        PRIMARY KEY,

    NomeProduto         VARCHAR(100)
                        NOT NULL,

    Categoria           VARCHAR(50)
                        NOT NULL,

    Embedding           VECTOR(4)
                        NOT NULL
);
GO

------------------------------------------------------------------------------
-- Estrutura da Tabela
------------------------------------------------------------------------------

EXEC sp_help 'dbo.ProdutosVetoriais';
GO

------------------------------------------------------------------------------
-- Inserção Utilizando Literal JSON
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosVetoriais
(
    NomeProduto,
    Categoria,
    Embedding
)
VALUES
(
    'Notebook Dell',
    'Informatica',
    '[0.12, 0.45, 0.33, 0.88]'
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
    'Monitor LG',
    'Monitores',
    JSON_ARRAY
    (
        0.34,
        0.11,
        0.84,
        0.29
    )
);
GO

------------------------------------------------------------------------------
-- Inserção de Mouse
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosVetoriais
(
    NomeProduto,
    Categoria,
    Embedding
)
VALUES
(
    'Mouse Logitech',
    'Perifericos',
    '[0.91, 0.05, 0.77, 0.15]'
);
GO

------------------------------------------------------------------------------
-- Inserção de Teclado
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
    '[0.80, 0.04, 0.75, 0.18]'
);
GO

------------------------------------------------------------------------------
-- Consulta Completa
------------------------------------------------------------------------------

SELECT
    PV.IdProduto,
    PV.NomeProduto,
    PV.Categoria,
    PV.Embedding
FROM dbo.ProdutosVetoriais AS PV
ORDER BY
    PV.IdProduto;
GO

------------------------------------------------------------------------------
-- Demonstrando Variável VECTOR
------------------------------------------------------------------------------

DECLARE @EmbeddingConsulta VECTOR(4);

SET @EmbeddingConsulta =
'[0.12, 0.45, 0.33, 0.88]';

SELECT
    @EmbeddingConsulta AS VetorConsulta;
GO

------------------------------------------------------------------------------
-- Vetor Simulando Embedding de Documento
------------------------------------------------------------------------------

DECLARE @Documento VECTOR(8);

SET @Documento =
'[
    0.12,
    0.25,
    0.33,
    0.45,
    0.50,
    0.88,
    0.77,
    0.19
]';

SELECT
    @Documento AS EmbeddingDocumento;
GO

------------------------------------------------------------------------------
-- Catálogo de Produtos Vetoriais
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
-- Exemplo de Armazenamento para IA Generativa
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.BaseConhecimento;
GO

CREATE TABLE dbo.BaseConhecimento
(
    IdDocumento        INT IDENTITY(1,1)
                       CONSTRAINT PK_BaseConhecimento
                       PRIMARY KEY,

    Titulo             VARCHAR(200)
                       NOT NULL,

    Conteudo           VARCHAR(MAX)
                       NOT NULL,

    Embedding          VECTOR(8)
                       NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Conteúdo Vetorial
------------------------------------------------------------------------------

INSERT INTO dbo.BaseConhecimento
(
    Titulo,
    Conteudo,
    Embedding
)
VALUES
(
    'Introducao ao SQL Server',

    'Documento de exemplo para demonstracao.',

    '[0.11,0.22,0.33,0.44,0.55,0.66,0.77,0.88]'
);
GO

------------------------------------------------------------------------------
-- Consulta da Base de Conhecimento
------------------------------------------------------------------------------

SELECT
    BC.IdDocumento,
    BC.Titulo,
    BC.Embedding
FROM dbo.BaseConhecimento AS BC;
GO

------------------------------------------------------------------------------
-- Exemplo de Vetor de 16 Dimensões
------------------------------------------------------------------------------

DECLARE @EmbeddingGrande VECTOR(16);

SET @EmbeddingGrande =
'[
 0.01,0.02,0.03,0.04,
 0.05,0.06,0.07,0.08,
 0.09,0.10,0.11,0.12,
 0.13,0.14,0.15,0.16
]';

SELECT
    @EmbeddingGrande AS Vetor16Dimensoes;
GO

------------------------------------------------------------------------------
-- Cenários de Utilização
--
-- IA Generativa
-- Retrieval Augmented Generation (RAG)
-- Busca Semântica
-- Catálogo Inteligente de Produtos
-- Recomendação de Conteúdo
-- Pesquisa de Documentos
-- Classificação Automatizada
-- Similaridade de Textos
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeProdutos
FROM dbo.ProdutosVetoriais;
GO

SELECT
    COUNT(*) AS QuantidadeDocumentos
FROM dbo.BaseConhecimento;
GO

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- 1) Um VECTOR armazena valores numéricos em formato
--    otimizado para operações matemáticas.
--
-- 2) Embeddings geralmente são produzidos por modelos
--    de IA externos.
--
-- 3) O SQL Server pode armazenar os vetores para futura
--    busca por similaridade.
--
-- 4) Vetores maiores normalmente possuem 384, 768,
--    1024 ou 1536 dimensões.
--
-- 5) Este script utiliza vetores pequenos para fins
--    didáticos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ProdutosVetoriais;
GO

DROP TABLE dbo.BaseConhecimento;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------