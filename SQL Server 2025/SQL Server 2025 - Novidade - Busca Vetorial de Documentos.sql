/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Busca Vetorial de Documentos.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a construção de uma base documental
 preparada para busca vetorial utilizando embeddings.

 Contexto...:
 Sistemas modernos de IA utilizam embeddings para
 localizar documentos semanticamente semelhantes a uma
 determinada pergunta realizada pelo usuário.

 Este cenário é amplamente utilizado em:

 - RAG (Retrieval Augmented Generation)
 - Chatbots Corporativos
 - Bases de Conhecimento
 - Pesquisa Jurídica
 - Pesquisa Acadêmica
 - Catálogos Técnicos

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos Vetoriais habilitados

 Resultado..:
 - Base documental vetorial
 - Embeddings armazenados no SQL Server
 - Simulação de perguntas
 - Pesquisa semântica
 - Preparação para IA Generativa

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

DROP TABLE IF EXISTS dbo.DocumentosVetoriais;
GO

------------------------------------------------------------------------------
-- Criação da Base Documental
------------------------------------------------------------------------------

CREATE TABLE dbo.DocumentosVetoriais
(
    IdDocumento            INT IDENTITY(1,1)
                           CONSTRAINT PK_DocumentosVetoriais
                           PRIMARY KEY,

    Categoria              VARCHAR(100)
                           NOT NULL,

    Titulo                 VARCHAR(200)
                           NOT NULL,

    Conteudo               VARCHAR(MAX)
                           NOT NULL,

    DataCadastro           DATETIME2
                           NOT NULL
                           DEFAULT GETDATE(),

    Embedding              VECTOR(8)
                           NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção de Conteúdo
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosVetoriais
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
    'Fundamentos do Microsoft SQL Server e administracao.',
    '[0.12,0.23,0.36,0.48,0.57,0.69,0.80,0.92]'
),
(
    'Banco de Dados',
    'Modelagem Relacional',
    'Conceitos de entidades, relacionamentos e normalizacao.',
    '[0.14,0.25,0.37,0.46,0.59,0.71,0.79,0.90]'
),
(
    'Business Intelligence',
    'Power BI para Analistas',
    'Dashboards, indicadores e visualizacao de dados.',
    '[0.51,0.42,0.36,0.28,0.21,0.15,0.09,0.04]'
),
(
    'Cloud',
    'Fundamentos Azure',
    'Servicos de computacao em nuvem da Microsoft.',
    '[0.16,0.29,0.41,0.55,0.64,0.73,0.84,0.95]'
),
(
    'Inteligencia Artificial',
    'Introducao aos Embeddings',
    'Representacao vetorial de informacoes.',
    '[0.10,0.24,0.38,0.50,0.61,0.72,0.85,0.96]'
),
(
    'Inteligencia Artificial',
    'Busca Vetorial',
    'Pesquisa baseada em similaridade semantica.',
    '[0.13,0.26,0.40,0.53,0.62,0.74,0.87,0.98]'
),
(
    'Engenharia de Software',
    'Levantamento de Requisitos',
    'Tecnicas para identificacao de requisitos.',
    '[0.66,0.57,0.49,0.39,0.32,0.23,0.17,0.08]'
);
GO

------------------------------------------------------------------------------
-- Consulta Geral
------------------------------------------------------------------------------

SELECT
    D.IdDocumento,
    D.Categoria,
    D.Titulo,
    D.DataCadastro
FROM dbo.DocumentosVetoriais AS D
ORDER BY
    D.Titulo;
GO

------------------------------------------------------------------------------
-- Simulação de Pergunta do Usuário
------------------------------------------------------------------------------

DECLARE @PerguntaUsuario VECTOR(8);

SET @PerguntaUsuario =
'[
    0.11,
    0.25,
    0.39,
    0.51,
    0.60,
    0.73,
    0.86,
    0.97
]';

SELECT
    @PerguntaUsuario AS EmbeddingPergunta;
