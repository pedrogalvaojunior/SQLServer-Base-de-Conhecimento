/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - REGEXP_COUNT.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função REGEXP_COUNT()
 introduzida no SQL Server 2025.

 Contexto...:
 REGEXP_COUNT() permite contar a quantidade de
 ocorrências de um padrão dentro de um texto.

 Este recurso é útil para:

 - Qualidade de Dados
 - Data Quality
 - Mineração de Texto
 - ETL
 - Análise de Logs
 - Inteligência de Negócios

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Contagem de palavras
 - Contagem de números
 - Contagem de e-mails
 - Contagem de hashtags
 - Contagem de URLs
 - Métricas textuais

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.AnaliseTextual
(
    IdTexto        INT IDENTITY(1,1)
                   CONSTRAINT PK_AnaliseTextual
                   PRIMARY KEY,

    Conteudo       VARCHAR(MAX)
                   NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.AnaliseTextual
(
    Conteudo
)
VALUES
(
'SQL Server 2025 possui diversas novidades.'
),
(
'Contato: pedro@empresa.com.br suporte@empresa.com.br'
),
(
'#sqlserver #azure #fabric #data'
),
(
'Acesse https://empresa.com e https://portal.com'
),
(
'Pedido 1001 Pedido 1002 Pedido 1003'
);
GO

------------------------------------------------------------------------------
-- Visualização Inicial
------------------------------------------------------------------------------

SELECT
    AT.IdTexto,
    AT.Conteudo
FROM dbo.AnaliseTextual AS AT;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Contando Dígitos
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '[0-9]'
    ) AS QuantidadeDigitos
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Contando Letras
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '[A-Za-z]'
    ) AS QuantidadeLetras
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Contando Palavras
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '[A-Za-z]+'
    ) AS QuantidadePalavras
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Contagem de E-mails
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
    ) AS QuantidadeEmails
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Contagem de Hashtags
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '#[A-Za-z0-9_]+'
    ) AS QuantidadeHashtags
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Contagem de URLs
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        'https?://[^ ]+'
    ) AS QuantidadeURLs
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Contagem de Espaços
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        '\s'
    ) AS QuantidadeEspacos
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Contagem de Pedidos
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_COUNT
    (
        Conteudo,
        'Pedido'
    ) AS QuantidadePedidos
FROM dbo.AnaliseTextual;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Contagem de Anos
------------------------------------------------------------------------------

SELECT
    REGEXP_COUNT
    (
        'SQL Server 2025 e SQL Server 2026',
        '[0-9]{4}'
    ) AS QuantidadeAnos;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Contagem de CEPs
------------------------------------------------------------------------------

SELECT
    REGEXP_COUNT
    (
        '18130-000 18050-200 13050-100',
        '[0-9]{5}-[0-9]{3}'
    ) AS QuantidadeCEP;
GO

----------------