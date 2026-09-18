/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Consultando Propriedades JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar técnicas de consulta de propriedades
 armazenadas em documentos JSON.

 Contexto...:
 Após armazenar documentos JSON, uma das principais
 necessidades é extrair informações específicas para
 consultas, relatórios e integrações.

 Este exemplo apresenta a utilização das funções
 JSON_VALUE() e JSON_QUERY() para acessar atributos
 simples, objetos aninhados e arrays.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Consultas de propriedades simples
 - Consultas de objetos aninhados
 - Recuperação de arrays
 - Filtros baseados em propriedades JSON
 - Projeção relacional dos dados

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

DROP TABLE IF EXISTS dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.ClientesJSON
(
    IdCliente          INT IDENTITY(1,1)
                       CONSTRAINT PK_ClientesJSON
                       PRIMARY KEY,

    DataCadastro       DATETIME2
                       NOT NULL
                       DEFAULT GETDATE(),

    Documento          JSON
                       NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção de Dados
------------------------------------------------------------------------------

INSERT INTO dbo.ClientesJSON
(
    Documento
)
VALUES
(
'{
    "Codigo":1,
    "Nome":"Pedro Antonio Galvao Junior",

    "Contato":
    {
        "Email":"pedro@email.com.br",
        "Telefone":"(11)99999-9999"
    },

    "Endereco":
    {
        "Cidade":"Sao Roque",
        "Estado":"SP"
    },

    "Cursos":
    [
        "SQL Server",
        "Power BI",
        "Azure"
    ]
}'
);
GO

INSERT INTO dbo.ClientesJSON
(
    Documento
)
VALUES
(
'{
    "Codigo":2,
    "Nome":"Maria Aparecida",

    "Contato":
    {
        "Email":"maria@email.com.br",
        "Telefone":"(15)98888-8888"
    },

    "Endereco":
    {
        "Cidade":"Sorocaba",
        "Estado":"SP"
    },

    "Cursos":
    [
        "Excel",
        "Power BI"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Consulta Completa dos Documentos
------------------------------------------------------------------------------

SELECT
    CJ.IdCliente,
    CJ.Documento
FROM dbo.ClientesJSON AS CJ
ORDER BY
    CJ.IdCliente;
GO

------------------------------------------------------------------------------
-- Consultando Propriedades Simples
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Codigo'
    ) AS Codigo,

    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Consultando Dados de Contato
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome,

    JSON_VALUE
    (
        Documento,
        '$.Contato.Email'
    ) AS Email,

    JSON_VALUE
    (
        Documento,
        '$.Contato.Telefone'
    ) AS Telefone
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Consultando Dados de Endereço
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome,

    JSON_VALUE
    (
        Documento,
        '$.Endereco.Cidade'
    ) AS Cidade,

    JSON_VALUE
    (
        Documento,
        '$.Endereco.Estado'
    ) AS Estado
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Consultando um Objeto Completo
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome,

    JSON_QUERY
    (
        Documento,
        '$.Endereco'
    ) AS Endereco
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Consultando um Array Completo
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome,

    JSON_QUERY
    (
        Documento,
        '$.Cursos'
    ) AS Cursos
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Filtro por Cidade
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome,

    JSON_VALUE
    (
        Documento,
        '$.Endereco.Cidade'
    ) AS Cidade
FROM dbo.ClientesJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Endereco.Cidade'
) = 'Sao Roque';
GO

------------------------------------------------------------------------------
-- Filtro por Estado
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Endereco.Estado'
) = 'SP';
GO

------------------------------------------------------------------------------
-- Ordenação por Nome
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Codigo'
    ) AS Codigo,

    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
ORDER BY
    Nome;
GO

------------------------------------------------------------------------------
-- Projeção Relacional
------------------------------------------------------------------------------

SELECT
    CJ.IdCliente,

    JSON_VALUE
    (
        CJ.Documento,
        '$.Codigo'
    ) AS Codigo,

    JSON_VALUE
    (
        CJ.Documento,
        '$.Nome'
    ) AS Nome,

    JSON_VALUE
    (
        CJ.Documento,
        '$.Contato.Email'
    ) AS Email,

    JSON_VALUE
    (
        CJ.Documento,
        '$.Endereco.Cidade'
    ) AS Cidade
FROM dbo.ClientesJSON AS CJ
ORDER BY
    CJ.IdCliente;
GO

------------------------------------------------------------------------------
-- Consultando Campos Inexistentes
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Contato.LinkedIn'
    ) AS LinkedIn
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Resultado Esperado
--
-- A função retorna NULL quando o caminho não existe.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Utilizando JSON_PATH_EXISTS
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
WHERE JSON_PATH_EXISTS
(
    Documento,
    '$.Contato.Email'
) = 1;
GO

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS TotalClientes
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- CRM
-- ERP
-- E-commerce
-- APIs REST
-- Catálogo de Produtos
-- Cadastro de Clientes
-- Metadata Management
-- Integrações B2B
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilize JSON_VALUE() para propriedades escalares.
--
-- 2) Utilize JSON_QUERY() para objetos e arrays.
--
-- 3) Valide caminhos utilizando JSON_PATH_EXISTS().
--
-- 4) Evite repetir extrações complexas em consultas
--    de alto volume.
--
-- 5) Considere a utilização de índices JSON para
--    propriedades frequentemente consultadas.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ClientesJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------