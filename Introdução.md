# SQL: Explorando a Linguagem de Consulta de Banco de Dados

Uma visão técnica e estruturada sobre SQL (Structured Query Language), abrangendo conceitos fundamentais, Sistemas Gerenciadores de Banco de Dados (SGBDs) e as subdivisões da linguagem (DDL, DML, DCL, DQL).

---

## 📌 Introdução ao SQL

A **SQL (Structured Query Language)** é a linguagem padrão de mercado utilizada para a manipulação de bancos de dados relacionais e execução de operações estruturadas. Por possuir uma sintaxe declarativa e literal, é considerada uma linguagem altamente acessível e de fácil curva de aprendizado, sendo uma habilidade indispensável para diversos papéis na área de tecnologia:

* **DBAs (Database Administrators):** Gerenciamento, otimização e infraestrutura de banco de dados.
* **Profissionais de BI (Business Intelligence):** Extração de dados para relatórios, análises de negócios e tomada de decisão.
* **Desenvolvedores (Devs):** Persistência de dados de aplicações e integração de sistemas.
* **Cientistas de Dados (DS):** Exploração, limpeza e preparação de grandes volumes de dados para modelagem.

---

## 🎯 Objetivos Principais

* **Definição e Modificação de Estrutura:** Criação, alteração e exclusão de tabelas, esquemas e restrições.
* **Manipulação de Registros:** Adição, remoção ou atualização de linhas em tabelas existentes.
* **Recuperação de Informação:** Consulta e filtragem eficiente de subconjuntos de dados específicos no banco de dados.

---

## 🔄 Cenários de Aplicação: OLTP vs. OLAP

No ecossistema de banco de dados, existem duas abordagens arquiteturais principais para o processamento de dados:

| Característica | OLTP (*Online Transaction Processing*) | OLAP (*Online Analytical Processing*) |
| :--- | :--- | :--- |
| **Foco** | Operações transacionais rápidas em tempo real. | Análise de dados históricos e consultas complexas. |
| **Operações** | `INSERT`, `UPDATE`, `DELETE` constantes. | Consultas de leitura pesadas (`SELECT`), agregações. |
| **Volume** | Dados atuais, transações rápidas e individuais. | Grandes volumes de dados consolidados (Data Warehouses). |
| **Exemplo** | Cadastro de cliente, compra em e-commerce. | Relatório de vendas anual estruturado por região. |

---

## 🗄️ Sistemas Gerenciadores de Banco de Dados (SGBDs) Relacionais

Para executar e gerenciar consultas SQL, utilizamos **SGBDs**. Dentre as soluções open-source mais robustas do mercado, destacam-se:

### 1. MySQL
* **Foco:** Alta velocidade de leitura, simplicidade de configuração e excelente ecossistema para aplicações web tradicionais.
* **Uso Comum:** WordPress, plataformas de e-commerce e aplicações MVC padrão.

### 2. PostgreSQL
* **Foco:** Extensibilidade, total conformidade com os padrões SQL (ANSI) e suporte avançado a tipos de dados complexos (como JSONB e dados espaciais via PostGIS).
* **Uso Comum:** Sistemas enterprise, aplicações com forte necessidade de integridade referencial e análise de dados complexa.

---

## 📂 Subdivisões da Linguagem SQL

Para organizar as diferentes responsabilidades e operações dentro de um banco de dados, o SQL é dividido em sublinguagens:

```
                      ┌─────────────────────────┐
                      │      Linguagem SQL      │
                      └────────────┬────────────┘
         ┌─────────────────────────┼─────────────────────────┐
 ┌───────┴───────┐         ┌───────┴───────┐         ┌───────┴───────┐
 │      DDL      │         │      DML      │         │ DQL / DCL /   │
 │ Definição de  │         │ Manipulação de│         │ Outros        │
 │  Estrutura    │         │     Dados     │         │               │
 └───────────────┘         └───────────────┘         └───────────────┘
```

### 1. DDL — *Data Definition Language* (Linguagem de Definição de Dados)
Comandos responsáveis por criar, modificar e definir a estrutura física dos objetos no banco de dados (tabelas, esquemas, índices).

