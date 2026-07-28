```md
# Elaborando Queries com Expressões em SQL

Este material complementa sua anotação sobre elaboração de queries usando expressões aritméticas, operações matemáticas, dados numéricos e strings, e o uso de alias para deixar os resultados mais claros e úteis.

---

## 1. Atributos aritméticos e operações matemáticas

Em SQL, você pode aplicar operações matemáticas diretamente sobre colunas numéricas dentro de um `SELECT`, `WHERE` ou `ORDER BY`. Essas colunas passam a funcionar como **atributos aritméticos**, isto é, valores sobre os quais você realiza cálculos [cite:208][cite:210].

### 1.1. Operadores básicos

Principais operadores aritméticos:

- `+` soma
- `-` subtração
- `*` multiplicação
- `/` divisão

Eles podem ser usados com colunas numéricas, constantes e outras expressões [cite:209][cite:210].

### 1.2. Exemplo simples

```sql
SELECT
    fname,
    lname,
    salary,
    salary * 1.10 AS salary_com_bonus
FROM employee;
```

- `salary * 1.10` calcula um aumento de 10% sobre o salário.
- `AS salary_com_bonus` é um **alias** que dá nome ao resultado da expressão.

### 1.3. Cálculo com duas colunas

```sql
SELECT
    price,
    quantity,
    price * quantity AS total_value
FROM inventory;
```

Aqui, `price * quantity` calcula o valor total em estoque por item, e o alias `total_value` torna o resultado mais compreensível [cite:218].

> As operações não modificam o dado armazenado na tabela; elas apenas mudam o resultado exibido pela consulta [cite:208][cite:210].

---

## 2. Dados string e numéricos

Em SQL, os tipos de dados podem ser:

- **Numéricos**: `INT`, `DECIMAL`, `FLOAT` etc.
- **Strings**: `CHAR`, `VARCHAR`, `TEXT` etc. [cite:215]

As operações possíveis dependem do tipo:

- Em colunas **numéricas**, você usa operadores aritméticos para somas, produtos, médias, percentuais.
- Em colunas **string**, o foco é em concatenação e funções de texto (como `UPPER`, `LOWER`, `SUBSTRING`) [cite:208][cite:215].

### 2.1. Exemplo misturando tipos

```sql
SELECT
    fname,
    lname,
    salary,
    salary * 0.15 AS imposto_estimado
FROM employee;
```

- `fname` e `lname` são strings.
- `salary` é numérico.
- A expressão é aplicada apenas sobre o valor numérico.

Em bancos como MySQL, operações matemáticas sobre strings podem ter comportamento inesperado (ex.: tratar string como 0), por isso não é uma prática recomendada [cite:208].

---

## 3. Armazenamento x resultado: simples e complexos

Sua anotação:

> armazenamento: dados simples  
> resultados: dados complexos

A ideia por trás disso é:

- **Armazenamento – dados simples**:  
  As tabelas guardam valores básicos e “atômicos” (salário, quantidade, nome, data). A estrutura fica limpa e normalizada.

- **Resultados – dados complexos**:  
  As queries combinam esses dados simples em **expressões** (totais, médias, percentuais, textos formatados), sem criar colunas físicas novas para cada variação [cite:214].

### 3.1. Exemplo de dados simples x complexos

Estrutura simples:

```sql
CREATE TABLE sale (
    sale_id    INT PRIMARY KEY,
    unit_price DECIMAL(10,2),
    quantity   INT
);
```

Resultados complexos:

```sql
SELECT
    sale_id,
    unit_price,
    quantity,
    unit_price * quantity AS total_sale
FROM sale;
```

- A tabela guarda apenas `unit_price` e `quantity`.
- A query calcula `total_sale` dinamicamente.

### 3.2. Computed columns (conceito)

Alguns SGBDs permitem criar colunas calculadas na própria DDL (`CREATE TABLE`), sempre derivadas de outras colunas, mas a lógica é a mesma: dados simples armazenados, dados complexos gerados por expressão [cite:214].

---

## 4. Plus: utilizar alias

Aliases (apelidos) são nomes temporários dados a colunas, incluindo colunas calculadas. Eles deixam as queries mais legíveis e os resultados mais autoexplicativos [cite:92][cite:207][cite:230].

### 4.1. Alias em expressão aritmética

```sql
SELECT
    fname,
    lname,
    salary,
    salary * 1.10 AS salary_com_bonus,
    salary * 0.15 AS imposto_estimado
