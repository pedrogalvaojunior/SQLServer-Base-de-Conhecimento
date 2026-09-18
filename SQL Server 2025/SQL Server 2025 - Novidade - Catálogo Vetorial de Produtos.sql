/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Catalogo Vetorial de Produtos.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a construção de um catálogo de produtos
 utilizando embeddings armazenados em colunas VECTOR.

 Contexto...:
 Plataformas modernas de e-commerce utilizam IA para
 encontrar produtos semelhantes, recomendar itens e
 realizar pesquisas semânticas.

 O SQL Server 2025 permite armazenar embeddings
 diretamente no banco de dados por meio do tipo
 VECTOR.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Recursos Preview habilitados

 Resultado..:
 - Catálogo vetorial
 - Produtos com embeddings
 - Categorias de produtos
 - Consultas de recomendação
 - Preparação para busca vetorial

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Habilitação de Recursos Preview
------------------------------------------------------------------------------

ALTER DATABASE SCOPED CONFIGURATION
SET PREVIEW_FEATURES = ON;
GO

------------------------------------------------------------------------------
-- Limpeza do Ambiente
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.CatalogoProdutosVetorial;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.CatalogoProdutosVetorial
(
    IdProduto              INT IDENTITY(1,1)
                           CONSTRAINT PK_CatalogoProdutosVetorial
                           PRIMARY KEY,

    CodigoProduto          VARCHAR(20)
                           NOT NULL,

    NomeProduto            VARCHAR(200)
                           NOT NULL,

    Categoria              VARCHAR(100)
                           NOT NULL,

    Marca                  VARCHAR(100)
                           NOT NULL,

    PrecoVenda             DECIMAL(12,2)
                           NOT NULL,

    Ativo                  BIT
                           NOT NULL
                           DEFAULT 1,

    Embedding              VECTOR(8)
                           NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção de Produtos de Informática
------------------------------------------------------------------------------

INSERT INTO dbo.CatalogoProdutosVetorial
(
    CodigoProduto,
    NomeProduto,
    Categoria,
    Marca,
    PrecoVenda,
    Embedding
)
VALUES
(
    'NOTE001',
    'Notebook Dell Inspiron',
    'Informatica',
    'Dell',
    4599.90,
    '[0.81,0.22,0.34,0.41,0.57,0.69,0.73,0.90]'
),
(
    'NOTE002',
    'Notebook Lenovo ThinkPad',
    'Informatica',
    'Lenovo',
    5299.90,
    '[0.84,0.24,0.36,0.43,0.59,0.71,0.75,0.92]'
),
(
    'NOTE003',
    'Notebook HP ProBook',
    'Informatica',
    'HP',
    4999.90,
    '[0.82,0.23,0.35,0.42,0.58,0.70,0.74,0.91]'
);
GO

------------------------------------------------------------------------------
-- Monitores
------------------------------------------------------------------------------

INSERT INTO dbo.CatalogoProdutosVetorial
(
    CodigoProduto,
    NomeProduto,
    Categoria,
    Marca,
    PrecoVenda,
    Embedding
)
VALUES
(
    'MON001',
    'Monitor LG 27 IPS',
    'Monitores',
    'LG',
    1399.90,
    '[0.31,0.20,0.46,0.54,0.37,0.21,0.59,0.70]'
),
(
    'MON002',
    'Monitor Samsung 27',
    'Monitores',
    'Samsung',
    1499.90,
    '[0.33,0.22,0.48,0.56,0.39,0.23,0.61,0.72]'
);
GO

------------------------------------------------------------------------------
-- Periféricos
------------------------------------------------------------------------------

INSERT INTO dbo.CatalogoProdutosVetorial
(
    CodigoProduto,
    NomeProduto,
    Categoria,
    Marca,
    PrecoVenda,
    Embedding
)
VALUES
(
    'MOU001',
    'Mouse Logitech MX Master',
    'Perifericos',
    'Logitech',
    399.90,
    '[0.88,0.12,0.41,0.30,0.22,0.18,0.65,0.79]'
),
(
    'MOU002',
    'Mouse Microsoft Bluetooth',
    'Perifericos',
    'Microsoft',
    299.90,
    '[0.85,0.15,0.39,0.28,0.20,0.19,0.63,0.77]'
),
(
    'TEC001',
    'Teclado Microsoft',
    'Perifericos',
    'Microsoft',
    349.90,
    '[0.80,0.15,0.39,0.33,0.18,0.16,0.67,0.82]'
);
GO

------------------------------------------------------------------------------
-- Consulta Geral
------------------------------------------------------------------------------

SELECT
    P.IdProduto,
    P.CodigoProduto,
    P.NomeProduto,
    P.Categoria,
    P.Marca,
    P.PrecoVenda
FROM dbo.CatalogoProdutosVetorial AS P
ORDER BY
    P.NomeProduto;
GO

------------------------------------------------------------------------------
-- Produtos por Categoria
------------------------------------------------------------------------------

SELECT
    Categoria,
    COUNT(*) AS Quantidade
FROM dbo.CatalogoProdutosVetorial
GROUP BY
    Categoria
ORDER BY
    Categoria;
GO

------------------------------------------------------------------------------
-- Valor Médio por Categoria
------------------------------------------------------------------------------

SELECT
    Categoria,
    AVG(PrecoVenda) AS PrecoMedio
FROM dbo.CatalogoProdutosVetorial
GROUP BY
    Categoria;
GO

------------------------------------------------------------------------------
-- Produtos da Categoria Informática
------------------------------------------------------------------------------

SELECT
    CodigoProduto,
    NomeProduto,
    Marca,
    PrecoVenda
FROM dbo.CatalogoProdutosVetorial
WHERE Categoria = 'Informatica';
GO

------------------------------------------------------------------------------
-- Embedding de Pesquisa Simulada
------------------------------------------------------------------------------

DECLARE @EmbeddingPesquisa VECTOR(8);

SET @EmbeddingPesquisa =
'[
    0.83,
    0.23,
    0.35,
    0.42,
    0.58,
    0.70,
    0.74,
    0.91
]';

