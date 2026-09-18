/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Arrays JSON Avancados.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar o trabalho com arrays JSON complexos
 utilizando os recursos nativos do SQL Server 2025.

 Contexto...:
 APIs modernas frequentemente utilizam estruturas JSON
 contendo:

 - Arrays Simples
 - Arrays de Objetos
 - Arrays Aninhados
 - Objetos Complexos

 O SQL Server 2025 oferece recursos avançados para
 manipular essas estruturas de forma nativa.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - Arrays JSON simples
 - Arrays de objetos
 - Arrays aninhados
 - OPENJSON
 - JSON_QUERY
 - JSON_PATH_EXISTS
 - Consultas corporativas

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

DROP TABLE IF EXISTS dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Criação da Estrutura
------------------------------------------------------------------------------

CREATE TABLE dbo.PedidosJSON
(
    IdPedido               INT IDENTITY(1,1)
                           CONSTRAINT PK_PedidosJSON
                           PRIMARY KEY,

    Documento              JSON
                           NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Documento Complexo
------------------------------------------------------------------------------

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroPedido":1001,
    "Cliente":
    {
        "Nome":"Pedro Antonio Galvao Junior",
        "Cidade":"Sao Roque",
        "Estado":"SP"
    },
    "Produtos":
    [
        {
            "Codigo":"NOTE001",
            "Descricao":"Notebook Dell",
            "Quantidade":1,
            "Valor":4500.00
        },
        {
            "Codigo":"MOU001",
            "Descricao":"Mouse Logitech",
            "Quantidade":2,
            "Valor":250.00
        }
    ],
    "Pagamentos":
    [
        {
            "Tipo":"Cartao",
            "Valor":4000.00
        },
        {
            "Tipo":"Pix",
            "Valor":1000.00
        }
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Visualizando Documento
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Propriedades Simples
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Objeto Cliente Completo
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Cliente'
    ) AS Cliente
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Nome do Cliente
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Cliente.Nome'
    ) AS NomeCliente
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Array de Produtos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos'
    ) AS Produtos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Primeiro Produto
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[0]'
    ) AS PrimeiroProduto
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Segundo Produto
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[1]'
    ) AS SegundoProduto
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Código do Primeiro Produto
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Produtos[0].Codigo'
    ) AS CodigoProduto
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Descrição do Segundo Produto
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Produtos[1].Descricao'
    ) AS Produto
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Array de Pagamentos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Pagamentos'
    ) AS Pagamentos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Primeiro Pagamento
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Pagamentos[0]'
    ) AS PrimeiroPagamento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Tipo do Primeiro Pagamento
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Pagamentos[0].Tipo'
    ) AS TipoPagamento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- OPENJSON para Produtos
------------------------------------------------------------------------------

SELECT
    P.[key],
    P.value
FROM dbo.PedidosJSON PJ
CROSS APPLY OPENJSON
(
    PJ.Documento,
    '$.Produtos'
) AS P;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- OPENJSON Projetando Colunas
------------------------------------------------------------------------------

SELECT
    Codigo,
    Descricao,
    Quantidade,
    Valor
FROM dbo.PedidosJSON PJ
CROSS APPLY OPENJSON
(
    PJ.Documento,
    '$.Produtos'
)
WITH
(
    Codigo      VARCHAR(20) '$.Codigo',
    Descricao   VARCHAR(100) '$.Descricao',
    Quantidade  INT '$.Quantidade',
    Valor       DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Valor Total dos Produtos
------------------------------------------------------------------------------

SELECT
    SUM(Valor) AS ValorTotal
FROM dbo.PedidosJSON PJ
CROSS APPLY OPENJSON
(
    PJ.Documento,
    '$.Produtos'
)
WITH
(
    Valor DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Quantidade de Produtos
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeProdutos
FROM dbo.PedidosJSON PJ
CROSS APPLY OPENJSON
(
    PJ.Documento,
    '$.Produtos'
);
GO

------------------------------------------------------------------------------
-- Exemplo 16
-- Verificando Existência do Array
------------------------------------------------------------------------------

SELECT
    JSON_PATH_EXISTS
    (
        Documento,
        '$.Produtos'
    ) AS PossuiProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 17
-- JSON_CONTAINS
------------------------------------------------------------------------------

SELECT
    JSON_CONTAINS
    (
        Documento,
        'Notebook Dell',
        '$.Produtos'
    ) AS PossuiNotebook
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 18
-- Estrutura com Arrays Aninhados
------------------------------------------------------------------------------

DECLARE @Documento JSON =
'{
    "Curso":"SQL Server",
    "Modulos":
    [
        {
            "Nome":"Fundamentos",
            "Aulas":
            [
                "Introducao",
                "Instalacao",
                "Configuracao"
            ]
        }
    ]
}';

SELECT
    JSON_QUERY
    (
        @Documento,
        '$.Modulos'
    ) AS Modulos;
GO

------------------------------------------------------------------------------
-- Exemplo 19
-- Primeira Aula
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        @Documento,
        '$.Modulos[0].Aulas[0]'
    ) AS PrimeiraAula;
GO

------------------------------------------------------------------------------
-- Exemplo 20
-- Segunda Aula
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        @Documento,
        '$.Modulos[0].Aulas[1]'
    ) AS SegundaAula;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- E-commerce
-- Marketplace
-- ERP
-- CRM
-- APIs REST
-- Microsserviços
-- Integração B2B
-- Aplicações Mobile
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estruturas Frequentes
--
-- Pedidos
-- Carrinhos
-- Produtos
-- Contratos
-- Eventos
-- Logs
-- Configurações
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Benefícios
--
-- Estruturas flexíveis
-- Menor acoplamento
-- Fácil integração
-- Compatibilidade com APIs
-- Menor necessidade de remodelagem
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar JSON_QUERY() para objetos e arrays.
--
-- 2) Utilizar JSON_VALUE() para propriedades simples.
--
-- 3) Utilizar OPENJSON() para projeção relacional.
--
-- 4) Validar documentos recebidos.
--
-- 5) Criar JSON INDEX para consultas frequentes.
--
-- 6) Evitar documentos excessivamente profundos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.PedidosJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------