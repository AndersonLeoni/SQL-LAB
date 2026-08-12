## Visão geral

No SQL Server, `constraints` são regras de integridade aplicadas às tabelas. Elas determinam quais valores podem ser inseridos, alterados ou relacionados entre tabelas. Dessa forma, o próprio banco ajuda a impedir dados ausentes, duplicados, inválidos ou sem correspondência.

As principais constraints abordadas neste material são `NOT NULL`, `UNIQUE`, `CHECK`, `DEFAULT`, `PRIMARY KEY` e `FOREIGN KEY`. O SQL Server também permite criar funções e procedures para reutilizar regras e operações SQL.

As constraints `UNIQUE` e `CHECK` são utilizadas para aplicar integridade aos dados, enquanto `PRIMARY KEY` e `FOREIGN KEY` protegem a identificação dos registros e os relacionamentos entre tabelas.[web:42][web:44]

## O que são Constraints

Uma constraint é uma regra declarada na criação ou alteração de uma tabela. Quando um comando `INSERT` ou `UPDATE` viola essa regra, o SQL Server rejeita a operação e informa o erro.

### Exemplo de tabela com várias constraints

```sql
CREATE TABLE Clientes
(
    IdCliente INT IDENTITY(1,1),
    Nome      NVARCHAR(100) NOT NULL,
    Email     NVARCHAR(150) NOT NULL,
    Idade     INT NOT NULL,
    Status    CHAR(1) NOT NULL
        CONSTRAINT DF_Clientes_Status DEFAULT ('A'),

    CONSTRAINT PK_Clientes
        PRIMARY KEY (IdCliente),

    CONSTRAINT UQ_Clientes_Email
        UNIQUE (Email),

    CONSTRAINT CK_Clientes_Idade
        CHECK (Idade >= 18),

    CONSTRAINT CK_Clientes_Status
        CHECK (Status IN ('A', 'I'))
);
```

Nesse exemplo:

- `IdCliente` é gerado automaticamente com `IDENTITY`.
- `Nome`, `Email`, `Idade` e `Status` são obrigatórios.
- `Email` não pode se repetir.
- `Idade` deve ser maior ou igual a 18.
- `Status` aceita apenas `A` ou `I`.
- O status padrão é `A` quando nenhum valor é informado.

## NOT NULL

### Conceito

`NOT NULL` obriga a coluna a receber um valor. A coluna não pode ficar com o valor especial `NULL`, que representa ausência ou desconhecimento de informação.

`NOT NULL` não impede valores duplicados. Por exemplo, vários clientes podem ter o mesmo nome, mas o nome ainda pode ser obrigatório.

### Exemplo

```sql
CREATE TABLE Produtos
(
    IdProduto INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Preco DECIMAL(10,2) NOT NULL
);
```

Inserção válida:

```sql
INSERT INTO Produtos (Nome, Preco)
VALUES ('Teclado', 120.00);
```

Inserção inválida:

```sql
INSERT INTO Produtos (Nome, Preco)
VALUES (NULL, 120.00);
```

### Quando usar

Use `NOT NULL` para campos essenciais, como nome, data de cadastro, preço, identificadores e chaves estrangeiras obrigatórias.

## UNIQUE

### Conceito

`UNIQUE` impede que uma coluna ou combinação de colunas tenha valores repetidos. É útil para e-mail, CPF, CNPJ, matrícula ou código externo.

No SQL Server, uma constraint `UNIQUE` é diferente da `PRIMARY KEY`: a tabela pode ter várias constraints `UNIQUE`, mas apenas uma chave primária. A `UNIQUE` pode aceitar `NULL`, respeitando as regras do SQL Server; em uma coluna única, normalmente apenas um valor `NULL` é permitido.[web:42]

### Exemplo em uma coluna

```sql
CREATE TABLE Usuarios
(
    IdUsuario INT IDENTITY(1,1),
    Email NVARCHAR(150) NOT NULL,

    CONSTRAINT PK_Usuarios
        PRIMARY KEY (IdUsuario),

    CONSTRAINT UQ_Usuarios_Email
        UNIQUE (Email)
);
```

A segunda inserção com o mesmo e-mail será rejeitada:

```sql
INSERT INTO Usuarios (Email)
VALUES ('ana@exemplo.com');

INSERT INTO Usuarios (Email)
VALUES ('ana@exemplo.com');
```

### Exemplo com combinação de colunas

```sql
CREATE TABLE Inscricoes
(
    IdAluno INT NOT NULL,
    IdCurso INT NOT NULL,

    CONSTRAINT UQ_Inscricoes_Aluno_Curso
        UNIQUE (IdAluno, IdCurso)
);
```

Nesse caso, o mesmo aluno não pode ser inscrito duas vezes no mesmo curso, mas pode participar de cursos diferentes.

## CHECK

### Conceito

`CHECK` limita os valores aceitos de acordo com uma expressão lógica. A expressão precisa ser verdadeira para que a inserção ou alteração seja aceita.

### Exemplo de faixa numérica

```sql
CREATE TABLE Avaliacoes
(
    IdAvaliacao INT IDENTITY(1,1) PRIMARY KEY,
    Nota DECIMAL(4,2) NOT NULL,

    CONSTRAINT CK_Avaliacoes_Nota
        CHECK (Nota >= 0 AND Nota <= 10)
);
```

Valores válidos:

```sql
INSERT INTO Avaliacoes (Nota)
VALUES (8.5);
```

Valor inválido:

```sql
INSERT INTO Avaliacoes (Nota)
VALUES (12);
```

### Exemplo com lista de valores

```sql
CREATE TABLE Pedidos
(
    IdPedido INT IDENTITY(1,1) PRIMARY KEY,
    Status CHAR(1) NOT NULL,

    CONSTRAINT CK_Pedidos_Status
        CHECK (Status IN ('A', 'P', 'F', 'C'))
);
```

Uma possível interpretação é:

- `A`: aberto.
- `P`: processando.
- `F`: finalizado.
- `C`: cancelado.

### Importante

`CHECK` deve representar uma regra que possa ser avaliada a partir dos valores da própria linha. Regras que dependem de várias tabelas geralmente devem ser controladas por relacionamentos, procedures, triggers ou pela aplicação.

## DEFAULT

### Conceito

`DEFAULT` define um valor automático quando o `INSERT` não informa uma coluna. Ele não substitui explicitamente um valor informado e não impede que `NULL` seja inserido se a coluna permitir `NULL`.

### Exemplo com texto

```sql
CREATE TABLE Tarefas
(
    IdTarefa INT IDENTITY(1,1) PRIMARY KEY,
    Descricao NVARCHAR(200) NOT NULL,
    Status CHAR(1) NOT NULL
        CONSTRAINT DF_Tarefas_Status DEFAULT ('A')
);
```

Inserção usando o valor padrão:

```sql
INSERT INTO Tarefas (Descricao)
VALUES ('Criar relatório mensal');
```

O SQL Server preencherá `Status` com `A`.

### Exemplo com data e hora

```sql
CREATE TABLE Logs
(
    IdLog INT IDENTITY(1,1) PRIMARY KEY,
    Mensagem NVARCHAR(500) NOT NULL,
    DataRegistro DATETIME2 NOT NULL
        CONSTRAINT DF_Logs_DataRegistro DEFAULT (SYSDATETIME())
);
```

### Observação

`GETDATE()` retorna a data e hora atuais com precisão de `datetime`. `SYSDATETIME()` retorna um valor `datetime2` com maior precisão.

## PRIMARY KEY

### Conceito

`PRIMARY KEY`, ou chave primária, identifica exclusivamente cada linha de uma tabela. Suas colunas não podem conter valores duplicados nem `NULL`. O SQL Server exige que todas as colunas de uma chave primária sejam `NOT NULL`.[web:44]

Uma tabela pode ter apenas uma constraint de chave primária, mas essa chave pode ser composta por várias colunas.

### Exemplo com chave simples

```sql
CREATE TABLE Categorias
(
    IdCategoria INT IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Categorias
        PRIMARY KEY (IdCategoria)
);
```

### Exemplo com chave composta

```sql
CREATE TABLE ItensPedido
(
    IdPedido INT NOT NULL,
    IdProduto INT NOT NULL,
    Quantidade INT NOT NULL,

    CONSTRAINT PK_ItensPedido
        PRIMARY KEY (IdPedido, IdProduto)
);
```