SELECT
    @EmbeddingPesquisa AS EmbeddingPesquisa;
GO

------------------------------------------------------------------------------
-- Produtos Potencialmente Relacionados
------------------------------------------------------------------------------

SELECT
    CodigoProduto,
    NomeProduto,
    Categoria,
    Marca
FROM dbo.CatalogoProdutosVetorial
WHERE Categoria = 'Informatica';
GO

------------------------------------------------------------------------------
-- Simulação de Recomendação
------------------------------------------------------------------------------

DECLARE @ProdutoAtual VARCHAR(20);

SET @ProdutoAtual = 'NOTE001';

SELECT
    CodigoProduto,
    NomeProduto,
    Marca
FROM dbo.CatalogoProdutosVetorial
WHERE Categoria =
(
    SELECT Categoria
    FROM dbo.CatalogoProdutosVetorial
    WHERE CodigoProduto = @ProdutoAtual
)
AND CodigoProduto <> @ProdutoAtual;
GO

------------------------------------------------------------------------------
-- Exportação JSON para API
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Codigo':CodigoProduto,
        'Nome':NomeProduto,
        'Categoria':Categoria,
        'Marca':Marca,
        'Preco':PrecoVenda
    ) AS ProdutoJSON
FROM dbo.CatalogoProdutosVetorial;
GO

------------------------------------------------------------------------------
-- Estatísticas Gerais
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeProdutos,
    SUM(PrecoVenda) AS ValorTotalCatalogo,
    AVG(PrecoVenda) AS TicketMedio
FROM dbo.CatalogoProdutosVetorial;
GO

------------------------------------------------------------------------------
-- Ranking de Produtos Mais Caros
------------------------------------------------------------------------------

SELECT TOP (5)
    CodigoProduto,
    NomeProduto,
    PrecoVenda
FROM dbo.CatalogoProdutosVetorial
ORDER BY
    PrecoVenda DESC;
GO

------------------------------------------------------------------------------
-- Cenário IA Generativa
--
-- 1) Produto é transformado em embedding.
-- 2) Embedding é gravado no SQL Server.
-- 3) Consulta gera embedding da pesquisa.
-- 4) Sistema localiza produtos semelhantes.
-- 5) IA utiliza os resultados para recomendar itens.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso
--
-- Ecommerce
-- Marketplace
-- Recomendação Inteligente
-- Busca Semântica
-- Catálogo Digital
-- IA Generativa
-- Assistentes Virtuais
-- Vendas Consultivas
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar sempre o mesmo modelo de embeddings.
--
-- 2) Regerar embeddings quando a descrição mudar.
--
-- 3) Indexar vetores quando suportado.
--
-- 4) Monitorar crescimento do catálogo.
--
-- 5) Separar embeddings por domínio de negócio.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.CatalogoProdutosVetorial;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------