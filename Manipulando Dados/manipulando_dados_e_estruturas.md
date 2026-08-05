# Manipulando Dados e Estruturas em SQL e MySQL

## Concatenando colunas

A concatenaçº£o une duas ou mais colunas de texto em uma única string. É útil para exibir informações combinadas, como nome completo ou descriçºµes personalizadas.

### Sintaxe no SQL padrão e MySQL

No **MySQL**, usa-se a funçººo `CONCAT()`:

```sql
SELECT CONCAT(nome, ' - ', email) AS contato
FROM clientes;
```

Em outros bancos, como **PostgreSQL**, usa-se o operador `||`:

```sql
SELECT nome || ' - ' || email AS contato
FROM clientes;
```

No **SQL Server**, pode-se usar o operador `+`:

```sql
SELECT nome + ' - ' + email AS contato
FROM clientes;
```

### Observaçºµes
- Se alguma coluna for `NULL`, o resultado pode ser `NULL` (depende do banco).
- Para evitar isso, use `COALESCE()` ou `IFNULL()` para substituir valores nulos.
- No MySQL, `CONCAT()` ignora automaticamente `NULL` apenas se todos os argumentos forem `NULL`.

## Trocar asterisco pelo nome da coluna e usar Alias

Em vez de usar `SELECT *`, que retorna todas as colunas, é recomendáººvel listar explicitamente as colunas desejadas. Isso melhora a performance e a clareza da consulta.

### Exemplo

```sql
-- Forma genÉ©rica (menos recomendada)
SELECT * FROM clientes;

-- Forma explÝ©cita (mais recomendada)
SELECT id_cliente, nome, email, telefone
FROM clientes;
```

### Usando Alias (apelido) para colunas

O **alias** dá um nome temporáººrio à coluna no resultado da consulta.

```sql
SELECT 
    nome AS nome_cliente,
    email AS contato_email,
    telefone AS telefone_contato
FROM clientes;
```

No MySQL, a palavra-chave `AS` é opcional:

```sql
SELECT 
    nome nome_cliente,
    email contato_email
FROM clientes;
```

## UPPER e LOWER com Alias

As funçºµes `UPPER()` e `LOWER()` convertem texto para maiÚºsculas e minÚºsculas, respectivamente.

### Exemplos

```sql
SELECT 
    UPPER(nome) AS nome_maiusculo,
    LOWER(email) AS email_minusculo
FROM clientes;
```

Isso é ÚÛtil para padronizar saÝ©das ou comparar strings sem se preocupar com maiÚºsculas/minÚºsculas.

## Adicionando nova coluna

Para adicionar uma nova coluna a uma tabela, usa-se o comando `ALTER TABLE`.

### Sintaxe

```sql
ALTER TABLE nome_tabela
ADD nome_coluna tipo_dado;
```

### Exemplo prÚºtico

```sql
ALTER TABLE produtos
ADD data_cadastro DATETIME;
```

### Preenchendo a nova coluna com valores

ApÓ©s adicionar a coluna, pode-se usar `UPDATE` para preencher os registros existentes.

```sql
UPDATE produtos
SET data_cadastro = GETDATE();
```

No **MySQL**, usa-se `NOW()` em vez de `GETDATE()`:

```sql
UPDATE produtos
SET data_cadastro = NOW();
```

## Formatando data

A funçººo `FORMAT()` (ou `DATE_FORMAT()` no MySQL) permite exibir datas em formatos especÝ©ficos.

### Exemplo no MySQL

```sql
SELECT 
    data_cadastro,
    DATE_FORMAT(data_cadastro, '%d-%m-%Y %H:%i') AS data_formatada
FROM produtos;
```

### Exemplo no SQL Server

```sql
SELECT 
    data_cadastro,
    FORMAT(data_cadastro, 'dd-MM-yyyy HH:mm') AS data_formatada
FROM produtos;
```