GO

------------------------------------------------------------------------------
-- Exemplo de Pesquisa Semântica
------------------------------------------------------------------------------

SELECT
    D.IdDocumento,
    D.Categoria,
    D.Titulo
FROM dbo.DocumentosVetoriais AS D
WHERE D.Categoria =
'Inteligencia Artificial';
GO

------------------------------------------------------------------------------
-- Pesquisa de Conteúdo SQL Server
------------------------------------------------------------------------------

SELECT
    D.IdDocumento,
    D.Categoria,
    D.Titulo
FROM dbo.DocumentosVetoriais AS D
WHERE D.Categoria =
'Banco de Dados';
GO

------------------------------------------------------------------------------
-- Pesquisa Cloud
------------------------------------------------------------------------------

SELECT
    D.IdDocumento,
    D.Categoria,
    D.Titulo
FROM dbo.DocumentosVetoriais AS D
WHERE D.Categoria =
'Cloud';
GO

------------------------------------------------------------------------------
-- Base para Chatbot Corporativo
------------------------------------------------------------------------------

SELECT
    D.Titulo,
    D.Conteudo
FROM dbo.DocumentosVetoriais AS D
WHERE D.Categoria IN
(
    'Banco de Dados',
    'Inteligencia Artificial'
);
GO

------------------------------------------------------------------------------
-- Simulação de Recuperação de Contexto
------------------------------------------------------------------------------

SELECT TOP (3)
    D.Titulo,
    D.Categoria,
    D.Conteudo
FROM dbo.DocumentosVetoriais AS D
ORDER BY
    D.IdDocumento;
GO

------------------------------------------------------------------------------
-- Exportação JSON para IA
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'IdDocumento':D.IdDocumento,
        'Categoria':D.Categoria,
        'Titulo':D.Titulo
    ) AS DocumentoJSON
FROM dbo.DocumentosVetoriais AS D;
GO

------------------------------------------------------------------------------
-- Estatísticas por Categoria
------------------------------------------------------------------------------

SELECT
    D.Categoria,
    COUNT(*) AS Quantidade
FROM dbo.DocumentosVetoriais AS D
GROUP BY
    D.Categoria
ORDER BY
    Quantidade DESC;
GO

------------------------------------------------------------------------------
-- Quantidade Total
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS TotalDocumentos
FROM dbo.DocumentosVetoriais;
GO

------------------------------------------------------------------------------
-- Conteúdo Médio por Categoria
------------------------------------------------------------------------------

SELECT
    Categoria,
    AVG(LEN(Conteudo)) AS TamanhoMedioConteudo
FROM dbo.DocumentosVetoriais
GROUP BY
    Categoria;
GO

------------------------------------------------------------------------------
-- Cenário RAG Completo
--
-- ETAPA 01
-- Usuário envia uma pergunta
--
-- ETAPA 02
-- A pergunta é transformada em embedding
--
-- ETAPA 03
-- SQL Server localiza documentos semelhantes
--
-- ETAPA 04
-- Os documentos são enviados para o LLM
--
-- ETAPA 05
-- O LLM produz a resposta enriquecida
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- Chatbots Corporativos
-- RAG
-- Pesquisa Jurídica
-- Pesquisa Acadêmica
-- Base de Conhecimento
-- FAQ Inteligente
-- Suporte Técnico
-- IA Generativa
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Dividir documentos muito extensos.
--
-- 2) Utilizar chunks menores.
--
-- 3) Manter embeddings atualizados.
--
-- 4) Organizar documentos por domínio.
--
-- 5) Criar processos de reindexação.
--
-- 6) Utilizar metadados para filtros.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estruturas Reais
--
-- VECTOR(384)
-- VECTOR(768)
-- VECTOR(1024)
-- VECTOR(1536)
--
-- Este exemplo utiliza VECTOR(8)
-- exclusivamente para fins didáticos.
------------------------------------------------------------------------------

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