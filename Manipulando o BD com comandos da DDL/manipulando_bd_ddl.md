# Manipulando o Banco de Dados com Comandos DDL

Este material complementa suas anotações mostrando como criar um banco de dados, criar tabelas, aplicar constraints, alterar estruturas e executar comandos básicos de inserção, atualização e consulta. Em SQL, os comandos de **DDL (Data Definition Language)** são usados para definir e modificar a estrutura do banco, como `CREATE`, `ALTER`, `DROP` e `TRUNCATE` [1][2][3].

> Observação importante: `INSERT`, `UPDATE` e `SELECT` aparecem nas suas anotações junto de DDL, mas tecnicamente `INSERT` e `UPDATE` pertencem à **DML (Data Manipulation Language)**, enquanto `SELECT` é normalmente associado à **DQL (Data Query Language)** [3][4].

***

## 1. Criando o banco de dados

A criação do banco é o primeiro passo para organizar as tabelas e dados de um sistema. O comando `CREATE DATABASE` cria a base, e a opção `IF NOT EXISTS` evita erro caso ela já exista [4][3].

### Exemplo

```sql
CREATE DATABASE IF NOT EXISTS manipulation;
USE manipulation;
```

### Explicação

- `CREATE DATABASE IF NOT EXISTS manipulation;` cria o banco chamado `manipulation` apenas se ele ainda não existir.
- `USE manipulation;` define esse banco como o banco atual da sessão.

***

## 2. Criando tabelas

O comando `CREATE TABLE` define a estrutura das tabelas: nome, colunas, tipos de dados e constraints. É aqui que modelamos os dados do sistema [1][2][5].

No seu exemplo, faz sentido criar três tabelas principais:

- `bankClient`
- `bankAccount`
- `bankTransactions`

***

## 3. Tabela `bankClient`

Essa tabela armazena os dados básicos dos clientes do banco.

```sql
CREATE TABLE bankClient (
    client_id   INT PRIMARY KEY,
    fname       VARCHAR(20) NOT NULL,
    lname       VARCHAR(20) NOT NULL,
    cpf         CHAR(11) UNIQUE,
    address     VARCHAR(50)
);
```

### Explicação

- `client_id INT PRIMARY KEY`: identificador único do cliente.
- `fname` e `lname`: nome e sobrenome obrigatórios.
- `cpf CHAR(11) UNIQUE`: impede duplicação de CPF.
- `address`: endereço opcional.

***

## 4. Tabela `bankAccount`

Essa tabela representa as contas bancárias e deve se relacionar com os clientes.

```sql
CREATE TABLE bankAccount (
    account_id       INT PRIMARY KEY,
    account_number   VARCHAR(20) NOT NULL UNIQUE,
    balance          DECIMAL(10,2) DEFAULT 0,
    client_id        INT NOT NULL,
    CONSTRAINT fk_account_client
        FOREIGN KEY (client_id) REFERENCES bankClient(client_id)
);
```

### Explicação

- `account_id`: chave primária da conta.
- `account_number`: número da conta, único.
- `balance DECIMAL(10,2) DEFAULT 0`: saldo inicia em zero se não for informado.
- `client_id INT NOT NULL`: cada conta precisa pertencer a um cliente.
- `FOREIGN KEY ... REFERENCES bankClient(client_id)`: cria a relação entre conta e cliente [6][7][8].

***

## 5. Tabela `bankTransactions`

Essa tabela armazena movimentações financeiras associadas a uma conta.

```sql
CREATE TABLE bankTransactions (
    transaction_id     INT PRIMARY KEY,
    transaction_type   VARCHAR(20) NOT NULL,
    amount             DECIMAL(10,2) NOT NULL,
    transaction_date   DATE,
    account_id         INT NOT NULL,
    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id) REFERENCES bankAccount(account_id)
);
```

### Explicação

- `transaction_id`: identificador da transação.
- `transaction_type`: tipo da operação (`deposito`, `saque`, `transferencia`, etc.).
- `amount`: valor da transação.
- `transaction_date`: data da movimentação.
- `account_id`: conta relacionada à transação.
- `FOREIGN KEY ... REFERENCES bankAccount(account_id)`: garante que a transação só exista para uma conta válida [6][7].

***

## 6. Constraints: FOREIGN KEY e REFERENCES

Sua anotação cita “incluir constraint, foreign key e references”. Esses elementos são fundamentais para **integridade referencial** [6][8][9].

### Conceito

- `FOREIGN KEY`: define a coluna que será chave estrangeira.
- `REFERENCES`: informa qual tabela e qual coluna serão referenciadas.

### Exemplo genérico

```sql
CONSTRAINT fk_nome
    FOREIGN KEY (coluna_filha)
    REFERENCES tabela_pai(coluna_pai)
```

### Exemplo prático

```sql
CONSTRAINT fk_account_client
    FOREIGN KEY (client_id)
    REFERENCES bankClient(client_id)
```

Isso significa que toda conta deve estar vinculada a um cliente existente.

***

## 7. DROP TABLE

O comando `DROP TABLE` remove completamente a tabela, incluindo estrutura e dados. Deve ser usado com cuidado, porque a tabela deixa de existir no banco [1][2][4].

### Exemplo

