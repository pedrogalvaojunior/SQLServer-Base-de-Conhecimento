/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - JSON_PATH_EXISTS.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função JSON_PATH_EXISTS()
 para validar a existência de propriedades em
 documentos JSON.

 Contexto...:
 Em aplicações modernas, nem todos os documentos JSON
 possuem exatamente a mesma estrutura.

 Em cenários de APIs, microsserviços, Data Lake,
 integrações e processamento de eventos, a verificação
 da existência de atributos é extremamente importante.

 A função JSON_PATH_EXISTS() permite verificar
 rapidamente se um determinado caminho existe
 dentro de um documento JSON.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Validação de caminhos JSON
 - Filtros utilizando JSON_PATH_EXISTS()
 - Constraints utilizando JSON_PATH_EXISTS()
 - Cenários corporativos

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

DROP TABLE IF EXISTS dbo.EventosJSON;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.EventosJSON
(
    IdEvento          INT IDENTITY(1,1)
                      CONSTRAINT PK_EventosJSON
                      PRIMARY KEY,

    DataRecebimento   DATETIME2
                      NOT NULL
                      DEFAULT GETDATE(),

    Payload           JSON
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção de Evento Completo
------------------------------------------------------------------------------

INSERT INTO dbo.EventosJSON
(
    Payload
)
VALUES
(
'{
    "IdPedido":1001,
    "Cliente":"Pedro Antonio Galvao Junior",
    "Valor":2500.00,

    "Entrega":
    {
        "Cidade":"Sao Roque",
        "Estado":"SP"
    }
}'
);
GO

------------------------------------------------------------------------------
-- Inserção de Evento Sem Entrega
------------------------------------------------------------------------------

INSERT INTO dbo.EventosJSON
(
    Payload
)
VALUES
(
'{
    "IdPedido":1002,
    "Cliente":"Maria Aparecida",
    "Valor":1500.00
}'
);
GO

------------------------------------------------------------------------------
-- Inserção de Evento Completo
------------------------------------------------------------------------------

INSERT INTO dbo.EventosJSON
(
    Payload
)
VALUES
(
'{
    "IdPedido":1003,
    "Cliente":"Carlos Eduardo",
    "Valor":3200.00,

    "Entrega":
    {
        "Cidade":"Sorocaba",
        "Estado":"SP"
    }
}'
);
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT
    EJ.IdEvento,
    EJ.Payload
FROM dbo.EventosJSON AS EJ;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Verificando Existência da Entrega
------------------------------------------------------------------------------

SELECT
    EJ.IdEvento,
    JSON_PATH_EXISTS
    (
        EJ.Payload,
        '$.Entrega'
    ) AS PossuiEntrega
FROM dbo.EventosJSON AS EJ;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Filtrando Apenas Pedidos com Entrega
------------------------------------------------------------------------------

SELECT
    EJ.IdEvento,
    JSON_VALUE
    (
        EJ.Payload,
        '$.Cliente'
    ) AS Cliente
FROM dbo.EventosJSON AS EJ
WHERE JSON_PATH_EXISTS
(
    EJ.Payload,
    '$.Entrega'
) = 1;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Filtrando Pedidos Sem Entrega
------------------------------------------------------------------------------

SELECT
    EJ.IdEvento,
    JSON_VALUE
    (
        EJ.Payload,
        '$.Cliente'
    ) AS Cliente
FROM dbo.EventosJSON AS EJ
WHERE JSON_PATH_EXISTS
(
    EJ.Payload,
    '$.Entrega'
) = 0;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Verificando Cidade da Entrega
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Payload,
        '$.Cliente'
    ) AS Cliente,

    JSON_PATH_EXISTS
    (
        Payload,
        '$.Entrega.Cidade'
    ) AS PossuiCidade
FROM dbo.EventosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Verificando Estado
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Payload,
        '$.Cliente'
    ) AS Cliente,

    JSON_PATH_EXISTS
    (
        Payload,
        '$.Entrega.Estado'
    ) AS PossuiEstado
FROM dbo.EventosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Estrutura Mais Complexa
------------------------------------------------------------------------------

DECLARE @Pedido JSON =
'
{
    "Pedido":
    {
        "Numero":5001,
        "Itens":
        [
            {
                "Produto":"Notebook"
            },
            {
                "Produto":"Mouse"
            }
        ]
    }
}
';
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Testando Caminhos Diversos
------------------------------------------------------------------------------

DECLARE @Documento JSON;

SET @Documento =
'
{
    "Cliente":
    {
        "Nome":"Pedro",
        "Email":"pedro@email.com.br"
    }
}
';

SELECT
    JSON_PATH_EXISTS
    (
        @Documento,
        '$.Cliente'
    ) AS CaminhoCliente,

    JSON_PATH_EXISTS
    (
        @Documento,
        '$.Cliente.Email'
    ) AS CaminhoEmail,

    JSON_PATH_EXISTS
    (
        @Documento,
        '$.Cliente.Telefone'
    ) AS CaminhoTelefone;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Utilizando CHECK Constraint
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.ContratosJSON;
GO

CREATE TABLE dbo.ContratosJSON
(
    IdContrato     INT IDENTITY(1,1),

    Documento      JSON NOT NULL,

    CONSTRAINT CK_ContratosJSON_Assinatura
    CHECK
    (
        JSON_PATH_EXISTS
        (
            Documento,
            '$.DataAssinatura'
        ) = 1
    )
);
GO

------------------------------------------------------------------------------
-- Inserção Válida
------------------------------------------------------------------------------

INSERT INTO dbo.ContratosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroContrato":"CTR-2026-001",
    "DataAssinatura":"2026-09-17"
}'
);
GO

------------------------------------------------------------------------------
-- Inserção Inválida
--
-- Descomente para testar
------------------------------------------------------------------------------

/*

INSERT INTO dbo.ContratosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroContrato":"CTR-2026-002"
}'
);
GO

*/

------------------------------------------------------------------------------
-- Exemplo 09
-- Localizando Eventos com Cidade Informada
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Payload,
        '$.Cliente'
    ) AS Cliente,

    JSON_VALUE
    (
        Payload,
        '$.Entrega.Cidade'
    ) AS Cidade
FROM dbo.EventosJSON
WHERE JSON_PATH_EXISTS
(
    Payload,
    '$.Entrega.Cidade'
) = 1;
GO

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS TotalEventos
FROM dbo.EventosJSON;
GO

SELECT
    COUNT(*) AS EventosComEntrega
FROM dbo.EventosJSON
WHERE JSON_PATH_EXISTS
(
    Payload,
    '$.Entrega'
) = 1;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- APIs REST
-- Integrações ERP
-- Contratos Eletrônicos
-- Pedidos de E-commerce
-- Eventos IoT
-- Data Lake
-- Auditoria
-- Mensageria
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar JSON_PATH_EXISTS() antes de JSON_VALUE()
--
-- 2) Evitar assumir que todas as propriedades
--    estarão presentes.
--
-- 3) Utilizar CHECK Constraints para garantir
--    documentos mínimos obrigatórios.
--
-- 4) Aplicar índices JSON em grandes volumes.
--
-- 5) Utilizar em processos ETL e ingestão de APIs.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.EventosJSON;
GO

DROP TABLE dbo.ContratosJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------