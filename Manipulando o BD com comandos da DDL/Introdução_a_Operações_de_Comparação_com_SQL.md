# Introdução a Operações de Comparação com SQL: LIKE e BETWEEN

---

## 1. LIKE – Comparando padrões em strings

O operador `LIKE` é usado em `WHERE` para buscar **padrões** dentro de colunas de texto. Em vez de comparar igualdade exata (`=`), você busca valores que “comecem com”, “terminem com” ou “que contenham” certo trecho [cite:258][cite:259][cite:261].

### 1.1. Sintaxe geral (SQL / MySQL)

```sql
SELECT coluna1, coluna2
FROM tabela
WHERE coluna_texto LIKE padrão;
```

### 1.2. Wildcards (caracteres especiais)

Com `LIKE`, usamos dois curingas principais:

- `%` – representa zero, um ou muitos caracteres.
- `_` – representa exatamente um caractere [cite:258][cite:259][cite:264][cite:267].

Esses caracteres permitem montar padrões flexíveis sobre strings.

---

## 2. Exemplos com `%` (percent)

### 2.1. Contém um trecho (SQL / MySQL)

```sql
SELECT *
FROM Customers
WHERE City LIKE '%on%';
```

- `%on%` encontra qualquer cidade que tenha `on` em qualquer posição (`London`, `Bronx`, etc.) [cite:258][cite:264].

### 2.2. Começa com um trecho

```sql
SELECT *
FROM Customers
WHERE CustomerName LIKE 'Mar%';
```

- `Mar%` encontra nomes que começam com `Mar` (`Maria`, `Marco`, `Marcos`) [cite:258][cite:264].

### 2.3. Termina com um trecho

```sql
SELECT *
FROM Customers
WHERE CustomerName LIKE '%son';
```

- `%son` encontra nomes que terminam com `son` (`Jackson`, `Henderson`) [cite:258][cite:264].

Em MySQL, esses padrões funcionam exatamente da mesma forma:

```sql
SELECT *
FROM customers
WHERE CustomerName LIKE '%a';
```

[cite:264]

---

## 3. Exemplos com `_` (underscore)

O `_` representa **um único caractere**, qualquer que seja, em uma posição específica [cite:258][cite:259][cite:262][cite:267].

### 3.1. Padrão com comprimento fixo

```sql
SELECT *
FROM Customers
WHERE City LIKE 'L_nd__';
```

- `L_nd__` encontra:
  - cidades que começam com `L`,
  - depois qualquer letra,
  - depois `nd`,
  - depois mais dois caracteres quaisquer (por exemplo, `LondON` numa certa variação de letras) [cite:258].

### 3.2. Posição específica

```sql
SELECT *
FROM Customers
WHERE CustomerName LIKE 'a__%';
```

- `a__%` encontra nomes:
  - que começam com `a`,
  - com pelo menos dois caracteres depois,
  - seguidos por qualquer coisa [cite:258][cite:262].

MySQL segue a mesma ideia:

```sql
SELECT *
FROM customers
WHERE CustomerName LIKE '_u%';
```

- `_u%` encontra textos em que o **segundo caractere** é `u` [cite:262].

---

## 4. Comparando valores persistidos com LIKE (SQL / MySQL)

`LIKE` é usado diretamente sobre **valores persistidos** nas colunas de texto, permitindo buscas flexíveis:

### 4.1. Exemplo genérico

```sql
SELECT fname, lname
FROM employee
WHERE fname LIKE 'Jo%';
```

- Busca funcionários cujo primeiro nome começa com `Jo` (João, John).

### 4.2. Exemplo MySQL com múltiplos padrões

```sql
SELECT *
FROM fiberbox f
WHERE f.fiberBox LIKE '%1740%'
   OR f.fiberBox LIKE '%1938%'
   OR f.fiberBox LIKE '%1940%';
```

[cite:257]

- Cada `LIKE` compara o valor persistido na coluna `fiberBox` com um padrão que inclui `%` (várias possibilidades de texto).

---

## 5. BETWEEN – Comparando faixas de valores

