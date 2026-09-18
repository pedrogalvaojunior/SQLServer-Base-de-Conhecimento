/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - OPENJSON com Tipo JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função OPENJSON()
 trabalhando diretamente com colunas do tipo JSON
 introduzidas no SQL Server 2025.

 Contexto...:
 OPENJSON é um dos recursos mais importantes para
 transformar documentos JSON em estruturas relacionais.

 Com o novo tipo JSON, a integração torna-se mais
 natural e simplificada.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - OPENJSON com JSON Nativo
 - Arrays JSON
 - Objetos JSON
 - Projeção Relacional
 - Integração com T-SQL

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
    IdPedido        INT IDENTITY(1,1)
                    CONSTRAINT PK_PedidosJSON
                    PRIMARY KEY,

    Documento       JSON
                    NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserindo Documento JSON
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
        "Codigo":1,
        "Nome":"Pedro Antonio Galvao Junior",
        "Cidade":"Sao Roque"
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
        },
        {
            "Codigo":"TEC001",
            "Descricao":"Teclado Microsoft",
            "Quantidade":1,
            "Valor":350.00
        }
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Visualização do Documento
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- OPENJSON na Raiz do Documento
------------------------------------------------------------------------------

SELECT
    J.[key],
    J.value,
    J.type
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento
) AS J;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Explorando o Objeto Cliente
------------------------------------------------------------------------------

SELECT
    J.[key],
    J.value,
    J.type
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Cliente'
) AS J;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Explorando o Array de Produtos
------------------------------------------------------------------------------

SELECT
    J.[key],
    J.value,
    J.type
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Produtos'
) AS J;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Projetando Colunas Relacionais
------------------------------------------------------------------------------

SELECT
    Codigo,
    Descricao,
    Quantidade,
    Valor
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Produtos'
)
WITH
(
    Codigo       VARCHAR(20) '$.Codigo',
    Descricao    VARCHAR(100) '$.Descricao',
    Quantidade   INT '$.Quantidade',
    Valor        DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Totalização de Produtos
------------------------------------------------------------------------------

SELECT
    SUM(Valor * Quantidade) AS ValorTotalPedido
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Produtos'
)
WITH
(
    Quantidade INT '$.Quantidade',
    Valor      DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Quantidade de Itens
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeItens
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Produtos'
);
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Recuperando Dados do Cliente
------------------------------------------------------------------------------

SELECT
    Codigo,
    Nome,
    Cidade
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Cliente'
)
WITH
(
    Codigo INT '$.Codigo',
    Nome   VARCHAR(100) '$.Nome',
    Cidade VARCHAR(100) '$.Cidade'
);
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- OPENJSON em Variável JSON
------------------------------------------------------------------------------

DECLARE @Pedido JSON =
'{
    "NumeroPedido":2001,
    "Status":"Aprovado",
    "Valor":799.90
}';

SELECT
    *
FROM OPENJSON(@Pedido);
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- OPENJSON com Estrutura Tipada
------------------------------------------------------------------------------

SELECT
    NumeroPedido,
    Status,
    Valor
FROM OPENJSON(@Pedido)
WITH
(
    NumeroPedido INT '$.NumeroPedido',
    Status       VARCHAR(30) '$.Status',
    Valor        DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Catálogo de Cursos
------------------------------------------------------------------------------

DECLARE @Cursos JSON =
'{
    "Cursos":
    [
        {
            "Nome":"SQL Server",
            "CargaHoraria":40
        },
        {
            "Nome":"Azure",
            "CargaHoraria":32
        },
        {
            "Nome":"Power BI",
            "CargaHoraria":24
        }
    ]
}';

SELECT
    Nome,
    CargaHoraria
FROM OPENJSON
(
    @Cursos,
    '$.Cursos'
)
WITH
(
    Nome          VARCHAR(100) '$.Nome',
    CargaHoraria  INT '$.CargaHoraria'
);
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Soma de Horas dos Cursos
------------------------------------------------------------------------------

SELECT
    SUM(CargaHoraria) AS TotalHoras
FROM OPENJSON
(
    @Cursos,
    '$.Cursos'
)
WITH
(
    CargaHoraria INT '$.CargaHoraria'
);
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Ambiente de E-commerce
------------------------------------------------------------------------------

DECLARE @Carrinho JSON =
'{
    "Itens":
    [
        {
            "Produto":"Notebook",
            "Quantidade":1
        },
        {
            "Produto":"Mouse",
            "Quantidade":2
        },
        {
            "Produto":"Monitor",
            "Quantidade":1
        }
    ]
}';

SELECT
    Produto,
    Quantidade
FROM OPENJSON
(
    @Carrinho,
    '$.Itens'
)
WITH
(
    Produto     VARCHAR(100) '$.Produto',
    Quantidade  INT '$.Quantidade'
);
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Contagem de Itens do Carrinho
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeItens
FROM OPENJSON
(
    @Carrinho,
    '$.Itens'
);
GO

------------------------------------------------------------------------------
-- Comparação de Abordagens
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Método Escalar
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
-- Método Relacional
------------------------------------------------------------------------------

SELECT
    Nome
FROM dbo.PedidosJSON P
CROSS APPLY OPENJSON
(
    P.Documento,
    '$.Cliente'
)
WITH
(
    Nome VARCHAR(100) '$.Nome'
);
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- APIs REST
-- ERP
-- CRM
-- E-commerce
-- Integração de Sistemas
-- Data Lake
-- Event Streaming
-- Microsserviços
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Benefícios do OPENJSON
--
-- Transformação relacional
-- Integração simplificada
-- Menos código
-- Flexibilidade
-- Compatibilidade com APIs
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar OPENJSON para arrays.
--
-- 2) Utilizar cláusula WITH para tipagem.
--
-- 3) Validar documentos antes da leitura.
--
-- 4) Utilizar JSON_VALUE para valores escalares.
--
-- 5) Utilizar JSON_QUERY para objetos e arrays.
--
-- 6) Criar índices apropriados para consultas.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadePedidos
FROM dbo.PedidosJSON;
GO

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