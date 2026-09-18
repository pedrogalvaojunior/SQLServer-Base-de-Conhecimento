/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Inserindo Documentos JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a inserção de documentos JSON utilizando
 o novo tipo de dados JSON nativo do SQL Server 2025.

 Contexto...:
 Em cenários modernos é comum armazenar informações
 semiestruturadas, como catálogos de produtos,
 configurações, integrações, APIs e metadados.

 O novo tipo JSON permite armazenar essas estruturas
 de forma nativa, com validação automática e
 melhor integração com os recursos do banco.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Inserção de múltiplos documentos JSON
 - Utilização de objetos aninhados
 - Utilização de arrays
 - Consulta dos documentos armazenados

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

DROP TABLE IF EXISTS dbo.ProdutosJSON;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.ProdutosJSON
(
    IdProduto           INT IDENTITY(1,1)
                         CONSTRAINT PK_ProdutosJSON
                         PRIMARY KEY,

    DataCadastro        DATETIME2
                         NOT NULL
                         DEFAULT GETDATE(),

    DadosProduto        JSON
                         NOT NULL
);
GO

------------------------------------------------------------------------------
-- Estrutura da Tabela
------------------------------------------------------------------------------

EXEC sp_help 'dbo.ProdutosJSON';
GO

------------------------------------------------------------------------------
-- Produto 01
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosJSON
(
    DadosProduto
)
VALUES
(
'{
    "Codigo":"NOTE001",
    "Nome":"Notebook Dell Inspiron",
    "Categoria":"Informatica",
    "Marca":"Dell",
    "Preco":4599.90,
    "Estoque":15,

    "Especificacoes":
    {
        "Processador":"Intel Core i7",
        "Memoria":"16 GB",
        "SSD":"512 GB"
    },

    "Tags":
    [
        "Notebook",
        "Dell",
        "Core i7",
        "SSD"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Produto 02
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosJSON
(
    DadosProduto
)
VALUES
(
'{
    "Codigo":"MON001",
    "Nome":"Monitor LG 27",
    "Categoria":"Monitores",
    "Marca":"LG",
    "Preco":1299.90,
    "Estoque":20,

    "Especificacoes":
    {
        "Tamanho":"27",
        "Resolucao":"Full HD",
        "Painel":"IPS"
    },

    "Tags":
    [
        "Monitor",
        "LG",
        "IPS"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Produto 03
------------------------------------------------------------------------------

INSERT INTO dbo.ProdutosJSON
(
    DadosProduto
)
VALUES
(
'{
    "Codigo":"MOU001",
    "Nome":"Mouse Sem Fio Logitech",
    "Categoria":"Perifericos",
    "Marca":"Logitech",
    "Preco":149.90,
    "Estoque":40,

    "Especificacoes":
    {
        "Conexao":"Wireless",
        "DPI":"4000",
        "Cor":"Preto"
    },

    "Tags":
    [
        "Mouse",
        "Wireless",
        "Logitech"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Quantidade de Produtos
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeProdutos
FROM dbo.ProdutosJSON;
GO

------------------------------------------------------------------------------
-- Consulta Completa
------------------------------------------------------------------------------

SELECT
    PJ.IdProduto,
    PJ.DataCadastro,
    PJ.DadosProduto
FROM dbo.ProdutosJSON AS PJ
ORDER BY
    PJ.IdProduto;
GO

------------------------------------------------------------------------------
-- Consulta de Propriedades Específicas
------------------------------------------------------------------------------

SELECT
    PJ.IdProduto,

    JSON_VALUE
    (
        PJ.DadosProduto,
        '$.Codigo'
    ) AS Codigo,

    JSON_VALUE
    (
        PJ.DadosProduto,
        '$.Nome'
    ) AS Nome,

    JSON_VALUE
    (
        PJ.DadosProduto,
        '$.Marca'
    ) AS Marca,

    JSON_VALUE
    (
        PJ.DadosProduto,
        '$.Preco'
    ) AS Preco
FROM dbo.ProdutosJSON AS PJ
ORDER BY
    Nome;
GO

------------------------------------------------------------------------------
-- Consulta de Especificações Aninhadas
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        DadosProduto,
        '$.Nome'
    ) AS Produto,

    JSON_VALUE
    (
        DadosProduto,
        '$.Especificacoes.Processador'
    ) AS Processador,

    JSON_VALUE
    (
        DadosProduto,
        '$.Especificacoes.Memoria'
    ) AS Memoria,

    JSON_VALUE
    (
        DadosProduto,
        '$.Especificacoes.SSD'
    ) AS SSD
FROM dbo.ProdutosJSON;
GO

------------------------------------------------------------------------------
-- Produtos com Estoque Superior a 20
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        DadosProduto,
        '$.Nome'
    ) AS Produto,

    JSON_VALUE
    (
        DadosProduto,
        '$.Estoque'
    ) AS Estoque
FROM dbo.ProdutosJSON
WHERE
    CAST
    (
        JSON_VALUE
        (
            DadosProduto,
            '$.Estoque'
        )
        AS INT
    ) > 20;
GO

------------------------------------------------------------------------------
-- Exemplo de Documento Inválido
--
-- O comando abaixo deverá falhar caso seja executado.
------------------------------------------------------------------------------

/*

INSERT INTO dbo.ProdutosJSON
(
    DadosProduto
)
VALUES
(
'{
    Codigo:"ABC",
    Nome:"Produto Invalido"
}'
);
GO

*/

------------------------------------------------------------------------------
-- Demonstração de Estrutura JSON Utilizada
------------------------------------------------------------------------------

/*

{
    "Codigo":"",
    "Nome":"",
    "Categoria":"",
    "Marca":"",
    "Preco":0,

    "Especificacoes":
    {

    },

    "Tags":
    [

    ]
}

*/

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- 1) O tipo JSON valida automaticamente o conteúdo.
--
-- 2) Objetos podem ser aninhados em múltiplos níveis.
--
-- 3) Arrays são aceitos normalmente.
--
-- 4) O documento pode ser consultado posteriormente
--    utilizando JSON_VALUE(), JSON_QUERY() e OPENJSON().
--
-- 5) O mesmo modelo pode ser utilizado para APIs,
--    catálogos, integrações e metadados.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ProdutosJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------