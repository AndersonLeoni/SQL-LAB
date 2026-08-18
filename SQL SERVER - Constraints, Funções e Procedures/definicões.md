# Stored Procedures e Functions em SQL e MySQL

## Visão geral

Uma rotina armazenada, ou *stored routine*, é um conjunto de instruções SQL salvo no servidor do banco de dados. No MySQL, os dois principais tipos são **stored procedures** e **stored functions**.[web:55]

A principal diferença é:

- A **stored procedure** é executada com `CALL` e pode retornar um ou mais conjuntos de resultados, além de usar parâmetros `IN`, `OUT` e `INOUT`.
- A **function** retorna um valor e pode ser utilizada dentro de expressões, como em `SELECT`, `WHERE` e `ORDER BY`.[web:55][web:62]

## Stored procedure

### Conceito

Uma stored procedure é um programa SQL armazenado no banco. Ela pode receber parâmetros, consultar tabelas, inserir dados, atualizar registros e executar regras de negócio.

Procedures são úteis quando uma operação precisa ser reutilizada por várias aplicações ou usuários. Como a lógica fica armazenada no banco, não é necessário repetir todo o código SQL em cada aplicação.

### Sintaxe básica no MySQL

```sql
DELIMITER //

CREATE PROCEDURE nome_procedure (
    IN parametro_entrada TIPO_DADO
)
BEGIN
    -- instruções SQL
END //

DELIMITER ;
```

O comando `DELIMITER` é utilizado no cliente do MySQL para que o ponto e vírgula dentro do bloco não seja interpretado como o fim antecipado do comando `CREATE PROCEDURE`.

### Exemplo sem parâmetros

```sql
DELIMITER //

CREATE PROCEDURE listar_clientes()
BEGIN
    SELECT
        id_cliente,
        nome,
        email
    FROM clientes
    ORDER BY nome;
END //

DELIMITER ;
```

A procedure foi criada, mas ainda precisa ser chamada para ser executada.

## Chamando uma stored procedure

### Usando CALL

Procedures MySQL são chamadas com o comando `CALL`.[web:62]

```sql
CALL listar_clientes();
```

Para uma procedure sem argumentos, o MySQL também permite omitir os parênteses em algumas situações:

```sql
CALL listar_clientes;
```

Apesar disso, usar `()` deixa o código mais claro e consistente.

### Procedure com parâmetro IN

O parâmetro `IN` recebe um valor enviado por quem chama a procedure. Ele é o tipo padrão de parâmetro no MySQL.

```sql
DELIMITER //

CREATE PROCEDURE buscar_cliente_por_id(
    IN p_id_cliente INT
)
BEGIN
    SELECT
        id_cliente,
        nome,
        email
    FROM clientes
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;
```

Chamada:

```sql
CALL buscar_cliente_por_id(10);
```

### Procedure com mais de um parâmetro

```sql
DELIMITER //

CREATE PROCEDURE listar_pedidos_periodo(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT
        id_pedido,
        id_cliente,
        data_pedido,
        valor_total
    FROM pedidos
    WHERE data_pedido BETWEEN p_data_inicio AND p_data_fim
    ORDER BY data_pedido;
END //

DELIMITER ;
```

Chamada:

```sql
CALL listar_pedidos_periodo('2026-01-01', '2026-01-31');
```

## Stored procedure com SELECT

Uma procedure pode conter um `SELECT` para retornar dados ao cliente.

```sql
DELIMITER //

CREATE PROCEDURE produtos_em_estoque()
BEGIN
    SELECT
        id_produto,
        nome,
        preco,
        estoque
    FROM produtos
    WHERE estoque > 0
    ORDER BY nome;
END //

DELIMITER ;
```

Execução:

```sql
CALL produtos_em_estoque();
```

O `SELECT` dentro da procedure retorna um conjunto de resultados. Uma procedure pode conter mais de um `SELECT`, e nesse caso o cliente pode receber múltiplos conjuntos de resultados.

### Procedure com agregação

```sql
DELIMITER //

CREATE PROCEDURE resumo_vendas_cliente(
    IN p_id_cliente INT
)
BEGIN
    SELECT
        p_id_cliente AS id_cliente,
        COUNT(*) AS quantidade_pedidos,
        COALESCE(SUM(valor_total), 0) AS total_gasto,
        COALESCE(AVG(valor_total), 0) AS media_pedido
    FROM pedidos
    WHERE id_cliente = p_id_cliente;
END //

DELIMITER ;
```

