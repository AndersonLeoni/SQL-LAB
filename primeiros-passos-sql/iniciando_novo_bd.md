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

uso de consultas (`SELECT`) e inserções (`INSERT`) em SQL, com foco em duplicações, operadores e sintaxe básica de DML.

---

## 1. Comportamento: Multiset e Duplicações

Em teoria de conjuntos, um **set** não admite elementos duplicados.  
Já uma tabela SQL funciona, na prática, como um **multiset**: ela pode conter linhas repetidas, ou seja, duplicações de dados [web:19].

- **Duplicações (redundâncias)**:
  - Podem ser custosas, ocupando mais espaço e dificultando análises.
  - Podem ser intencionais em alguns cenários (por exemplo, logs, histórico de eventos).

Exemplo de consulta que pode retornar duplicatas:

```sql
SELECT salary
FROM employee;
```

Se vários funcionários têm o mesmo salário, ele aparecerá repetido no resultado.

Para remover duplicatas na visualização:

```sql
SELECT DISTINCT salary
FROM employee;
```

`DISTINCT` não altera a tabela, apenas o **resultado da consulta**, retornando valores únicos [web:16][web:20][web:23].

---

## 2. Mapeamento de Consultas (SELECT)

Forma geral de uma consulta simples:

```sql
SELECT <lista_de_atributos>
FROM <tabela>
WHERE <condição>;
```

- `SELECT`: define quais colunas serão projetadas (exibidas).
- `FROM`: indica de qual tabela virão os dados.
- `WHERE`: filtra linhas com base em uma condição lógica [web:24][web:21].

### Exemplo prático

```sql
SELECT bdate, address
FROM employee
WHERE fname = 'John'
  AND minit = 'B'
  AND lname = 'Smith';
```

Nesta consulta:

- Retornamos apenas `bdate` e `address`.
- Filtramos um funcionário específico pelo conjunto de atributos (`fname`, `minit`, `lname`).

---

## 3. Projeção de Atributos

**Projeção** é o ato de escolher quais colunas aparecerão no resultado.

- Ao invés de buscar todas as colunas, escolhemos apenas o necessário.
- Isso reduz custo de leitura e torna o resultado mais focado.

Exemplos:

```sql
-- Projeção específica
SELECT fname, lname
FROM employee;

-- Todas as colunas (projeção completa)
SELECT *
FROM employee;
```

---

## 4. Operadores em SQL

### 4.1. Operadores de comparação

- `=`  (igual)
- `<`  (menor)
- `<=` (menor ou igual)
- `>`  (maior)
- `>=` (maior ou igual)
- `<>` ou `!=` (diferente)

Exemplo:

```sql
WHERE salary >= 3000
  AND salary <> 0;
```

---

### 4.2. Operadores aritméticos

- `+` soma
- `-` subtração
- `*` multiplicação
- `/` divisão

Exemplo:

```sql
SELECT fname, lname, salary, salary * 1.10 AS salary_with_raise
FROM employee;
```

---

### 4.3. Operadores lógicos

- `AND`: todas as condições devem ser verdadeiras.
- `OR`: pelo menos uma condição deve ser verdadeira.
- `NOT`: nega uma condição.
- Alguns bancos suportam `XOR` para exclusão lógica (uma condição verdadeira, outra falsa).

Exemplo:

```sql
WHERE (sexo = 'M' OR sexo = 'F')
  AND NOT (salary < 0);
```

Valores lógicos avaliados: `TRUE`, `FALSE`.

---

## 5. DML: Data Manipulation Language

A **DML** é o subconjunto de SQL mais usado no dia a dia.  
Ela é responsável por manipular linhas dentro das tabelas [web:24][web:28].

Principais comandos:

- `INSERT`: inserir registros.
- `UPDATE`: atualizar registros.
- `DELETE`: remover registros.

---

## 6. Comando INSERT

Forma básica:

```sql
INSERT INTO <table> (<lista_atributos>)
VALUES (<lista_valores>);
```

Regra importante:

- A quantidade de colunas na lista de atributos deve ser igual à quantidade de valores.
- Os tipos de dados dos valores devem ser compatíveis com os tipos das colunas [web:28].

### Exemplo

```sql
INSERT INTO employee (
    fname, minit, lname, ssn, bdate, address, sexo, salary, super_ssn, dno
) VALUES (
    'John', 'B', 'Smith', '123456789', '1985-01-15',
    'Rua Exemplo, 123', 'M', 3500.00, '987654321', 5
);
```

---

## 7. Valores de PK e Tipos Inteiros

Para colunas que são **chave primária** numérica, é comum usar:

- `SMALLINT UNSIGNED`
- `INT`
- `BIGINT` [web:18][web:22].

No MySQL:

- `SMALLINT UNSIGNED`: até 65.535.
- `INT`: até aproximadamente 4 bilhões (quando UNSIGNED).
- `BIGINT`: faixa muito maior, útil para IDs globais [web:22].

Exemplo de definição de PK numérica:

```sql
CREATE TABLE departament (
    dnumber INT UNSIGNED PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL UNIQUE
);
```

Ao escolher o tipo da PK:

- Pense na quantidade máxima de registros que aquela tabela pode ter.
- Use `UNSIGNED` quando não faz sentido ter valores negativos (ex.: códigos, IDs) [web:22][web:18].

---

---
# Adicionando Constraints no Banco de Dados

Constraints são regras aplicadas às colunas ou tabelas para garantir integridade, consistência e validade dos dados armazenados. Elas podem ser definidas no momento da criação da tabela com `CREATE TABLE` ou adicionadas depois com `ALTER TABLE` [1][2].

## Tipos principais de constraints

Os tipos mais comuns de constraints em SQL são `NOT NULL`, `PRIMARY KEY`, `UNIQUE`, `FOREIGN KEY`, `CHECK` e `DEFAULT`. Cada uma tem a função de restringir ou validar os dados de uma forma específica, ajudando a manter o banco coerente com as regras do sistema [3][4].

## NOT NULL

A constraint `NOT NULL` impede que uma coluna receba valor nulo, tornando o preenchimento obrigatório. Ela é usada quando determinado atributo sempre precisa existir no registro [3][4].

