/******************************************************************************
 Nome.......: SQL Server 2025 - Novidade - JSON_OBJECT.sql
 Autor......: Pedro Antonio Galvão Junior
 Data.......: 2026-09-17
 Versão.....: 1.0

 Objetivo...:
 Demonstrar a utilização da função JSON_OBJECT()
 para construção de documentos JSON.

 Contexto...:
 A função JSON_OBJECT() simplifica a criação de objetos
 JSON diretamente em consultas SQL, reduzindo a necessidade
 de manipulação manual de strings.

 Pode ser utilizada em APIs, integrações, relatórios,
 exportação de dados, auditoria e composição de documentos
 complexos.

 Requisitos.:
 - SQL Server 2025
 - Compatibilidade 170 ou superior

 Resultado..:
 - Criação de objetos JSON simples
 - Criação de objetos aninhados
 - Integração com JSON_ARRAY()
 - Construção de respostas de APIs
 - Geração de documentos corporativos

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
-- Objeto Simples
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Nome':'Pedro Antonio Galvao Junior',
        'Cidade':'Sao Roque',
        'Estado':'SP'
    ) AS DocumentoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 02
-- Objeto com Valores Numéricos
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Codigo':1001,
        'Descricao':'Notebook',
        'Preco':4599.90
    ) AS Produto;
GO

------------------------------------------------------------------------------
-- Exemplo 03
-- Objeto com Valores Booleanos
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Ativo':TRUE,
        'PermiteLogin':TRUE,
        'Administrador':FALSE
    ) AS Usuario;
GO

------------------------------------------------------------------------------
-- Exemplo 04
-- Objeto de Configuração
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Tema':'Escuro',
        'Idioma':'pt-BR',
        'Notificacoes':TRUE
    ) AS Configuracao;
GO

------------------------------------------------------------------------------
-- Exemplo 05
-- Objeto Aninhado
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Cliente':'Pedro Antonio Galvao Junior',
        'Endereco':
            JSON_OBJECT
            (
                'Cidade':'Sao Roque',
                'Estado':'SP',
                'Pais':'Brasil'
            )
    ) AS ClienteJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 06
-- Integração com JSON_ARRAY
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Aluno':'Pedro',
        'Cursos':
            JSON_ARRAY
            (
                'SQL Server',
                'Power BI',
                'Azure'
            )
    ) AS AlunoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 07
-- Documento Corporativo
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Empresa':'Anglo Sao Roque',
        'Departamento':'Tecnologia',
        'Responsavel':'Pedro Antonio Galvao Junior'
    ) AS EmpresaJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 08
-- Resposta Simples de API
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Sucesso':TRUE,
        'Mensagem':'Operacao realizada com sucesso',
        'CodigoRetorno':200
    ) AS RespostaAPI;
GO

------------------------------------------------------------------------------
-- Exemplo 09
-- Resposta de API com Dados
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Sucesso':TRUE,

        'Dados':
            JSON_OBJECT
            (
                'IdCliente':1,
                'Nome':'Pedro'
            )
    ) AS RespostaAPI;
GO

------------------------------------------------------------------------------
-- Ambiente de Demonstração
------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Clientes;
GO

CREATE TABLE dbo.Clientes
(
    IdCliente        INT IDENTITY(1,1)
                     CONSTRAINT PK_Clientes
                     PRIMARY KEY,

    NomeCliente      VARCHAR(100),
    Cidade           VARCHAR(100),
    Estado           CHAR(2)
);
GO

------------------------------------------------------------------------------
-- Carga de Dados
------------------------------------------------------------------------------

INSERT INTO dbo.Clientes
(
    NomeCliente,
    Cidade,
    Estado
)
VALUES
(
    'Pedro Antonio Galvao Junior',
    'Sao Roque',
    'SP'
),
(
    'Maria Aparecida',
    'Sorocaba',
    'SP'
),
(
    'Carlos Eduardo',
    'Jundiai',
    'SP'
);
GO

------------------------------------------------------------------------------
-- Consulta Relacional
------------------------------------------------------------------------------

SELECT
    C.IdCliente,
    C.NomeCliente,
    C.Cidade,
    C.Estado
FROM dbo.Clientes AS C;
GO

------------------------------------------------------------------------------
-- Exemplo 10
-- Transformação Relacional para JSON
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'IdCliente':C.IdCliente,
        'NomeCliente':C.NomeCliente,
        'Cidade':C.Cidade,
        'Estado':C.Estado
    ) AS ClienteJSON
FROM dbo.Clientes AS C;
GO

------------------------------------------------------------------------------
-- Exemplo 11
-- Documento Mais Completo
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Cliente':
            JSON_OBJECT
            (
                'Codigo':1,
                'Nome':'Pedro Antonio Galvao Junior'
            ),

        'Cursos':
            JSON_ARRAY
            (
                'SQL Server',
                'Azure',
                'Power BI'
            ),

        'Ativo':TRUE
    ) AS DocumentoCompleto;
GO

------------------------------------------------------------------------------
-- Exemplo 12
-- Catálogo de Produto
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Codigo':'NOTE001',

        'Descricao':'Notebook Dell',

        'Especificacoes':
            JSON_OBJECT
            (
                'Memoria':'16 GB',
                'SSD':'512 GB',
                'Processador':'Core i7'
            )
    ) AS ProdutoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 13
-- Dados Acadêmicos
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Instituicao':'Fatec Sao Roque',

        'Curso':'Sistemas para Internet',

        'Semestre':3
    ) AS CursoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 14
-- Estrutura para Mensageria
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Evento':'PedidoCriado',

        'DataEvento':
            CONVERT
            (
                VARCHAR(19),
                GETDATE(),
                120
            ),

        'Origem':'ERP'
    ) AS EventoJSON;
GO

------------------------------------------------------------------------------
-- Exemplo 15
-- Configuração de Aplicação
------------------------------------------------------------------------------

SELECT
    JSON_OBJECT
    (
        'Aplicacao':'PortalAcademico',

        'Configuracoes':
            JSON_OBJECT
            (
                'Idioma':'pt-BR',
                'Tema':'Escuro',
                'Timeout':30
            )
    ) AS ConfiguracaoJSON;
GO

------------------------------------------------------------------------------
-- Casos de Uso Corporativos
--
-- APIs REST
-- Integrações ERP
-- Integrações CRM
-- Mensageria
-- Data Lake
-- Auditoria
-- Catálogo de Produtos
-- Portais Corporativos
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Boas Práticas
--
-- 1) Utilize JSON_OBJECT() para construção formal
--    de documentos JSON.
--
-- 2) Evite concatenação manual de strings JSON.
--
-- 3) Combine JSON_OBJECT() com JSON_ARRAY().
--
-- 4) Utilize objetos aninhados para representar
--    estruturas hierárquicas.
--
-- 5) Mantenha nomenclatura consistente das propriedades.
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Limpeza Opcional
------------------------------------------------------------------------------

/*

DROP TABLE dbo.Clientes;
GO

*/

------------------------------------------------------------------------------
-- Fim do Script
------------------------------------------------------------------------------