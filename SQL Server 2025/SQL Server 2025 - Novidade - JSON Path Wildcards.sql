/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - JSON Path Wildcards.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização de Wildcards em expressões
 JSON Path no SQL Server 2025.

 Contexto...:
 O SQL Server 2025 amplia o suporte ao padrão
 ANSI SQL/JSON, permitindo consultas mais flexíveis
 sobre arrays JSON através de Wildcards.

 Os Wildcards permitem acessar múltiplos elementos
 sem necessidade de especificar posições individuais.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - Navegação em arrays
 - Wildcards
 - JSON_QUERY
 - JSON_PATH_EXISTS
 - Consultas avançadas
 - Estruturas complexas

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
-- Inserção do Documento
------------------------------------------------------------------------------

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "Pedido":1001,

    "Cliente":
    {
        "Nome":"Pedro Antonio Galvao Junior",
        "Cidade":"Sao Roque"
    },

    "Produtos":
    [
        {
            "Codigo":"NOTE001",
            "Descricao":"Notebook Dell",
            "Valor":4500
        },
        {
            "Codigo":"MOU001",
            "Descricao":"Mouse Logitech",
            "Valor":250
        },
        {
            "Codigo":"TEC001",
            "Descricao":"Teclado Microsoft",
            "Valor":350
        }
    ],

    "Pagamentos":
    [
        {
            "Tipo":"Cartao",
            "Valor":3000
        },
        {
            "Tipo":"Pix",
            "Valor":2100
        }
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Visualização
------------------------------------------------------------------------------

SELECT
    Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Primeiro Elemento do Array
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
-- Exemplo 02
-- Segundo Elemento do Array
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
-- Exemplo 03
-- Todos os Produtos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[*]'
    ) AS TodosProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Todas as Descrições
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[*].Descricao'
    ) AS DescricoesProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Todos os Códigos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[*].Codigo'
    ) AS CodigosProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Todos os Valores
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Produtos[*].Valor'
    ) AS ValoresProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Todos os Tipos de Pagamento
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Pagamentos[*].Tipo'
    ) AS TiposPagamento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Todos os Valores dos Pagamentos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Pagamentos[*].Valor'
    ) AS ValoresPagamento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- JSON_PATH_EXISTS com Wildcard
------------------------------------------------------------------------------

SELECT
    JSON_PATH_EXISTS
    (
        Documento,
        '$.Produtos[*]'
    ) AS PossuiProdutos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Verificando Pagamentos
------------------------------------------------------------------------------

SELECT
    JSON_PATH_EXISTS
    (
        Documento,
        '$.Pagamentos[*]'
    ) AS PossuiPagamentos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- OPENJSON Tradicional
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
-- Exemplo 12
-- OPENJSON Projetado
------------------------------------------------------------------------------

SELECT
    Codigo,
    Descricao,
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
    Valor       DECIMAL(10,2) '$.Valor'
);
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Documento com Múltiplos Cursos
------------------------------------------------------------------------------

DECLARE @Cursos JSON =
'{
   "Aluno":"Pedro",

   "Cursos":
   [
      {
         "Nome":"SQL Server",
         "Nivel":"Avancado"
      },
      {
         "Nome":"Azure",
         "Nivel":"Intermediario"
      },
      {
         "Nome":"Power BI",
         "Nivel":"Avancado"
      }
   ]
}';

SELECT
    JSON_QUERY
    (
        @Cursos,
        '$.Cursos[*]'
    ) AS Cursos;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Todos os Nomes dos Cursos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        @Cursos,
        '$.Cursos[*].Nome'
    ) AS NomesCursos;
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Todos os Níveis
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        @Cursos,
        '$.Cursos[*].Nivel'
    ) AS Niveis;
GO

------------------------------------------------------------------------------
-- Exemplo 16
-- Estrutura de E-commerce
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
    JSON_QUERY
    (
        @Carrinho,
        '$.Itens[*].Produto'
    ) AS ProdutosCarrinho;
GO

------------------------------------------------------------------------------
-- Exemplo 17
-- Arrays Aninhados
------------------------------------------------------------------------------

DECLARE @Treinamento JSON =
'{
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
        @Treinamento,
        '$.Modulos[*]'
    ) AS Modulos;
GO

------------------------------------------------------------------------------
-- Exemplo 18
-- Primeiro Módulo
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        @Treinamento,
        '$.Modulos[0]'
    ) AS PrimeiroModulo;
GO

------------------------------------------------------------------------------
-- Exemplo 19
-- Todas as Aulas do Primeiro Módulo
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        @Treinamento,
        '$.Modulos[0].Aulas[*]'
    ) AS AulasModulo;
GO

------------------------------------------------------------------------------
-- Exemplo 20
-- Verificando Existência com Wildcards
------------------------------------------------------------------------------

SELECT
    JSON_PATH_EXISTS
    (
        @Treinamento,
        '$.Modulos[0].Aulas[*]'
    ) AS PossuiAulas;
GO

------------------------------------------------------------------------------
-- Operadores Comuns
--
-- [0]
-- [1]
-- [2]
-- [*]
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Exemplos de Caminhos
--
-- $.Produtos[0]
-- $.Produtos[*]
-- $.Produtos[*].Descricao
--
-- $.Pagamentos[*]
-- $.Pagamentos[*].Tipo
--
-- $.Cursos[*]
-- $.Cursos[*].Nome
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- APIs REST
-- ERP
-- CRM
-- E-commerce
-- Marketplaces
-- Integrações B2B
-- Aplicações Mobile
-- Microsserviços
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Benefícios
--
-- Menos código
-- Mais flexibilidade
-- Consultas simplificadas
-- Melhor legibilidade
-- Compatibilidade ANSI SQL/JSON
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar Wildcards para navegação em arrays.
--
-- 2) Utilizar JSON_QUERY para objetos e arrays.
--
-- 3) Utilizar JSON_VALUE para valores escalares.
--
-- 4) Utilizar OPENJSON para projeções relacionais.
--
-- 5) Criar JSON INDEX quando apropriado.
--
-- 6) Evitar estruturas excessivamente profundas.
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