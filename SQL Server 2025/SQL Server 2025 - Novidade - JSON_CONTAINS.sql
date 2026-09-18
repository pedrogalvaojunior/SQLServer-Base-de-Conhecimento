/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - JSON_CONTAINS.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função JSON_CONTAINS()
 introduzida no SQL Server 2025.

 Contexto...:
 A função JSON_CONTAINS() permite verificar se um
 determinado valor está presente dentro de um documento
 JSON.

 Sua utilização simplifica consultas sobre arrays,
 objetos e propriedades JSON, tornando o código mais
 legível e eficiente.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - Pesquisa em arrays JSON
 - Pesquisa em objetos JSON
 - Filtros JSON simplificados
 - Integração com consultas T-SQL

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
    IdCliente              INT IDENTITY(1,1)
                           CONSTRAINT PK_ClientesJSON
                           PRIMARY KEY,

    Documento              JSON
                           NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.ClientesJSON
(
    Documento
)
VALUES
(
'{
    "Nome":"Pedro Antonio Galvao Junior",
    "Cidade":"Sao Roque",
    "Cursos":
    [
        "SQL Server",
        "Azure",
        "Power BI"
    ]
}'
),
(
'{
    "Nome":"Maria Aparecida",
    "Cidade":"Sorocaba",
    "Cursos":
    [
        "Excel",
        "Power BI"
    ]
}'
),
(
'{
    "Nome":"Carlos Eduardo",
    "Cidade":"Jundiai",
    "Cursos":
    [
        "Python",
        "Azure",
        "GitHub"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT
    C.IdCliente,
    C.Documento
FROM dbo.ClientesJSON AS C;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Verificando Existência de Curso
------------------------------------------------------------------------------

SELECT
    C.IdCliente
FROM dbo.ClientesJSON AS C
WHERE JSON_CONTAINS
(
    C.Documento,
    'SQL Server',
    '$.Cursos'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Clientes que Possuem Azure
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Azure',
    '$.Cursos'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Clientes que Possuem Power BI
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Power BI',
    '$.Cursos'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Verificando Cidade
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Nome'
    ) AS Nome
FROM dbo.ClientesJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Sorocaba',
    '$.Cidade'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Verificando Nome do Cliente
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.ClientesJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Pedro Antonio Galvao Junior',
    '$.Nome'
) = 1;
GO

------------------------------------------------------------------------------
-- Ambiente Corporativo
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.PedidosJSON;
GO

CREATE TABLE dbo.PedidosJSON
(
    IdPedido            INT IDENTITY(1,1)
                        CONSTRAINT PK_PedidosJSON
                        PRIMARY KEY,

    Documento           JSON
                        NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Pedidos
------------------------------------------------------------------------------

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroPedido":1001,
    "Status":"Aprovado",
    "Produtos":
    [
        "Notebook",
        "Mouse"
    ]
}'
),
(
'{
    "NumeroPedido":1002,
    "Status":"Pendente",
    "Produtos":
    [
        "Monitor",
        "Teclado"
    ]
}'
),
(
'{
    "NumeroPedido":1003,
    "Status":"Faturado",
    "Produtos":
    [
        "Notebook",
        "Monitor"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Pedidos que Contêm Notebook
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido
FROM dbo.PedidosJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Notebook',
    '$.Produtos'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Pedidos que Contêm Monitor
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido
FROM dbo.PedidosJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Monitor',
    '$.Produtos'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Verificando Status
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido
FROM dbo.PedidosJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Aprovado',
    '$.Status'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Utilização com CASE
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    CASE
        WHEN JSON_CONTAINS
        (
            Documento,
            'Notebook',
            '$.Produtos'
        ) = 1
        THEN 'SIM'
        ELSE 'NAO'
    END AS PossuiNotebook
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Utilização com COUNT
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadePedidosNotebook
FROM dbo.PedidosJSON
WHERE JSON_CONTAINS
(
    Documento,
    'Notebook',
    '$.Produtos'
) = 1;
GO

------------------------------------------------------------------------------
-- Comparação com OPENJSON
------------------------------------------------------------------------------

/*

Método Tradicional

OPENJSON(...)
+
JOIN
+
Filtro

Método Moderno

JSON_CONTAINS(...)

*/

------------------------------------------------------------------------------
-- Vantagens
--
-- Código mais simples.
-- Melhor legibilidade.
-- Menos processamento.
-- Maior produtividade.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- ERP
-- CRM
-- E-commerce
-- APIs REST
-- Controle de Permissões
-- Catálogo de Produtos
-- Configurações de Sistemas
-- Preferências de Usuários
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar JSON_CONTAINS() para pesquisas simples.
--
-- 2) Criar JSON INDEX quando apropriado.
--
-- 3) Definir caminhos JSON específicos.
--
-- 4) Padronizar estruturas JSON.
--
-- 5) Evitar documentos excessivamente grandes.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeClientes
FROM dbo.ClientesJSON;
GO

SELECT
    COUNT(*) AS QuantidadePedidos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ClientesJSON;
GO

DROP TABLE dbo.PedidosJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------