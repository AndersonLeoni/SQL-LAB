
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
# Nomes, Aliasing e Variação de Tuplas em SQL

Este material detalha três conceitos importantes na escrita de queries SQL: nomes (identificadores), aliasing e variação de tuplas. Esses elementos ajudam a tornar as consultas mais claras, evitam ambiguidades e permitem trabalhar corretamente com múltiplas tabelas ou com a mesma tabela mais de uma vez na mesma query [1][2][3].

***

## 1. Nomes em SQL

Em SQL, os nomes usados para identificar objetos do banco são chamados de **identificadores**. Eles representam tabelas, colunas, schemas, views, índices e outros elementos da estrutura do banco [4][5].

### Exemplos de identificadores

- Nome de tabela: `employee`
- Nome de coluna: `fname`
- Nome de schema: `company`
- Nome de constraint: `pk_employee`

### Exemplo em query

```sql
SELECT fname, lname
FROM employee;
```

Nesse exemplo:

- `employee` é o nome da tabela.
- `fname` e `lname` são nomes de colunas.

***

## 2. Boas práticas para nomes

Boas convenções de nomenclatura tornam o código mais legível e mais fácil de manter. Guias de estilo costumam recomendar nomes claros, sem espaços, sem palavras reservadas e, de preferência, consistentes em todo o banco [4][6][5].

### Recomendações comuns

- Usar nomes descritivos.
- Evitar abreviações excessivas.
- Evitar espaços em nomes.
- Evitar palavras reservadas do SQL.
- Manter um padrão, como `snake_case`.

### Exemplos

**Bom:**

```sql
employee
employee_address
birth_date
```

**Ruim:**

```sql
emp
Employee Data
select
```

***

## 3. O que é aliasing

**Aliasing** é o uso de nomes temporários para colunas ou tabelas dentro de uma query. O alias não altera o nome real no banco; ele existe apenas durante a execução daquela consulta [1][3][7].

O alias pode ser criado com a palavra-chave `AS`, embora em muitos bancos ela seja opcional [1][3].

***

## 4. Alias de coluna

O alias de coluna é usado para renomear o título exibido no resultado da query. Isso é útil para melhorar a leitura, principalmente quando o nome original é técnico, abreviado ou quando há expressões calculadas [1][2][7].

### Exemplo

```sql
SELECT fname AS primeiro_nome,
       lname AS sobrenome,
       salary AS salario
FROM employee;
```

Nesse caso:

- `fname` será mostrado como `primeiro_nome`
- `lname` será mostrado como `sobrenome`
- `salary` será mostrado como `salario`

### Exemplo com cálculo

```sql
SELECT fname,
       salary,
       salary * 1.10 AS salary_with_bonus
FROM employee;
```

O alias ajuda a dar significado ao resultado da expressão calculada [2][7].

***

## 5. Alias de tabela

O alias de tabela é usado para dar um nome temporário mais curto à tabela dentro da query. Isso é muito útil em consultas maiores, em `JOINs` e em casos em que o nome da tabela é longo [1][8][7].

### Exemplo

```sql
SELECT e.fname, e.lname
FROM employee AS e;
```

Aqui, `e` passa a representar a tabela `employee`.

### Vantagens

- Reduz o tamanho da query.
- Facilita a leitura.
- Evita repetição de nomes longos.
- Ajuda a diferenciar tabelas em consultas com múltiplas relações [8][7].

***

## 6. Ambiguidade de nomes

Quando duas ou mais tabelas possuem colunas com o mesmo nome, é necessário qualificar o atributo com o nome da tabela ou com seu alias. Isso evita ambiguidade e informa ao banco exatamente de onde vem cada coluna [8][3][9].

### Exemplo

Suponha duas tabelas com a coluna `dnumber`:

```sql
SELECT employee.dno, departament.dnumber
FROM employee, departament;
```

Com alias, fica mais claro:

```sql
SELECT e.dno, d.dnumber
FROM employee AS e, departament AS d;
```

Essa qualificação é ainda mais importante em joins.

***

