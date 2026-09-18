/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Pesquisa de Pedidos com JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar consultas corporativas sobre documentos
 JSON armazenados utilizando o tipo de dados JSON
 nativo do SQL Server 2025.

 Contexto...:
 Sistemas ERP, CRM, E-commerce e plataformas de
 integração costumam armazenar documentos JSON para
 representar pedidos, contratos, eventos e mensagens.

 Este exemplo demonstra filtros, ordenações,
 agrupamentos e extração de propriedades de documentos
 JSON.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Pesquisa de pedidos
 - Consultas por cliente
 - Consultas por período
 - Consultas por status
 - Agregações
 - Relatórios operacionais

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
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.PedidosJSON
(
    IdPedido          INT IDENTITY(1,1)
                      CONSTRAINT PK_PedidosJSON
                      PRIMARY KEY,

    DataCarga         DATETIME2
                      NOT NULL
                      DEFAULT GETDATE(),

    Documento         JSON
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Carga de Dados
------------------------------------------------------------------------------

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroPedido":1001,
    "Cliente":"Pedro Antonio Galvao Junior",
    "Cidade":"Sao Roque",
    "DataPedido":"2026-09-10",
    "Valor":1500.00,
    "Status":"Pendente"
}'
),
(
'{
    "NumeroPedido":1002,
    "Cliente":"Maria Aparecida",
    "Cidade":"Sorocaba",
    "DataPedido":"2026-09-11",
    "Valor":2500.00,
    "Status":"Aprovado"
}'
),
(
'{
    "NumeroPedido":1003,
    "Cliente":"Carlos Eduardo",
    "Cidade":"Jundiai",
    "DataPedido":"2026-09-12",
    "Valor":3800.00,
    "Status":"Faturado"
}'
),
(
'{
    "NumeroPedido":1004,
    "Cliente":"Ana Paula",
    "Cidade":"Campinas",
    "DataPedido":"2026-09-12",
    "Valor":4200.00,
    "Status":"Aprovado"
}'
),
(
'{
    "NumeroPedido":1005,
    "Cliente":"Pedro Antonio Galvao Junior",
    "Cidade":"Sao Roque",
    "DataPedido":"2026-09-15",
    "Valor":750.00,
    "Status":"Pendente"
}'
);
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT
    P.IdPedido,
    P.Documento
FROM dbo.PedidosJSON AS P;
GO

------------------------------------------------------------------------------
-- Consulta Relacional dos Documentos
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Cidade'
    ) AS Cidade,

    JSON_VALUE
    (
        Documento,
        '$.DataPedido'
    ) AS DataPedido,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS Valor,

    JSON_VALUE
    (
        Documento,
        '$.Status'
    ) AS Status
FROM dbo.PedidosJSON
ORDER BY
    NumeroPedido;
GO

------------------------------------------------------------------------------
-- Pesquisa por Cliente
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS Valor
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Cliente'
) = 'Pedro Antonio Galvao Junior';
GO

------------------------------------------------------------------------------
-- Pesquisa por Cidade
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Cidade'
) = 'Sao Roque';
GO

------------------------------------------------------------------------------
-- Pesquisa por Status
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Status'
    ) AS Status
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Status'
) = 'Aprovado';
GO

------------------------------------------------------------------------------
-- Pedidos com Valor Superior a R$ 2.000,00
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS Valor
FROM dbo.PedidosJSON
WHERE CAST
(
    JSON_VALUE
    (
        Documento,
        '$.Valor'
    )
    AS DECIMAL(12,2)
) > 2000.00;
GO

------------------------------------------------------------------------------
-- Relatório de Pedidos Pendentes
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS Valor
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Status'
) = 'Pendente'
ORDER BY
    Cliente;
GO

------------------------------------------------------------------------------
-- Total de Pedidos por Status
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Status'
    ) AS Status,

    COUNT(*) AS Quantidade
FROM dbo.PedidosJSON
GROUP BY
    JSON_VALUE
    (
        Documento,
        '$.Status'
    )
ORDER BY
    Status;
GO

------------------------------------------------------------------------------
-- Valor Total por Status
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Status'
    ) AS Status,

    SUM
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS ValorTotal
FROM dbo.PedidosJSON
GROUP BY
    JSON_VALUE
    (
        Documento,
        '$.Status'
    );
GO

------------------------------------------------------------------------------
-- Média dos Pedidos
------------------------------------------------------------------------------

SELECT
    AVG
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS ValorMedio
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Maior Pedido
------------------------------------------------------------------------------

SELECT TOP (1)
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS Valor
FROM dbo.PedidosJSON
ORDER BY
    CAST
    (
        JSON_VALUE
        (
            Documento,
            '$.Valor'
        )
        AS DECIMAL(12,2)
    ) DESC;
GO

------------------------------------------------------------------------------
-- Total de Vendas por Cliente
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    ) AS Cliente,

    SUM
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS TotalComprado
FROM dbo.PedidosJSON
GROUP BY
    JSON_VALUE
    (
        Documento,
        '$.Cliente'
    )
ORDER BY
    TotalComprado DESC;
GO

------------------------------------------------------------------------------
-- Pedidos Entre Datas
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.NumeroPedido'
    ) AS NumeroPedido,

    JSON_VALUE
    (
        Documento,
        '$.DataPedido'
    ) AS DataPedido
FROM dbo.PedidosJSON
WHERE CAST
(
    JSON_VALUE
    (
        Documento,
        '$.DataPedido'
    )
    AS DATE
)
BETWEEN
    '2026-09-11'
AND
    '2026-09-13';
GO

------------------------------------------------------------------------------
-- Estatísticas Gerais
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadePedidos,

    SUM
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS ValorTotalPedidos,

    MIN
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS MenorPedido,

    MAX
    (
        CAST
        (
            JSON_VALUE
            (
                Documento,
                '$.Valor'
            )
            AS DECIMAL(12,2)
        )
    ) AS MaiorPedido
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- ERP
-- CRM
-- E-commerce
-- Marketplaces
-- Integrações B2B
-- APIs REST
-- Auditoria
-- Data Lake
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar JSON_VALUE() para filtros.
--
-- 2) Aplicar JSON_PATH_EXISTS() quando houver campos
--    opcionais.
--
-- 3) Criar JSON INDEX para propriedades frequentemente
--    pesquisadas.
--
-- 4) Converter tipos numéricos antes de agregações.
--
-- 5) Monitorar desempenho das consultas recorrentes.
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