Chamada:

```sql
CALL resumo_vendas_cliente(10);
```

## Parâmetros OUT e INOUT

### Parâmetro OUT

Um parâmetro `OUT` devolve um valor para quem chamou a procedure. Ele precisa ser associado a uma variável do usuário.

```sql
DELIMITER //

CREATE PROCEDURE contar_clientes(
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*)
    INTO p_total
    FROM clientes;
END //

DELIMITER ;
```

Chamada e leitura do resultado:

```sql
CALL contar_clientes(@total_clientes);

SELECT @total_clientes AS total_clientes;
```

### Parâmetro INOUT

O parâmetro `INOUT` recebe um valor e pode devolvê-lo alterado.

```sql
DELIMITER //

CREATE PROCEDURE aplicar_acrescimo(
    INOUT p_valor DECIMAL(10,2),
    IN p_percentual DECIMAL(5,2)
)
BEGIN
    SET p_valor = p_valor + (p_valor * p_percentual / 100);
END //

DELIMITER ;
```

Uso:

```sql
SET @valor = 100.00;

CALL aplicar_acrescimo(@valor, 10);

SELECT @valor AS valor_atualizado;
```

## Procedure com INSERT

```sql
DELIMITER //

CREATE PROCEDURE cadastrar_cliente(
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(150)
)
BEGIN
    INSERT INTO clientes (nome, email)
    VALUES (p_nome, p_email);
END //

DELIMITER ;
```

Chamada:

```sql
CALL cadastrar_cliente('Ana Souza', 'ana@exemplo.com');
```

Se a coluna `email` possuir uma constraint `UNIQUE`, a procedure não conseguirá inserir um e-mail duplicado. As regras definidas na tabela continuam válidas mesmo quando os dados são alterados por uma procedure.

## Procedure com UPDATE

```sql
DELIMITER //

CREATE PROCEDURE atualizar_preco_produto(
    IN p_id_produto INT,
    IN p_novo_preco DECIMAL(10,2)
)
BEGIN
    UPDATE produtos
    SET preco = p_novo_preco
    WHERE id_produto = p_id_produto;
END //

DELIMITER ;
```

Chamada:

```sql
CALL atualizar_preco_produto(5, 199.90);
```

## Procedure com transação e tratamento de erro

Para operações que envolvem várias alterações, pode-se usar uma transação. O `EXIT HANDLER` trata uma exceção e desfaz a operação quando necessário.

```sql
DELIMITER //

CREATE PROCEDURE transferir_saldo(
    IN p_conta_origem INT,
    IN p_conta_destino INT,
    IN p_valor DECIMAL(10,2)
)
BEGIN
    DECLARE v_saldo DECIMAL(10,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT saldo
    INTO v_saldo
    FROM contas
    WHERE id_conta = p_conta_origem
    FOR UPDATE;

    IF v_saldo < p_valor THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Saldo insuficiente';
    END IF;

    UPDATE contas
    SET saldo = saldo - p_valor
    WHERE id_conta = p_conta_origem;

    UPDATE contas
    SET saldo = saldo + p_valor
    WHERE id_conta = p_conta_destino;

    COMMIT;
END //

DELIMITER ;
```

Esse exemplo demonstra a ideia de agrupar operações que precisam ser confirmadas juntas. Em um sistema real, também devem ser validados valores positivos, existência das contas e concorrência.

## Functions

### Conceito

Uma stored function recebe parâmetros e retorna um valor definido pela cláusula `RETURNS`. No MySQL, uma function pode ser chamada dentro de uma expressão, como parte de um `SELECT`.[web:55]

### Sintaxe básica

```sql
DELIMITER //

CREATE FUNCTION nome_function(
    parametro TIPO_DADO
)
RETURNS TIPO_RETORNO
DETERMINISTIC
BEGIN
    DECLARE resultado TIPO_RETORNO;

    -- cálculo ou consulta

    RETURN resultado;
END //

DELIMITER ;
```

`DETERMINISTIC` indica que, para os mesmos parâmetros, a function produz o mesmo resultado. Use essa característica somente quando ela corresponder ao comportamento real da função.

### Function simples

```sql
DELIMITER //

CREATE FUNCTION calcular_desconto(
    p_preco DECIMAL(10,2),
    p_percentual DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN p_preco - (p_preco * p_percentual / 100);
END //

DELIMITER ;
```

