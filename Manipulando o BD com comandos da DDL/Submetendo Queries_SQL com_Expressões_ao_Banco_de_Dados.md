# Submetendo Queries SQL com Expressões ao Banco de Dados

---

## 1. Expressões e alias

Expressões são combinações de colunas, constantes, operadores e funções dentro de uma query. Aliases (`AS`) dão nomes amigáveis a essas expressões no resultado [cite:247][cite:250].

### 1.1. Exemplo em SQL padrão

```sql
SELECT
    salary,
    salary * 1.10 AS salary_com_bonus
FROM employee;
```

- `salary * 1.10` é uma expressão aritmética.
- `AS salary_com_bonus` é o alias da coluna calculada.

### 1.2. Exemplo em MySQL

```sql
SELECT
    salary,
    salary * 0.85 AS salary_liquido
FROM employee;
```

- Mesma lógica: expressão numérica, alias para torná-la legível [cite:218][cite:232].

> Aliases podem ser usados em `ORDER BY` e em cláusulas externas (subqueries/CTEs), mas não são reconhecidos dentro do próprio `WHERE` da mesma instrução, pois o `WHERE` é avaliado antes do alias ser “criado” [cite:243][cite:252].

---

## 2. Função ROUND

A função `ROUND` serve para **arredondar números** a um determinado número de casas decimais. É muito útil para formatar valores de saída (por exemplo, dinheiro, média, porcentagem) [cite:241][cite:244][cite:245].

### 2.1. Sintaxe geral

MySQL:

```sql
ROUND(number, decimals)
```

- `number`: valor numérico.
- `decimals`: número de casas decimais. Se omitido, arredonda para inteiro [cite:241][cite:244].

### 2.2. Exemplos básicos (MySQL)

```sql
SELECT ROUND(123.456) AS rounded_int;
-- Resultado: 123

SELECT ROUND(123.456, 2) AS rounded_two_decimals;
-- Resultado: 123.46

SELECT ROUND(-10.11) AS rounded_negative;
-- Resultado: -10
```

[cite:244][cite:245][cite:253]

### 2.3. ROUND com colunas e alias

```sql
SELECT
    ProductName,
    Price,
    ROUND(Price, 1) AS RoundedPrice
FROM Products;
```

[cite:241][cite:248]

Em MySQL:

```sql
SELECT
    salary,
    ROUND(salary * 1.10, 2) AS salary_com_bonus
FROM employee;
```

- Arredonda o salário com bônus para duas casas decimais.
- O alias `salary_com_bonus` deixa claro o significado da coluna [cite:244][cite:248][cite:253].

---

## 3. Função CONCAT

A função `CONCAT` concatena (junta) duas ou mais strings em uma única saída. Em MySQL, ela é a forma mais comum de construir textos formatados a partir de várias colunas [cite:242][cite:246][cite:249][cite:239].

### 3.1. Sintaxe

```sql
CONCAT(expression1, expression2, expression3, ...)
```

[cite:242][cite:239]

### 3.2. Exemplo básico (MySQL)

```sql
SELECT CONCAT('SQL ', 'Tutorial ', 'is ', 'fun!')
       AS ConcatenatedString;
```

Resultado: `SQL Tutorial is fun!` [cite:242][cite:239].

### 3.3. Concatenando colunas

SQL genérico / MySQL:

```sql
SELECT
    CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;
```

[cite:239]

Outro exemplo:

```sql
SELECT
    CONCAT(Address, ' ', PostalCode, ' ', City) AS Address
FROM Customers;
```

[cite:242][cite:246][cite:249]

---

## 4. Condições WHERE + AND

A cláusula `WHERE` filtra linhas com base em condições; o operador `AND` combina múltiplas condições, exigindo que todas sejam verdadeiras [cite:250].

### 4.1. Exemplo básico em SQL

```sql
SELECT fname, lname, salary
FROM employee
WHERE salary > 3000
  AND dept_id = 10;
```

