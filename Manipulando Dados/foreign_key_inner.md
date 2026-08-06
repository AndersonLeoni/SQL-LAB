# Criando vínculos com Foreign Key e usando JOIN em SQL e MySQL

## Visão geral

Em bancos de dados relacionais, as informações são normalmente separadas em tabelas relacionadas. A `FOREIGN KEY` cria e protege o vínculo entre tabelas, enquanto o `JOIN` permite consultar dados relacionados em uma única consulta. No MySQL, as restrições de chave estrangeira podem ser definidas com `CREATE TABLE` ou adicionadas posteriormente com `ALTER TABLE`.[cite:11][cite:12]

Exemplo de relacionamento:

- `clientes` é a tabela principal ou pai.
- `pedidos` é a tabela dependente ou filha.
- `clientes.id_cliente` é a chave primária.
- `pedidos.id_cliente` é a chave estrangeira que referencia o cliente.

## Foreign Key

### Conceito

Uma `FOREIGN KEY`, ou chave estrangeira, é uma coluna — ou conjunto de colunas — que referencia uma `PRIMARY KEY` ou outra chave única em uma tabela relacionada. Ela ajuda a manter a integridade referencial, evitando que a tabela filha armazene uma referência para um registro inexistente na tabela pai.[cite:11][cite:22]

### Criando as tabelas com vínculo

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor DECIMAL(10, 2),

    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);
```

No exemplo, cada pedido precisa estar associado a um `id_cliente` existente na tabela `clientes`.

### Adicionando uma Foreign Key depois

Quando as tabelas já existem, o vínculo pode ser criado com `ALTER TABLE`:

```sql
ALTER TABLE pedidos
ADD CONSTRAINT fk_pedidos_clientes
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente);
```

A coluna `pedidos.id_cliente` deve ser compatível com a coluna referenciada, especialmente em tipo e atributos importantes. É recomendável criar as tabelas e suas restrições por script, pois o código pode ser versionado, revisado e reproduzido em outros ambientes.

### Ações de atualização e exclusão

As cláusulas `ON DELETE` e `ON UPDATE` definem o que acontece na tabela filha quando o registro referenciado é excluído ou atualizado. O MySQL documenta opções como `RESTRICT`, `CASCADE`, `SET NULL`, `NO ACTION` e `SET DEFAULT`.[cite:11]

```sql
CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,

    CONSTRAINT fk_pedidos_clientes
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
```

Nesse exemplo:

- `ON UPDATE CASCADE` propaga uma alteração da chave referenciada.
- `ON DELETE RESTRICT` impede a exclusão de um cliente enquanto houver pedidos relacionados.

Use `ON DELETE CASCADE` com cuidado, porque a exclusão de um registro pai pode excluir automaticamente registros filhos.

## JOIN

### Conceito

`JOIN` combina linhas de duas ou mais tabelas com base em uma condição de relacionamento, normalmente uma comparação entre a chave primária de uma tabela e a chave estrangeira de outra.

### Sintaxe geral

```sql
SELECT tabela_a.coluna,
       tabela_b.coluna
FROM tabela_a
JOIN tabela_b
    ON tabela_a.chave = tabela_b.chave_estrangeira;
```

Embora a `FOREIGN KEY` documente e proteja o relacionamento, o `JOIN` é a cláusula usada para recuperar os dados relacionados. O MySQL suporta `INNER JOIN`, `LEFT JOIN` e `RIGHT JOIN`, entre outras formas de junção.[cite:13]

## INNER JOIN

### Conceito

`INNER JOIN` retorna somente as linhas que possuem correspondência nas duas tabelas. Se um cliente não tiver pedido, ele não aparecerá em uma consulta que use `INNER JOIN` entre `clientes` e `pedidos`.[cite:13][cite:21]

### Exemplo

```sql
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido,
    p.valor
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente;
```

`JOIN` sem especificar o tipo geralmente é tratado como `INNER JOIN` em consultas desse formato.[cite:16]

### Com condição adicional

```sql
SELECT
    c.nome,
    p.id_pedido,
    p.valor
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente
WHERE p.valor > 100;
```

A condição de relacionamento fica no `ON`; o filtro sobre os dados pode ficar no `WHERE`.

## LEFT JOIN

### Conceito

`LEFT JOIN`, também chamado `LEFT OUTER JOIN`, retorna todas as linhas da tabela à esquerda e as linhas correspondentes da tabela à direita. Quando não existe correspondência, as colunas da tabela direita aparecem como `NULL`.[cite:13][cite:17]

### Exemplo

Listar todos os clientes, inclusive os que ainda não fizeram pedidos:

```sql
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido,
    p.valor
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente;
```

### Encontrando clientes sem pedidos

```sql
SELECT
    c.id_cliente,
    c.nome
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente
WHERE p.id_pedido IS NULL;
```

O `LEFT JOIN` é útil quando a tabela principal deve aparecer completa, mesmo que não existam registros relacionados.

## RIGHT JOIN

### Conceito

`RIGHT JOIN`, também chamado `RIGHT OUTER JOIN`, retorna todas as linhas da tabela à direita e somente as linhas correspondentes da tabela à esquerda. Quando não há correspondência, as colunas da tabela esquerda aparecem como `NULL`.[cite:13][cite:18]

### Exemplo

```sql
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido
FROM clientes AS c
RIGHT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente;
```

Nesse caso, todos os pedidos aparecem, inclusive aqueles cujo cliente correspondente não esteja disponível. Em um banco com uma `FOREIGN KEY` válida, esse cenário normalmente não deveria ocorrer, mas o exemplo demonstra o comportamento do `RIGHT JOIN`.

Na prática, muitos desenvolvedores preferem reescrever um `RIGHT JOIN` como `LEFT JOIN`, invertendo a ordem das tabelas. Isso costuma deixar a leitura mais uniforme:

```sql
SELECT
    c.id_cliente,
    c.nome,
    p.id_pedido,
    p.data_pedido