FROM employee;
```

- `salary_com_bonus` e `imposto_estimado` são aliases de colunas calculadas.

### 4.2. Alias usado no ORDER BY

```sql
SELECT
    name,
    price,
    quantity,
    price * quantity AS total_value
FROM inventory
ORDER BY total_value DESC;
```

- O alias `total_value` é usado para ordenar o resultado pelo valor calculado [cite:218].

> Em geral, você não pode usar o alias dentro da mesma expressão do `SELECT` (por exemplo, fazer novo cálculo sobre o alias na mesma lista). Para reutilizar um alias em cálculos, usa-se subqueries ou CTEs [cite:216][cite:223][cite:228].

---

## 5. Conectando strings

Além de números, é muito comum criar expressões com strings, como montar nome completo, formatar documentos ou construir mensagens.

### 5.1. CONCAT – forma portátil

Em MySQL, PostgreSQL e outros bancos, a forma mais compatível de concatenar strings é a função `CONCAT` [cite:217][cite:225][cite:239].

```sql
SELECT
    CONCAT(fname, ' ', lname) AS full_name
FROM employee;
```

Outro exemplo:

```sql
SELECT
    CONCAT(fname, ' ', lname, ' - CPF: ', cpf) AS cliente_info
FROM bankClient;
```

- Junta várias partes em uma única string, com separadores.

### 5.2. Concatenar strings com pipes (`||`)

Sua anotação menciona “concatenar strings com pipes”. O operador `||` é o padrão ANSI para concatenação de strings, usado em Oracle, PostgreSQL e, com configuração, em MySQL [cite:211][cite:212][cite:237].

```sql
SELECT
    fname || ' ' || lname AS full_name
FROM employee;
```

Em MySQL, por padrão, `||` é tratado como `OR` lógico. Para que funcione como concatenação, é preciso ativar o modo `PIPES_AS_CONCAT` [cite:211][cite:224][cite:233][cite:236]:

```sql
SET @@session.sql_mode = 'PIPES_AS_CONCAT';

SELECT 'Hello' || ' ' || 'World' AS greeting;
```

Essa consulta passa a retornar `Hello World`, com `||` atuando como operador de concatenação [cite:211][cite:224][cite:233].

### 5.3. CONCAT vs. `||` em MySQL

No dia a dia:

- Use `CONCAT(...)` como padrão (mais portável e direto).
- Use `||` apenas se você tiver configurado o modo `PIPES_AS_CONCAT` e quiser seguir sintaxe ANSI [cite:217][cite:221][cite:234].

---

## 6. Exemplo completo de query com expressões

```sql
SELECT
    e.fname,
    e.lname,
    CONCAT(e.fname, ' ', e.lname) AS full_name,
    e.salary,
    e.salary * 1.10 AS salary_com_bonus,
    e.salary * 0.15 AS imposto_estimado,
    e.salary * 0.85 AS salary_liquido
FROM employee AS e
ORDER BY salary_liquido DESC;
```

### O que está acontecendo

- **Strings**: `CONCAT(e.fname, ' ', e.lname)` monta o nome completo (`full_name`).
- **Números**:
  - `salary_com_bonus`: salário com 10% de aumento.
  - `imposto_estimado`: exemplo de imposto de 15%.
  - `salary_liquido`: salário após desconto de 15%.
- **Aliases**: cada expressão recebe um nome claro, facilitando análise e ordenação [cite:218][cite:232][cite:230].

---

## 7. Resumo conceitual

Elaborar queries com expressões significa:

- usar colunas numéricas em operações aritméticas;
- usar colunas string em concatenação;
- derivar valores complexos (totais, médias, textos formatados) a partir de dados simples armazenados;
- nomear resultados com aliases para tornar a saída clara.

Operadores aritméticos (`+`, `-`, `*`, `/`), funções de concatenação (`CONCAT`, `||`) e aliases (`AS`) são as principais ferramentas para construir resultados ricos em SQL, sem “poluir” o esquema com colunas físicas desnecessárias [cite:208][cite:210][cite:217][cite:239].
```
