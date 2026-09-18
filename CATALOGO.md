# Catálogo de Scripts SQL Server

Este catálogo tem como objetivo facilitar a navegação pelo acervo de scripts disponíveis neste repositório.

A base de conhecimento reúne estudos, experimentos, exemplos práticos, projetos, materiais de treinamento, troubleshooting, monitoramento e soluções desenvolvidas ao longo de anos de utilização do Microsoft SQL Server.

---

# Dimensão do Acervo

- 📂 Mais de 90 categorias técnicas
- 📄 Mais de 1.5030 arquivos
- 💾 Compatível com SQL Server 2000 até SQL Server 2025
- 📚 Conteúdo básico, intermediário e avançado
- 🤖 Inteligência Artificial Aplicada ao SQL Server
- 🔎 Busca Vetorial e Pesquisa Semântica
- 🔍 Administração de Banco de Dados
- ⚡ Performance Tuning
- 📈 Monitoramento e Troubleshooting
- 🔒 Segurança e Criptografia
- 🔄 Backup, Restore e Recovery
- 🧠 Transaction Log Internals
- 📊 XML, Query Store e Recursos Avançados
- 🎓 Material utilizado em estudos, treinamentos e apresentações técnicas
- 🏆 Projetos completos de simulação da Copa do Mundo utilizando T-SQL

---

# Estatísticas do Acervo

| Categoria | Quantidade Aproximada |
|------------|------------:|
| Desenvolvimento T-SQL | 260+ |
| Administração SQL Server | 300+ |
| Performance Tuning | 180+ |
| Monitoramento e Diagnóstico | 120+ |
| Segurança | 60+ |
| Recovery e Transaction Log | 80+ |
| Índices | 35+ |
| Query Store | 25+ |
| XML | 30+ |
| Backup e Restore | 40+ |
| Versões do SQL Server | 120+ |
| Livros e Treinamentos | 150+ |
| Projetos Especiais | 100+ |

---

# Cobertura Técnica

| Área | Cobertura |
|--------|-----------|
| Administração SQL Server | ⭐⭐⭐⭐⭐ |
| Desenvolvimento T-SQL | ⭐⭐⭐⭐⭐ |
| Performance Tuning | ⭐⭐⭐⭐⭐ |
| Monitoramento | ⭐⭐⭐⭐⭐ |
| Índices | ⭐⭐⭐⭐⭐ |
| Transaction Log | ⭐⭐⭐⭐⭐ |
| Backup e Restore | ⭐⭐⭐⭐⭐ |
| Segurança | ⭐⭐⭐⭐ |
| Query Store | ⭐⭐⭐⭐ |
| XML | ⭐⭐⭐⭐ |
| JSON Avançado | ⭐⭐⭐⭐ |
| Inteligência Artificial e Busca Vetorial | ⭐⭐⭐⭐ |
| Expressões Regulares (REGEXP) | ⭐⭐⭐⭐ |
| Service Broker | ⭐⭐⭐ |
| Spatial Data | ⭐⭐⭐ |
| Memory Optimized Data | ⭐⭐⭐ |

---

# Áreas com Maior Cobertura

1. Administração SQL Server
2. Desenvolvimento T-SQL
3. Performance Tuning
4. Monitoramento e Diagnóstico
5. Índices e Estatísticas
6. Transaction Log
7. Backup e Restore
8. Segurança
9. Query Store
10. Recuperação de Dados
11. JSON Avançado
12. IA e Busca Vetorial

---

# Sumário

- Desenvolvimento
- Administração
- Performance
- Monitoramento
- Segurança
- Recovery
- Recursos Avançados
- Compatibilidade por Versão
- SQL Server 2025
- Projetos Especiais
- Livros e Materiais de Estudo

---

# Desenvolvimento

## Functions

### Conceitos Básicos

- Criação de Functions
- Scalar Functions
- Multi Statement Functions
- Table-Valued Functions

### Exemplos Intermediários

- Function + Computed Columns
- Function + Criptografia
- Function + Outer Apply
- Function + Datas

### Exemplos Avançados

- Geração de Senhas
- Funções Não Documentadas
- LaborDay
- Manipulação de Strings

---

## Stored Procedures

### Conceitos Básicos

- Criação
- Parâmetros
- Tratamento de Erros
- Versionamento

### Intermediário

- Controle de Concorrência
- Procedures Administrativas
- Procedures de Diagnóstico

### Avançado

- Checklists Automatizados
- Monitoramento
- Rebuild de Índices
- Importação de Logs

---

## Triggers

- Triggers DML
- Triggers DDL
- Triggers de Logon
- Triggers entre Bancos
- Triggers com Bulk Insert

---

## Views

- Views Simples
- Views Indexadas
- Views Criptografadas
- OpenRowset + Views

---

## CTE

- CTE Básica
- CTE Recursiva
- Hierarquias
- Calendários
- Monitoramento de Processos

---

## Query Dinâmica

- SP_ExecuteSQL
- Pivot Dinâmico
- SQL Dinâmico Parametrizado
- Cross Database Query

---

# Administração

## Backup e Restore

- Backup Full
- Backup Diferencial
- Backup de Log
- Restore Point in Time
- Database Snapshot
- Estratégias de Recuperação

---

## DBCC

- CHECKDB
- CHECKFILEGROUP
- PAGE
- LOGINFO
- OPENTRAN

