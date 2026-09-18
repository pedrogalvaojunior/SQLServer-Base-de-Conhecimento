/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Tipo de Dados JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização do novo tipo de dados JSON nativo
 introduzido no SQL Server 2025.

 Contexto...:
 Até o SQL Server 2022, documentos JSON eram armazenados
 normalmente em colunas VARCHAR(MAX) ou NVARCHAR(MAX).

 O SQL Server 2025 introduz o tipo de dados JSON nativo,
 permitindo armazenamento otimizado, validação automática,
 redução de processamento e novos recursos de indexação.

 Requisitos.:
 - SQL Server 2025
 - Banco de dados compatível com a versão 17.x

 Resultado..:
 - Criação de tabela utilizando o tipo JSON
 - Inserção de documentos válidos
 - Tentativa de inserção de documento inválido
 - Consulta dos dados armazenados

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

DROP TABLE IF EXISTS dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Criação da Tabela
------------------------------------------------------------------------------

CREATE TABLE dbo.ClientesJSON
(
    IdCliente            INT IDENTITY(1,1)
                          CONSTRAINT PK_ClientesJSON
                          PRIMARY KEY,

    NomeCliente          VARCHAR(100)
                          NOT NULL,

    DataCadastro         DATETIME2
                          NOT NULL
                          DEFAULT GETDATE(),

    DadosComplementares  JSON
                          NOT NULL
);
GO

------------------------------------------------------------------------------
-- Estrutura Criada
------------------------------------------------------------------------------

EXEC sp_help 'dbo.ClientesJSON';
GO

------------------------------------------------------------------------------
-- Inserção de Documento JSON Válido
------------------------------------------------------------------------------

INSERT INTO dbo.ClientesJSON
(
    NomeCliente,
    DadosComplementares
)
VALUES
(
    'Pedro Antonio Galvao Junior',
    '{
        "Cidade":"Sao Roque",
        "Estado":"SP",
        "Pais":"Brasil",
        "CEP":"18130-000",
        "Contato":
        {
            "Email":"pedro@empresa.com.br",
            "Telefone":"(11)99999-9999"
        }
     }'
);
GO

------------------------------------------------------------------------------
-- Segunda Inserção
------------------------------------------------------------------------------

INSERT INTO dbo.ClientesJSON
(
    NomeCliente,
    DadosComplementares
)
VALUES
(
    'Maria Aparecida',
    '{
        "Cidade":"Sorocaba",
        "Estado":"SP",
        "Pais":"Brasil",
        "CEP":"18000-000",
        "Contato":
        {
            "Email":"maria@empresa.com.br",
            "Telefone":"(15)98888-8888"
        }
     }'
);
GO

------------------------------------------------------------------------------
-- Consulta dos Dados Armazenados
------------------------------------------------------------------------------

SELECT
    CJ.IdCliente,
    CJ.NomeCliente,
    CJ.DataCadastro,
    CJ.DadosComplementares
FROM dbo.ClientesJSON AS CJ
ORDER BY
    CJ.IdCliente;
GO

------------------------------------------------------------------------------
-- Consulta de Informações Específicas
------------------------------------------------------------------------------

SELECT
    CJ.IdCliente,
    CJ.NomeCliente,
    JSON_VALUE
    (
        CJ.DadosComplementares,
        '$.Cidade'
    ) AS Cidade,

    JSON_VALUE
    (
        CJ.DadosComplementares,
        '$.Estado'
    ) AS Estado,

    JSON_VALUE
    (
        CJ.DadosComplementares,
        '$.Contato.Email'
    ) AS Email
FROM dbo.ClientesJSON AS CJ;
GO

------------------------------------------------------------------------------
-- Exemplo de Tentativa de Inserção Inválida
--
-- O comando abaixo deve gerar erro de validação
-- pois o documento JSON está mal formatado.
--
-- Descomente para testar.
------------------------------------------------------------------------------

/*

INSERT INTO dbo.ClientesJSON
(
    NomeCliente,
    DadosComplementares
)
VALUES
(
    'Cliente Invalido',
    '{
        Cidade:"Sao Roque",
        Estado:"SP"
     }'
);
GO

*/

------------------------------------------------------------------------------
-- Quantidade de Clientes
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeClientes
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exibição Formatada dos Documentos
------------------------------------------------------------------------------

SELECT
    CJ.IdCliente,
    CJ.NomeCliente,
    CJ.DadosComplementares
FROM dbo.ClientesJSON AS CJ;
GO

------------------------------------------------------------------------------
-- Considerações Técnicas
--
-- 1) O documento JSON é validado automaticamente.
-- 2) Apenas JSON válido pode ser armazenado.
-- 3) O tipo JSON permite utilização futura de
--    índices JSON nativos.
-- 4) O formato reduz a necessidade de validações
--    manuais com ISJSON().
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ClientesJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------