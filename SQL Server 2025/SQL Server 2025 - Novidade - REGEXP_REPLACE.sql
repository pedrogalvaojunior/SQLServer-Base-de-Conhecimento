/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - REGEXP_REPLACE.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função REGEXP_REPLACE()
 para substituição e transformação de dados utilizando
 expressões regulares.

 Contexto...:
 REGEXP_REPLACE() permite localizar padrões em textos
 e substituí-los por outros valores.

 Este recurso é extremamente útil em processos de:

 - ETL
 - Data Quality
 - Integrações
 - Migração de Dados
 - Padronização Cadastral

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Remoção de máscaras
 - Limpeza de caracteres especiais
 - Padronização de dados
 - Transformação de textos
 - Preparação para integrações

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

DROP TABLE IF EXISTS dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.DadosCadastro
(
    IdRegistro          INT IDENTITY(1,1)
                        CONSTRAINT PK_DadosCadastro
                        PRIMARY KEY,

    NomePessoa          VARCHAR(100),

    CPF                 VARCHAR(30),

    CNPJ                VARCHAR(30),

    Telefone            VARCHAR(30),

    CEP                 VARCHAR(20),

    Email               VARCHAR(200)
);
GO

------------------------------------------------------------------------------
-- Inserção de Dados
------------------------------------------------------------------------------

INSERT INTO dbo.DadosCadastro
(
    NomePessoa,
    CPF,
    CNPJ,
    Telefone,
    CEP,
    Email
)
VALUES
(
    'Pedro Antonio Galvao Junior',
    '123.456.789-00',
    '12.345.678/0001-90',
    '(11)99999-9999',
    '18130-000',
    'pedro@email.com.br'
),
(
    'Maria Aparecida',
    '987.654.321-11',
    '98.765.432/0001-10',
    '(15)98888-8888',
    '18050-200',
    'maria@email.com.br'
);
GO

------------------------------------------------------------------------------
-- Visualização Inicial
------------------------------------------------------------------------------

SELECT *
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Removendo Máscara de CPF
------------------------------------------------------------------------------

SELECT
    CPF,

    REGEXP_REPLACE
    (
        CPF,
        '[^0-9]',
        ''
    ) AS CPFLimpo
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Removendo Máscara de CNPJ
------------------------------------------------------------------------------

SELECT
    CNPJ,

    REGEXP_REPLACE
    (
        CNPJ,
        '[^0-9]',
        ''
    ) AS CNPJLimpo
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Removendo Máscara de Telefone
------------------------------------------------------------------------------

SELECT
    Telefone,

    REGEXP_REPLACE
    (
        Telefone,
        '[^0-9]',
        ''
    ) AS TelefoneLimpo
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Removendo Máscara de CEP
------------------------------------------------------------------------------

SELECT
    CEP,

    REGEXP_REPLACE
    (
        CEP,
        '[^0-9]',
        ''
    ) AS CEPLimpo
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Removendo Espaços Duplicados
------------------------------------------------------------------------------

DECLARE @Texto VARCHAR(200);

SET @Texto =
'SQL      Server        2025';

SELECT
    REGEXP_REPLACE
    (
        @Texto,
        '\s+',
        ' '
    ) AS TextoFormatado;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Removendo Caracteres Especiais
------------------------------------------------------------------------------

DECLARE @Descricao VARCHAR(200);

SET @Descricao =
'Produto @#$% Especial!!!';

SELECT
    REGEXP_REPLACE
    (
        @Descricao,
        '[^A-Za-z0-9 ]',
        ''
    ) AS TextoLimpo;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Extraindo Somente Letras
------------------------------------------------------------------------------

DECLARE @Codigo VARCHAR(100);

SET @Codigo =
'ABC123XYZ789';

SELECT
    REGEXP_REPLACE
    (
        @Codigo,
        '[0-9]',
        ''
    ) AS ApenasLetras;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Extraindo Somente Números
------------------------------------------------------------------------------

SELECT
    REGEXP_REPLACE
    (
        @Codigo,
        '[A-Za-z]',
        ''
    ) AS ApenasNumeros;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Substituindo Múltiplos Separadores
------------------------------------------------------------------------------

DECLARE @Lista VARCHAR(100);

SET @Lista =
'SQL;Azure|Power BI/AI';

SELECT
    REGEXP_REPLACE
    (
        @Lista,
        '[;|/]',
        ','
    ) AS ListaPadronizada;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Ocultando Parte do CPF
------------------------------------------------------------------------------

SELECT
    CPF,

    REGEXP_REPLACE
    (
        CPF,
        '^[0-9]{3}',
        '***'
    ) AS CPFMascarado
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Padronizando Caixa Alta
------------------------------------------------------------------------------

DECLARE @TextoCorporativo VARCHAR(100);

SET @TextoCorporativo =
'SQL Server';

SELECT
    UPPER
    (
        REGEXP_REPLACE
        (
            @TextoCorporativo,
            '\s+',
            ' '
        )
    ) AS TextoFinal;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Removendo Tags HTML
------------------------------------------------------------------------------

DECLARE @Html VARCHAR(MAX);

SET @Html =
'<h1>Titulo</h1><p>Conteudo</p>';

SELECT
    REGEXP_REPLACE
    (
        @Html,
        '<[^>]+>',
        ''
    ) AS TextoSemHTML;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Removendo Linhas em Branco
------------------------------------------------------------------------------

DECLARE @Conteudo VARCHAR(MAX);

SET @Conteudo =
'Linha1


Linha2


Linha3';

SELECT
    REGEXP_REPLACE
    (
        @Conteudo,
        '\n+',
        CHAR(10)
    ) AS ConteudoLimpo;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Padronizando Código de Produto
------------------------------------------------------------------------------

DECLARE @Produto VARCHAR(50);

SET @Produto =
'prd-2025-001';

SELECT
    UPPER
    (
        REGEXP_REPLACE
        (
            @Produto,
            '\s+',
            ''
        )
    ) AS CodigoPadronizado;
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Atualização na Tabela
------------------------------------------------------------------------------

UPDATE dbo.DadosCadastro
SET CPF =
    REGEXP_REPLACE
    (
        CPF,
        '[^0-9]',
        ''
    );
GO

------------------------------------------------------------------------------
-- Validação da Atualização
------------------------------------------------------------------------------

SELECT
    IdRegistro,
    NomePessoa,
    CPF
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- ETL
-- Data Warehouse
-- CRM
-- ERP
-- E-commerce
-- APIs REST
-- Data Quality
-- Migração de Sistemas
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Comparação com REPLACE()
--
-- REPLACE remove valores literais.
--
-- REGEXP_REPLACE remove padrões.
------------------------------------------------------------------------------

DECLARE @CPF VARCHAR(20);

SET @CPF = '123.456.789-00';

SELECT
    REPLACE
    (
        REPLACE
        (
            REPLACE
            (
                @CPF,
                '.',
                ''
            ),
            '.',
            ''
        ),
        '-',
        ''
    ) AS MetodoAntigo;
GO

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeRegistros
FROM dbo.DadosCadastro;
GO

------------------------------------------------------------------------------
-- Benefícios do REGEXP_REPLACE
--
-- Menos código
-- Maior flexibilidade
-- Melhor legibilidade
-- Menor manutenção
-- Melhor qualidade de dados
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Documentar padrões complexos.
--
-- 2) Testar desempenho em lote.
--
-- 3) Validar resultados após transformação.
--
-- 4) Evitar regex excessivamente complexas.
--
-- 5) Criar padrões reutilizáveis.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.DadosCadastro;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------