Uso em um `SELECT`:

```sql
SELECT
    nome,
    preco,
    calcular_desconto(preco, 10) AS preco_com_desconto
FROM produtos;
```

### Function para classificar uma nota

```sql
DELIMITER //

CREATE FUNCTION classificar_nota(
    p_nota DECIMAL(4,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_nota >= 7 THEN
        RETURN 'Aprovado';
    ELSEIF p_nota >= 5 THEN
        RETURN 'Recuperação';
    ELSE
        RETURN 'Reprovado';
    END IF;
END //

DELIMITER ;
```

Uso:

```sql
SELECT
    nome_aluno,
    nota_final,
    classificar_nota(nota_final) AS situacao
FROM alunos;
```

### Function com consulta

```sql
DELIMITER //

CREATE FUNCTION total_pedidos_cliente(
    p_id_cliente INT
)
RETURNS DECIMAL(12,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(12,2);

    SELECT COALESCE(SUM(valor_total), 0)
    INTO v_total
    FROM pedidos
    WHERE id_cliente = p_id_cliente;

    RETURN v_total;
END //

DELIMITER ;
```

Uso:

```sql
SELECT
    id_cliente,
    nome,
    total_pedidos_cliente(id_cliente) AS total_gasto
FROM clientes;
```

`READS SQL DATA` documenta que a função lê dados. As características da rotina devem refletir o que ela realmente faz.

## Procedure versus Function

| Característica | Stored procedure | Stored function |
|---|---|---|
| Chamada principal | `CALL nome(...)` | `SELECT nome(...)` ou expressão |
| Retorno | Pode retornar conjuntos de resultados e parâmetros `OUT` | Retorna um valor definido por `RETURNS` |
| Uso comum | Processos, relatórios e alterações de dados | Cálculos e transformações reutilizáveis |
| Pode ter `SELECT` | Sim, para retornar resultados ou preencher variáveis | Sim, normalmente com `SELECT ... INTO` |
| Pode usar `INSERT`, `UPDATE` e `DELETE` | Sim, observadas as regras do MySQL | Possui restrições próprias; deve ser usada principalmente para obter um valor |

O MySQL chama procedures com `CALL`, enquanto functions são referenciadas dentro de expressões.[web:55][web:62]

## Consultando e removendo rotinas

Ver a definição de uma procedure:

```sql
SHOW CREATE PROCEDURE listar_clientes;
```

Ver a definição de uma function:

```sql
SHOW CREATE FUNCTION calcular_desconto;
```

Listar rotinas de um banco:

```sql
SELECT
    ROUTINE_TYPE,
    ROUTINE_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_SCHEMA = DATABASE();
```

Remover uma procedure:

```sql
DROP PROCEDURE IF EXISTS listar_clientes;
```

Remover uma function:

```sql
DROP FUNCTION IF EXISTS calcular_desconto;
```

## Boas práticas

- Use nomes claros e padronizados para procedures e functions.
- Prefixos como `sp_` são frequentemente evitados para não confundir objetos do usuário com procedures internas do sistema.
- Valide parâmetros antes de alterar dados.
- Use transações quando várias operações precisarem ser confirmadas juntas.
- Use `SELECT ... INTO` quando precisar armazenar o resultado de uma consulta em uma variável local.
- Documente se uma function é `DETERMINISTIC`, se lê dados ou se modifica dados.
- Evite colocar regras muito complexas em functions usadas em milhares de linhas, pois isso pode afetar o desempenho.
- Use `SHOW CREATE PROCEDURE` e `SHOW CREATE FUNCTION` para verificar a definição armazenada.
- Controle permissões para evitar que usuários executem rotinas sem autorização.

## Resumo

- `CREATE PROCEDURE` cria uma procedure armazenada.
- `CALL` executa uma stored procedure.
- Procedures podem conter `SELECT`, `INSERT`, `UPDATE`, `DELETE`, variáveis, condições e transações.
- `CREATE FUNCTION` cria uma função armazenada.
- Functions retornam um valor e podem ser usadas em expressões SQL.
- Parâmetros `IN`, `OUT` e `INOUT` permitem controlar a entrada e a saída de dados.
- O `DELIMITER` facilita a criação de blocos com múltiplos comandos no cliente MySQL.
