/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - JSON_ARRAY.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função JSON_ARRAY() para
 geração de arrays JSON no SQL Server 2025.

 Contexto...:
 A função JSON_ARRAY() permite criar arrays JSON de
 forma simples e padronizada.

 Este recurso é útil na construção de APIs, geração
 de documentos JSON, integrações, auditorias,
 exportações de dados e composição de estruturas
 complexas baseadas em resultados relacionais.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Criação de arrays JSON simples
 - Criação de arrays mistos
 - Estruturas para APIs
 - Catálogos de produtos
 - Preferências de usuários
 - Integração com consultas SQL

 Referências:
 https://learn.microsoft.com/
******************************************************************************/

------------------------------------------------------------------------------
-- Banco de Dados de Trabalho
------------------------------------------------------------------------------

USE tempdb;
GO

------------------------------------------------------------------------------
-- Exemplo 01
-- Array Simples de Tecnologias
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'SQL Server',
        'Azure',
        'Power BI',
        'Microsoft Fabric'
    ) AS Tecnologias;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Array de Valores Inteiros
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        10,
        20,
        30,
        40,
        50
    ) AS Valores;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Array com Valores Decimais
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        12.50,
        15.75,
        99.90,
        150.00
    ) AS Precos;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Array Misturando Tipos
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Notebook',
        4500.00,
        TRUE,
        NULL
    ) AS Produto;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Informações de Curso
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Banco de Dados',
        'Engenharia de Software',
        'Desenvolvimento Web',
        'Cloud Computing'
    ) AS Disciplinas;
GO

------------------------------------------------------------------------------
-- Criação de Ambiente de Exemplo
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Produtos;
GO

CREATE TABLE dbo.Produtos
(
    IdProduto       INT IDENTITY(1,1)
                    CONSTRAINT PK_Produtos
                    PRIMARY KEY,

    NomeProduto     VARCHAR(100)
                    NOT NULL,

    Categoria       VARCHAR(50)
                    NOT NULL,

    PrecoVenda      DECIMAL(10,2)
                    NOT NULL
);
GO

------------------------------------------------------------------------------
-- Carga de Dados
------------------------------------------------------------------------------

INSERT INTO dbo.Produtos
(
    NomeProduto,
    Categoria,
    PrecoVenda
)
VALUES
(
    'Notebook Dell',
    'Informatica',
    4599.90
),
(
    'Monitor LG',
    'Monitores',
    1299.90
),
(
    'Mouse Logitech',
    'Perifericos',
    149.90
),
(
    'Teclado Microsoft',
    'Perifericos',
    299.90
);
GO

------------------------------------------------------------------------------
-- Visualização dos Dados
------------------------------------------------------------------------------

SELECT
    P.IdProduto,
    P.NomeProduto,
    P.Categoria,
    P.PrecoVenda
FROM dbo.Produtos AS P
ORDER BY
    P.NomeProduto;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Array Manual de Produtos
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Notebook Dell',
        'Monitor LG',
        'Mouse Logitech',
        'Teclado Microsoft'
    ) AS Produtos;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Preferências de Usuário
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Tema Escuro',
        'Notificacoes',
        'Idioma Portugues',
        'Backup Automatico'
    ) AS Preferencias;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Categorias de Produtos
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Informatica',
        'Monitores',
        'Perifericos',
        'Acessorios'
    ) AS Categorias;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Permissões de Usuário
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'SELECT',
        'INSERT',
        'UPDATE'
    ) AS Permissoes;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Composição de Estrutura JSON Maior
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Empresa':'Anglo Sao Roque',
        'Tecnologias':
            JSON_ARRAY
            (
                'SQL Server',
                'Azure',
                'Power BI'
            )
    ) AS DocumentoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Simulação de API
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Sucesso':TRUE,
        'Mensagem':'Consulta realizada',
        'Codigos':
            JSON_ARRAY
            (
                1001,
                1002,
                1003
            )
    ) AS RespostaAPI;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Catálogo Acadêmico
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Sistemas para Internet',
        'Analise e Desenvolvimento de Sistemas',
        'Gestao Empresarial'
    ) AS CursosFatec;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Áreas de Conhecimento
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Banco de Dados',
        'Programacao',
        'Redes',
        'Seguranca',
        'IA'
    ) AS Areas;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Matérias de um Semestre
------------------------------------------------------------------------------

SELECT
    JSON_ARRAY
    (
        'Engenharia de Software',
        'Banco de Dados',
        'Programacao Web',
        'UX',
        'Arquitetura da Informacao'
    ) AS Disciplinas;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- APIs REST
-- Microsserviços
-- Catálogo de Produtos
-- Preferências de Usuários
-- Perfis e Permissões
-- ERP
-- CRM
-- E-commerce
-- LMS
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilize JSON_ARRAY() para criar listas simples.
--
-- 2) Combine JSON_ARRAY() com JSON_OBJECT()
--    para gerar documentos completos.
--
-- 3) Evite montar arrays manualmente usando
--    concatenação de strings.
--
-- 4) Padronize estruturas utilizadas por APIs.
--
-- 5) Utilize arrays para representar coleções
--    e relacionamentos do tipo lista.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.Produtos;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------