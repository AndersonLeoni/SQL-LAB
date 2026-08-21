# Fundamentos de Bancos de Dados e SGBD

## Visão geral

Um banco de dados é uma coleção organizada de informações relacionadas, criada para armazenar, consultar e recuperar dados. Um **SGBD**, ou Sistema de Gerenciamento de Banco de Dados, é o software que controla o armazenamento, a organização e a recuperação desses dados.[web:86][web:89]

O banco não serve apenas para guardar textos e números. Ele também pode armazenar datas, imagens, documentos, localização, eventos, relacionamentos, dados de sensores e estruturas como JSON. O SGBD fornece mecanismos para transformar esses dados em informação útil.

## O que são bancos de dados

Um banco de dados reúne dados que pertencem a um contexto comum. Em um banco relacional, esses dados são organizados em tabelas, compostas por colunas e linhas.

### Exemplo

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    data_cadastro DATE
);
```

Nesse exemplo:

- `clientes` é a tabela.
- Cada linha representa um cliente.
- Cada coluna representa uma característica do cliente.
- `id_cliente` identifica o registro.
- `nome`, `email` e `data_cadastro` são atributos.

Um banco de dados pode ser entendido como um conjunto de dados persistidos e relacionados, acompanhado de estruturas, regras, metadados e mecanismos de acesso.

## SGBD

### Definição

O SGBD é o conjunto de programas que funciona entre as aplicações e os dados armazenados. Ele fornece uma forma controlada de criar, consultar, alterar, proteger e compartilhar informações.

Os principais elementos de um SGBD incluem:

- Motor de armazenamento.
- Catálogo ou dicionário de dados.
- Linguagem de consulta.
- Controle de transações.
- Controle de concorrência.
- Gerenciamento de usuários e permissões.
- Mecanismos de backup e recuperação.
- Ferramentas de monitoramento.

Oracle descreve um DBMS como o software que controla armazenamento, organização e recuperação dos dados. Também destaca o uso de estruturas, operações e regras de integridade no modelo relacional.[web:86][web:89]

### Exemplos de SGBD

- MySQL.
- SQL Server.
- Oracle Database.
- PostgreSQL.
- MariaDB.
- SQLite.
- MongoDB, em uma categoria não relacional.

## Negócios e bancos de dados

O banco de dados deve representar as informações importantes para um negócio. O contexto determina quais entidades existem, quais dados são obrigatórios e quais consultas serão necessárias.

### E-commerce

Um e-commerce pode armazenar:

- Clientes.
- Produtos.
- Categorias.
- Carrinhos.
- Pedidos.
- Itens de pedido.
- Pagamentos.
- Entregas.
- Cupons.
- Estoque.

```sql
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    status VARCHAR(30) NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);
```

### Medicina

Na medicina, o banco pode armazenar:

- Pacientes.
- Profissionais de saúde.
- Consultas.
- Prontuários.
- Exames.
- Prescrições.
- Resultados laboratoriais.

Nesse domínio, segurança, privacidade, auditoria, histórico e controle de acesso são especialmente importantes. Uma alteração clínica não deve apagar indevidamente o histórico anterior.

### Social Media

Em redes sociais, podem existir dados de:

- Usuários.
- Publicações.
- Comentários.
- Reações.
- Seguidores.
- Mensagens.
- Denúncias.
- Notificações.

Além dos dados atuais, é comum armazenar eventos, como criação de publicação, curtida, compartilhamento e alteração de perfil.

### Engenharia

Na engenharia, bancos podem armazenar:

- Projetos.
- Equipamentos.
- Materiais.
- Medições.
- Plantas e documentos.
- Inspeções.
- Manutenções.
- Dados de sensores.
- Histórico de falhas.

Esse contexto pode combinar dados relacionais com arquivos, dados geográficos, séries temporais e grandes volumes de medições.

## Conjuntos que são estruturas

Os dados não aparecem isolados. Eles são organizados em estruturas que expressam entidades, atributos e relacionamentos.

### Estrutura relacional

```text
CLIENTES
- id_cliente
- nome
- email

