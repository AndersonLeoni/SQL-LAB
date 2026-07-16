Criar o Primeiro Schema e Tabela

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
