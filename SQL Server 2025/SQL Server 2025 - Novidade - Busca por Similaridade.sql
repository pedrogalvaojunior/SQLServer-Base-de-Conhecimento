/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Busca por Similaridade.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar conceitos de busca por similaridade
 utilizando embeddings armazenados em colunas VECTOR.

 Contexto...:
 Sistemas modernos de IA utilizam embeddings para
 representar textos, documentos, produtos e imagens.

 A busca por similaridade permite localizar os itens
 semanticamente mais próximos de uma consulta,
 substituindo pesquisas puramente textuais.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos vetoriais habilitados

 Resultado..:
 - Base vetorial de documentos
 - Embeddings simulados
 - Consulta vetorial
 - Ranking de similaridade
 - Cenários de IA Generativa

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

DROP TABLE IF EXISTS dbo.BaseConhecimentoVetorial;
GO

------------------------------------------------------------------------------
-- Criação da Estrutura
------------------------------------------------------------------------------

CREATE TABLE dbo.BaseConhecimentoVetorial
(
    IdDocumento          INT IDENTITY(1,1)
                         CONSTRAINT PK_BaseConhecimentoVetorial
                         PRIMARY KEY,

    Categoria            VARCHAR(100)
                         NOT NULL,

    Titulo               VARCHAR(200)
                         NOT NULL,

    Conteudo             VARCHAR(MAX)
                         NOT NULL,

    Embedding            VECTOR(8)
                         NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Documentos
------------------------------------------------------------------------------

INSERT INTO dbo.BaseConhecimentoVetorial
(
    Categoria,
    Titulo,
    Conteudo,
    Embedding
)
VALUES
(
    'Banco de Dados',
    'Introducao ao SQL Server',
    'Fundamentos da plataforma Microsoft SQL Server.',
    '[0.10,0.21,0.35,0.48,0.57,0.66,0.77,0.88]'
),
(
    'Business Intelligence',
    'Power BI para Analistas',
    'Conceitos de modelagem e visualizacao.',
    '[0.50,0.44,0.38,0.29,0.20,0.18,0.10,0.05]'
),
(
    'Cloud Computing',
    'Fundamentos Azure',
    'Introducao aos servicos de nuvem Microsoft.',
    '[0.18,0.29,0.43,0.55,0.63,0.71,0.82,0.91]'
),
(
    'Inteligencia Artificial',
    'Embeddings e Busca Vetorial',
    'Conceitos de IA Generativa e Similaridade.',
    '[0.12,0.23,0.34,0.49,0.58,0.69,0.81,0.95]'
),
(
    'Engenharia de Software',
    'Levantamento de Requisitos',
    'Tecnicas para identificacao de requisitos.',
    '[0.65,0.58,0.49,0.40,0.31,0.24,0.16,0.08]'
);
GO

------------------------------------------------------------------------------
-- Visualização da Base
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Categoria,
    B.Titulo,
    B.Embedding
FROM dbo.BaseConhecimentoVetorial AS B
ORDER BY
    B.IdDocumento;
GO

------------------------------------------------------------------------------
-- Embedding da Consulta
--
-- Simula a pergunta de um usuário.
------------------------------------------------------------------------------

DECLARE @EmbeddingConsulta VECTOR(8);

SET @EmbeddingConsulta =
'[
    0.13,
    0.24,
    0.37,
    0.50,
    0.59,
    0.70,
    0.80,
    0.94
]';

SELECT
    @EmbeddingConsulta AS EmbeddingConsulta;
GO

------------------------------------------------------------------------------
-- Exemplo Conceitual de Busca Vetorial
--
-- Em cenários reais o mecanismo calculará
-- uma distância vetorial ou similaridade.
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Categoria,
    B.Titulo,
    B.Embedding
FROM dbo.BaseConhecimentoVetorial AS B;
GO

------------------------------------------------------------------------------
-- Consulta Simulando Documentos Relevantes
------------------------------------------------------------------------------

SELECT TOP (3)
    B.IdDocumento,
    B.Categoria,
    B.Titulo