PEDIDOS
- id_pedido
- id_cliente
- data_pedido
- valor_total
```

O campo `id_cliente` em `pedidos` cria o vínculo com `clientes`. Assim, uma estrutura representa tanto os dados quanto a maneira como eles se relacionam.

### Estruturas comuns

- Tabelas.
- Colunas.
- Linhas.
- Índices.
- Views.
- Chaves primárias.
- Chaves estrangeiras.
- Constraints.
- Procedures.
- Functions.
- Partições.
- Documentos JSON.
- Arquivos e objetos externos.

No modelo relacional, estruturas bem definidas, operações sobre os dados e regras de integridade são partes fundamentais do banco.[web:89]

## Dados são acontecimentos

Dados podem representar acontecimentos do mundo real. Um pedido feito, uma consulta médica realizada, uma mensagem enviada ou uma medição registrada são eventos.

### Exemplo de evento

```sql
CREATE TABLE eventos_sistema (
    id_evento BIGINT PRIMARY KEY AUTO_INCREMENT,
    tipo_evento VARCHAR(50) NOT NULL,
    id_usuario INT,
    ocorrido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    detalhes JSON
);
```

Cada linha registra um acontecimento em determinado momento. Esse padrão é útil para auditoria, análise de comportamento, rastreamento e reconstrução de históricos.

### Estado versus evento

- **Evento:** algo aconteceu, como “pedido criado”.
- **Estado:** situação atual, como “pedido está em processamento”.

Um sistema pode manter ambos:

- A tabela `pedidos` guarda o estado atual.
- A tabela `eventos_pedido` guarda o histórico de acontecimentos.

## Dados precisam ser persistidos

Persistir dados significa gravá-los em um armazenamento não volátil, para que continuem disponíveis depois que a aplicação for encerrada ou o computador for reiniciado. Uma API de persistência, por exemplo, permite que uma aplicação grave e recupere informações de um sistema de armazenamento não volátil.[web:87]

### Memória versus persistência

| Local | Característica | Exemplo |
|---|---|---|
| Memória RAM | Rápida, mas normalmente temporária | Variáveis de uma aplicação |
| Banco de dados | Persistente e estruturado | Tabelas de clientes |
| Arquivo | Persistente, com estrutura definida pelo formato | JSON, CSV, PDF |
| Armazenamento de objetos | Adequado para arquivos e grandes objetos | Imagens e vídeos |

### Por que persistir

- Preservar histórico.
- Permitir recuperação após falhas.
- Compartilhar informações entre aplicações.
- Gerar relatórios.
- Manter rastreabilidade.
- Apoiar decisões.
- Reutilizar dados ao longo do tempo.

Um banco de dados é, portanto, um conjunto de dados persistidos, organizados e submetidos a regras de integridade e acesso.

## Como acessar dados persistidos

Os dados persistidos podem ser acessados por diferentes camadas:

1. Usuário ou sistema solicita uma ação.
2. A aplicação valida a solicitação.
3. A aplicação acessa o SGBD ou outro serviço de dados.
4. O SGBD executa a consulta ou alteração.
5. O resultado volta para a aplicação.
6. A aplicação apresenta ou transforma o resultado.

### Acesso direto por SQL

```sql
SELECT id_cliente, nome, email
FROM clientes
WHERE id_cliente = 10;
```

Esse acesso costuma ser usado por ferramentas administrativas, aplicações backend, relatórios e processos de integração.

## Acesso via API

Uma API é uma interface que permite que sistemas diferentes se comuniquem. Em uma arquitetura comum, o cliente não acessa o banco diretamente. Ele chama uma API, e o backend acessa o SGBD.

### Fluxo de uma consulta via API

```text
Aplicação cliente
        |
        | HTTP/HTTPS
        v
API / Backend
        |
        | SQL ou ORM
        v
SGBD
        |
        v
