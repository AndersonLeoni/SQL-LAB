# Criar o Primeiro Schema e Tabela

O primeiro passo prático num Sistema Gestor de Bases de Dados (SGBD) é criar o espaço lógico (*schema*) e, em seguida, as estruturas das tabelas.

```sql
-- 1. Criação da base de dados (schema)
CREATE DATABASE first_example;

-- 2. Seleciona a base de dados para torná-la ativa
USE first_example;

-- (Opcional) Lista todas as tabelas existentes no schema selecionado
SHOW TABLES;

-- 3. Criação da tabela 'person'
CREATE TABLE person (
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    gender ENUM('M', 'F'),
    birth_date DATE,
    street VARCHAR(20),
    city VARCHAR(20),
    state VARCHAR(20),
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);
```

---
### Detalhes do Uso Prático

* **`CONSTRAINT pk_person`**: Estamos a atribuir o nome explícito de "pk_person" à nossa regra. Nomear a restrição é uma excelente prática técnica que facilita imenso a manutenção futura do esquema, caso seja necessário alterar ou eliminar esta regra.
* **`PRIMARY KEY (person_id)`**: Define que a coluna `person_id` é a **Chave Primária** da tabela. Isto aplica duas regras automáticas e incontornáveis: a base de dados não aceitará valores repetidos (garantindo que cada registo tenha um ID único) e não permitirá que este campo seja inserido em branco (`NOT NULL`).


---
```markdown
# Relacionamento de Tabelas e Manipulação de Dados (DML)

Nesta etapa, vamos criar uma segunda tabela para estabelecer um relacionamento com a estrutura anterior e, em seguida, explorar comandos de consulta de metadados e manipulação de dados (inserção e exclusão).

---

## 🔗 1. Criando a Segunda Tabela (Relacionamento)

A tabela `favorite_food` será criada para armazenar as comidas favoritas de cada pessoa. Para garantir que os dados façam sentido, ela precisa estar conectada à tabela `person`.

```sql
-- Cria a tabela com uma Chave Primária Composta e uma Chave Estrangeira
CREATE TABLE favorite_food (
    person_id SMALLINT UNSIGNED,
    food VARCHAR(20),
    CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food),
    CONSTRAINT fk_favorite_food_person_id FOREIGN KEY (person_id) REFERENCES person(person_id)
);

```

### 💡 Detalhes Técnicos da Estrutura

* **Chave Primária Composta (`PRIMARY KEY (person_id, food)`):** Garante que uma mesma pessoa não cadastre a mesma comida repetida. A exclusividade é garantida pela combinação das duas colunas.
* **Chave Estrangeira (`FOREIGN KEY ... REFERENCES`):** A *constraint* `fk_favorite_food_person_id` aplica a integridade referencial. O banco de dados só aceitará a inserção de uma comida se o `person_id` informado já estiver previamente cadastrado na tabela `person`.

---

## 🔍 2. Explorando a Estrutura e Metadados

O SGBD fornece comandos e tabelas de sistema para inspecionar a estrutura que acabamos de criar.

```sql
-- Descreve a estrutura (tipos de dados, chaves, nulos) da tabela favorite_food
DESC favorite_food;

-- Lista todos os bancos de dados (schemas) disponíveis no servidor
SHOW DATABASES;

-- Consulta o dicionário de dados para listar todas as constraints criadas no nosso banco
SELECT * FROM information_schema.table_constraints
WHERE constraint_schema = 'first_example';

```

---

## ➕ 3. Inserção de Dados (DML - INSERT)

Com a estrutura pronta, utilizamos o comando `INSERT INTO` para popular as tabelas, respeitando a ordem e o tipo de dado de cada coluna.

### Alimentando a tabela principal (`person`):

```sql
INSERT INTO person VALUES (
    1,
    'Carolina',
    'Silva',
    'F',
    '1979-08-21',
    'Rua Tal',
    'Cidade J',
    'RJ',
    'Brasil',
    '26054-89'
);

```

### Alimentando a tabela relacionada (`favorite_food`):

```sql
INSERT INTO favorite_food VALUES (1, 'Lasanha');

```

> **Observação:** Esta inserção é bem-sucedida porque o identificador `1` já existe na tabela `person`, respeitando a regra da Chave Estrangeira.

---

## 🗑️ 4. Remoção de Instâncias (DML - DELETE)

Para remover registros específicos de uma tabela, utilizamos o comando `DELETE`.

> ⚠️ **Aviso de Segurança:** É imprescindível o uso da cláusula `WHERE` para restringir a ação. Um `DELETE` sem `WHERE` apagará todos os dados da tabela.

```sql
-- Exclui da tabela person os registros que correspondam aos IDs especificados
DELETE FROM person 
WHERE person_id = 2 
   OR person_id = 3 
   OR person_id = 4;

```

```
Segue a versão em `.md`, já corrigida, estruturada e com alguns complementos para você usar direto no GitHub como continuação do seu estudo.