- Apenas funcionários com salário maior que 3000 **e** pertencentes ao departamento 10.

### 4.2. WHERE combinado com expressões

Você pode usar funções e expressões diretamente no `WHERE`, desde que se refira às **colunas originais**, não aos aliases definidos no `SELECT` [cite:243][cite:252].

#### Exemplo em SQL padrão

```sql
SELECT
    fname,
    lname,
    salary,
    ROUND(salary * 1.10, 2) AS salary_com_bonus
FROM employee
WHERE salary * 1.10 > 4000
  AND dept_id = 10;
```

- O filtro usa `salary * 1.10`, não `salary_com_bonus`, porque o alias ainda não existe na etapa de avaliação do `WHERE` [cite:243][cite:252].

#### Exemplo equivalente em MySQL

```sql
SELECT
    fname,
    lname,
    ROUND(salary * 1.10, 2) AS salary_com_bonus
FROM employee
WHERE salary * 1.10 > 4000
  AND dept_id = 10;
```

---

## 5. Submetendo queries com ROUND, CONCAT e WHERE + AND (SQL / MySQL)

### 5.1. Formatação de salário e nome completo

SQL genérico:

```sql
SELECT
    fname,
    lname,
    CONCAT(fname, ' ', lname) AS full_name,
    salary,
    ROUND(salary * 1.10, 2) AS salary_com_bonus
FROM employee
WHERE salary > 3000
  AND dept_id = 10;
```

MySQL (igual, mesma sintaxe):

- `CONCAT(...)` para juntar nome e sobrenome.
- `ROUND(...)` para formatar salário com bônus.
- `WHERE ... AND ...` para filtrar por salário e departamento [cite:241][cite:242][cite:239].

### 5.2. Formatação de endereço com filtro (MySQL)

```sql
SELECT
    lastname AS Customer,
    CONCAT(Address, ', ', PostalCode, ', ', City) AS Address
FROM customers
WHERE country = 'Singapore';
```

[cite:246]

- Alias `Customer` e `Address` deixam a saída amigável.
- `CONCAT` organiza endereço completo.
- `WHERE country = 'Singapore'` filtra por país.

---

## 6. Exemplo completo – SQL / MySQL

```sql
SELECT
    e.fname,
    e.lname,
    CONCAT(e.fname, ' ', e.lname)          AS full_name,
    e.salary,
    ROUND(e.salary, 2)                     AS salary_formatado,
    ROUND(e.salary * 1.10, 2)              AS salary_com_bonus,
    CONCAT(e.fname, ' ', e.lname, ' - R$ ',
           ROUND(e.salary * 1.10, 2))      AS resumo_funcionario
FROM employee AS e
WHERE e.salary * 1.10 > 4000
  AND e.dept_id = 5;
```

### O que essa query faz

- Usa **expressões aritméticas** (`salary * 1.10`) com `ROUND` para controlar casas decimais [cite:241][cite:244][cite:248][cite:253].
- Usa **CONCAT** para montar strings com nome e valores formatados [cite:242][cite:239][cite:249].
- Usa **aliases** (`full_name`, `salary_com_bonus`, `resumo_funcionario`) para deixar o resultado autoexplicativo [cite:247][cite:250].
- Usa **WHERE + AND** para filtrar por salário com bônus e departamento.

---

## 7. Resumo conceitual

Submeter queries com expressões ao banco significa:

- combinar colunas numéricas com operações e funções (`ROUND`) para controlar precisão e apresentação;
- combinar colunas string com `CONCAT` para criar saídas textuais ricas;
- usar `WHERE` + `AND` para aplicar filtros sobre essas expressões (sempre usando as colunas ou expressões, não aliases);
- usar aliases (`AS`) para nomear os resultados de forma clara e amigável.

Essas técnicas funcionam tanto em SQL genérico quanto em MySQL, com pequenas diferenças de detalhes, e são essenciais para transformar dados brutos em informações úteis para análise e relatórios [cite:241][cite:242][cite:247][cite:239].
