/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - REGEXP_SUBSTR.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função REGEXP_SUBSTR()
 introduzida no SQL Server 2025.

 Contexto...:
 REGEXP_SUBSTR() permite localizar e extrair partes
 específicas de um texto com base em expressões
 regulares.

 Este recurso é extremamente útil em cenários de:

 - ETL
 - Data Quality
 - Integrações
 - APIs
 - Mineração de Texto
 - Inteligência de Negócios

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Extração de e-mails
 - Extração de domínios
 - Extração de DDD
 - Extração de CEP
 - Extração de URLs
 - Extração de hashtags
 - Extração de códigos

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

DROP TABLE IF EXISTS dbo.TextosRegex;
GO

------------------------------------------------------------------------------
-- Tabela de Demonstração
------------------------------------------------------------------------------

CREATE TABLE dbo.TextosRegex
(
    IdRegistro      INT IDENTITY(1,1)
                    CONSTRAINT PK_TextosRegex
                    PRIMARY KEY,

    Conteudo        VARCHAR(500)
                    NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.TextosRegex
(
    Conteudo
)
VALUES
('Contato: pedro@empresa.com.br'),
('Telefone: (11)99999-9999'),
('CEP: 18130-000'),
('Site: https://www.microsoft.com'),
('Curso SQL Server 2025'),
('Produto ABC-2025-001'),
('Hashtags: #sqlserver #azure #fabric');
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT *
FROM dbo.TextosRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Extração de E-mail
------------------------------------------------------------------------------

SELECT
    Conteudo,

    REGEXP_SUBSTR
    (
        Conteudo,
        '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
    ) AS EmailEncontrado
FROM dbo.TextosRegex;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Extração de Domínio
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'pedro@empresa.com.br',
        '@([A-Za-z0-9.-]+\.[A-Za-z]{2,})'
    ) AS Dominio;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Extração de DDD
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        '(11)99999-9999',
        '\([0-9]{2}\)'
    ) AS DDD;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Extração de CEP
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Endereco CEP 18130-000',
        '[0-9]{5}-[0-9]{3}'
    ) AS CEP;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Extração de URL
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Acesse https://www.microsoft.com para detalhes',
        'https?://[^ ]+'
    ) AS URLEncontrada;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Extração de Código de Produto
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Produto ABC-2025-001',
        '[A-Z]{3}-[0-9]{4}-[0-9]{3}'
    ) AS CodigoProduto;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Extração de CPF
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'CPF: 123.456.789-00',
        '[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}'
    ) AS CPF;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Extração de CNPJ
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Empresa 12.345.678/0001-90',
        '[0-9]{2}\.[0-9]{3}\.[0-9]{3}/[0-9]{4}-[0-9]{2}'
    ) AS CNPJ;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Extração de Data
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Reuniao em 17/09/2026',
        '[0-9]{2}/[0-9]{2}/[0-9]{4}'
    ) AS DataEncontrada;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Extração de Hora
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Horario: 19:45',
        '[0-9]{2}:[0-9]{2}'
    ) AS HoraEncontrada;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Extração de Hashtags
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        '#sqlserver #azure #fabric',
        '#[A-Za-z0-9_]+'
    ) AS PrimeiraHashtag;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Extração de Número
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Pedido 123456',
        '[0-9]+'
    ) AS NumeroPedido;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Extração da Primeira Palavra
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'SQL Server 2025',
        '^[A-Za-z]+'
    ) AS PrimeiraPalavra;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Extração de Extensão de Arquivo
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'script_backup.sql',
        '\.[A-Za-z0-9]+$'
    ) AS Extensao;
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Extração de IP
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Servidor 192.168.1.10',
        '[0-9]{1,3}(\.[0-9]{1,3}){3}'
    ) AS EnderecoIP;
GO

------------------------------------------------------------------------------
-- Exemplo 16
-- Extração do Ano
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'SQL Server 2025',
        '[0-9]{4}'
    ) AS Ano;
GO

------------------------------------------------------------------------------
-- Exemplo 17
-- Extração do Nome da Pessoa
------------------------------------------------------------------------------

SELECT
    REGEXP_SUBSTR
    (
        'Nome: Pedro Antonio Galvao Junior',
        '[A-Za-z ]+$'
    ) AS NomeExtraido;
GO

------------------------------------------------------------------------------
-- Exemplo 18
-- Extração em Lote
------------------------------------------------------------------------------

SELECT
    IdRegistro,
    Conteudo,

    REGEXP_SUBSTR
    (
        Conteudo,
        '[0-9]+'
    ) AS PrimeiroNumero
FROM dbo.TextosRegex;
GO

------------------------------------------------------------------------------
-- Comparação com CHARINDEX
------------------------------------------------------------------------------

SELECT
    CHARINDEX
    (
        '@',
        'pedro@empresa.com.br'
    ) AS PosicaoArroba;
GO

------------------------------------------------------------------------------
-- Observação
--
-- CHARINDEX encontra posições.
--
-- REGEXP_SUBSTR extrai padrões completos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- ETL
-- CRM
-- ERP
-- Integrações
-- Mineração de Texto
-- Monitoramento
-- Logs
-- Data Warehouse
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeRegistros
FROM dbo.TextosRegex;
GO

------------------------------------------------------------------------------
-- Benefícios do REGEXP_SUBSTR
--
-- Extração simplificada
-- Menos código
-- Maior produtividade
-- Melhor legibilidade
-- Integração facilitada
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar padrões específicos.
--
-- 2) Documentar expressões complexas.
--
-- 3) Validar resultados obtidos.
--
-- 4) Evitar regex excessivamente genéricas.
--
-- 5) Testar grandes volumes de dados.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.TextosRegex;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------