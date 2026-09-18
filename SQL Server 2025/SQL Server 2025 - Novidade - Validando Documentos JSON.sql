/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Validando Documentos JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar os mecanismos de validação de documentos JSON
 utilizando o novo tipo de dados JSON nativo do SQL Server 2025.

 Contexto...:
 Em versões anteriores do SQL Server, documentos JSON eram
 normalmente armazenados em colunas VARCHAR(MAX) ou
 NVARCHAR(MAX), permitindo inclusive a gravação de
 conteúdos inválidos.

 Com o tipo JSON nativo, o SQL Server passa a validar
 automaticamente os documentos inseridos.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Inserção de documentos válidos
 - Tentativa de inserção de documentos inválidos
 - Tratamento de erros
 - Comparação com abordagem tradicional

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

DROP TABLE IF EXISTS dbo.DocumentosJSON;
GO

DROP TABLE IF EXISTS dbo.DocumentosNVARCHAR;
GO

------------------------------------------------------------------------------
-- Tabela Utilizando o Novo Tipo JSON
------------------------------------------------------------------------------

CREATE TABLE dbo.DocumentosJSON
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_DocumentosJSON
                      PRIMARY KEY,

    DataCadastro      DATETIME2
                      NOT NULL
                      DEFAULT GETDATE(),

    Documento         JSON
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Tabela Utilizando NVARCHAR(MAX)
--
-- Simula a abordagem utilizada em versões anteriores
------------------------------------------------------------------------------

CREATE TABLE dbo.DocumentosNVARCHAR
(
    IdDocumento       INT IDENTITY(1,1)
                      CONSTRAINT PK_DocumentosNVARCHAR
                      PRIMARY KEY,

    DataCadastro      DATETIME2
                      NOT NULL
                      DEFAULT GETDATE(),

    Documento         NVARCHAR(MAX)
                      NOT NULL
);
GO

------------------------------------------------------------------------------
-- Documento JSON Válido
------------------------------------------------------------------------------

DECLARE @DocumentoValido JSON;

SET @DocumentoValido =
'
{
    "Codigo":100,
    "Descricao":"Notebook",
    "Preco":4500.00,
    "Ativo":true
}
';
GO

------------------------------------------------------------------------------
-- Inserção de Documento Válido
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosJSON
(
    Documento
)
VALUES
(
'{
    "Codigo":100,
    "Descricao":"Notebook",
    "Preco":4500.00,
    "Ativo":true
}'
);
GO

------------------------------------------------------------------------------
-- Consulta dos Dados Gravados
------------------------------------------------------------------------------

SELECT
    DJ.IdDocumento,
    DJ.DataCadastro,
    DJ.Documento
FROM dbo.DocumentosJSON AS DJ;
GO

------------------------------------------------------------------------------
-- Documento Inválido
--
-- Ausência de aspas no nome da propriedade
------------------------------------------------------------------------------

BEGIN TRY

    INSERT INTO dbo.DocumentosJSON
    (
        Documento
    )
    VALUES
    (
    '{
        Codigo:100,
        "Descricao":"Produto Invalido"
    }'
    );

END TRY

BEGIN CATCH

    SELECT
        ERROR_NUMBER()    AS NumeroErro,
        ERROR_MESSAGE()   AS MensagemErro;

END CATCH;
GO

------------------------------------------------------------------------------
-- Documento Inválido
--
-- Chave não encerrada corretamente
------------------------------------------------------------------------------

BEGIN TRY

    INSERT INTO dbo.DocumentosJSON
    (
        Documento
    )
    VALUES
    (
    '{
        "Codigo":100,
        "Descricao":"Outro Produto",
        "Preco":2500
    '
    );

END TRY

BEGIN CATCH

    SELECT
        ERROR_NUMBER()  AS NumeroErro,
        ERROR_MESSAGE() AS MensagemErro;

END CATCH;
GO

------------------------------------------------------------------------------
-- Demonstração da Abordagem Tradicional
--
-- A tabela NVARCHAR aceita qualquer conteúdo textual.
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosNVARCHAR
(
    Documento
)
VALUES
(
'{
    Codigo:100,
    Nome:ProdutoSemValidacao
}'
);
GO

------------------------------------------------------------------------------
-- Resultado da Inserção
------------------------------------------------------------------------------

SELECT
    D.IdDocumento,
    D.Documento
FROM dbo.DocumentosNVARCHAR AS D;
GO

------------------------------------------------------------------------------
-- Comparação dos Registros
------------------------------------------------------------------------------

SELECT
    'JSON' AS TipoArmazenamento,
    COUNT(*) AS QuantidadeRegistros
FROM dbo.DocumentosJSON

UNION ALL

SELECT
    'NVARCHAR',
    COUNT(*)
FROM dbo.DocumentosNVARCHAR;
GO

------------------------------------------------------------------------------
-- Utilizando ISJSON
--
-- Continua sendo útil para processos de auditoria,
-- importação e migração.
------------------------------------------------------------------------------

SELECT
    Documento,
    ISJSON(Documento) AS DocumentoValido
FROM dbo.DocumentosNVARCHAR;
GO

------------------------------------------------------------------------------
-- Inserção de Documento Complexo
------------------------------------------------------------------------------

INSERT INTO dbo.DocumentosJSON
(
    Documento
)
VALUES
(
'{
    "Cliente":
    {
        "Codigo":1,
        "Nome":"Pedro Antonio Galvao Junior"
    },

    "Pedidos":
    [
        {
            "Numero":1001,
            "Valor":1500.00
        },
        {
            "Numero":1002,
            "Valor":2300.00
        }
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Consulta dos Documentos Gravados
------------------------------------------------------------------------------

SELECT
    DJ.IdDocumento,
    DJ.Documento
FROM dbo.DocumentosJSON AS DJ;
GO

------------------------------------------------------------------------------
-- Consulta de Propriedades
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Cliente.Nome'
    ) AS NomeCliente
FROM dbo.DocumentosJSON
WHERE JSON_PATH_EXISTS
(
    Documento,
    '$.Cliente.Nome'
) = 1;
GO

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilizar o tipo JSON sempre que possível.
--
-- 2) Evitar armazenar JSON em NVARCHAR(MAX)
--    quando o objetivo for utilizar os recursos
--    nativos do SQL Server 2025.
--
-- 3) Utilizar TRY/CATCH em processos ETL.
--
-- 4) Validar documentos recebidos de APIs.
--
-- 5) Criar índices JSON para grandes volumes.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas do Ambiente
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS TotalDocumentosJSON
FROM dbo.DocumentosJSON;
GO

SELECT
    COUNT(*) AS TotalDocumentosNVARCHAR
FROM dbo.DocumentosNVARCHAR;
GO

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.DocumentosJSON;
GO

DROP TABLE dbo.DocumentosNVARCHAR;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------