O operador `BETWEEN` é usado em `WHERE` para filtrar valores **dentro de um intervalo**. Ele é **inclusivo**, ou seja, inclui os limites inicial e final [cite:256][cite:260][cite:263][cite:269].

### 5.1. Sintaxe geral (SQL / MySQL)

```sql
SELECT coluna1, coluna2
FROM tabela
WHERE coluna_valor BETWEEN valor_inicio AND valor_fim;
```

- Funciona com números, datas e, em muitos bancos, até com texto (seguindo ordenação alfabética) [cite:256][cite:263].

---

## 6. Exemplos com BETWEEN – números

### 6.1. SQL padrão

```sql
SELECT *
FROM Products
WHERE Price BETWEEN 10 AND 20;
```

- Retorna produtos com preço **entre 10 e 20**, incluindo 10 e 20 [cite:256][cite:260].

### 6.2. MySQL (igual)

```sql
SELECT ProductName, Price
FROM Products
WHERE Price BETWEEN 10 AND 20;
```

- Sintaxe e comportamento são os mesmos [cite:256][cite:260].

---

## 7. Exemplos com BETWEEN – datas

### 7.1. SQL padrão

```sql
SELECT *
FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';
```

- Seleciona pedidos feitos entre 1º e 31 de julho de 1996 (inclusive) [cite:256][cite:260].

### 7.2. MySQL – faixa de vendas

```sql
SELECT *
FROM sales
WHERE date BETWEEN '2023-01-01' AND '2023-03-31';
```

[cite:269]

- Retorna vendas do primeiro trimestre de 2023.

---

## 8. LIKE + BETWEEN: exemplos combinados em consultas mais ricas

Você pode usar `LIKE` e `BETWEEN` juntos em uma mesma query, combinando filtros de texto e de faixa numérica/data com `AND`.

### 8.1. SQL genérico

```sql
SELECT fname, lname, salary, hire_date
FROM employee
WHERE fname LIKE 'Mar%'
  AND salary BETWEEN 3000 AND 6000
  AND hire_date BETWEEN '2020-01-01' AND '2022-12-31';
```

- `LIKE 'Mar%'`: nomes que começam com “Mar”.
- `BETWEEN 3000 AND 6000`: salários nessa faixa.
- `BETWEEN '2020-01-01' AND '2022-12-31'`: funcionários contratados nesse período.

### 8.2. MySQL equivalente

```sql
SELECT fname, lname, salary, hire_date
FROM employee
WHERE fname LIKE 'Mar%'
  AND salary BETWEEN 3000 AND 6000
  AND hire_date BETWEEN '2020-01-01' AND '2022-12-31';
```

- Mesma sintaxe, comportamento igual [cite:256][cite:264][cite:269].

---

## 9. Caracteres especiais `%` e `_` – visão resumida

> caracteres especiais % e _

Eles são os **wildcards** usados com `LIKE`:

- `%`  
  - Zero ou mais caracteres.  
  - Bom para “começa com”, “termina com” e “contém” [cite:258][cite:259][cite:264][cite:267].

- `_`  
  - Um único caractere.  
  - Bom para padrões de tamanho fixo ou posições específicas [cite:259][cite:262][cite:265][cite:267].

Exemplos MySQL:

```sql
-- Qualquer nome que termine com 'a'
SELECT *
FROM customers
WHERE CustomerName LIKE '%a';

-- Qualquer nome com segundo caractere 'u'
SELECT *
FROM customers
WHERE CustomerName LIKE '_u%';
```

[cite:264][cite:262]

---

## 10. Resumo conceitual

Nesta introdução:

- `LIKE` permite comparar valores persistidos **por padrão**, usando `%` e `_` como curingas.
- `%` representa qualquer sequência de caracteres (inclusive zero).
- `_` representa um único caractere.
- `BETWEEN` permite comparar valores dentro de **faixas inclusivas**, útil para números e datas.
- Em SQL e MySQL, esses operadores aparecem quase sempre em `WHERE`, muitas vezes combinados com `AND` para construir filtros mais ricos e precisos [cite:256][cite:258][cite:264][cite:260][cite:269].