### Exemplo

```sql
CREATE TABLE employee (
    ssn     CHAR(9) NOT NULL,
    fname   VARCHAR(15) NOT NULL,
    lname   VARCHAR(15) NOT NULL,
    salary  DECIMAL(10,2) NOT NULL
);
```

Nesse exemplo, `ssn`, `fname`, `lname` e `salary` obrigatoriamente precisam receber um valor no momento da inserção.

***

## PRIMARY KEY

A `PRIMARY KEY` identifica de forma única cada linha da tabela. Ela não permite valores duplicados nem valores nulos, funcionando como o identificador principal do registro [1][3][5].

### Exemplo de chave primária simples

```sql
CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL
);
```

### Exemplo de chave primária composta

```sql
CREATE TABLE works_on (
    essn  CHAR(9) NOT NULL,
    pno   INT NOT NULL,
    hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (essn, pno)
);
```

No segundo caso, a combinação entre `essn` e `pno` deve ser única. Isso significa que o mesmo funcionário não pode aparecer duas vezes no mesmo projeto [1][5].

***

## UNIQUE

A constraint `UNIQUE` impede a repetição de valores em uma coluna ou conjunto de colunas. Ela é útil quando um campo precisa ser exclusivo, mas não necessariamente é a chave primária da tabela [3][4].

### Exemplo

```sql
CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL UNIQUE
);
```

Nesse caso, dois departamentos não podem ter o mesmo nome.

***

## FOREIGN KEY

A `FOREIGN KEY` estabelece uma relação entre duas tabelas. Ela garante que o valor inserido na tabela filha exista previamente na tabela pai, preservando a integridade referencial [6][5].

### Exemplo

```sql
CREATE TABLE employee (
    ssn   CHAR(9) PRIMARY KEY,
    fname VARCHAR(15) NOT NULL,
    lname VARCHAR(15) NOT NULL
);

CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL UNIQUE,
    mgr_ssn CHAR(9),
    FOREIGN KEY (mgr_ssn) REFERENCES employee(ssn)
);
```

Nesse modelo, o valor de `mgr_ssn` só será aceito se já existir na coluna `ssn` da tabela `employee` [6][5].

***

## CHECK

A constraint `CHECK` valida uma condição lógica antes de aceitar o valor. Ela é usada para limitar o domínio dos dados, como faixa de idade, salário positivo ou coerência entre datas [1][2][4].

### Exemplo com salário

```sql
CREATE TABLE employee (
    ssn    CHAR(9) PRIMARY KEY,
    fname  VARCHAR(15) NOT NULL,
    salary DECIMAL(10,2),
    CONSTRAINT chk_salary CHECK (salary >= 0)
);
```

Esse exemplo impede que um salário negativo seja armazenado .

### Exemplo com datas

```sql
CREATE TABLE departament (
    dnumber           INT PRIMARY KEY,
    dname             VARCHAR(15) NOT NULL UNIQUE,
    dept_create_date  DATE,
    mgr_start_date    DATE,
    CONSTRAINT chk_dates CHECK (dept_create_date <= mgr_start_date)
);
```

Essa regra garante que a data de criação do departamento não seja posterior à data de início do gerente.

***

## DEFAULT

A constraint `DEFAULT` define um valor padrão para a coluna quando nenhum valor é informado na inserção. Isso é útil para estados iniciais, datas automáticas e comportamentos esperados do sistema .

### Exemplo

```sql
CREATE TABLE employee (
    ssn    CHAR(9) PRIMARY KEY,
    fname  VARCHAR(15) NOT NULL,
    status VARCHAR(10) DEFAULT 'ATIVO'
);
```

Se o campo `status` não for informado no `INSERT`, o banco preencherá automaticamente com `ATIVO`.

***

## Adicionando constraints com ALTER TABLE

Além de criar constraints diretamente no `CREATE TABLE`, também é possível adicioná-las depois que a tabela já existe usando `ALTER TABLE`.

### Exemplos

```sql
ALTER TABLE employee
ADD CONSTRAINT pk_employee PRIMARY KEY (ssn);
```

```sql
ALTER TABLE employee
ADD CONSTRAINT chk_salary_positive CHECK (salary >= 0);
```

```sql
ALTER TABLE departament
ADD CONSTRAINT fk_departament_mgr
FOREIGN KEY (mgr_ssn) REFERENCES employee(ssn);
```

Esse padrão facilita a manutenção do banco, especialmente quando a modelagem evolui com o tempo.

***

## Ações referenciais

Ao trabalhar com `FOREIGN KEY`, também é possível definir o comportamento do banco em operações de exclusão ou atualização na tabela pai. As opções mais comuns são `ON DELETE CASCADE`, `ON DELETE SET NULL` e `ON UPDATE CASCADE`.

### Exemplo com CASCADE

```sql
CREATE TABLE project (
    pnumber INT PRIMARY KEY,
    pname   VARCHAR(15) NOT NULL UNIQUE,
    dnum    INT NOT NULL,
    FOREIGN KEY (dnum)
        REFERENCES departament(dnumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
```

Nesse caso, se o departamento pai for excluído, os projetos associados também serão removidos automaticamente.

### Exemplo com SET NULL

```sql
CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL UNIQUE,
    mgr_ssn CHAR(9),
    FOREIGN KEY (mgr_ssn)
        REFERENCES employee(ssn)
        ON DELETE SET NULL
);
```

Aqui, se o funcionário gerente for removido, o campo `mgr_ssn` do departamento passa a ser `NULL`, preservando o departamento.

***

## Boas práticas

Ao modelar tabelas, é recomendado nomear constraints explicitamente com `CONSTRAINT nome_regra`, porque isso facilita manutenção, leitura e remoção futura das regras.

Algumas boas práticas comuns:

- Usar `PRIMARY KEY` para identificar registros.
- Usar `FOREIGN KEY` para relacionamentos.
- Usar `NOT NULL` em campos obrigatórios.
- Usar `UNIQUE` em atributos que não podem se repetir.
- Usar `CHECK` para regras de negócio.
- Usar `DEFAULT` para valores iniciais previsíveis.