* `CREATE`: Cria um novo objeto (banco de dados, tabela, índice, view).
* `DROP`: Exclui permanentemente um objeto existente do banco de dados.
* `ALTER`: Modifica a estrutura de um objeto existente (adicionar ou remover colunas, alterar tipos de dados).
* `RENAME`: Altera o nome de uma tabela ou coluna.
* `TRUNCATE`: Remove todos os registros de uma tabela rapidamente, liberando o espaço em disco, sem registrar deleções individuais no log.

---

### 2. DML — *Data Manipulation Language* (Linguagem de Manipulação de Dados)
Comandos voltados para a manipulação direta dos dados armazenados dentro das estruturas previamente criadas pelo DDL.

* `INSERT`: Insere novas linhas em uma tabela.
* `UPDATE`: Atualiza valores de registros existentes com base em condições específicas.
* `DELETE`: Remove linhas específicas de uma tabela.
* `MERGE` (Upsert): Combina operações de `INSERT` e `UPDATE` condicionalmente em uma única instrução.

---

### 3. DQL — *Data Query Language* (Linguagem de Consulta de Dados)
Focada exclusivamente na recuperação e visualização de dados. O comando central é o `SELECT`, que permite filtrar, ordenar, agrupar e juntar dados de múltiplas origens.

---

### 4. DCL — *Data Control Language* (Linguagem de Controle de Dados)
Controla os privilégios, permissões e segurança dos usuários dentro do banco de dados.

* `GRANT`: Concede permissões específicas de acesso a objetos do banco para um usuário.
* `REVOKE`: Remove permissões previamente concedidas.

---

## 🛠️ Conceitos Fundamentais de Arquitetura

Para operar bancos de dados relacionais com eficiência, é crucial compreender os seguintes pilares:

* **Usuário (User):** Credencial de acesso com permissões específicas para interagir com o SGBD.
* **Esquema (Schema):** Espaço lógico que organiza fisicamente as tabelas, views, procedures e índices associados a um projeto.
* **Instruções (Statements):** Linhas de comando ou queries SQL executadas contra o banco para realizar uma ação.
* **Indexação (Indexing):** Estrutura física otimizada (geralmente baseada em B-Tree) que acelera drasticamente a velocidade de busca e recuperação de registros em colunas frequentemente consultadas.

  ---

## 🛠️ DDL na Prática: Criação de Tabela (MySQL)

Para iniciar a criação de estruturas de dados, primeiro selecionamos o banco de dados (esquema) ativo e, em seguida, declaramos a estrutura da tabela utilizando o comando `CREATE TABLE`.

```sql
-- Seleciona o banco de dados/esquema de trabalho
USE teste;

-- Cria a tabela 'person' com seus respectivos campos e tipos de dados
CREATE TABLE person (
    person_id SMALLINT UNSIGNED,
    fname VARCHAR(20),
    lname VARCHAR(20),
    gender ENUM('M', 'F'),
    birth_date DATE, 
    street VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20), 
    country VARCHAR(20),
    postal_code VARCHAR(20),
    CONSTRAINT pk_person PRIMARY KEY (person_id)
);
```
## O que é o CONSTRAINT?

No exemplo acima, utilizamos a instrução final: `CONSTRAINT pk_person PRIMARY KEY (person_id)`.

**Constraint (Restrição)** é uma regra de integridade aplicada a uma coluna para garantir que os dados inseridos sejam válidos, consistentes e confiáveis.

* **`CONSTRAINT pk_person`**: Estamos dando o nome explícito de "pk_person" para a nossa regra. Nomear a constraint é uma boa prática que facilita a manutenção, caso precise alterar ou deletar essa regra no futuro.
* **`PRIMARY KEY (person_id)`**: Define que a coluna `person_id` é a Chave Primária da tabela. Isso aplica duas regras automáticas: o banco não aceitará valores repetidos (garantindo um ID único) e não permitirá que esse campo seja nulo (`NOT NULL`).