FROM pedidos AS p
LEFT JOIN clientes AS c
    ON c.id_cliente = p.id_cliente;
```

## Comparação entre os tipos de JOIN

| Tipo | Linhas retornadas | Quando usar |
|---|---|---|
| `INNER JOIN` | Apenas correspondências nas duas tabelas | Quando somente relacionamentos existentes interessam |
| `LEFT JOIN` | Todas as linhas da tabela esquerda e correspondências da direita | Quando a tabela esquerda deve aparecer completa |
| `RIGHT JOIN` | Todas as linhas da tabela direita e correspondências da esquerda | Quando a tabela direita deve aparecer completa |

## Exemplo completo

### Inserindo dados

```sql
INSERT INTO clientes (nome, email)
VALUES
    ('Ana Souza', 'ana@exemplo.com'),
    ('Bruno Lima', 'bruno@exemplo.com'),
    ('Carla Mendes', 'carla@exemplo.com');

INSERT INTO pedidos (id_cliente, data_pedido, valor)
VALUES
    (1, '2026-08-01', 250.00),
    (1, '2026-08-02', 80.00),
    (2, '2026-08-03', 140.00);
```

### Total de pedidos por cliente

```sql
SELECT
    c.id_cliente,
    c.nome,
    COUNT(p.id_pedido) AS quantidade_pedidos,
    COALESCE(SUM(p.valor), 0) AS total_gasto
FROM clientes AS c
LEFT JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;
```

O `LEFT JOIN` mantém Carla no resultado mesmo sem pedido. `COUNT(p.id_pedido)` não conta a linha sem pedido, e `COALESCE` transforma um total `NULL` em zero.

## Ordem básica das cláusulas

Uma consulta com `JOIN`, filtro, agrupamento e ordenação normalmente segue esta estrutura:

```sql
SELECT colunas
FROM tabela_principal
INNER JOIN tabela_relacionada
    ON condição_de_relacionamento
WHERE condição_de_filtro
GROUP BY colunas_de_agrupamento
HAVING condição_sobre_agregação
ORDER BY coluna ASC;
```

A condição que conecta as tabelas deve ser definida no `ON`. Colocar filtros de uma tabela do lado direito no `WHERE` após um `LEFT JOIN` pode eliminar as linhas com `NULL` e produzir um resultado parecido com `INNER JOIN`.

## Boas práticas

- Nomeie as restrições, como `fk_pedidos_clientes`, para facilitar manutenção.
- Use aliases curtos e claros, como `c` para `clientes` e `p` para `pedidos`.
- Liste as colunas desejadas em vez de usar `SELECT *` em consultas de produção.
- Prefira `LEFT JOIN` quando todos os registros da tabela principal precisam aparecer.
- Verifique se as colunas usadas no relacionamento têm tipos compatíveis.
- Use ações `ON DELETE` e `ON UPDATE` somente quando o comportamento estiver de acordo com a regra de negócio.
- Crie e altere vínculos por scripts testados e versionados.

## Conclusão

A `FOREIGN KEY` define e protege o relacionamento entre tabelas. O `INNER JOIN` retorna somente registros relacionados, enquanto `LEFT JOIN` e `RIGHT JOIN` também preservam todos os registros de um dos lados, preenchendo o lado sem correspondência com `NULL`. Esses recursos formam a base para consultar dados normalizados em SQL e MySQL.