FROM dbo.BaseConhecimentoVetorial AS B
WHERE B.Categoria IN
(
    'Banco de Dados',
    'Inteligencia Artificial',
    'Cloud Computing'
)
ORDER BY
    B.IdDocumento;
GO

------------------------------------------------------------------------------
-- Catálogo Vetorial de Produtos
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.ProdutosVetoriais;
GO

CREATE TABLE dbo.ProdutosVetoriais
(
    IdProduto            INT IDENTITY(1,1)
                         CONSTRAINT PK_ProdutosVetoriais
                         PRIMARY KEY,

    NomeProduto          VARCHAR(100)
                         NOT NULL,

    Categoria            VARCHAR(100)
                         NOT NULL,

    Embedding            VECTOR(8)
                         NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Produtos
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
    '[0.81,0.22,0.34,0.41,0.57,0.69,0.73,0.90]'
),
(
    'Monitor LG',
    'Monitores',
    '[0.32,0.20,0.47,0.55,0.38,0.22,0.60,0.71]'
),
(
    'Mouse Logitech',
    'Perifericos',
    '[0.88,0.12,0.41,0.30,0.22,0.18,0.65,0.79]'
),
(
    'Teclado Microsoft',
    'Perifericos',
    '[0.80,0.15,0.39,0.33,0.18,0.16,0.67,0.82]'
);
GO

------------------------------------------------------------------------------
-- Consulta do Catálogo
------------------------------------------------------------------------------

SELECT
    P.IdProduto,
    P.NomeProduto,
    P.Categoria,
    P.Embedding
FROM dbo.ProdutosVetoriais AS P;
GO

------------------------------------------------------------------------------
-- Simulação de Pesquisa por Produto
------------------------------------------------------------------------------

DECLARE @ProdutoPesquisado VECTOR(8);

SET @ProdutoPesquisado =
'[
    0.83,
    0.18,
    0.36,
    0.35,
    0.20,
    0.15,
    0.66,
    0.83
]';

SELECT
    @ProdutoPesquisado AS EmbeddingProduto;
GO

------------------------------------------------------------------------------
-- Produtos Potencialmente Similares
------------------------------------------------------------------------------

SELECT
    P.IdProduto,
    P.NomeProduto,
    P.Categoria
FROM dbo.ProdutosVetoriais AS P
WHERE P.Categoria = 'Perifericos';
GO

------------------------------------------------------------------------------
-- Cenário RAG
--
-- 1) Usuário envia uma pergunta.
-- 2) A pergunta é transformada em embedding.
-- 3) O banco localiza os documentos mais próximos.
-- 4) Os documentos são enviados para o LLM.
-- 5) O LLM produz a resposta enriquecida.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeDocumentos
FROM dbo.BaseConhecimentoVetorial;
GO

SELECT
    COUNT(*) AS QuantidadeProdutos
FROM dbo.ProdutosVetoriais;
GO

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- Similaridade de Cosseno
--
-- Distância Euclidiana
--
-- Distância de Manhattan
--
-- Produto Escalar
--
-- São métricas frequentemente utilizadas em sistemas
-- de busca vetorial.
--
-- O SQL Server armazena os embeddings e prepara a
-- infraestrutura para pesquisas por similaridade.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- IA Generativa
-- Retrieval Augmented Generation (RAG)
-- Chatbots Corporativos
-- Pesquisa Semântica
-- Catálogo Inteligente
-- Recomendação de Produtos
-- Busca de Documentos
-- Base de Conhecimento
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar o mesmo modelo de embeddings.
--
-- 2) Padronizar dimensionalidade.
--
-- 3) Indexar vetores quando suportado.
--
-- 4) Monitorar crescimento da base vetorial.
--
-- 5) Separar embeddings por domínio de negócio.
--
-- 6) Validar periodicamente a qualidade dos
--    resultados retornados.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.BaseConhecimentoVetorial;
GO

DROP TABLE dbo.ProdutosVetoriais;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------