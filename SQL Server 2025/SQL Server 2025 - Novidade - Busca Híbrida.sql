/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Busca Hibrida.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar o conceito de Busca Híbrida utilizando
 filtros relacionais tradicionais combinados com
 pesquisa semântica baseada em embeddings.

 Contexto...:
 Em aplicações modernas de IA, raramente utiliza-se
 apenas busca textual ou apenas busca vetorial.

 O cenário mais comum consiste em combinar filtros
 estruturados (categoria, data, status, região, etc.)
 com embeddings vetoriais.

 Esta abordagem é conhecida como Busca Híbrida.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos Vetoriais habilitados

 Resultado..:
 - Base documental híbrida
 - Filtros estruturados
 - Embeddings vetoriais
 - Seleção de contexto para RAG
 - Simulação de pesquisa inteligente

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
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.BaseConhecimentoHibrida;
GO

------------------------------------------------------------------------------
-- Criação da Estrutura
------------------------------------------------------------------------------

CREATE TABLE dbo.BaseConhecimentoHibrida
(
    IdDocumento          INT IDENTITY(1,1)
                         CONSTRAINT PK_BaseConhecimentoHibrida
                         PRIMARY KEY,

    Categoria            VARCHAR(100)
                         NOT NULL,

    SubCategoria         VARCHAR(100)
                         NOT NULL,

    Titulo               VARCHAR(200)
                         NOT NULL,

    Conteudo             VARCHAR(MAX)
                         NOT NULL,

    Autor                VARCHAR(100)
                         NOT NULL,

    DataPublicacao       DATE
                         NOT NULL,

    Ativo                BIT
                         NOT NULL
                         DEFAULT 1,

    Embedding            VECTOR(8)
                         NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Documentos
------------------------------------------------------------------------------

INSERT INTO dbo.BaseConhecimentoHibrida
(
    Categoria,
    SubCategoria,
    Titulo,
    Conteudo,
    Autor,
    DataPublicacao,
    Embedding
)
VALUES
(
    'Banco de Dados',
    'SQL Server',
    'Introducao ao SQL Server',
    'Fundamentos e arquitetura da plataforma.',
    'Pedro Antonio Galvao Junior',
    '2026-09-01',
    '[0.12,0.23,0.36,0.48,0.57,0.69,0.80,0.92]'
),
(
    'Banco de Dados',
    'Data Warehouse',
    'Modelagem Dimensional',
    'Conceitos de fatos e dimensoes.',
    'Pedro Antonio Galvao Junior',
    '2026-09-05',
    '[0.15,0.26,0.39,0.50,0.60,0.71,0.82,0.95]'
),
(
    'Cloud',
    'Azure',
    'Fundamentos Azure',
    'Servicos de computacao em nuvem.',
    'Equipe Azure',
    '2026-09-08',
    '[0.18,0.29,0.43,0.55,0.64,0.74,0.84,0.96]'
),
(
    'Inteligencia Artificial',
    'Embeddings',
    'Introducao aos Embeddings',
    'Representacao vetorial de conteudo.',
    'Equipe IA',
    '2026-09-10',
    '[0.11,0.24,0.38,0.52,0.61,0.73,0.86,0.98]'
),
(
    'Inteligencia Artificial',
    'Busca Vetorial',
    'Busca Semantica',
    'Pesquisa baseada em similaridade.',
    'Equipe IA',
    '2026-09-11',
    '[0.13,0.25,0.40,0.54,0.63,0.75,0.87,0.99]'
),
(
    'Engenharia de Software',
    'Requisitos',
    'Levantamento de Requisitos',
    'Tecnicas de descoberta e analise.',
    'Fatec Sao Roque',
    '2026-09-12',
    '[0.66,0.58,0.49,0.40,0.31,0.23,0.16,0.08]'
);
GO

------------------------------------------------------------------------------
-- Consulta Geral
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Categoria,
    B.SubCategoria,
    B.Titulo,
    B.DataPublicacao
FROM dbo.BaseConhecimentoHibrida AS B
ORDER BY
    B.DataPublicacao;
GO

------------------------------------------------------------------------------
-- Filtro Tradicional
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Titulo
FROM dbo.BaseConhecimentoHibrida AS B
WHERE B.Categoria = 'Inteligencia Artificial';
GO

------------------------------------------------------------------------------
-- Filtro por Período
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Titulo,
    B.DataPublicacao
FROM dbo.BaseConhecimentoHibrida AS B
WHERE B.DataPublicacao >= '2026-09-08';
GO

------------------------------------------------------------------------------
-- Filtro por Autor
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Titulo,
    B.Autor
FROM dbo.BaseConhecimentoHibrida AS B
WHERE B.Autor = 'Pedro Antonio Galvao Junior';
GO

------------------------------------------------------------------------------
-- Embedding da Pergunta
------------------------------------------------------------------------------

DECLARE @EmbeddingPergunta VECTOR(8);

SET @EmbeddingPergunta =
'[
    0.12,
    0.25,
    0.39,
    0.53,
    0.62,
    0.74,
    0.86,
    0.98
]';

