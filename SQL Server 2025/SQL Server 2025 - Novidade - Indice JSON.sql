/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Indice JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a criação e utilização de índices JSON
 nativos introduzidos no SQL Server 2025.

 Contexto...:
 Um dos desafios da utilização de documentos JSON em
 grandes volumes é a necessidade de localizar valores
 específicos dentro dos documentos.

 O SQL Server 2025 introduz o comando CREATE JSON INDEX,
 permitindo indexar propriedades específicas de um
 documento JSON e melhorar significativamente o
 desempenho das consultas.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - Criação de índice JSON
 - Consultas utilizando propriedades indexadas
 - Cenários corporativos de pesquisa
 - Demonstração prática

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
    IdPedido             INT IDENTITY(1,1)
                         CONSTRAINT PK_PedidosJSON
                         PRIMARY KEY,

    DataInclusao         DATETIME2
                         NOT NULL
                         DEFAULT GETDATE(),

    Documento            JSON
                         NOT NULL
);
GO

------------------------------------------------------------------------------
-- Estrutura da Tabela
------------------------------------------------------------------------------

EXEC sp_help 'dbo.PedidosJSON';
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
    "Estado":"SP",
    "Valor":1500.00,
    "Status":"Pendente"
}'
),
(
'{
    "NumeroPedido":1002,
    "Cliente":"Maria Aparecida",
    "Cidade":"Sorocaba",
    "Estado":"SP",
    "Valor":2500.00,
    "Status":"Aprovado"
}'
),
(
'{
    "NumeroPedido":1003,
    "Cliente":"Carlos Eduardo",
    "Cidade":"Jundiai",
    "Estado":"SP",
    "Valor":3800.00,
    "Status":"Faturado"
}'
),
(
'{
    "NumeroPedido":1004,
    "Cliente":"Ana Paula",
    "Cidade":"Campinas",
    "Estado":"SP",
    "Valor":4200.00,
    "Status":"Aprovado"
}'
);
GO

------------------------------------------------------------------------------
-- Consulta Inicial
------------------------------------------------------------------------------

SELECT
    P.IdPedido,
    P.Documento
FROM dbo.PedidosJSON AS P;
GO

------------------------------------------------------------------------------
-- Consulta Sem Índice
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
-- Plano de Execução
--
-- Habilite o plano de execução real no SSMS para
-- comparação antes e depois da criação do índice.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Criação do Índice JSON
------------------------------------------------------------------------------

CREATE JSON INDEX IX_PedidosJSON
ON dbo.PedidosJSON (Documento)
FOR
(
    '$.NumeroPedido',
    '$.Cliente',
    '$.Cidade',
    '$.Estado',
    '$.Status',
    '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Verificando Índices
------------------------------------------------------------------------------

SELECT
    I.name,
    I.type_desc
FROM sys.indexes AS I
WHERE I.object_id = OBJECT_ID('dbo.PedidosJSON');
GO

------------------------------------------------------------------------------
-- Consulta Utilizando Campos Indexados
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
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Documento,
        '$.Cidade'
    ) AS Cidade
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Cidade'
) = 'Sorocaba';
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
        '$.Status'
    ) AS Status
FROM dbo.PedidosJSON
WHERE JSON_VALUE
(
    Documento,
    '$.Status'
) = 'Faturado';
GO

------------------------------------------------------------------------------
-- Pesquisa por Valor
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
WHERE CAST
(
    JSON_VALUE
    (
        Documento,
        '$.Valor'
    )
    AS DECIMAL(10,2)
) > 3000;
GO

------------------------------------------------------------------------------
-- Cenário Corporativo
-- Relatório de Pedidos Aprovados
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
    ) AS Valor,

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
) = 'Aprovado'
ORDER BY
    Cliente;
GO

------------------------------------------------------------------------------
-- Estatísticas do Ambiente
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadePedidos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Índices do Objeto
------------------------------------------------------------------------------

EXEC sp_helpindex 'dbo.PedidosJSON';
GO

------------------------------------------------------------------------------
-- Limitações Importantes
--
-- 1) O índice JSON é criado sobre uma coluna JSON.
--
-- 2) Apenas caminhos definidos no FOR são indexados.
--
-- 3) Deve-se indexar apenas propriedades consultadas
--    frequentemente.
--
-- 4) Muitos caminhos indexados aumentam custo de
--    manutenção durante INSERT e UPDATE.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Indexar propriedades utilizadas em filtros.
--
-- 2) Indexar propriedades utilizadas em JOINs.
--
-- 3) Monitorar seletividade das propriedades.
--
-- 4) Evitar indexar caminhos pouco utilizados.
--
-- 5) Revisar índices periodicamente.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Exemplo de Estrutura Utilizada
------------------------------------------------------------------------------

/*

{
    "NumeroPedido":1001,
    "Cliente":"Pedro Antonio Galvao Junior",
    "Cidade":"Sao Roque",
    "Estado":"SP",
    "Valor":1500.00,
    "Status":"Pendente"
}

*/

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