***

## Exemplo completo

```sql
CREATE TABLE employee (
    ssn        CHAR(9) NOT NULL,
    fname      VARCHAR(15) NOT NULL,
    lname      VARCHAR(15) NOT NULL,
    salary     DECIMAL(10,2) DEFAULT 0,
    dept_id    INT,
    CONSTRAINT pk_employee PRIMARY KEY (ssn),
    CONSTRAINT chk_salary CHECK (salary >= 0)
);

CREATE TABLE departament (
    dnumber INT NOT NULL,
    dname   VARCHAR(15) NOT NULL,
    mgr_ssn CHAR(9),
    CONSTRAINT pk_departament PRIMARY KEY (dnumber),
    CONSTRAINT unq_departament_name UNIQUE (dname),
    CONSTRAINT fk_departament_mgr FOREIGN KEY (mgr_ssn)
        REFERENCES employee(ssn)
        ON DELETE SET NULL
);
```

# Constraints com ALTER TABLE

Este material explica como adicionar e remover constraints em tabelas já existentes usando `ALTER TABLE`, além de mostrar o funcionamento de `ON DELETE CASCADE` e `ON UPDATE CASCADE` em chaves estrangeiras.

***

## O que é ALTER TABLE

O comando `ALTER TABLE` é usado para modificar a estrutura de uma tabela já criada. Com ele, é possível adicionar, remover ou recriar constraints sem precisar apagar a tabela inteira.

Sintaxe geral:

```sql
ALTER TABLE nome_tabela
acao;
```

***

## ADD CONSTRAINT

`ADD CONSTRAINT` serve para adicionar uma nova regra de integridade a uma tabela já existente. Esse comando é útil quando a tabela foi criada inicialmente sem todas as restrições, ou quando novas regras de negócio surgem depois.

### Exemplo com PRIMARY KEY

```sql
ALTER TABLE employee
ADD CONSTRAINT pk_employee PRIMARY KEY (ssn);
```

Esse comando define `ssn` como chave primária da tabela `employee`.

### Exemplo com UNIQUE

```sql
ALTER TABLE departament
ADD CONSTRAINT unq_departament_name UNIQUE (dname);
```

Agora o nome do departamento não pode se repetir.

### Exemplo com CHECK

```sql
ALTER TABLE employee
ADD CONSTRAINT chk_salary_positive CHECK (salary >= 0);
```

Essa constraint impede que salários negativos sejam armazenados.

### Exemplo com FOREIGN KEY

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber);
```

Com isso, cada `dnum` inserido em `project` precisa existir antes em `departament(dnumber)`.

***

## DROP CONSTRAINT

`DROP CONSTRAINT` é usado para remover uma constraint existente. Em muitos casos, quando se deseja “alterar” uma constraint, o procedimento real é remover a antiga e criar outra com a nova definição.

### Exemplo genérico

```sql
ALTER TABLE employee
DROP CONSTRAINT chk_salary_positive;
```

Esse padrão é válido em vários SGBDs, mas no MySQL algumas constraints usam comandos específicos, dependendo do tipo.

***

## DROP de constraints no MySQL

No MySQL, a remoção pode variar conforme o tipo de constraint.

### Remover PRIMARY KEY

```sql
ALTER TABLE employee
DROP PRIMARY KEY;
```

### Remover FOREIGN KEY

```sql
ALTER TABLE project
DROP FOREIGN KEY fk_project_departament;
```

### Remover índice UNIQUE

Em MySQL, a constraint `UNIQUE` normalmente está associada a um índice único, então a remoção costuma ser feita com `DROP INDEX`.

```sql
ALTER TABLE departament
DROP INDEX unq_departament_name;
```

### Remover CHECK

```sql
ALTER TABLE employee
DROP CONSTRAINT chk_salary_positive;
```

Dependendo da versão do MySQL, esse comando pode ser aceito diretamente para `CHECK`.

***

## Estratégia comum: drop + add

Em SQL, normalmente não se “edita” uma constraint já pronta. O mais comum é remover a constraint antiga e adicionar outra com a nova regra.

### Exemplo prático

Suponha que a foreign key de `project` foi criada sem `CASCADE`, mas depois você quer ativar esse comportamento.

Primeiro remove a antiga:

```sql
ALTER TABLE project
DROP FOREIGN KEY fk_project_departament;
```

Depois recria com a nova regra:

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

Esse processo é muito comum em manutenção de banco.

***

## O que é CASCADE

`CASCADE` é uma ação referencial usada em `FOREIGN KEY` para propagar automaticamente alterações da tabela pai para a tabela filha. Isso evita registros órfãos e mantém a integridade referencial sem intervenção manual.

As duas formas mais comuns são:

- `ON DELETE CASCADE`
- `ON UPDATE CASCADE`

***

## ON DELETE CASCADE

`ON DELETE CASCADE` significa que, se um registro da tabela pai for removido, todos os registros relacionados da tabela filha também serão removidos automaticamente.

### Exemplo

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
ON DELETE CASCADE;
```

### Como funciona

Imagine os dados:

- Departamento 10 existe em `departament`
- Projetos A e B pertencem ao departamento 10 em `project`

Se o departamento 10 for apagado, os projetos A e B também serão apagados automaticamente.

### Quando usar

Use `ON DELETE CASCADE` quando os registros filhos não fazem sentido sem o registro pai.

Exemplos:

- Itens de pedido em relação ao pedido.
- Dependentes em relação ao funcionário.
- Projetos que só existem vinculados a um departamento.

***

## ON UPDATE CASCADE

`ON UPDATE CASCADE` significa que, se o valor da chave referenciada na tabela pai for alterado, os valores correspondentes na tabela filha também serão atualizados automaticamente.