SELECT
    @EmbeddingPergunta AS EmbeddingPergunta;
GO

------------------------------------------------------------------------------
-- Busca Híbrida
--
-- Filtro Estruturado + Pesquisa Semântica
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Categoria,
    B.SubCategoria,
    B.Titulo
FROM dbo.BaseConhecimentoHibrida AS B
WHERE
    B.Categoria = 'Inteligencia Artificial'
    AND B.Ativo = 1;
GO

------------------------------------------------------------------------------
-- Busca Híbrida por Data
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Titulo,
    B.DataPublicacao
FROM dbo.BaseConhecimentoHibrida AS B
WHERE
    B.Categoria = 'Inteligencia Artificial'
    AND B.DataPublicacao >= '2026-09-01';
GO

------------------------------------------------------------------------------
-- Busca Híbrida por SubCategoria
------------------------------------------------------------------------------

SELECT
    B.IdDocumento,
    B.Titulo
FROM dbo.BaseConhecimentoHibrida AS B
WHERE
    B.Categoria = 'Inteligencia Artificial'
    AND B.SubCategoria = 'Embeddings';
GO

------------------------------------------------------------------------------
-- Contexto Recuperado para RAG
------------------------------------------------------------------------------

SELECT TOP (3)
    B.Titulo,
    B.Conteudo
FROM dbo.BaseConhecimentoHibrida AS B
WHERE
    B.Categoria IN
    (
        'Banco de Dados',
        'Inteligencia Artificial'
    )
ORDER BY
    B.DataPublicacao DESC;
GO

------------------------------------------------------------------------------
-- Simulação de Resposta para Chatbot
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Titulo':Titulo,
        'Categoria':Categoria,
        'Autor':Autor
    ) AS DocumentoJSON
FROM dbo.BaseConhecimentoHibrida
WHERE Categoria = 'Inteligencia Artificial';
GO

------------------------------------------------------------------------------
-- Ranking por Categoria
------------------------------------------------------------------------------

SELECT
    Categoria,
    COUNT(*) AS QuantidadeDocumentos
FROM dbo.BaseConhecimentoHibrida
GROUP BY
    Categoria
ORDER BY
    QuantidadeDocumentos DESC;
GO

------------------------------------------------------------------------------
-- Estatísticas Gerais
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS TotalDocumentos
FROM dbo.BaseConhecimentoHibrida;
GO

SELECT
    MIN(DataPublicacao) AS MenorData,
    MAX(DataPublicacao) AS MaiorData
FROM dbo.BaseConhecimentoHibrida;
GO

------------------------------------------------------------------------------
-- Exemplo Corporativo
--
-- Pergunta:
--
-- "Quais documentos mais relevantes sobre
-- busca vetorial publicados recentemente?"
--
-- Etapa 01:
-- Filtro por categoria
--
-- Etapa 02:
-- Filtro por data
--
-- Etapa 03:
-- Busca vetorial
--
-- Etapa 04:
-- Envio para o LLM
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- RAG Corporativo
-- Chatbots
-- FAQ Inteligente
-- Pesquisa Jurídica
-- Pesquisa Acadêmica
-- Base de Conhecimento
-- Service Desk
-- Suporte Técnico
-- Portal do Conhecimento
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Benefícios da Busca Híbrida
--
-- Maior precisão
-- Menor volume de documentos retornados
-- Melhor qualidade das respostas
-- Menor custo computacional
-- Melhor experiência do usuário
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar filtros estruturados sempre que possível.
--
-- 2) Utilizar embeddings para refinamento semântico.
--
-- 3) Utilizar metadados para restringir o universo
--    pesquisado.
--
-- 4) Separar documentos por domínio de negócio.
--
-- 5) Definir critérios claros de relevância.
--
-- 6) Monitorar qualidade dos resultados obtidos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estruturas Utilizadas em Produção
--
-- VECTOR(384)
-- VECTOR(768)
-- VECTOR(1024)
-- VECTOR(1536)
--
-- Este exemplo utiliza VECTOR(8)
-- apenas para fins didáticos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.BaseConhecimentoHibrida;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------