---

## TempDB

- Monitoramento
- Contenção
- Crescimento
- Troubleshooting

---

## Filegroups

- Criação
- Migração
- Partition Function
- Partition Scheme

---

## Jobs and Steps

- SQL Agent Jobs
- Schedules
- Histórico
- Automação

---

# Performance

## Índices

- Fragmentação
- Missing Index
- Fill Factor
- Índices Clusterizados
- Índices Não Clusterizados
- Compressão
- Cobertura

---

## Estatísticas

- Histogramas
- Atualização
- Estatísticas Filtradas
- Cardinalidade

---

## Plano de Execução

### Lookup

- Key Lookup
- RID Lookup

### Join Operators

- Nested Loops
- Merge Join
- Hash Join

### Scan e Seek

- Table Scan
- Index Scan
- Index Seek

### Sort e Spool

- Sort
- Lazy Spool
- Eager Spool
- Row Count Spool

---

## Query Store

- Configuração
- Limpeza
- Force Plan
- Regressão de Performance
- Top Consultas

---

## Wait Statistics

- CPU Pressure
- Wait Queues
- Session Waits
- Troubleshooting

---

# Monitoramento

## WhoIsActive

- Captura de Sessões
- Log Histórico
- Blocking Sessions

## Auditoria

- SQL Audit
- Default Trace
- Eventos de Segurança

## Extended Events

- Deadlocks
- Sort Warnings
- Blocked Process

---

# Segurança

## Logins e Usuários

- Criação
- Migração
- Permissões
- Proxy Accounts

## Criptografia

- Hash
- Chaves Simétricas
- Certificados
- Proteção de Dados

## Permissões

- Roles
- Grants
- Schemas
- Endpoints

---

# Recovery

## Transaction Log

- LSN
- VLF
- fn_dblog
- Recuperação de Dados

## Recuperação

- Banco SUSPECT
- Emergency Mode
- Recuperação de Páginas

---

# Recursos Avançados

## Service Broker

- Filas
- Contratos
- Mensagens
- Processamento Assíncrono

## XML

- XQuery
- FOR XML
- XML Indexes
- XML Data Type

## Spatial Data

- Geography
- Geometry

## Memory Optimized Data

- In-Memory OLTP
- Memory Optimized Tables

---

# Compatibilidade por Versão

- SQL Server 2000
- SQL Server 2005
- SQL Server 2008
- SQL Server 2012
- SQL Server 2014
- SQL Server 2016
- SQL Server 2017
- SQL Server 2019
- SQL Server 2022
- SQL Server 2025
  
---
---

# SQL Server 2025

## Novidades Implementadas

A pasta SQL Server 2025 reúne aproximadamente 30 scripts desenvolvidos para estudar e demonstrar os novos recursos introduzidos na plataforma.

## JSON

- Tipo de Dados JSON
- JSON_ARRAY
- JSON_OBJECT
- JSON_CONTAINS
- JSON_PATH_EXISTS
- JSON Path Wildcards
- OPENJSON com Tipo JSON
- Atualizações Parciais em JSON
- Índices JSON
- Validação de Documentos JSON

## VECTOR e Inteligência Artificial

- Tipo de Dados VECTOR
- Conversão para VECTOR
- Conversão de VECTOR para JSON
- Variáveis VECTOR
- Vetores Float16
- Inserção de Embeddings
- Busca Vetorial de Documentos
- Busca por Similaridade
- Busca Híbrida
- Catálogo Vetorial de Produtos

## Expressões Regulares

- REGEXP_COUNT
- REGEXP_LIKE
- REGEXP_REPLACE
- REGEXP_SUBSTR
- Regular Expressions

## Quantidade de Scripts

- Aproximadamente 30 scripts dedicados aos novos recursos do SQL Server 2025.
- 
# Projetos Especiais

## Copa do Mundo 2022

Simulador completo da Copa do Mundo FIFA utilizando SQL Server.

## Copa do Mundo Feminina 2023

Simulador completo da Copa do Mundo Feminina FIFA utilizando SQL Server.

## Copa do Mundo 2026

Versão atualizada contemplando o novo formato da competição.

## Tabela de Endereçamento IPv4

Projeto para geração de todos os endereços IPv4 utilizando SQL Server.

## Controle de Perda por Lote

Procedures de análise e acompanhamento de produção.

---

# Livros e Materiais de Estudo

## Transact-SQL Fundamentals

- SQL Server 2008
- SQL Server 2012
- SQL Server 2012-2016
- SQL Server 2014-2022

## Querying Microsoft SQL Server 2012 (70-461)

- Exercícios
- Soluções
- Scripts dos capítulos

## SQL para Análise de Dados

- Séries Temporais
- Cohorts
- Text Analysis
- Anomaly Detection
- Experiment Analysis

---

# Legenda de Níveis

🟢 Básico

🟡 Intermediário

🟠 Avançado

🔴 Especialista

---

# Última Atualização

### Setembro de 2026

- Inclusão da categoria SQL Server 2025.
- Inclusão de aproximadamente 30 novos scripts.
- Inclusão de exemplos sobre JSON, VECTOR, Embeddings e Busca Vetorial.
- Atualização das estatísticas do acervo.
- Revisão da documentação do projeto.

Manter este catálogo atualizado conforme novas categorias, scripts e estudos forem adicionados ao repositório.