### Exemplo

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
ON UPDATE CASCADE;
```

### Como funciona

Imagine que `departament.dnumber = 10` e existem projetos em `project` com `dnum = 10`.

Se o valor do departamento mudar de 10 para 20, o banco atualiza automaticamente todos os `dnum` relacionados de 10 para 20.

### Quando usar

Use `ON UPDATE CASCADE` quando a chave da tabela pai pode mudar e você quer manter o relacionamento consistente sem atualizar tudo manualmente.

Na prática, como chaves primárias quase sempre são estáveis, `ON UPDATE CASCADE` é menos usado que `ON DELETE CASCADE`, mas ainda é importante em alguns modelos.

***

## Exemplo completo com ADD CONSTRAINT e CASCADE

```sql
CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE project (
    pnumber INT PRIMARY KEY,
    pname   VARCHAR(15) NOT NULL,
    dnum    INT NOT NULL
);
```

Agora adicionando a foreign key depois:

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

Esse exemplo mostra bem a lógica do `ALTER TABLE`: a tabela já existe, e depois a constraint é adicionada com comportamento referencial completo.

***

## Exemplo completo com DROP e recriação

```sql
ALTER TABLE project
DROP FOREIGN KEY fk_project_departament;
```

```sql
ALTER TABLE project
ADD CONSTRAINT fk_project_departament
FOREIGN KEY (dnum) REFERENCES departament(dnumber)
ON DELETE CASCADE
ON UPDATE CASCADE;
```

Esse padrão é o mais usado quando se quer trocar a regra de uma foreign key já existente.

***

## Resumo prático

### Para adicionar constraints

```sql
ALTER TABLE nome_tabela
ADD CONSTRAINT nome_constraint definicao_constraint;
```

### Para remover constraints

```sql
ALTER TABLE nome_tabela
DROP CONSTRAINT nome_constraint;
```

### Casos específicos no MySQL

```sql
ALTER TABLE employee DROP PRIMARY KEY;
ALTER TABLE project DROP FOREIGN KEY fk_project_departament;
ALTER TABLE departament DROP INDEX unq_departament_name;
```

***

## Boas práticas

- Nomear as constraints (`pk_`, `fk_`, `chk_`, `unq_`) facilita manutenção.
- Antes de adicionar uma constraint, verificar se os dados atuais já obedecem à regra.
- Antes de usar `ON DELETE CASCADE`, confirmar se a exclusão automática de dados filhos realmente faz sentido no sistema.
- Em alterações de produção, é comum remover e recriar constraints para mudar comportamento referencial.


# Persistência de Dados em SQL

Persistência de dados é o processo de armazenar informações de forma permanente ou duradoura em um banco de dados, para que elas continuem existindo mesmo depois que o sistema, aplicação ou sessão do usuário seja encerrada. Em bancos relacionais, essa persistência acontece principalmente por meio de comandos SQL de manipulação de dados, como `INSERT`, `UPDATE` e `DELETE`, que gravam mudanças nas tabelas do banco.

***

## O que significa persistir dados

Persistir dados significa registrar informações no banco para que possam ser consultadas, alteradas ou reutilizadas futuramente. Diferente de um dado mantido apenas em memória temporária, o dado persistido permanece salvo na estrutura física do banco de dados.

Exemplo prático:

- Um usuário preenche um formulário de cadastro.
- A aplicação envia os dados ao banco.
- O banco grava essas informações em uma tabela.
- Depois, esses dados podem ser recuperados por uma consulta `SELECT`.

***

## Inserção de dados no banco

A forma mais comum de persistir novos dados em SQL é usando o comando `INSERT INTO`. Esse comando adiciona uma nova linha em uma tabela, respeitando a ordem das colunas, os tipos de dados e as constraints definidas na estrutura.

### Sintaxe com todas as colunas

```sql
INSERT INTO nome_tabela
VALUES (valor1, valor2, valor3);
```

Essa forma só é segura quando a ordem dos valores corresponde exatamente à ordem das colunas da tabela.

### Sintaxe recomendada

```sql
INSERT INTO nome_tabela (coluna1, coluna2, coluna3)
VALUES (valor1, valor2, valor3);
```

Essa é a forma mais indicada, porque deixa explícito quais colunas receberão quais valores.

***

## Selecionando o banco correto

Antes de persistir dados, é importante garantir que o comando será executado na base correta. No MySQL, isso pode ser feito com `USE nome_do_banco`.

### Exemplo

```sql
USE company;
SHOW TABLES;
```

- `USE company;` seleciona o banco ativo.
- `SHOW TABLES;` lista as tabelas existentes e ajuda a validar se você está no schema certo.

> Observação: o comando correto é `SHOW TABLES;` e não `SHOW TABLAS;`.

***

## Exemplo básico de persistência

Suponha a seguinte tabela:

```sql
CREATE TABLE employee (
    ssn     CHAR(9) PRIMARY KEY,
    fname   VARCHAR(15) NOT NULL,
    lname   VARCHAR(15) NOT NULL,
    bdate   DATE,
    address VARCHAR(30)
);
```

Agora, inserindo um registro:

```sql
INSERT INTO employee (ssn, fname, lname, bdate, address)
VALUES ('123456789', 'John', 'Smith', '1985-01-15', 'Rua Central, 100');
```

Nesse momento, os dados passam a existir no banco e podem ser recuperados por futuras consultas.

***

## Uso de NULL

Quando um dado não for preenchido, em muitos casos é possível utilizar `NULL`, desde que a coluna não tenha a constraint `NOT NULL`. Em SQL, `NULL` representa ausência de valor, valor desconhecido ou informação ainda não disponível, e não deve ser confundido com zero ou string vazia.

### Exemplo com NULL explícito

```sql
INSERT INTO employee (ssn, fname, lname, bdate, address)
VALUES ('987654321', 'Maria', 'Souza', NULL, NULL);
```

Nesse caso:

- `bdate` não foi informada.
- `address` não foi informada.
- O banco aceita a inserção porque essas colunas não são obrigatórias.

### Exemplo omitindo colunas opcionais

```sql
INSERT INTO employee (ssn, fname, lname)
VALUES ('111222333', 'Ana', 'Lima');
```

Se as colunas omitidas permitirem `NULL` e não tiverem `DEFAULT`, elas receberão `NULL` automaticamente.

***

## Quando NULL não pode ser usado

Se uma coluna foi criada com `NOT NULL`, ela precisa obrigatoriamente receber um valor válido no `INSERT`. Caso contrário, o banco rejeita a operação.

### Exemplo

```sql
CREATE TABLE departament (
    dnumber INT PRIMARY KEY,
    dname   VARCHAR(15) NOT NULL
);
```

Tentativa inválida:

```sql
INSERT INTO departament (dnumber, dname)
VALUES (10, NULL);
```

Esse comando falha porque `dname` é obrigatório.

***

## Persistência e integridade dos dados

Persistir dados não significa apenas gravar qualquer valor, mas gravar valores válidos segundo a modelagem do banco. Por isso, durante a inserção, o banco verifica regras como `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK` e `DEFAULT` antes de confirmar a gravação.

### Exemplo com chave primária

```sql
CREATE TABLE project (
    pnumber INT PRIMARY KEY,
    pname   VARCHAR(15) NOT NULL
);
```

Se o valor de `pnumber` já existir, a nova inserção será rejeitada porque a chave primária não pode se repetir .

***

## Boas práticas ao inserir dados

Ao persistir dados em SQL, algumas práticas ajudam a evitar erros e melhorar a legibilidade do código:

- Sempre selecionar o banco correto com `USE` antes de começar.
- Validar as tabelas com `SHOW TABLES`.
- Preferir `INSERT INTO tabela (colunas...) VALUES (...)` em vez de inserir valores sem informar colunas.
- Verificar se colunas obrigatórias possuem `NOT NULL`.
- Usar `NULL` apenas quando a ausência de valor faz sentido conceitualmente.
- Confirmar se chaves primárias e estrangeiras respeitam a integridade do modelo.

***

## Exemplo completo

```sql
USE company;
SHOW TABLES;

