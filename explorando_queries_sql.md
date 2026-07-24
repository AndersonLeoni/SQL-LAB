# Explorando Queries com SQL

Este material detalha, em blocos, os principais tópicos que você listou: percurso lógico de estudo, comandos DDL, criação de expressões, operações de conjuntos (`UNION`, `INTERSECT`, `EXCEPT`) e nested queries, destacando também a diferença entre DDL e DML onde sua anotação se misturou.

---

## 1. Percurso – Caminho de aprendizado em SQL

Um percurso consistente para estudar queries em SQL costuma seguir esta ordem:

1. **Comandos DDL (Data Definition Language)**  
   Definir a estrutura do banco: tabelas, colunas, tipos de dados, chaves, constraints [cite:184][cite:190].

2. **Criar expressões em SQL**  
   Usar colunas, operadores, funções e aliases para gerar valores derivados, filtros e projeções mais ricas.

3. **Conjuntos com SQL**  
   Combinar resultados de diferentes consultas usando operadores de conjunto (`UNION`, `INTERSECT`, `EXCEPT`) [cite:170][cite:180][cite:188].

4. **Nested Queries (Subqueries)**  
   Resolver problemas em duas ou mais etapas, usando o resultado de uma query como entrada de outra [cite:171][cite:178][cite:186].

Esse percurso te leva de “criar a estrutura” até “compor consultas complexas”, o que é exatamente o que você está fazendo na formação.

---

## 2. Comandos DDL – Data Definition Language

**DDL** é o conjunto de comandos que define e gerencia a estrutura do banco de dados: criação, alteração, renomeação e exclusão de objetos [cite:184][cite:187][cite:190].

> Importante: na sua anotação, `Insert`, `Update`, `Delete` e `Merge` aparecem junto de DDL, mas eles pertencem à **DML (Data Manipulation Language)**, pois manipulam dados, não estrutura [cite:182].

### 2.1. CREATE

Cria um novo objeto: tabela, banco, view etc.

```sql
CREATE TABLE employee (
    ssn   CHAR(9) PRIMARY KEY,
    fname VARCHAR(15) NOT NULL,
    lname VARCHAR(15) NOT NULL,
    bdate DATE
);
```

- Define nome da tabela.
- Define colunas e tipos de dados.
- Pode incluir constraints (PK, FK, UNIQUE, CHECK) [cite:172][cite:184][cite:190].

### 2.2. ALTER

Altera a estrutura de um objeto existente, sem recriá‑lo.

```sql
ALTER TABLE employee
ADD salary DECIMAL(10,2);
```

Outros usos comuns:

- adicionar coluna (`ADD COLUMN`);
- modificar tipo de coluna (dependendo do SGBD);
- remover coluna (`DROP COLUMN`);
- renomear coluna ou tabela (sintaxe varia) [cite:172][cite:184][cite:190].

### 2.3. DROP

Remove o objeto e sua estrutura do banco (irreversível em muitos SGBDs).

```sql
DROP TABLE employee;
```

- Apaga dados + estrutura.
- Deve ser usado com muito cuidado [cite:172][cite:184][cite:187].

### 2.4. TRUNCATE

Remove todas as linhas de uma tabela, mas preserva a estrutura.

```sql
TRUNCATE TABLE employee;
```

- Muito rápido para “zerar” uma tabela.
- Não remove colunas nem constraints.
- Em muitos bancos é tratado como DDL e faz auto‑commit [cite:172][cite:184][cite:190].

### 2.5. RENAME

Altera o nome de uma tabela (ou outro objeto), mantendo dados e estrutura.

```sql
RENAME TABLE employee TO employee_old;
```

Ou via `ALTER TABLE ... RENAME`, dependendo do SGBD [cite:184][cite:190][cite:192].

---

## 3. DML – Data Manipulation Language (sobre sua anotação)

Os comandos abaixo não são DDL, mas vale registrá‑los corretamente:

- `INSERT` – inserir linhas novas.
- `UPDATE` – atualizar linhas existentes.
- `DELETE` – remover linhas.
- `MERGE` – combinar lógica de `INSERT`/`UPDATE` (upsert) [cite:182].

Todos eles atuam sobre dados **dentro** das tabelas, não sobre a estrutura.

---

## 4. Criando expressões com SQL

Expressões combinam colunas, constantes, operadores e funções para produzir novos valores ou filtros.

### 4.1. Expressões em SELECT (projeção)

```sql
SELECT
    fname,
    lname,
    salary,
    salary * 1.10 AS salary_com_bonus
FROM employee;
```

- `salary * 1.10` é expressão aritmética.
- `AS salary_com_bonus` é alias da coluna calculada.

### 4.2. Expressões em WHERE (seleção)

```sql
SELECT fname, lname
FROM employee
WHERE salary > 3000
  AND bdate <= '1990-01-01';
```

- Combinação de operadores de comparação (`>`, `<=`) e lógicos (`AND`).
- Filtra tuplas de acordo com a regra de negócio.

### 4.3. Expressões com funções

