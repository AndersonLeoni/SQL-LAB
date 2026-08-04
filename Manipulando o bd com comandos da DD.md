# Manipulando dados: COUNT, SUM, MAX, MIN e AVG em SQL e MySQL

## Visão geral
As funções de agregação servem para resumir dados em consultas SQL. Elas são muito usadas para contar registros, somar valores, identificar extremos e calcular médias em conjuntos de linhas.

Essas funções existem no SQL padrão e também no MySQL, com comportamento muito parecido na maioria dos casos. Em geral, elas aparecem junto com `SELECT`, `WHERE`, `GROUP BY` e `HAVING`.

## COUNT
A função `COUNT` é usada para contar registros. Ela pode contar todas as linhas retornadas por uma consulta ou apenas os valores não nulos de uma coluna específica.

### Formas mais comuns
```sql
COUNT(*)
COUNT(coluna)
COUNT(DISTINCT coluna)
```

### Exemplos
Contando todas as linhas da tabela `clientes`:

```sql
SELECT COUNT(*) AS total_clientes
FROM clientes;
```

Contando apenas clientes que possuem e-mail preenchido:

```sql
SELECT COUNT(email) AS clientes_com_email
FROM clientes;
```

Contando cidades diferentes cadastradas:

```sql
SELECT COUNT(DISTINCT cidade) AS total_cidades
FROM clientes;
```

### Observações
- `COUNT(*)` conta todas as linhas, inclusive quando há valores nulos em colunas.
- `COUNT(coluna)` conta apenas as linhas em que aquela coluna não é `NULL`.
- `COUNT(DISTINCT coluna)` conta valores distintos, ignorando repetições.

## SUM
A função `SUM` soma os valores de uma coluna numérica. Ela é útil para calcular totais, como faturamento, quantidade vendida ou saldo.

### Exemplo simples
Somando o valor total de pedidos:

```sql
SELECT SUM(valor_total) AS soma_pedidos
FROM pedidos;
```

Somando a quantidade vendida de um produto específico:

```sql
SELECT SUM(quantidade) AS total_vendido
FROM itens_pedido
WHERE id_produto = 10;
```

### Observações
- `SUM` deve ser usada com colunas numéricas.
- Valores `NULL` são ignorados no cálculo.
- Pode ser combinada com `GROUP BY` para somas por categoria.

### Exemplo com agrupamento
Total de vendas por cliente:

```sql
SELECT id_cliente, SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY id_cliente;
```

## MAX e MIN
As funções `MAX` e `MIN` retornam, respectivamente, o maior e o menor valor de uma coluna. Elas funcionam com números, datas e até textos, dependendo do banco.

### Exemplos
Maior salário cadastrado:

```sql
SELECT MAX(salario) AS maior_salario
FROM funcionarios;
```

Menor salário cadastrado:

```sql
SELECT MIN(salario) AS menor_salario
FROM funcionarios;
```

Data do pedido mais recente:

```sql
SELECT MAX(data_pedido) AS pedido_mais_recente
FROM pedidos;
```

Data do pedido mais antigo:

```sql
SELECT MIN(data_pedido) AS pedido_mais_antigo
FROM pedidos;
```

### Observações
- `MAX` encontra o valor mais alto.
- `MIN` encontra o valor mais baixo.
- Em colunas de data, ajudam a encontrar registros mais antigos ou mais recentes.
- Em colunas textuais, o resultado depende da ordem alfabética e da collation usada pelo banco.

## AVG
A função `AVG` calcula a média dos valores de uma coluna numérica. Ela é muito usada em relatórios para obter médias de notas, preços, salários ou quantidades.

### Exemplo simples
Média salarial dos funcionários:

```sql
SELECT AVG(salario) AS media_salarial
FROM funcionarios;
```

Média das notas dos alunos aprovados:

```sql
SELECT AVG(nota_final) AS media_aprovados
FROM alunos
WHERE situacao = 'Aprovado';
```

### Observações
- `AVG` ignora valores `NULL`.
- O resultado pode ter casas decimais.
- Em MySQL, pode ser útil usar `ROUND` para arredondar o valor.

### Exemplo com arredondamento no MySQL
```sql
SELECT ROUND(AVG(salario), 2) AS media_salarial
FROM funcionarios;
```

## Uso com GROUP BY
As funções de agregação ficam ainda mais úteis quando combinadas com `GROUP BY`. Isso permite resumir dados por grupo, como departamento, categoria, cidade ou cliente.

### Exemplo
Resumo por departamento:

```sql
SELECT 
    departamento,
    COUNT(*) AS total_funcionarios,
    SUM(salario) AS folha_total,
    MAX(salario) AS maior_salario,
    MIN(salario) AS menor_salario,
    AVG(salario) AS media_salarial
FROM funcionarios
GROUP BY departamento;
```

Nesse caso, cada departamento vira um grupo, e as funções são aplicadas dentro de cada grupo.

## Uso com HAVING
Quando a consulta usa agrupamento, o filtro de resultados agregados normalmente é feito com `HAVING`, e não com `WHERE`.

### Exemplo
Mostrar apenas departamentos com média salarial acima de 3000:

```sql
SELECT departamento, AVG(salario) AS media_salarial
FROM funcionarios
GROUP BY departamento
HAVING AVG(salario) > 3000;
```

## Diferenças práticas entre SQL e MySQL
Na maior parte dos casos, `COUNT`, `SUM`, `MAX`, `MIN` e `AVG` funcionam da mesma forma no SQL padrão e no MySQL. Ainda assim, existem alguns detalhes práticos importantes:

- No MySQL, é comum usar `ROUND()` junto com `AVG()` para formatar médias.
- O MySQL aceita agregações com grande flexibilidade, mas é importante respeitar o uso correto de `GROUP BY` para evitar resultados ambíguos.
- Em ambientes que seguem SQL padrão de forma mais rígida, a consulta precisa deixar muito claro quais colunas estão agrupadas e quais estão sendo agregadas.

## Exemplo completo em MySQL
Considere a tabela `vendas` com as colunas:
- `id_venda`
- `id_vendedor`
- `valor`
- `data_venda`

Consulta de resumo por vendedor:

```sql
SELECT
    id_vendedor,
    COUNT(*) AS quantidade_vendas,
    SUM(valor) AS total_vendido,
    MAX(valor) AS maior_venda,
    MIN(valor) AS menor_venda,
    ROUND(AVG(valor), 2) AS media_vendas
FROM vendas
GROUP BY id_vendedor;
```

## Tabela-resumo
| Função | Objetivo | Exemplo |
|---|---|---|
| `COUNT()` | Contar linhas ou valores | `COUNT(*)` |
| `SUM()` | Somar valores numéricos | `SUM(valor)` |
| `MAX()` | Retornar o maior valor | `MAX(salario)` |
| `MIN()` | Retornar o menor valor | `MIN(salario)` |
| `AVG()` | Calcular a média | `AVG(nota)` |

## Boas práticas
- Use `COUNT(*)` quando o objetivo for contar linhas.
- Use `COUNT(coluna)` quando quiser ignorar valores nulos.
- Verifique se a coluna usada em `SUM` e `AVG` é numérica.
- Combine funções de agregação com `GROUP BY` para análises por grupo.
- Use `HAVING` para filtrar resultados agregados.
- No MySQL, use `ROUND()` quando quiser apresentar médias com menos casas decimais.

## Conclusão
As funções `COUNT`, `SUM`, `MAX`, `MIN` e `AVG` são essenciais para manipular e resumir dados em SQL e MySQL. Com elas, é possível transformar tabelas grandes em informações úteis para relatórios, análises e tomadas de decisão.