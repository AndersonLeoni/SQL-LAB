```md
# SQL: Explorando a Linguagem de Consulta de Banco de Dados

Uma visão técnica e estruturada sobre SQL (Structured Query Language), abrangendo conceitos fundamentais, Sistemas Gerenciadores de Banco de Dados (SGBDs) e as subdivisões da linguagem (DDL, DML, DCL, DQL).

---

## Introdução ao SQL

A **SQL (Structured Query Language)** é a linguagem padrão utilizada para manipulação de bancos de dados relacionais e execução de operações estruturadas.

Por possuir sintaxe declarativa, é considerada acessível e amplamente utilizada em diferentes áreas:

- **DBAs (Database Administrators):** Gerenciamento e otimização de bancos
- **BI (Business Intelligence):** Análise e geração de relatórios
- **Desenvolvedores:** Integração e persistência de dados
- **Cientistas de Dados:** Exploração e preparação de dados

---

## Objetivos Principais

- Definição e modificação de estrutura (tabelas, schemas)
- Manipulação de registros
- Recuperação eficiente de dados

---

## Cenários de Aplicação: OLTP vs OLAP

### OLTP (Online Transaction Processing)
- Foco em transações rápidas
- Operações frequentes: `INSERT`, `UPDATE`, `DELETE`
- Dados atuais
- Exemplo: sistema de compras

### OLAP (Online Analytical Processing)
- Foco em análise de dados
- Consultas complexas com `SELECT`
- Grandes volumes de dados históricos
- Exemplo: relatórios gerenciais

---

## SGBDs Relacionais

### MySQL
- Simples e rápido
- Muito usado em aplicações web

### PostgreSQL
- Mais robusto e avançado
- Suporte a JSON, dados espaciais e alta conformidade SQL

---

## Subdivisões da Linguagem SQL

```
              Linguagem SQL
                    |
   -----------------------------------------
   |           |             |             |
  DDL         DML           DQL           DCL
```

### DDL — Data Definition Language
Responsável pela estrutura do banco:

- `CREATE`
- `ALTER`
- `DROP`
- `RENAME`
- `TRUNCATE`

---

### DML — Data Manipulation Language
Manipulação de dados:

- `INSERT`
- `UPDATE`
- `DELETE`
- `MERGE` (upsert)

---

### DQL — Data Query Language
Consulta de dados:

- `SELECT`

---

### DCL — Data Control Language
Controle de acesso:

- `GRANT`
- `REVOKE`

---

## Conceitos Fundamentais

- **Usuário:** credencial de acesso
- **Schema:** organização lógica das tabelas
- **Statement:** instrução SQL executável
- **Index:** estrutura que melhora performance de busca

---

## DDL na Prática

```sql
USE teste;

CREATE TABLE person (
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    gender ENUM('M', 'F'),
    birth_date DATE, 
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20), 
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);
```

### O que é CONSTRAINT?

Constraint é uma regra que garante integridade dos dados.

Exemplo:

```sql
CONSTRAINT pk_person PRIMARY KEY (person_id)
```

- Define chave primária
- Impede valores duplicados
- Impede valores nulos

---

# Fundamentos SQL: Comandos, Cláusulas e Modelagem

---

## Classificação dos Comandos

### DML
- Manipulação de dados
- `INSERT`, `UPDATE`, `DELETE`, `MERGE`

### DQL
- Consulta de dados
- `SELECT`

### DCL
- Controle de acesso
- `GRANT`, `REVOKE`

---

## Estrutura SQL

### Statement
Um comando SQL completo executado pelo banco.

---

## Cláusulas SQL

Principais cláusulas:

- `SELECT`
- `FROM`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`

### Ordem lógica de execução

1. `FROM`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`
6. `ORDER BY`

---

## Funções SQL

Funções retornam valores a partir de operações.

Exemplos:
- `NOW()`: data/hora atual
- `COUNT()`: contagem de registros

Observação:
- Em Oracle: `SELECT SYSDATE FROM dual;`

---

## Termos Importantes

- **Identificador:** nome de tabela/coluna
- **Operador:** `=`, `>`, `AND`, `OR`
- **Constante:** valores fixos (`'Maria'`, `10`)
- **Expressão:** combinação que gera resultado

---

## Modelagem de Dados

### Modelo ER (Entidade-Relacionamento)
- Modelo conceitual
- Representa entidades, atributos e relacionamentos

### Modelo Relacional
- Modelo lógico
- Estrutura em tabelas com chaves primárias e estrangeiras

---

## Exemplo Prático

```sql
SELECT cidade, COUNT(*) AS total
FROM clientes
WHERE ativo = 1
GROUP BY cidade
HAVING COUNT(*) > 5
ORDER BY total DESC;
```

### Execução passo a passo

1. FROM → tabela base (`clientes`)
2. WHERE → filtra clientes ativos
3. GROUP BY → agrupa por cidade
4. HAVING → filtra grupos (> 5)
5. SELECT → define saída
6. ORDER BY → ordena resultado

---
```

