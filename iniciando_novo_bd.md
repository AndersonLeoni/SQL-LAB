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

```
