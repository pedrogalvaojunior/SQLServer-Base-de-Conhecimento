/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - Atualizacoes Parciais em JSON.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar técnicas de atualização parcial de
 documentos JSON utilizando os recursos do
 SQL Server 2025.

 Contexto...:
 Em ambientes corporativos é comum alterar apenas
 partes de um documento JSON.

 Atualizar o documento inteiro pode gerar:
 
 - Maior processamento
 - Código mais complexo
 - Maior risco de inconsistências

 Os recursos JSON modernos permitem alterações
 pontuais em propriedades específicas.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior
 - Tipo de dados JSON

 Resultado..:
 - Atualização de propriedades
 - Inclusão de propriedades
 - Remoção de propriedades
 - Atualização de objetos
 - Atualização de arrays
 - Auditoria de alterações

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
-- Criação da Estrutura
------------------------------------------------------------------------------

CREATE TABLE dbo.ClientesJSON
(
    IdCliente      INT IDENTITY(1,1)
                   CONSTRAINT PK_ClientesJSON
                   PRIMARY KEY,

    Documento      JSON
                   NOT NULL
);
GO

------------------------------------------------------------------------------
-- Inserção dos Dados
------------------------------------------------------------------------------

INSERT INTO dbo.ClientesJSON
(
    Documento
)
VALUES
(
'{
    "Codigo":1,
    "Nome":"Pedro Antonio Galvao Junior",
    "Cidade":"Sao Roque",
    "Email":"pedro@email.com.br",
    "Ativo":true,
    "Cursos":
    [
        "SQL Server",
        "Azure"
    ]
}'
);
GO

------------------------------------------------------------------------------
-- Visualização Inicial
------------------------------------------------------------------------------

SELECT
    IdCliente,
    Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Alterando Cidade
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Cidade',
        'Sorocaba'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Alterando E-mail
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Email',
        'pedro.galvao@empresa.com.br'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Alterando Status
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Ativo',
        0
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Adicionando Telefone
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Telefone',
        '(11)99999-9999'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Adicionando CEP
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.CEP',
        '18130-000'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Removendo CEP
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.CEP',
        NULL
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Atualizando Nome
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Nome',
        'Pedro Antonio Galvao Junior Filho'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Adicionando Objeto Endereco
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Endereco',
        JSON_QUERY
        (
            '{
                "Logradouro":"Rua das Flores",
                "Numero":100,
                "Bairro":"Centro"
            }'
        )
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Atualizando Propriedade do Objeto
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Endereco.Numero',
        200
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Atualizando Bairro
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Endereco.Bairro',
        'Jardim Paulista'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Adicionando Curso ao Array
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        'append $.Cursos',
        'Power BI'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Adicionando Novo Curso
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        'append $.Cursos',
        'Microsoft Fabric'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Consultando Cursos
------------------------------------------------------------------------------

SELECT
    JSON_QUERY
    (
        Documento,
        '$.Cursos'
    ) AS Cursos
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Atualizando Primeiro Curso
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Cursos[0]',
        'SQL Server 2025'
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Adicionando Metadados
------------------------------------------------------------------------------

UPDATE dbo.ClientesJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.DataAtualizacao',
        CONVERT(VARCHAR(19),GETDATE(),120)
    );

SELECT Documento
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 16
-- Extraindo Propriedades Atualizadas
------------------------------------------------------------------------------

SELECT
    JSON_VALUE(Documento,'$.Nome')      AS Nome,
    JSON_VALUE(Documento,'$.Cidade')    AS Cidade,
    JSON_VALUE(Documento,'$.Email')     AS Email
FROM dbo.ClientesJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 17
-- Estrutura Corporativa
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.PedidosJSON;
GO

CREATE TABLE dbo.PedidosJSON
(
    IdPedido       INT IDENTITY(1,1)
                   PRIMARY KEY,

    Documento      JSON
                   NOT NULL
);
GO

INSERT INTO dbo.PedidosJSON
(
    Documento
)
VALUES
(
'{
    "Pedido":1001,
    "Status":"Pendente",
    "Valor":1500.00
}'
);
GO

------------------------------------------------------------------------------
-- Atualizando Status do Pedido
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Status',
        'Faturado'
    );

SELECT Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Atualizando Valor
------------------------------------------------------------------------------

UPDATE dbo.PedidosJSON
SET Documento =
    JSON_MODIFY
    (
        Documento,
        '$.Valor',
        1750.00
    );

SELECT Documento
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Auditoria de Alterações
------------------------------------------------------------------------------

SELECT
    JSON_VALUE
    (
        Documento,
        '$.Status'
    ) AS StatusPedido,

    JSON_VALUE
    (
        Documento,
        '$.Valor'
    ) AS ValorPedido
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Comparação Conceitual
--
-- Método Antigo
--
-- Ler JSON
-- Alterar aplicação
-- Regravar documento inteiro
--
-- Método Atual
--
-- JSON_MODIFY()
-- Atualização pontual
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- ERP
-- CRM
-- E-commerce
-- Marketplaces
-- APIs REST
-- Microsserviços
-- Configurações
-- Catálogos
-- Perfis de Usuário
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Benefícios
--
-- Menos processamento
-- Menor volume de código
-- Melhor manutenção
-- Maior produtividade
-- Menor risco operacional
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Atualizar apenas o necessário.
--
-- 2) Validar documentos antes da alteração.
--
-- 3) Utilizar JSON_VALUE para auditoria.
--
-- 4) Registrar histórico relevante.
--
-- 5) Utilizar JSON_QUERY para objetos complexos.
--
-- 6) Testar alterações em grandes documentos.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Estatísticas
------------------------------------------------------------------------------

SELECT
    COUNT(*) AS QuantidadeClientes
FROM dbo.ClientesJSON;
GO

SELECT
    COUNT(*) AS QuantidadePedidos
FROM dbo.PedidosJSON;
GO

------------------------------------------------------------------------------
-- Encerramento do Lote 03
--
-- 021 - Regular Expressions
-- 022 - REGEXP_LIKE
-- 023 - REGEXP_REPLACE
-- 024 - REGEXP_SUBSTR
-- 025 - REGEXP_COUNT
-- 026 - JSON_CONTAINS
-- 027 - Arrays JSON Avançados
-- 028 - JSON Path Wildcards
-- 029 - OPENJSON com Tipo JSON
-- 030 - Atualizações Parciais em JSON
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.ClientesJSON;
GO

DROP TABLE dbo.PedidosJSON;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------