INSERT INTO employee (ssn, fname, lname, bdate, address)
VALUES ('123123123', 'Carlos', 'Silva', '1998-04-20', 'Av. Brasil, 500');

INSERT INTO employee (ssn, fname, lname, bdate, address)
VALUES ('456456456', 'Juliana', 'Costa', NULL, NULL);
```

### Interpretação

- O banco `company` é ativado.
- As tabelas são listadas para conferência.
- O primeiro `INSERT` persiste um registro completo.
- O segundo `INSERT` persiste um registro com campos opcionais nulos.

***

## Resumo conceitual

Persistência de dados em SQL é o ato de gravar informações nas tabelas do banco para uso futuro. O comando mais básico para isso é o `INSERT INTO`, que adiciona linhas respeitando tipos de dados e constraints, enquanto `NULL` pode ser usado para campos não preenchidos desde que a modelagem permita .

# Recuperação de Dados com Queries em SQL

A recuperação de dados é uma das funções centrais da linguagem SQL. Ela consiste em consultar informações armazenadas nas tabelas do banco de dados por meio de comandos de leitura, principalmente com a instrução `SELECT`, que permite buscar todas as colunas ou apenas atributos específicos, com ou sem filtros [1][2][3].

***

## O que é recuperar dados

Recuperar dados significa acessar informações já persistidas no banco para visualização, análise, conferência ou uso pela aplicação. Em SQL, esse processo é feito com queries, isto é, consultas escritas para localizar e retornar registros de uma ou mais tabelas [4][1][5].

Em termos práticos:

- Os dados já estão armazenados na tabela.
- O comando `SELECT` faz a leitura desses dados.
- O banco devolve um conjunto de linhas como resultado da consulta [2][3].

***

## SELECT: comando básico de recuperação

O principal comando para recuperar dados é o `SELECT`. Ele permite definir quais colunas serão retornadas e de qual tabela virão essas informações [6][7][5].

### Sintaxe geral

```sql
SELECT coluna1, coluna2, coluna3
FROM nome_tabela;
```

Se o objetivo for trazer todas as colunas da tabela, utiliza-se o caractere `*` [7][4][2].

```sql
SELECT *
FROM nome_tabela;
```

***

## Recuperando todos os dados da tabela

Quando se usa `SELECT *`, o banco retorna todas as colunas da tabela para cada linha encontrada. Essa forma é útil para inspeção rápida, testes e conferência inicial dos dados [7][2][5].

### Exemplo

```sql
SELECT *
FROM employee;
```

Esse comando recupera todas as informações da tabela `employee`, como nome, sobrenome, data de nascimento, endereço, salário e demais colunas existentes.

### Observação importante

Embora `SELECT *` seja prático, em ambientes reais geralmente é melhor selecionar apenas as colunas necessárias. Isso melhora legibilidade, reduz tráfego de dados e evita retorno de informações desnecessárias [8][1].

***

## Recuperando colunas específicas

Em muitos casos, não é necessário visualizar a linha inteira. O SQL permite fazer a **projeção de atributos**, ou seja, escolher apenas as colunas que devem aparecer no resultado [6][8][9].

### Exemplo

```sql
SELECT fname, lname, salary
FROM employee;
```

Nesse caso, a consulta retorna apenas o primeiro nome, sobrenome e salário dos funcionários.

### Vantagens

- Reduz volume de dados retornado.
- Deixa a query mais objetiva.
- Melhora a leitura do resultado.
- Evita expor campos desnecessários [6][8].

***

## Filtrando dados com WHERE

A cláusula `WHERE` serve para restringir o resultado da consulta, retornando apenas as linhas que atendem a uma condição específica [10][11][12].

### Sintaxe

```sql
SELECT coluna1, coluna2
FROM nome_tabela
WHERE condição;
```

A condição pode usar operadores como:

- `=` igual
- `<>` diferente
- `>` maior que
- `<` menor que
- `>=` maior ou igual
- `<=` menor ou igual [11][12]

***

## Recuperando dados por campos-chave

Quando suas anotações dizem:

```sql
SELECT <nome das colunas>
FROM <nome da tabela>
WHERE <campos chaves>
```

isso significa consultar usando atributos importantes para localizar um registro específico, como chave primária, CPF, código, matrícula ou combinação de campos identificadores.

### Exemplo com chave primária

```sql
SELECT fname, lname, bdate
FROM employee
WHERE ssn = '123456789';
```

Como `ssn` normalmente é chave primária, essa consulta tende a retornar um único funcionário.

### Exemplo com combinação de campos

```sql
SELECT bdate, address
FROM employee
WHERE fname = 'John'
  AND minit = 'B'
  AND lname = 'Smith';