### Formatos comuns
- `%d` - dia (01-31)
- `%m` - mËs (01-12)
- `%Y` - ano com 4 dÝ©gitos
- `%H` - hora (00-23)
- `%i` - minutos (00-59)

## GROUP BY com base em condiçººo

O `GROUP BY` agrupa linhas com valores iguais em uma ou mais colunas. A clÚºusula `WHERE` deve vir **antes** do `GROUP BY`.

### Exemplo

```sql
SELECT 
    tamanho,
    COUNT(*) AS qtd
FROM produtos
WHERE estoque > 0
GROUP BY tamanho;
```

### Ordem correta das clÚºusulas

```sql
SELECT colunas
FROM tabela
WHERE condiçººo
GROUP BY colunas_agrupamento
HAVING condiçººo_agrupamento
ORDER BY colunas_ordem;
```

## ORDER BY

O `ORDER BY` ordena os resultados da consulta.

### Sintaxe

```sql
SELECT nome, preco
FROM produtos
ORDER BY preco DESC;  -- do maior para o menor
```

```sql
SELECT nome, preco
FROM produtos
ORDER BY preco ASC;   -- do menor para o maior (padrØ£o)
```

### Observaçºµes
- `ASC` é o padrão (crescente).
- `DESC` inverte a ordem (decrescente).
- Pode ordenar por mÚºltiplas colunas.

## Primary Key e Foreign Key

### Primary Key (Chave PrimÚºria)

É¡ uma chave ÚÛnica que identifica cada registro em uma tabela.

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100)
);
```

### CaracterÝ©sticas
- ÚÛnica para cada registro
- NØ£o pode ser `NULL`
- Geralmente é um campo numÉ©rico autoincremento

### Foreign Key (Chave Estrangeira)

É¡ uma chave que referencia um registro em outra tabela, estabelecendo um relacionamento.

```sql
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    data_pedido DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);
```

### CaracterÝ©sticas
- Aponta para uma `PRIMARY KEY` em outra tabela
- Garante integridade referencial
- Evita registros ÓÓ»rfØ£os

## Tabela-resumo

| Conceito | Funçººo | Exemplo |
|----------|---------|---------|
| `CONCAT()` | Unir colunas de texto | `CONCAT(nome, ' ', sobrenome)` |
| Alias | Apelido temporÚºrio | `nome AS nome_cliente` |
| `UPPER()` | Converter para maiÚºsculas | `UPPER(nome)` |
| `LOWER()` | Converter para minÚºsculas | `LOWER(email)` |
| `ALTER TABLE ADD` | Adicionar coluna | `ALTER TABLE produtos ADD coluna INT` |
| `UPDATE` | Atualizar dados | `UPDATE produtos SET coluna = NOW()` |
| `DATE_FORMAT()` | Formatar data | `DATE_FORMAT(data, '%d-%m-%Y')` |
| `GROUP BY` | Agrupar dados | `GROUP BY tamanho` |
| `ORDER BY` | Ordenar dados | `ORDER BY preco DESC` |
| `PRIMARY KEY` | Chave ÚÛnica | `id_cliente INT PRIMARY KEY` |
| `FOREIGN KEY` | Referenciar outra tabela | `FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)` |

## Boas prÚºticas

- Evite usar `SELECT *` em produçººo; liste explicitamente as colunas.
- Use alias para tornar os resultados mais legÝ©veis.
- Sempre defina `PRIMARY KEY` nas tabelas principais.
- Use `FOREIGN KEY` para manter relacionamentos consistentes.
- Teste scripts de `ALTER TABLE` em ambientes de desenvolvimento antes de produçººo.
- Use `WHERE` antes de `GROUP BY` para filtrar linhas antes do agrupamento.

## ConclusØ£o

Esses comandos permitem manipular dados, formatar saÝ©das, estruturar tabelas e manter relacionamentos entre dados em SQL e MySQL. Dominar essas tÉ©cnicas é essencial para criar consultas eficientes e bancos de dados bem estruturados.
