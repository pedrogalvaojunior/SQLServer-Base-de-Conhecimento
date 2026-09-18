/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - REGEXP_LIKE.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função REGEXP_LIKE()
 introduzida no SQL Server 2025.

 Contexto...:
 REGEXP_LIKE() permite verificar se um texto atende
 a uma expressão regular.

 É uma evolução significativa em relação ao LIKE e
 PATINDEX(), permitindo validações muito mais precisas.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Validação de e-mails
 - Validação de telefones
 - Validação de CEP
 - Validação de CPF
 - Validação de CNPJ
 - Validação de URLs
 - Validação de códigos

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

DROP TABLE IF EXISTS dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Tabela de Testes
------------------------------------------------------------------------------

CREATE TABLE dbo.ValidacoesRegex
(
    IdRegistro          INT IDENTITY(1,1)
                        CONSTRAINT PK_ValidacoesRegex
                        PRIMARY KEY,

    NomePessoa          VARCHAR(100),

    Email               VARCHAR(200),

    Telefone            VARCHAR(30),

    CEP                 VARCHAR(15),

    CPF                 VARCHAR(20),

    CodigoProduto       VARCHAR(30),

    URLSite             VARCHAR(300)
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.ValidacoesRegex
(
    NomePessoa,
    Email,
    Telefone,
    CEP,
    CPF,
    CodigoProduto,
    URLSite
)
VALUES
(
    'Pedro Antonio Galvao Junior',
    'pedro@email.com.br',
    '(11)99999-9999',
    '18130-000',
    '123.456.789-00',
    'ABC-2025-001',
    'https://www.microsoft.com'
),
(
    'Maria Aparecida',
    'maria@email',
    '(15)98888-8888',
    '18000000',
    '111.222.333-44',
    'XYZ-2025-010',
    'http://empresa.com.br'
),
(
    'Carlos Eduardo',
    'carlos@empresa.com.br',
    '11999999999',
    '13050-200',
    '999.888.777-66',
    'PRD-2024-888',
    'https://portal.empresa.com'
);
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT *
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Validação de E-mail
------------------------------------------------------------------------------

SELECT
    NomePessoa,
    Email,

    REGEXP_LIKE
    (
        Email,
        '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    ) AS EmailValido
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Retornando Apenas E-mails Válidos
------------------------------------------------------------------------------

SELECT
    NomePessoa,
    Email
FROM dbo.ValidacoesRegex
WHERE REGEXP_LIKE
(
    Email,
    '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
);
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Telefones Celulares
------------------------------------------------------------------------------

SELECT
    NomePessoa,
    Telefone,

    REGEXP_LIKE
    (
        Telefone,
        '^\([0-9]{2}\)[0-9]{5}-[0-9]{4}$'
    ) AS TelefoneValido
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- CEP Brasileiro
------------------------------------------------------------------------------

SELECT
    NomePessoa,
    CEP,

    REGEXP_LIKE
    (
        CEP,
        '^[0-9]{5}-[0-9]{3}$'
    ) AS CEPValido
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- CPF Formatado
------------------------------------------------------------------------------

SELECT
    NomePessoa,
    CPF,

    REGEXP_LIKE
    (
        CPF,
        '^[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}$'
    ) AS CPFValido
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Código de Produto
------------------------------------------------------------------------------

SELECT
    CodigoProduto,

    REGEXP_LIKE
    (
        CodigoProduto,
        '^[A-Z]{3}-[0-9]{4}-[0-9]{3}$'
    ) AS CodigoValido
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- URL HTTP ou HTTPS
------------------------------------------------------------------------------

SELECT
    URLSite,

    REGEXP_LIKE
    (
        URLSite,
        '^https?://.*'
    ) AS URLValida
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- CNPJ Formatado
------------------------------------------------------------------------------

DECLARE @Empresas TABLE
(
    CNPJ VARCHAR(30)
);

INSERT INTO @Empresas
VALUES
('12.345.678/0001-90'),
('11222333000144'),
('98.765.432/0001-10');

SELECT
    CNPJ,

    REGEXP_LIKE
    (
        CNPJ,
        '^[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}$'
    ) AS CNPJValido
FROM @Empresas;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Somente Números
------------------------------------------------------------------------------

DECLARE @Valores TABLE
(
    Valor VARCHAR(50)
);

INSERT INTO @Valores
VALUES
('12345'),
('ABC123'),
('99999');

SELECT
    Valor,

    REGEXP_LIKE
    (
        Valor,
        '^[0-9]+$'
    ) AS ApenasNumeros
FROM @Valores;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Somente Letras
------------------------------------------------------------------------------

DECLARE @Nomes TABLE
(
    Nome VARCHAR(100)
);

INSERT INTO @Nomes
VALUES
('Pedro'),
('Maria'),
('Pedro123');

SELECT
    Nome,

    REGEXP_LIKE
    (
        Nome,
        '^[A-Za-z]+$'
    ) AS ApenasLetras
FROM @Nomes;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Senha Forte
------------------------------------------------------------------------------

DECLARE @Senhas TABLE
(
    Senha VARCHAR(50)
);

INSERT INTO @Senhas
VALUES
('abc123'),
('Senha@2025'),
('123456');

SELECT
    Senha,

    REGEXP_LIKE
    (
        Senha,
        '^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$'
    ) AS SenhaForte
FROM @Senhas;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Placas Mercosul
------------------------------------------------------------------------------

DECLARE @Placas TABLE
(
    Placa VARCHAR(20)
);

INSERT INTO @Placas
VALUES
('BRA2E19'),
('ABC1234'),
('XYZ9A88');

SELECT
    Placa,

    REGEXP_LIKE
    (
        Placa,
        '^[A-Z]{3}[0-9][A-Z][0-9]{2}$'
    ) AS PlacaMercosul
FROM @Placas;
GO

------------------------------------------------------------------------------
-- Comparação com LIKE
------------------------------------------------------------------------------

SELECT
    Email
FROM dbo.ValidacoesRegex
WHERE Email LIKE '%@%';
GO

------------------------------------------------------------------------------
-- Observação
--
-- LIKE encontra o caractere.
--
-- REGEXP_LIKE valida a estrutura completa.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- CRM
-- ERP
-- E-commerce
-- ETL
-- APIs REST
-- Integrações
-- Data Quality
-- Cadastro de Clientes
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeRegistros
FROM dbo.ValidacoesRegex;
GO

------------------------------------------------------------------------------
-- Benefícios do REGEXP_LIKE
--
-- Validação avançada
-- Menos código
-- Melhor qualidade dos dados
-- Regras mais precisas
-- Maior legibilidade
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar padrões simples sempre que possível.
--
-- 2) Documentar expressões complexas.
--
-- 3) Testar desempenho em grandes volumes.
--
-- 4) Centralizar expressões reutilizadas.
--
-- 5) Utilizar âncoras (^ e $) para validações.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ValidacoesRegex;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------