```

Nesse caso, a recuperação é feita usando múltiplos atributos como critério de busca.

***

## Relação entre SELECT, FROM e WHERE

Essas três partes formam a base da maioria das queries de recuperação:

- `SELECT`: define o que será mostrado.
- `FROM`: indica de onde os dados serão lidos.
- `WHERE`: define quais linhas devem ser retornadas [10][1][5].

### Exemplo comentado

```sql
SELECT fname, salary
FROM employee
WHERE salary > 3000;
```

Interpretação:

1. O banco acessa a tabela `employee`.
2. Filtra apenas funcionários com salário maior que 3000.
3. Retorna somente as colunas `fname` e `salary`.

***

## SELECT sem filtro e SELECT com filtro

### Sem filtro

```sql
SELECT fname, lname
FROM employee;
```

Retorna todos os funcionários, exibindo apenas nome e sobrenome.

### Com filtro

```sql
SELECT fname, lname
FROM employee
WHERE dno = 5;
```

Retorna apenas os funcionários que pertencem ao departamento 5 [10][12].

***

## Importância da recuperação de dados

A recuperação de dados é essencial porque praticamente toda aplicação consulta o banco antes de tomar decisões, exibir telas, gerar relatórios ou validar informações. Sistemas de cadastro, e-commerce, BI e aplicações corporativas dependem constantemente de queries bem escritas para retornar dados corretos e úteis [1][3].

***

## Boas práticas em queries de recuperação

Algumas práticas ajudam a escrever consultas melhores:

- Preferir colunas específicas em vez de `SELECT *` quando possível [8][1].
- Usar `WHERE` para reduzir resultados desnecessários [10][12].
- Consultar por chaves ou campos indexados quando a intenção for localizar registros específicos.
- Escrever nomes de tabelas e colunas com clareza.
- Testar a query gradualmente: primeiro o `SELECT`, depois o filtro.

***

## Exemplo completo

```sql
SELECT *
FROM employee;
```

Essa consulta exibe todos os dados da tabela.

```sql
SELECT fname, lname, salary
FROM employee
WHERE ssn = '123456789';
```

Essa consulta recupera apenas algumas colunas de um funcionário específico.

```sql
SELECT address, bdate
FROM employee
WHERE fname = 'John'
  AND minit = 'B'
  AND lname = 'Smith';
```

Essa consulta usa mais de um critério para localizar o registro desejado.

***

## Resumo conceitual

Recuperar dados em SQL significa consultar informações já armazenadas no banco utilizando queries. O comando central é o `SELECT`, que pode trazer todas as colunas com `*` ou apenas atributos específicos, enquanto a cláusula `WHERE` permite filtrar os registros com base em campos-chave ou outras condições [10][7][1].

```md
# Queries com Alias em SQL

Aliases em SQL são apelidos temporários dados a colunas ou tabelas dentro de uma consulta. Eles deixam o código mais legível, ajudam a evitar ambiguidade de nomes e são indispensáveis em joins, subqueries e self joins.

---

## 1. Ideia geral de alias

Um **alias** existe apenas durante a execução da query:

- Não muda o nome real da tabela ou coluna no banco.
- Serve para:
  - encurtar nomes longos;
  - dar nomes mais amigáveis para o resultado;
  - diferenciar múltiplas referências à mesma tabela.

### Sintaxe básica

Alias de coluna:

```sql
SELECT coluna AS alias_coluna
FROM tabela;
```

Alias de tabela:

```sql
SELECT t.coluna
FROM tabela AS t;
```

Em muitos SGBDs, o `AS` é opcional, mas usá‑lo melhora a leitura:

```sql
SELECT t.coluna
FROM tabela t;
```

---

## 2. Queries com alias de coluna

Alias de coluna renomeia a “etiqueta” exibida no resultado, sem alterar o nome da coluna na tabela.

### Exemplo 1 — renomeando colunas

```sql
SELECT
    fname AS primeiro_nome,
    lname AS sobrenome,
    salary AS salario
FROM employee;
```

Saída (conceitualmente):

| primeiro_nome | sobrenome | salario |
|--------------|-----------|---------|
| John         | Smith     | 3500.00 |
| Maria        | Souza     | 4200.00 |

### Exemplo 2 — alias em expressão calculada

```sql
SELECT
    fname,
    salary,
    salary * 1.10 AS salario_com_bonus
FROM employee;
```

Aqui, `salario_com_bonus` é o nome da coluna calculada no resultado.  
Isso é útil para:

- relatórios;
- colunas derivadas (descontos, impostos, totais, etc.).

### Exemplo 3 — alias “bonito” para relatório

```sql
SELECT
    fname AS "Primeiro Nome",
    lname AS "Sobrenome"
FROM employee;
```

Alguns bancos exigem aspas (ou outro delimitador) quando o alias tem espaço.

---

## 3. Queries com alias de tabela

Alias de tabela reduz o tamanho da query e organiza melhor joins.

### Exemplo 4 — alias simples de tabela

```sql
SELECT e.fname, e.lname
FROM employee AS e;
```

- `e` é um apelido para `employee`.
- Em vez de `employee.fname`, usamos `e.fname`.

### Exemplo 5 — alias em JOIN

```sql
SELECT
    e.fname  AS funcionario,
    d.dname  AS departamento
FROM employee   AS e
JOIN departament AS d
    ON e.dno = d.dnumber;
```

Benefícios:

- Query mais curta e fácil de ler.
- Fica claro de qual tabela vem cada coluna.

---

## 4. Evitando ambiguidade com alias

Quando duas tabelas têm colunas com o mesmo nome (ex.: `id`), é obrigatório qualificar com tabela/alias; caso contrário, a query fica ambígua.

### Exemplo 6 — colunas com mesmo nome em tabelas diferentes