Dados persistidos
```

### Exemplo de requisição

```http
GET /api/clientes/10
Authorization: Bearer token
```

### Exemplo de resposta

```json
{
  "id_cliente": 10,
  "nome": "Ana Souza",
  "email": "ana@exemplo.com"
}
```

### Vantagens do acesso via API

- Oculta credenciais do banco.
- Centraliza regras de negócio.
- Controla autenticação e autorização.
- Valida entradas.
- Limita dados retornados.
- Permite auditoria.
- Facilita integração com aplicações web e mobile.
- Evita que cada cliente precise conhecer a estrutura interna do banco.

Uma API bem projetada não deve simplesmente expor todas as tabelas. Ela deve oferecer operações coerentes com o negócio e proteger informações sensíveis.

## Ações e mudança de estado

Uma ação é uma operação solicitada por um usuário ou sistema. A mudança de estado é o efeito persistido dessa ação.

### Exemplo de pedido

Ação:

```http
POST /api/pedidos
```

Efeito:

```sql
INSERT INTO pedidos (id_cliente, status, valor_total)
VALUES (10, 'CRIADO', 250.00);
```

O estado do sistema mudou: agora existe um pedido criado.

### Outro exemplo

Ação:

```http
PATCH /api/pedidos/100/status
```

Efeito:

```sql
UPDATE pedidos
SET status = 'PAGO'
WHERE id_pedido = 100;
```

A ação é o comando; o estado é a situação armazenada após o comando.

### Ações e eventos

Quando a rastreabilidade é importante, a mudança de estado pode gerar um evento:

```sql
START TRANSACTION;

UPDATE pedidos
SET status = 'PAGO'
WHERE id_pedido = 100;

INSERT INTO eventos_pedido
    (id_pedido, tipo_evento, ocorrido_em)
VALUES
    (100, 'PAGAMENTO_CONFIRMADO', CURRENT_TIMESTAMP);

COMMIT;
```

A transação garante que a atualização do estado e o registro do evento sejam tratados como uma unidade de trabalho.

## SGBD: gerenciamento de banco de dados

O gerenciamento de banco de dados pode ser dividido em quatro áreas: definição, construção, manipulação e compartilhamento.

### Definição

A definição descreve o que será armazenado e quais regras serão aplicadas. É realizada principalmente com comandos DDL, como:

- `CREATE DATABASE`.
- `CREATE TABLE`.
- `ALTER TABLE`.
- `CREATE INDEX`.
- `CREATE VIEW`.
- `CREATE PROCEDURE`.

Exemplo:

```sql
CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) CHECK (preco >= 0)
);
```

### Construção

A construção transforma a definição em objetos reais no SGBD. Inclui:

- Criar o banco.
- Criar schemas.
- Criar tabelas.
- Definir chaves.
- Criar relacionamentos.
- Criar índices.
- Configurar usuários.
- Criar procedures e functions.

É recomendável realizar essa construção com scripts versionados, e não somente com ações manuais em uma ferramenta visual.

### Manipulação

A manipulação usa comandos DML para consultar e modificar linhas:

- `SELECT`: consulta.
- `INSERT`: inserção.
- `UPDATE`: alteração.
- `DELETE`: exclusão.
- `MERGE`: combinação de inserção e atualização, conforme o SGBD.

```sql
INSERT INTO produtos (id_produto, nome, preco)
VALUES (1, 'Mouse', 75.90);

UPDATE produtos
SET preco = 69.90
WHERE id_produto = 1;