A combinação `IdPedido + IdProduto` não pode se repetir.

## FOREIGN KEY

### Conceito

`FOREIGN KEY`, ou chave estrangeira, cria um vínculo entre uma tabela filha e uma tabela pai. A coluna filha referencia uma chave primária ou uma constraint `UNIQUE` da tabela pai.

### Exemplo

```sql
CREATE TABLE Clientes
(
    IdCliente INT IDENTITY(1,1),
    Nome NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Clientes
        PRIMARY KEY (IdCliente)
);

CREATE TABLE Pedidos
(
    IdPedido INT IDENTITY(1,1),
    IdCliente INT NOT NULL,
    DataPedido DATETIME2 NOT NULL
        CONSTRAINT DF_Pedidos_DataPedido DEFAULT (SYSDATETIME()),

    CONSTRAINT PK_Pedidos
        PRIMARY KEY (IdPedido),

    CONSTRAINT FK_Pedidos_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes (IdCliente)
);
```

O pedido só poderá utilizar um `IdCliente` que exista em `Clientes`.

### Ações referenciais

```sql
CREATE TABLE Pedidos
(
    IdPedido INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,

    CONSTRAINT FK_Pedidos_Clientes
        FOREIGN KEY (IdCliente)
        REFERENCES Clientes (IdCliente)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
```

Principais ações:

- `NO ACTION`: impede a alteração ou exclusão quando há registros dependentes.
- `CASCADE`: propaga a alteração ou exclusão para os registros relacionados.
- `SET NULL`: coloca `NULL` na chave estrangeira; a coluna deve aceitar `NULL`.
- `SET DEFAULT`: usa o valor padrão da coluna, quando a configuração for compatível.

O SQL Server documenta as opções de ações referenciais e exige, por exemplo, que uma chave estrangeira aceite `NULL` quando `SET NULL` for utilizado.[web:44]

## Adicionando constraints depois

As constraints podem ser criadas junto com a tabela ou depois, usando `ALTER TABLE`.[web:46]

```sql
ALTER TABLE Clientes
ADD CONSTRAINT UQ_Clientes_Email
UNIQUE (Email);
```

```sql
ALTER TABLE Produtos
ADD CONSTRAINT CK_Produtos_Preco
CHECK (Preco >= 0);
```

```sql
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Pedidos_Clientes
FOREIGN KEY (IdCliente)
REFERENCES Clientes (IdCliente);
```

Se a tabela já contiver dados inválidos, o SQL Server poderá rejeitar a criação da constraint até que os dados sejam corrigidos.

## Funções no SQL Server

Uma função é um objeto reutilizável que recebe parâmetros e retorna um valor ou uma tabela. Funções podem ser utilizadas em consultas, expressões e outras rotinas, de acordo com o tipo de função.

### Função escalar

```sql
CREATE OR ALTER FUNCTION dbo.CalcularDesconto
(
    @Preco DECIMAL(10,2),
    @Percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Preco - (@Preco * @Percentual / 100);
END;
GO
```

Uso:

```sql
SELECT
    Nome,
    Preco,
    dbo.CalcularDesconto(Preco, 10) AS PrecoComDesconto
FROM Produtos;
```

### Função que retorna tabela

```sql
CREATE OR ALTER FUNCTION dbo.ClientesAtivos()
RETURNS TABLE
AS
RETURN
(
    SELECT IdCliente, Nome, Email
    FROM Clientes
    WHERE Ativo = 1
);
GO
```

Uso:

```sql
SELECT *
FROM dbo.ClientesAtivos();
```

## Procedures no SQL Server

Uma stored procedure é um conjunto nomeado de instruções T-SQL armazenado no banco. Pode receber parâmetros, executar consultas e realizar operações de inserção, alteração e exclusão. A sintaxe oficial utiliza `CREATE PROCEDURE` ou `CREATE OR ALTER PROCEDURE`.[web:41][web:43]

### Procedure de consulta

```sql
CREATE OR ALTER PROCEDURE dbo.ListarPedidosPorCliente
    @IdCliente INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        IdPedido,
        IdCliente,
        DataPedido
    FROM Pedidos
    WHERE IdCliente = @IdCliente
    ORDER BY DataPedido DESC;
END;
GO
```