```sql
SELECT
    fname,
    UPPER(lname) AS sobrenome_maiusculo,
    YEAR(CURRENT_DATE) - YEAR(bdate) AS idade_aprox
FROM employee;
```

- Uso de funções de string e de data para derivar informações.

---

## 5. Conjuntos com SQL

O SQL implementa operações de **conjuntos** para combinar resultados de consultas, espelhando conceitos matemáticos: união, interseção e diferença [cite:170][cite:180][cite:188].

Regras principais:

- Mesma quantidade de colunas em cada `SELECT`.
- Tipos compatíveis entre colunas correspondentes.
- Resultado é um novo conjunto de linhas.

Os operadores são aplicados entre duas queries:

```sql
SELECT ... FROM ...
UNION / INTERSECT / EXCEPT
SELECT ... FROM ...;
```

---

## 6. Comandos baseados em operações de conjunto

### 6.1. UNION

Une os resultados de duas consultas, removendo duplicatas por padrão [cite:170][cite:180][cite:183].

```sql
SELECT fname AS nome
FROM employee
UNION
SELECT dependent_name AS nome
FROM dependent;
```

- Retorna todos os nomes presentes como `fname` ou `dependent_name`, sem repetir.

`UNION ALL` mantém duplicatas (mais rápido, não faz eliminação de repetidos):

```sql
SELECT fname AS nome
FROM employee
UNION ALL
SELECT dependent_name AS nome
FROM dependent;
```

### 6.2. INTERSECT

Retorna apenas as linhas que aparecem nas duas consultas (interseção) [cite:170][cite:180][cite:191].

```sql
SELECT fname FROM employee
INTERSECT
SELECT dependent_name FROM dependent;
```

- Mostra nomes que aparecem em ambos os conjuntos.

### 6.3. EXCEPT

Retorna as linhas da primeira consulta que **não aparecem** na segunda (diferença) [cite:170][cite:180][cite:188].

```sql
SELECT fname FROM employee
EXCEPT
SELECT dependent_name FROM dependent;
```

- Lista funcionários cujo nome não aparece em `dependent_name`.

> Observação: alguns bancos usam `MINUS` no lugar de `EXCEPT`, mas a ideia é a mesma (diferença de conjuntos).

---

## 7. Nested Queries (Subqueries)

**Nested queries** ou **subqueries** são consultas dentro de outras consultas. A query interna gera um resultado intermediário, que é usado pela query externa [cite:171][cite:178][cite:186].

### 7.1. Conceito

- A subquery roda primeiro (inner query).
- O resultado alimenta a query externa (outer query).
- Subqueries podem aparecer em `SELECT`, `FROM`, `WHERE`, `HAVING`, etc. [cite:171][cite:181][cite:189].

### 7.2. Subquery em WHERE com IN

```sql
SELECT fname, lname
FROM employee
WHERE dno IN (
    SELECT dnumber
    FROM departament
    WHERE dname = 'Research'
);
```

- A subquery acha o(s) `dnumber` do departamento “Research”.
- A query externa recupera funcionários cujos `dno` estão nesse conjunto.

### 7.3. Subquery correlacionada

Subquery que depende de valores da linha atual da query externa:

```sql
SELECT fname, lname
FROM employee e
WHERE salary > (
    SELECT AVG(salary)
    FROM employee
    WHERE dno = e.dno
);
```

- Para cada funcionário `e`, a subquery calcula a média salarial do departamento de `e`.
- A condição seleciona funcionários com salário acima da média do próprio departamento [cite:171][cite:186].

### 7.4. Subquery em FROM (tabela derivada)

```sql
SELECT d.dname, c.total
FROM (
    SELECT dno, COUNT(*) AS total
    FROM employee
    GROUP BY dno
) AS c
JOIN departament d
    ON c.dno = d.dnumber;
```

- A subquery gera uma “tabela” com `dno` e `total`.
- Essa tabela derivada (`c`) é usada em um `JOIN` com `departament`.

---

## 8. Amarrando tudo: DDL + expressões + conjuntos + nested

Um fluxo típico na prática:

1. **DDL** (CREATE/ALTER/DROP/TRUNCATE/RENAME) define e ajusta a estrutura das tabelas onde os dados vão viver [cite:172][cite:184][cite:190].
2. **DML** (`INSERT`, `UPDATE`, `DELETE`, `MERGE`) manipula as linhas, persistindo novas informações ou alterando existentes [cite:182].
3. **Expressões** em `SELECT` e `WHERE` refinam a consulta (cálculos, filtros, aliases).
4. **Set operations** (`UNION`, `INTERSECT`, `EXCEPT`) combinam resultados de múltiplas queries como conjuntos [cite:170][cite:180][cite:188].
5. **Nested queries** quebram problemas complexos em etapas menores e reutilizam resultados intermediários dentro da mesma instrução SQL [cite:171][cite:178][cite:186].

Esse encadeamento é a base para sair do “SQL básico” e caminhar para consultas mais avançadas e expressivas.