## 7. Variação de tuplas em SQL

No contexto teórico de banco de dados, uma **tupla** é uma linha de uma tabela. Quando uma query percorre tabelas para avaliar condições e combinar dados, ela trabalha com variações dessas tuplas dentro do resultado [2][10][11].

A expressão **variação de tuplas** costuma aparecer associada à ideia de **tuple variables** ou **range variables**, isto é, variáveis que representam temporariamente as tuplas de uma relação durante a execução da consulta [2][11].

Em SQL prático, isso aparece por meio dos aliases de tabela.

***

## 8. Alias como variável de tupla

Quando você escreve:

```sql
SELECT e.fname
FROM employee AS e;
```

O alias `e` funciona como uma variável que representa as tuplas da tabela `employee` durante a query. Isso significa que, para cada linha analisada, `e` referencia uma ocorrência dessa tabela [2][8][11].

Esse conceito vem da teoria relacional e ajuda a entender melhor consultas com mais de uma tabela ou com auto-relacionamentos [2][11].

***

## 9. Variação de tuplas em múltiplas tabelas

Quando há mais de uma tabela na cláusula `FROM`, cada alias representa um conjunto de tuplas diferente. O banco avalia combinações entre essas tuplas para aplicar filtros e relacionamentos [8][9].

### Exemplo

```sql
SELECT e.fname, d.dname
FROM employee AS e, departament AS d
WHERE e.dno = d.dnumber;
```

Nesse exemplo:

- `e` representa tuplas da tabela `employee`
- `d` representa tuplas da tabela `departament`
- a condição `e.dno = d.dnumber` relaciona as duas variações de tuplas

Esse é o raciocínio básico por trás dos joins relacionais [8][9].

***

## 10. Auto-relacionamento e necessidade de alias

O uso de aliases se torna obrigatório quando a mesma tabela aparece mais de uma vez na mesma query, como em um **self join**. Nessa situação, o banco precisa distinguir claramente cada “papel” da tabela [2][3][7].

### Exemplo

Suponha uma tabela `employee` em que `super_ssn` guarda o supervisor do funcionário:

```sql
SELECT e.fname AS funcionario,
       s.fname AS supervisor
FROM employee AS e, employee AS s
WHERE e.super_ssn = s.ssn;
```

Nesse caso:

- `e` representa a tupla do funcionário.
- `s` representa a tupla do supervisor.
- ambas vêm da mesma tabela, mas assumem papéis diferentes [2][3].

Sem alias, a query ficaria ambígua e incorreta.

***

## 11. Relação entre nomes, aliasing e legibilidade

Esses três elementos estão ligados diretamente à qualidade da query. Bons nomes ajudam a entender a estrutura do banco, aliases melhoram a leitura e a teoria de variação de tuplas ajuda a compreender como o banco interpreta cada tabela na consulta [4][3][11].

Na prática:

- nomes claros facilitam manutenção;
- aliases encurtam e organizam queries;
- variáveis de tupla ajudam a raciocinar sobre relacionamentos e autojoins.

***

## 12. Exemplo completo

```sql
SELECT e.fname AS funcionario,
       e.lname AS sobrenome,
       d.dname AS departamento,
       s.fname AS supervisor
FROM employee AS e,
     departament AS d,
     employee AS s
WHERE e.dno = d.dnumber
  AND e.super_ssn = s.ssn;
```

### Interpretação

- `e` é a variação de tupla da tabela `employee` para o funcionário.
- `d` é a variação de tupla da tabela `departament`.
- `s` é outra variação de tupla da tabela `employee`, agora representando o supervisor.
- Os aliases de coluna tornam o resultado mais compreensível.

***

## Resumo conceitual

Em SQL, **nomes** identificam os objetos do banco, **aliases** criam nomes temporários para tabelas e colunas, e a **variação de tuplas** explica como cada alias representa as linhas de uma relação durante a execução da query. Esses conceitos são fundamentais para evitar ambiguidades, melhorar a legibilidade e entender consultas com múltiplas tabelas ou com auto-relacionamentos [1][2][3].