```sql
SELECT
    c.id   AS id_cliente,
    o.id   AS id_pedido,
    c.nome AS nome_cliente
FROM customers AS c
JOIN orders    AS o
    ON c.id = o.customer_id;
```

Sem alias, seria difícil saber de qual tabela vem cada `id`.  
Com alias:

- `c.id` → `customers.id`
- `o.id` → `orders.id`

---

## 5. Self join com alias (mesma tabela 2 vezes)

Em **self join**, a mesma tabela aparece duas vezes na mesma query; usar alias deixa de ser só recomendação e vira necessidade.

### Exemplo 7 — funcionário e supervisor

Suponha `super_ssn` guardando o SSN do supervisor:

```sql
SELECT
    e.fname AS funcionario,
    s.fname AS supervisor
FROM employee AS e
JOIN employee AS s
    ON e.super_ssn = s.ssn;
```

- `e` representa a tupla do funcionário.
- `s` representa a tupla do supervisor.
- Ambas são da tabela `employee`, mas com papéis diferentes.

Sem alias, o banco não conseguiria saber qual “lado” da tabela você está referenciando.

---

## 6. Alias em subqueries

Aliases também são importantes em subqueries (subconsultas), onde você precisa nomear o resultado interno para usá‑lo na consulta externa.

### Exemplo 8 — subquery com alias de tabela e coluna

```sql
SELECT
    e.fname,
    e.lname,
    dept_info.total_funcionarios
FROM employee AS e
JOIN (
    SELECT dno, COUNT(*) AS total_funcionarios
    FROM employee
    GROUP BY dno
) AS dept_info
    ON e.dno = dept_info.dno;
```

Aqui:

- A subquery recebe o alias `dept_info`.
- A coluna agregada `COUNT(*)` recebe o alias `total_funcionarios`.
- A consulta externa pode usar `dept_info.dno` e `dept_info.total_funcionarios`.

---

## 7. Alias e ordenação (ORDER BY)

Depois de criar um alias de coluna, normalmente você pode usá‑lo no `ORDER BY` em vez de repetir a expressão.

### Exemplo 9 — usando alias no ORDER BY

```sql
SELECT
    fname,
    salary * 12 AS salario_anual
FROM employee
ORDER BY salario_anual DESC;
```

Melhor do que:

```sql
ORDER BY salary * 12 DESC;
```

Fica mais legível e evita repetir a expressão longa.

---

## 8. Boas práticas ao usar alias

- Use `AS` para deixar explícito que se trata de um alias.
- Use aliases curtos para tabelas (e, d, c, p…) e nomes descritivos para colunas.
- Sempre use alias em:
  - joins com várias tabelas;
  - self joins;
  - subqueries.
- Use alias de coluna em:
  - campos calculados;
  - nomes técnicos que precisam ficar amigáveis em relatórios (por exemplo, para BI).

---

## 9. Exemplo completo de query com alias

```sql
SELECT
    e.fname       AS funcionario,
    e.lname       AS sobrenome,
    d.dname       AS departamento,
    s.fname       AS supervisor,
    e.salary      AS salario,
    e.salary * 1.10 AS salario_com_bonus
FROM employee   AS e
JOIN departament AS d
    ON e.dno = d.dnumber
LEFT JOIN employee AS s
    ON e.super_ssn = s.ssn;
```

Nesta consulta:

- `e` e `s` são aliases da mesma tabela `employee`, com papéis diferentes.
- `d` é alias de `departament`.
- As colunas recebem aliases amigáveis para saída.
- A expressão `salary * 1.10` ganha um nome claro no resultado.

---

## 10. Resumo conceitual

Realizar queries com alias em SQL significa atribuir apelidos temporários a tabelas e colunas para:

- tornar o código mais legível;
- evitar ambiguidade quando há nomes repetidos;
- organizar joins, self joins e subqueries;
- dar nomes claros a colunas calculadas.

Os aliases só existem durante a execução daquela consulta e não alteram o esquema físico do banco.
```

# When Good Statements Go Bad em SQL

A expressão **“when good statements go bad”** descreve situações em que um comando SQL é sintaticamente correto e aparentemente “bonito”, mas produz resultados errados, inconsistentes ou ineficientes. Em outras palavras: a query roda, não dá erro, mas mente para você ou derruba a performance [cite:139][cite:142][cite:152].

---

## 1. Conceito central

Um statement “bom que deu ruim” tem estas características:

- A sintaxe está correta, o banco executa sem reclamar.
- A intenção do desenvolvedor nem sempre casa com o resultado real.
- Muitas vezes o problema só aparece em produção: mais dados, mais casos extremos, mais inconsistências [cite:139][cite:142].

Isso acontece por:

- lógica de negócio mal traduzida em SQL;
- joins montados incorretamente;
- má interpretação de `NULL`;
- uso incorreto de agregações;
- queries aparentemente inocentes que explodem o volume de linhas [cite:140][cite:144][cite:153].

---

## 2. Exemplo clássico: JOIN que “dobra” linhas

Uma query de join pode parecer correta, mas gerar **linhas duplicadas** (ou “explosão” de linhas) quando existe uma relação muitos‑para‑muitos ou chaves não únicas [cite:140][cite:144][cite:153].

### Exemplo

```sql
SELECT e.fname, p.pname
FROM employee AS e
JOIN project  AS p
    ON e.dno = p.dnum;