```sql
DROP TABLE bankTransactions;
```

### Explicação

- Apaga a tabela `bankTransactions`.
- Todos os registros da tabela são perdidos.
- Se houver dependência de chave estrangeira, pode ser necessário remover as tabelas filhas antes.

***

## 8. ALTER TABLE

O comando `ALTER TABLE` é usado para modificar a estrutura de uma tabela já criada, sem precisar apagá-la e recriá-la [1][2][10].

### Exemplo adicionando coluna

```sql
ALTER TABLE bankClient
ADD email VARCHAR(50);
```

### Exemplo removendo coluna

```sql
ALTER TABLE bankClient
DROP COLUMN email;
```

### Exemplo adicionando constraint

```sql
ALTER TABLE bankAccount
ADD CONSTRAINT chk_balance
CHECK (balance >= 0);
```

### Explicação

Com `ALTER TABLE`, você pode:

- adicionar colunas;
- remover colunas;
- alterar tipo de dados;
- adicionar ou remover constraints.

***

## 9. INSERT INTO

`INSERT INTO` é usado para inserir novas linhas em uma tabela. Embora não seja DDL, ele é essencial para começar a popular as tabelas com dados [3].

### Inserindo cliente

```sql
INSERT INTO bankClient (client_id, fname, lname, cpf, address)
VALUES (1, 'Maria', 'Silva', '12345678901', 'Rua A, 100');
```

### Inserindo conta

```sql
INSERT INTO bankAccount (account_id, account_number, balance, client_id)
VALUES (101, '000123-4', 1500.00, 1);
```

### Inserindo transação

```sql
INSERT INTO bankTransactions (transaction_id, transaction_type, amount, transaction_date, account_id)
VALUES (1001, 'deposito', 500.00, '2026-07-27', 101);
```

### Explicação

Cada `INSERT` adiciona uma nova tupla à tabela. O banco valida as constraints antes de aceitar os dados.

***

## 10. UPDATE

O comando `UPDATE` altera registros já existentes na tabela. Também faz parte da DML [3].

### Exemplo

```sql
UPDATE bankAccount
SET balance = 2000.00
WHERE account_id = 101;
```

### Explicação

- `SET balance = 2000.00`: novo valor do saldo.
- `WHERE account_id = 101`: define qual conta será atualizada.

> Sem `WHERE`, o comando atualizaria todas as linhas da tabela.

***

## 11. SELECT * FROM

O comando `SELECT` recupera dados do banco. Quando usado com `*`, retorna todas as colunas da tabela [1][3].

### Exemplo

```sql
SELECT * FROM bankClient;
```

```sql
SELECT * FROM bankAccount;
```

```sql
SELECT * FROM bankTransactions;
```

### Explicação

- `SELECT *` mostra todos os dados da tabela.
- É útil para testes e conferência inicial.
- Em sistemas reais, geralmente é melhor selecionar apenas as colunas necessárias.

***

## 12. Exemplo completo

Abaixo está um fluxo simples de criação e uso do banco:

```sql
CREATE DATABASE IF NOT EXISTS manipulation;
USE manipulation;

CREATE TABLE bankClient (
    client_id   INT PRIMARY KEY,
    fname       VARCHAR(20) NOT NULL,
    lname       VARCHAR(20) NOT NULL,
    cpf         CHAR(11) UNIQUE,
    address     VARCHAR(50)
);

CREATE TABLE bankAccount (
    account_id       INT PRIMARY KEY,
    account_number   VARCHAR(20) NOT NULL UNIQUE,
    balance          DECIMAL(10,2) DEFAULT 0,
    client_id        INT NOT NULL,
    CONSTRAINT fk_account_client
        FOREIGN KEY (client_id) REFERENCES bankClient(client_id)
);

CREATE TABLE bankTransactions (
    transaction_id     INT PRIMARY KEY,
    transaction_type   VARCHAR(20) NOT NULL,
    amount             DECIMAL(10,2) NOT NULL,
    transaction_date   DATE,
    account_id         INT NOT NULL,
    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id) REFERENCES bankAccount(account_id)
);

INSERT INTO bankClient (client_id, fname, lname, cpf, address)
VALUES (1, 'Maria', 'Silva', '12345678901', 'Rua A, 100');

INSERT INTO bankAccount (account_id, account_number, balance, client_id)
VALUES (101, '000123-4', 1500.00, 1);

INSERT INTO bankTransactions (transaction_id, transaction_type, amount, transaction_date, account_id)
VALUES (1001, 'deposito', 500.00, '2026-07-27', 101);

UPDATE bankAccount
SET balance = 2000.00
WHERE account_id = 101;

SELECT * FROM bankClient;
SELECT * FROM bankAccount;
SELECT * FROM bankTransactions;
```

***

## 13. Resumo conceitual

Manipular o banco com comandos estruturais significa criar e manter o esquema do banco com DDL (`CREATE`, `ALTER`, `DROP`). Já os comandos `INSERT`, `UPDATE` e `SELECT` atuam diretamente sobre os dados. Ao combinar tabelas bem definidas com constraints como `PRIMARY KEY`, `FOREIGN KEY` e `REFERENCES`, o banco passa a garantir organização, integridade e consistência das informações [6][8][4].
