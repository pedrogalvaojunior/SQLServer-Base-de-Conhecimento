/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Metodo MODIFY.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização do método MODIFY aplicado ao
 novo tipo de dados JSON do SQL Server 2025.

 Contexto...:
 Em versões anteriores do SQL Server, alterações em
 documentos JSON normalmente exigiam o uso da função
 JSON_MODIFY(), gerando a reconstrução do documento.

 O SQL Server 2025 introduz o método MODIFY para o tipo
 JSON nativo, permitindo atualizações mais eficientes
 e simplificando a manutenção de documentos.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Atualização de propriedades simples
 - Atualização de objetos aninhados
 - Inclusão de novas propriedades
 - Atualização de múltiplos documentos
 - Demonstração de cenários corporativos

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
    IdPedido           INT IDENTITY(1,1)
                       CONSTRAINT PK_PedidosJSON
                       PRIMARY KEY,

    DataCadastro       DATETIME2
                       NOT NULL
                       DEFAULT GETDATE(),

    Documento          JSON
                       NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
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
    "Valor":1500.00,
    "Status":"Pendente"
}'
);
GO

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "NumeroPedido":1002,
    "Cliente":"Maria Aparecida",
    "Valor":2500.00,
    "Status":"Pendente"
}'
);
GO

------------------------------------------------------------------------------
-- Situação Inicial
------------------------------------------------------------------------------

SELECT
    P.IdPedido,
    P.Documento
FROM dbo.PedidosJSON AS P;
GO

------------------------------------------------------------------------------
-- Atualizando Propriedade Simples
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Status',
        'Aprovado'
    )
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Resultado da Atualização
------------------------------------------------------------------------------

SELECT
    P.IdPedido,
    P.Documento
FROM dbo.PedidosJSON AS P
WHERE P.IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Alterando Valor Monetário
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Valor',
        1750.00
    )
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Consulta
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
    ) AS ValorAtualizado
FROM dbo.PedidosJSON
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Adicionando Estrutura de Entrega
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Entrega',
        JSON_QUERY
        (
            '{
                "Cidade":"Sao Roque",
                "Estado":"SP",
                "PrazoDias":3
            }'
        )
    )
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Resultado
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.PedidosJSON
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Atualizando Objeto Aninhado
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Entrega.PrazoDias',
        5
    )
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Consulta da Entrega
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Entrega.Cidade'
    ) AS Cidade,

    JSON_VALUE
    (
        Documento,
        '$.Entrega.Estado'
    ) AS Estado,

    JSON_VALUE
    (
        Documento,
        '$.Entrega.PrazoDias'
    ) AS PrazoDias
FROM dbo.PedidosJSON
WHERE IdPedido = 1;
GO

------------------------------------------------------------------------------
-- Inclusão de Campo de Auditoria
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.UltimaAtualizacao',
        CONVERT
        (
            VARCHAR(19),
            GETDATE(),
            120
        )
    );
GO

------------------------------------------------------------------------------
-- Verificando Inclusão
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Atualização em Massa
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Categoria',
        'ECommerce'
    );
GO

------------------------------------------------------------------------------
-- Consulta dos Dados
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
        '$.Categoria'
    ) AS Categoria
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Cenário Corporativo
-- Atualização de Status de Pedido
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    Documento.modify
    (
        '$.Status',
        'Faturado'
    )
WHERE JSON_VALUE
(
    Documento,
    '$.NumeroPedido'
) = '1002';
GO

------------------------------------------------------------------------------
-- Resultado
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
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Estatísticas do Ambiente
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadePedidos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Documento Completo Após Atualizações
------------------------------------------------------------------------------

SELECT
    P.IdPedido,
    P.Documento
FROM dbo.PedidosJSON AS P
ORDER BY
    P.IdPedido;
GO

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Atualizar somente propriedades necessárias.
--
-- 2) Evitar substituir o documento completo.
--
-- 3) Manter campos de auditoria.
--
-- 4) Validar estruturas obrigatórias.
--
-- 5) Utilizar índices JSON para consultas frequentes.
--
-- 6) Preferir atualizações incrementais.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Exemplo de Estrutura Final Esperada
------------------------------------------------------------------------------

/*

{
    "NumeroPedido":1001,
    "Cliente":"Pedro Antonio Galvao Junior",
    "Valor":1750.00,
    "Status":"Aprovado",
    "Categoria":"ECommerce",

    "Entrega":
    {
        "Cidade":"Sao Roque",
        "Estado":"SP",
        "PrazoDias":5
    },

    "UltimaAtualizacao":"2026-09-17 20:00:00"
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