```

Se:

- um funcionário participa de vários projetos;
- e um departamento tem vários projetos;

você pode acabar com muito mais linhas do que esperava.  
A query está “boa” sintaticamente, mas a modelagem/relacionamento faz com que o resultado seja enganoso [cite:140][cite:144].

### Como perceber que “deu ruim”

- Contagem de linhas muito maior que o número de funcionários ou projetos.
- Totais financeiros aparentando “dobrar” ou “triplicar” sem sentido [cite:140][cite:153].

### Estratégias de correção

- Usar `DISTINCT` quando a intenção é só remover duplicatas do resultado imediato.
- Reestruturar a query com `GROUP BY` e agregações corretas.
- Verificar a cardinalidade do join e se as colunas usadas realmente identificam a relação de forma única [cite:140][cite:144][cite:153].

---

## 3. SELECT * que parece inofensivo

`SELECT *` funciona e é extremamente comum, mas é um ótimo exemplo de “good statement” que pode dar problema:

- traz colunas desnecessárias;
- aumenta tráfego de dados e uso de memória;
- torna a aplicação sensível a alterações na estrutura da tabela;
- pode impactar negativamente performance em grandes volumes [cite:139][cite:142][cite:152].

### Exemplo “bonito mas ruim”

```sql
SELECT *
FROM employee;
```

Em ambiente pequeno, tudo bem. Em tabela com centenas de colunas e milhões de linhas, é caro e pouco controlado.

### Melhor abordagem

```sql
SELECT fname, lname, salary
FROM employee;
```

- Mais previsível, mais eficiente.
- “Boa” tanto em correção quanto em qualidade [cite:139][cite:142].

---

## 4. Falta de WHERE em UPDATE/DELETE

Outro caso clássico: o comando está perfeito, mas **sem filtro**, afetando todas as linhas da tabela.

### Exemplo perigoso

```sql
DELETE FROM employee;
```

Sem `WHERE`, a instrução exclui todos os registros. Sintaticamente correto; semanticamente, possivelmente um desastre [cite:149].

### Boas práticas

- Sempre testar antes com um `SELECT` equivalente:

```sql
SELECT *
FROM employee
WHERE dno = 5;
```

Depois, aplicar o mesmo filtro no `UPDATE` ou `DELETE`:

```sql
DELETE FROM employee
WHERE dno = 5;
```

Isso reduz muito a chance de “good statement” virar incidente grave [cite:149].

---

## 5. NULL e lógica booleana enganosa

`NULL` em SQL significa “valor desconhecido” e não é igual a nada — nem a outro `NULL`. Comparações diretas com `=` ou `<>` podem gerar resultados inesperados [cite:64][cite:73].

### Exemplo problemático

```sql
SELECT *
FROM employee
WHERE address = NULL;
```

Essa consulta nunca retorna linhas, porque `address = NULL` é sempre avaliado como **UNKNOWN**, não como TRUE [cite:64][cite:73].

### Versão correta

```sql
SELECT *
FROM employee
WHERE address IS NULL;
```

A query original é “bonita” sintaticamente, mas logicamente incorreta.  
Esse tipo de detalhe é fonte comum de statements que “passam” mas não entregam o que foi pedido [cite:64][cite:73][cite:149].

---

## 6. NOT IN com NULL na subquery

Outro ponto em que uma query aparentemente correta pode “ir pro lado errado” é o uso de `NOT IN` com subqueries que retornam `NULL` [cite:149].

### Exemplo

```sql
SELECT *
FROM employee
WHERE ssn NOT IN (
    SELECT super_ssn FROM employee
);
```

Se a subquery retorna algum `NULL`, a lógica de três valores do SQL pode fazer o resultado ser vazio ou enganoso, mesmo com sintaxe perfeita [cite:64][cite:73][cite:149].

Melhor evitar esse padrão e preferir `NOT EXISTS` quando há risco de `NULL` na subquery.

---

## 7. Queries corretas, mas que matam performance

Às vezes o problema não é semântica, mas performance. A query “funciona”, porém:

- demora demais;
- consome muitos recursos;
- não escala com crescimento de dados [cite:139][cite:142][cite:152].

### Exemplos típicos

- Filtros em colunas sem índice, em tabelas muito grandes.
- Uso excessivo de subqueries correlacionadas (executadas para cada linha).
- Funções em colunas de filtro (`WHERE LOWER(col) = 'x'`), impedindo uso de índice.
- Combinação de vários `OR` complexos em vez de reestruturar a lógica [cite:139][cite:142][cite:143][cite:152].

Mesmo estando “certo”, esse tipo de statement vira um “good statement gone bad” em ambiente real.

---

## 8. Quando a modelagem é o problema

Às vezes a query está até bem escrita, mas a **modelagem de dados** é que permite inconsistências: redundância de informações críticas, ausência de constraints de integridade, falta de normalização [cite:148].

### Exemplo conceitual (baseado em Learning SQL)

Se o nome do cliente estiver:

- em `customer`;
- e também em várias outras tabelas (pedidos, histórico, etc.);

uma atualização de nome feita só em um lugar deixa o banco inconsistente [cite:148].  
A query de relatório pode estar “certa” do ponto de vista sintático e lógico, mas retorna dados divergentes porque o modelo permite múltiplas fontes da mesma verdade.

O “good statement” fica “bad” porque:

- lê dados redundantes;
- pega versões diferentes da mesma informação [cite:148].

---

## 9. Checklist mental para evitar que “deem ruim”

Antes de confiar em uma query “bonita”, vale passar por um checklist rápido:

1. **Entendimento da regra de negócio**  
   - A query realmente traduz a pergunta que o negócio está fazendo?

2. **Joins e cardinalidades**  
   - O join pode multiplicar linhas?  
   - As colunas usadas garantem unicidade quando necessário? [cite:140][cite:144][cite:153]

3. **Uso de NULL**  
   - Comparações com `IS NULL` / `IS NOT NULL`?  
   - Algum `NOT IN` com possibilidade de `NULL`? [cite:64][cite:73][cite:149]

4. **Filtros em operações de escrita**  
   - `UPDATE` e `DELETE` com `WHERE` correto?  
   - Já testou antes com um `SELECT` equivalente? [cite:149]

5. **Performance básica**  
   - Está evitando `SELECT *` em cenários críticos?  
   - Filtros e joins usam colunas indexadas quando faz sentido? [cite:139][cite:142][cite:152]

---

## 10. Resumo conceitual

“**When good statements go bad**” é um rótulo para queries SQL que:

- são sintaticamente válidas;
- muitas vezes até “elegantes”;
- mas produzem resultados errados, duplicados, inconsistentes ou muito lentos.

Os vilões mais comuns incluem joins mal definidos, uso ingênuo de `NULL`, falta de filtros em comandos de escrita, `SELECT *` indiscriminado, má modelagem e falta de atenção à performance. Escrever SQL “sem erro 