SELECT id_produto, nome, preco
FROM produtos;
```

A documentação de conceitos de Oracle separa a linguagem de definição de dados, a linguagem de manipulação e operações de consulta, além de destacar que SQL também controla acesso e integridade.[web:84][web:89]

### Compartilhamento

O SGBD permite que várias aplicações e usuários compartilhem os mesmos dados. Para isso, ele precisa lidar com:

- Usuários simultâneos.
- Transações.
- Bloqueios.
- Isolamento.
- Controle de concorrência.
- Permissões.
- Auditoria.
- Disponibilidade.

Em um sistema multiusuário, duas pessoas podem tentar alterar o mesmo registro. O SGBD precisa aplicar regras para evitar perda de dados e inconsistências.

## Tipos de dados

Tipos de dados determinam quais valores podem ser armazenados e quais operações podem ser realizadas.

### Numéricos

```sql
quantidade INT
preco DECIMAL(10,2)
medicao DOUBLE
```

Use inteiros para contagens e identificadores. Use `DECIMAL` para valores monetários, pois ele representa valores decimais com precisão definida.

### Textuais

```sql
nome VARCHAR(100)
descricao TEXT
sigla CHAR(2)
```

- `CHAR` é adequado para textos de tamanho fixo.
- `VARCHAR` é adequado para textos variáveis.
- `TEXT` é adequado para conteúdos longos, conforme as características do SGBD.

### Temporais

```sql
data_nascimento DATE
data_hora_criacao DATETIME
```

Datas e horários permitem ordenar acontecimentos, filtrar períodos e calcular duração.

### Outros dados

- Booleanos.
- JSON.
- XML.
- Geográficos.
- Binários.
- Vetores, quando suportados pelo SGBD ou por extensões.

## Estrutura

A estrutura de um banco representa a organização dos dados e dos objetos que os controlam.

### Elementos comuns

- Banco ou schema.
- Tabela.
- Coluna.
- Linha.
- Chave primária.
- Chave estrangeira.
- Índice.
- View.
- Procedure.
- Function.
- Trigger.
- Constraint.
- Sequência ou coluna autogerada.

### Exemplo de estrutura relacionada

```sql
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    id_categoria INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_produtos_categorias
        FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria),

    CONSTRAINT ck_produtos_preco
        CHECK (preco >= 0)
);
```

## Constraints

Constraints são regras aplicadas aos dados. Elas ajudam a impedir inserções e alterações inválidas.

### `NOT NULL`

```sql
nome VARCHAR(100) NOT NULL
```

Exige que a coluna receba um valor.

### `UNIQUE`

```sql
email VARCHAR(150) UNIQUE
```

Impede valores duplicados, conforme as regras do SGBD para `NULL`.

### `PRIMARY KEY`

```sql
id_cliente INT PRIMARY KEY
```

Identifica exclusivamente cada linha.

### `FOREIGN KEY`

```sql
FOREIGN KEY (id_categoria)
REFERENCES categorias(id_categoria)
```

Garante que o valor referenciado exista na tabela relacionada.

### `CHECK`

```sql
CHECK (preco >= 0)
```

Impõe uma condição que precisa ser verdadeira.

### `DEFAULT`

```sql
criado_em DATETIME DEFAULT CURRENT_TIMESTAMP
```

Fornece um valor automático quando nenhum valor é informado.

As constraints são regras de integridade. A documentação Oracle explica que os tipos de dados definem formato, restrições e faixa válida, enquanto as constraints impedem entradas que violem as regras do banco.[web:86]

## Inserção de dados

A inserção é realizada com `INSERT INTO`.

### Inserindo uma linha

```sql
INSERT INTO clientes (id_cliente, nome, email)
VALUES (1, 'Ana Souza', 'ana@exemplo.com');
```

### Inserindo várias linhas

```sql
INSERT INTO clientes (id_cliente, nome, email)
VALUES
    (2, 'Bruno Lima', 'bruno@exemplo.com'),
    (3, 'Carla Mendes', 'carla@exemplo.com');
```

### Inserção baseada em consulta

```sql
INSERT INTO clientes_ativos (id_cliente, nome, email)
SELECT id_cliente, nome, email
FROM clientes
WHERE ativo = 1;
```

### Cuidados

- Informe explicitamente as colunas.
- Confirme os tipos de dados.
- Verifique chaves estrangeiras.
- Valide valores obrigatórios.
- Use transação para operações relacionadas.
- Evite duplicidades com `UNIQUE`.
- Faça testes antes de inserir grandes volumes.

## Resumo dos conceitos

| Conceito | Significado | Exemplo |
|---|---|---|
| Banco de dados | Conjunto organizado e persistido de dados | Tabelas de clientes e pedidos |
| SGBD | Software que gerencia armazenamento, acesso e integridade | MySQL, SQL Server, Oracle |
| Persistência | Gravação durável dos dados | `INSERT INTO` |
| API | Interface de acesso entre sistemas | `GET /api/clientes/10` |
| Ação | Operação solicitada | Criar pedido |
| Mudança de estado | Resultado persistido da ação | Pedido passa para `PAGO` |
| Estrutura | Organização de tabelas, colunas e relacionamentos | `CREATE TABLE` |
| Constraint | Regra de integridade | `CHECK`, `UNIQUE`, `FOREIGN KEY` |
| Inserção | Inclusão de novos registros | `INSERT INTO` |

## Conclusão

Banco de dados é um conjunto organizado e persistido de dados. O SGBD fornece os recursos para definir estruturas, construir objetos, manipular registros e compartilhar informações com segurança. Em negócios como e-commerce, medicina, social media e engenharia, os dados representam entidades, acontecimentos, estados e relacionamentos. O acesso pode ocorrer por SQL ou por APIs, e as constraints ajudam a manter a consistência das informações.