```md
# SQL na Prática: Schemas, Tabelas, Tipos de Dados e Constraints

Este documento complementa as anotações práticas sobre criação de schemas, definição de tabelas, tipos de dados e uso de constraints em MySQL.

---

## 1. Criando Schema e Tabelas

### 1.1. Criação de schema

```sql
CREATE SCHEMA IF NOT EXISTS company;
```

Ativa o schema:

```sql
USE company;
```

---

### 1.2. Tabela `employee`

```sql
CREATE TABLE company.employee (
    fname       VARCHAR(15) NOT NULL,
    minit       CHAR(1),
    lname       VARCHAR(15) NOT NULL,
    ssn         CHAR(9) NOT NULL,
    bdate       DATE,
    address     VARCHAR(30),
    sexo        CHAR(1),
    salary      DECIMAL(10,2),
    super_ssn   CHAR(9),
    dno         INT NOT NULL,
    PRIMARY KEY (ssn)
);
```

**Observações importantes:**

- `VARCHAR(15)`: texto de tamanho variável até 15 caracteres.
- `CHAR(1)`: campo fixo de 1 caractere (bom para iniciais, sexo, etc.).
- `DECIMAL(10,2)`: ideal para valores monetários (10 dígitos no total, 2 decimais).
- `PRIMARY KEY (ssn)`: garante unicidade do CPF/SSN e impede valores nulos.

---

### 1.3. Tabela `departament`

```sql
CREATE TABLE departament (
    dname           VARCHAR(15) NOT NULL,
    dnumber         INT NOT NULL,
    mgr_ssn         CHAR(9),
    mgr_start_date  DATE,
    PRIMARY KEY (dnumber),
    UNIQUE (dname),
    FOREIGN KEY (mgr_ssn) REFERENCES employee(ssn)
);
```

**Pontos-chave:**

- `PRIMARY KEY (dnumber)`: identifica unicamente o departamento.
- `UNIQUE (dname)`: não permite dois departamentos com o mesmo nome.
- `FOREIGN KEY (mgr_ssn)`: gerente deve existir na tabela `employee`.

---

### 1.4. Tabela `dept_location`

```sql
CREATE TABLE dept_location (
    dnumber     INT NOT NULL, 
    dlocation   VARCHAR(15) NOT NULL,
    PRIMARY KEY (dnumber, dlocation),
    FOREIGN KEY (dnumber) REFERENCES departament(dnumber)
);
```

**Pontos-chave:**

- `PRIMARY KEY (dnumber, dlocation)`: chave composta; combinação única de departamento + local.
- Permite que um mesmo departamento tenha várias localizações.

---

### 1.5. Tabela `project`

```sql
CREATE TABLE project (
    pname       VARCHAR(15) NOT NULL,
    pnumber     INT NOT NULL,
    plocation   VARCHAR(15),
    dnum        INT NOT NULL,
    PRIMARY KEY (pnumber),
    UNIQUE (pname),
    FOREIGN KEY (dnum) REFERENCES departament(dnumber)
);
```

**Correção importante:**

- A foreign key deve referenciar `dnum`, não `dnumber` dentro da própria tabela.
- `UNIQUE (pname)`: evita nomes duplicados de projetos.

---

### 1.6. Tabela `works_on`

```sql
CREATE TABLE works_on (
    essn    CHAR(9) NOT NULL,
    pno     INT NOT NULL,
    hours   DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (essn, pno),
    FOREIGN KEY (essn) REFERENCES employee(ssn),
    FOREIGN KEY (pno) REFERENCES project(pnumber)
);
```

**Pontos-chave:**

- Chave primária composta (`essn`, `pno`): um funcionário pode trabalhar em vários projetos; o par funcionário+projeto é único.
- `DECIMAL(3,1)`: permite valores como 10.5, 40.0 horas, etc.

---

### 1.7. Tabela `dependent`

```sql
CREATE TABLE dependent (
    essn            CHAR(9) NOT NULL,
    dependent_name  VARCHAR(15) NOT NULL,
    sex             CHAR(1),
    bdate           DATE,
    relationship    VARCHAR(8),
    PRIMARY KEY (essn, dependent_name),
    FOREIGN KEY (essn) REFERENCES employee(ssn)
);
```

**Correção:**

- A referência correta é apenas `employee(ssn)`, sem `Project` no meio.

---

## 2. Tipos de Dados no MySQL

### 2.1. Tipos de caracteres

**Principais tipos:**

- `CHAR(n)`: comprimento fixo, até 255 bytes. Bom para campos de tamanho previsível (siglas, códigos, etc.) [web:14].
- `VARCHAR(n)`: comprimento variável, até 65.535 bytes para a linha inteira, considerando todas as colunas e o charset [web:14].

### 2.2. TEXT types

Tabelas de tamanhos máximos (em bytes):

- `TINYTEXT`: até 255 bytes [web:1][web:11].
- `TEXT`: até 65.535 bytes (≈ 64 KB) [web:1][web:11].
- `MEDIUMTEXT`: até 16.777.215 bytes (≈ 16 MB) [web:1][web:4].
- `LONGTEXT`: até 4.294.967.295 bytes (≈ 4 GB) [web:1][web:4].

Uso típico:

- `TEXT`: comentários, descrições médias.
- `MEDIUMTEXT`/`LONGTEXT`: textos grandes (artigos longos, documentos, logs).

---

### 2.3. Conjunto de caracteres (Character Set)

Um **conjunto de caracteres** é o “alfabeto” que o banco usa, incluindo letras, símbolos e codificação.

Para listar os charsets disponíveis:

```sql
SHOW CHARACTER SET;
```

Esse comando retorna o charset, collation padrão e `Maxlen`, que é o número máximo de bytes por caractere (por exemplo, até 4 bytes nos charsets UTF) [web:10][web:13].

- `maxlen > 1`: indica charset multibyte (ex.: `utf8mb4`) [web:10][web:14].

---

### 2.4. Tipos TEXT mais usados (< 64 KB)

- `TINYTEXT`: até 255 bytes [web:1][web:11].
- `TEXT`: até 65.535 bytes [web:1][web:11].

---

### 2.5. Tipos numéricos

**Ponto flutuante:**

- `FLOAT`: menor precisão, ocupa menos espaço.
- `DOUBLE`: maior precisão, útil para cálculos científicos.

**Inteiros:**

- `TINYINT`
- `SMALLINT`
- `MEDIUMINT`
- `INT`
- `BIGINT`

Cada um tem faixas de valores e consumo de armazenamento diferentes [web:8][web:11].

---

### 2.6. Tipos temporais

Principais tipos:

- `DATE`: apenas data (YYYY-MM-DD).
- `DATETIME`: data + hora (sem fuso automático).
- `TIMESTAMP`: data + hora com armazenamento relativo ao fuso, útil para auditoria.
- `YEAR`: armazena apenas ano.
- `TIME`: hora/minuto/segundo [web:11].

---

## 3. Constraints em SQL

Constraints são regras que garantem integridade, consistência e validade dos dados [web:12][web:15].

### 3.1. NOT NULL

- Impede que a coluna receba valor nulo.
- Torna o preenchimento obrigatório.

```sql
fname VARCHAR(15) NOT NULL
```

---

### 3.2. PRIMARY KEY (PK)

- Identifica unicamente cada linha da tabela.
- Não aceita valores `NULL`.
- Implicitamente combina `NOT NULL` e `UNIQUE` [web:9][web:12].

```sql
Dnumber INT PRIMARY KEY
```

---

### 3.3. UNIQUE

- Garante que todos os valores da coluna sejam diferentes.
- Diferente de PK porque:
  - Uma tabela pode ter várias `UNIQUE`.
  - Em alguns SGBDs, permite um valor `NULL` [web:6][web:12].

```sql
Dname VARCHAR(15) UNIQUE
```

---

### 3.4. DEFAULT

Define um valor padrão caso nenhum valor seja informado na inserção.

```sql
status VARCHAR(10) DEFAULT 'ATIVO'
```

---

### 3.5. CHECK (domínio)

O `CHECK` delimita o domínio (faixa permitida) de valores na coluna [web:2][web:12].

```sql
CHECK (salary > 0)
```

Exemplo de criação de “domínio” (mais conceitual/ANSI do que MySQL puro):

```sql
CREATE DOMAIN D_NUM AS INTEGER
CHECK (D_NUM > 0 AND D_NUM < 21);
```

No MySQL, o equivalente prático é declarar o `CHECK` diretamente na coluna ou na tabela [web:2].

---

### 3.6. Referential triggered action (ações referenciais)

Relacionadas às **foreign keys**:

- Definem o que acontece com registros filhos quando um registro pai é atualizado ou deletado.
- Ex.: `ON DELETE CASCADE`, `ON UPDATE CASCADE`, etc. [web:2][web:12].

```sql
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE;
```

---

### 3.7. CHECK com datas (exemplo prático)

```sql
CHECK (dept_create_date <= mgr_start_date);
```

- Garante que a data de criação do departamento seja menor ou igual à data de início do gerente.
- Exemplo de regra de integridade temporal aplicada à modelagem.

---

## 4. Row-Based Constraints (Linha a Linha)

Constraints como `CHECK`, `NOT NULL`, `UNIQUE` e `DEFAULT` são avaliadas **por linha**, garantindo que cada registro respeite as regras definidas [web:12][web:15].

- Podem ser nomeadas com `CONSTRAINT nome_regra`.
- Facilitam manutenção (alterar/remover regras específicas).

Exemplo:

```sql
CONSTRAINT chk_salary CHECK (salary >= 0)
```

---