Execução:

```sql
EXEC dbo.ListarPedidosPorCliente @IdCliente = 1;
```

### Procedure de inserção

```sql
CREATE OR ALTER PROCEDURE dbo.CadastrarCliente
    @Nome NVARCHAR(100),
    @Email NVARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Clientes (Nome, Email)
    VALUES (@Nome, @Email);
END;
GO
```

Execução:

```sql
EXEC dbo.CadastrarCliente
    @Nome = 'Ana Souza',
    @Email = 'ana@exemplo.com';
```

A constraint `UNIQUE` sobre `Email` continua sendo aplicada mesmo quando a inserção é feita por uma procedure. Isso é importante porque as regras ficam protegidas no banco, independentemente da aplicação ou rotina que execute o `INSERT`.

## Função versus procedure

| Recurso | Função | Procedure |
|---|---|---|
| Retorno | Retorna um valor ou uma tabela | Pode retornar conjuntos de resultados e parâmetros de saída |
| Uso típico | Cálculos e consultas reutilizáveis | Processos, consultas parametrizadas e operações de dados |
| Chamada | Pode aparecer em expressões, conforme o tipo | Executada com `EXEC` ou `EXECUTE` |
| Alteração de dados | Possui restrições específicas | Pode executar `INSERT`, `UPDATE` e `DELETE` |
| Exemplo | Calcular desconto | Cadastrar cliente |

## Inserções válidas e inválidas

### Inserção válida

```sql
INSERT INTO Clientes (Nome, Email, Idade, Status)
VALUES ('Ana Souza', 'ana@exemplo.com', 25, 'A');
```

### Exemplos de violações

```sql
-- Viola NOT NULL
INSERT INTO Clientes (Nome, Email, Idade, Status)
VALUES (NULL, 'ana2@exemplo.com', 25, 'A');
```

```sql
-- Viola UNIQUE se o e-mail já existir
INSERT INTO Clientes (Nome, Email, Idade, Status)
VALUES ('Outra Pessoa', 'ana@exemplo.com', 30, 'A');
```

```sql
-- Viola CHECK
INSERT INTO Clientes (Nome, Email, Idade, Status)
VALUES ('Pessoa Menor', 'menor@exemplo.com', 15, 'A');
```

```sql
-- Viola FOREIGN KEY se o cliente 999 não existir
INSERT INTO Pedidos (IdCliente)
VALUES (999);
```

## Boas práticas

- Nomeie constraints explicitamente, por exemplo, `PK_Clientes` e `FK_Pedidos_Clientes`.
- Use `NOT NULL` em informações obrigatórias.
- Use `UNIQUE` para identificadores de negócio, como e-mail e CPF.
- Use `CHECK` para regras simples e estáveis de domínio.
- Use `DEFAULT` para valores automáticos, como status inicial e data de cadastro.
- Defina uma `PRIMARY KEY` em todas as tabelas de entidades.
- Use `FOREIGN KEY` para proteger relacionamentos entre tabelas.
- Prefira `CREATE OR ALTER` para facilitar a manutenção de funções e procedures.
- Use `SET NOCOUNT ON` em procedures para reduzir mensagens de contagem de linhas.
- Valide os dados antes de inserir, mas mantenha as regras essenciais também no banco.

## Resumo

| Constraint | Regra principal | Exemplo |
|---|---|---|
| `NOT NULL` | Exige um valor | `Nome NVARCHAR(100) NOT NULL` |
| `UNIQUE` | Impede duplicidade | `CONSTRAINT UQ_Email UNIQUE (Email)` |
| `CHECK` | Valida uma condição | `CHECK (Preco >= 0)` |
| `DEFAULT` | Fornece valor automático | `DEFAULT (SYSDATETIME())` |
| `PRIMARY KEY` | Identifica cada linha | `PRIMARY KEY (IdCliente)` |
| `FOREIGN KEY` | Mantém vínculo entre tabelas | `REFERENCES Clientes (IdCliente)` |

Constraints protegem a qualidade dos dados; funções encapsulam cálculos ou consultas reutilizáveis; e procedures organizam operações de negócio no SQL Server. A combinação desses recursos torna o banco mais consistente, seguro e fácil de manter.
