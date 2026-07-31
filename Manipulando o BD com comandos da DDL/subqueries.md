# Subqueries, Operadores Lógicos e Conjuntos Explícitos em SQL/MySQL

## Visão geral

Este material explica **subqueries (consultas aninhadas)**, o uso de **ANY / SOME / ALL**, operadores lógicos e de comparação (`<`, `>`, `=`, etc.), além de `EXISTS`, `NOT EXISTS`, `UNIQUE` e **conjuntos explícitos** em SQL, com foco em MySQL.

---

## Nested Queries (Subqueries)

### Conceito

Uma **subquery** (consulta aninhada) é uma instrução `SELECT` colocada dentro de outra instrução SQL (a consulta externa). Ela pode aparecer em:

- Cláusula `WHERE`
- Cláusula `FROM` (tabela derivada)
- Cláusula `SELECT` (valor calculado)

A consulta que contém a subquery é chamada de **consulta externa**, e a que está dentro é a **consulta interna**.

### Tipos de subqueries

- **Subquery não correlacionada:** Não depende de valores da consulta externa; é executada uma vez.
- **Subquery correlacionada:** Usa colunas da consulta externa; é executada linha a linha.

### Exemplo básico em SQL/MySQL

Suponha tabelas:

- `alunos(id, nome, curso, nota_final)`
- `matriculas(id_aluno, id_disciplina)`

#### Consulta aninhada na cláusula `WHERE` (não correlacionada)

```sql
-- Alunos com nota acima da média da turma
SELECT nome, nota_final
FROM alunos
WHERE nota_final > (
    SELECT AVG(nota_final)
    FROM alunos
);
```

#### Consulta aninhada na cláusula `WHERE` (correlacionada)

```sql
-- Alunos com nota acima da média do próprio curso
SELECT a1.nome, a1.curso, a1.nota_final
FROM alunos a1
WHERE a1.nota_final > (
    SELECT AVG(a2.nota_final)
    FROM alunos a2
    WHERE a2.curso = a1.curso
);
```

#### Subquery na cláusula `FROM` (tabela derivada)

```sql
-- Média de notas por curso, e depois filtrar cursos com média > 7
SELECT curso, media_curso
FROM (
    SELECT curso, AVG(nota_final) AS media_curso
    FROM alunos
    GROUP BY curso
) AS medias
WHERE media_curso > 7;
```

#### Subquery na cláusula `SELECT`

```sql
-- Mostrar a média geral junto com cada aluno
SELECT 
    nome,
    nota_final,
    (SELECT AVG(nota_final) FROM alunos) AS media_geral
FROM alunos;
```

---

## Comparação por atributos buscados

### Conceito

Em subqueries, muitas vezes comparamos um **atributo** da consulta externa (por exemplo, `nota_final` ou `curso`) com valores retornados pela subquery. Isso é feito com operadores de comparação (`=`, `<`, `>`, `<=`, `>=`, `<>`) e com operadores como `IN`, `ANY`, `SOME`, `ALL`.

### Exemplo: comparação de atributos

```sql
-- Aluno(s) com a maior nota da tabela
SELECT nome, nota_final
FROM alunos
WHERE nota_final = (
    SELECT MAX(nota_final)
    FROM alunos
);

-- Alunos do curso cujo número de matrículas é maior que 50
SELECT curso
FROM alunos
WHERE curso IN (
    SELECT curso
    FROM alunos
    GROUP BY curso
    HAVING COUNT(*) > 50
);
```

---

## Operadores ANY, SOME e ALL

### Conceito

- **`ANY`** (ou `SOME`, que é equivalente): Compara um valor com **pelo menos um** valor retornado pela subquery.
- **`ALL`**: Compara um valor com **todos** os valores retornados pela subquery.

São usados com operadores como `=`, `<>`, `<`, `>`, `<=`, `>=`.

### Exemplo em SQL/MySQL com ANY/SOME

```sql
-- Alunos com nota maior que ALGUMA nota dos alunos de 'Medicina'
SELECT nome, nota_final
FROM alunos
WHERE nota_final > ANY (
    SELECT nota_final
    FROM alunos
    WHERE curso = 'Medicina'
);

-- Equivalente a comparar com a menor nota de Medicina
SELECT nome, nota_final
FROM alunos
WHERE nota_final > (
    SELECT MIN(nota_final)
    FROM alunos
    WHERE curso = 'Medicina'
);
```

### Exemplo com ALL

```sql
-- Alunos com nota maior que TODAS as notas dos alunos de 'Medicina'
SELECT nome, nota_final
FROM alunos
WHERE nota_final > ALL (
    SELECT nota_final
    FROM alunos
    WHERE curso = 'Medicina'
);

-- Equivalente a comparar com a maior nota de Medicina
SELECT nome, nota_final
FROM alunos
WHERE nota_final > (
    SELECT MAX(nota_final)
    FROM alunos
    WHERE curso = 'Medicina'
);
```

> Dica: `ANY`/`SOME` funciona como "maior que pelo menos um", e `ALL` como "maior que todos".

---

## Operadores lógicos e de comparação

### Conceito

Operadores lógicos e de comparação são usados para construir condições em consultas.

- **Operadores de comparação:**
  - `=` (igual)
  - `<>` ou `!=` (diferente)
  - `>` (maior que)
  - `<` (menor que)
  - `>=` (maior ou igual)
  - `<=` (menor ou igual)

- **Operadores lógicos:**
  - `AND` (e)
  - `OR` (ou)
  - `NOT` (não)

### Exemplos em SQL/MySQL

```sql
-- Alunos com nota maior ou igual a 7 E idade menor que 25
SELECT *
FROM alunos
WHERE nota_final >= 7 AND idade < 25;

-- Alunos de Fisioterapia OU Educação Física
SELECT *
FROM alunos
WHERE curso = 'Fisioterapia' OR curso = 'Educacao Fisica';

-- Alunos que NÃO são de Medicina
SELECT *
FROM alunos
WHERE NOT curso = 'Medicina';
-- ou
SELECT *
FROM alunos
WHERE curso <> 'Medicina';
```

Esses operadores são a base para todas as condições, inclusive com subqueries.

---

## EXISTS e NOT EXISTS

### Conceito

- **`EXISTS`**: Retorna verdadeiro se a subquery interna retorna **pelo menos uma linha**.
- **`NOT EXISTS`**: Retorna verdadeiro se a subquery interna **não retorna nenhuma linha**.

São muito usados em subqueries correlacionadas.

### Exemplo com EXISTS

```sql
-- Alunos que têm alguma matrícula registrada
SELECT a.nome
FROM alunos a
WHERE EXISTS (
    SELECT 1
    FROM matriculas m
    WHERE m.id_aluno = a.id
);
```

### Exemplo com NOT EXISTS

```sql
-- Alunos que NÃO têm nenhuma matrícula registrada
SELECT a.nome
FROM alunos a
WHERE NOT EXISTS (
    SELECT 1
    FROM matriculas m
    WHERE m.id_aluno = a.id
);
```

> Observação: `SELECT 1` dentro da subquery é usado apenas como placeholder; o importante é se existe linha ou não.

---

## UNIQUE

### Conceito

`UNIQUE` é um predicado SQL (presente em alguns SGBDs) que testa se a subquery retorna **no máximo uma linha**. Em bancos modernos, esse predicado é pouco usado; o mais comum é garantir unicidade com **constraints** (chaves únicas) e lógica de aplicação.

MySQL não implementa o predicado `UNIQUE` em subqueries da forma clássica padrão SQL, mas você pode obter comportamentos semelhantes usando `GROUP BY` e funções de agregação.

### Exemplo conceitual (padrão SQL)

```sql
-- Verificar se uma subquery retorna no máximo uma linha
SELECT nome
FROM alunos a
WHERE UNIQUE (
    SELECT curso
    FROM alunos
    WHERE nota_final > 9
);
```

### Alternativa em MySQL

Em MySQL, você pode checar se o número de linhas é 0 ou 1 usando contagem:

```sql
-- Exemplo alternativo: verificar se há no máximo um aluno com nota > 9
SELECT CASE
    WHEN (
        SELECT COUNT(*)
        FROM alunos
        WHERE nota_final > 9
    ) <= 1 THEN 'UNICO OU NENHUM'
    ELSE 'MULTIPLOS'
END AS situacao;
```

---

## Conjuntos explícitos

### Conceito

**Conjuntos explícitos** são listas de valores especificadas diretamente na consulta, geralmente com o operador `IN`. Em vez de buscar os valores em uma tabela, você lista manualmente no próprio SQL.

### Exemplo com IN (conjunto explícito)

```sql
-- Alunos de cursos específicos
SELECT nome, curso
FROM alunos
WHERE curso IN ('Fisioterapia', 'Educacao Fisica', 'Nutricao');
```

### Exemplo com NOT IN

```sql
-- Alunos que NÃO são dos cursos listados
SELECT nome, curso
FROM alunos
WHERE curso NOT IN ('Medicina', 'Odontologia');
```

### Conjuntos explícitos em subqueries

Você pode combinar conjuntos explícitos com subqueries para criar filtros mais detalhados:

```sql
-- Alunos de alguns cursos que têm média de notas acima de 7
SELECT nome, curso
FROM alunos
WHERE curso IN ('Fisioterapia', 'Educacao Fisica')
  AND nota_final > (
      SELECT AVG(nota_final)
      FROM alunos
  );
```

---

## Resumo rápido

| Conceito              | Descrição resumida                                        | MySQL |
|-----------------------|-----------------------------------------------------------|-------|
| Subquery              | Consulta aninhada dentro de outra (`SELECT` interno)      | ✅    |
| Subquery correlacionada | Usa colunas da consulta externa, executada por linha    | ✅    |
| ANY / SOME            | Compara com pelo menos um valor da subquery               | ✅    |
| ALL                   | Compara com todos os valores da subquery                  | ✅    |
| EXISTS                | Verdadeiro se subquery retorna alguma linha               | ✅    |
| NOT EXISTS            | Verdadeiro se subquery não retorna nenhuma linha          | ✅    |
| Operadores `<`, `>`, `=` etc. | Comparação de valores em condições                | ✅    |
| Operadores lógicos AND/OR/NOT | Combinação e negação de condições                 | ✅    |
| UNIQUE (predicado)    | Testa se subquery retorna no máximo uma linha             | Parcial (via alternativas) |
| Conjuntos explícitos (IN) | Lista fixa de valores dentro da consulta             | ✅    |

---

## Dicas práticas

1. **Use subqueries não correlacionadas** quando possível: são mais fáceis de otimizar.
2. **Prefira `EXISTS` / `NOT EXISTS`** em vez de `IN` / `NOT IN` com grandes tabelas, quando estiver verificando existência.
3. **ANY/SOME/ALL** são úteis para comparações mais avançadas, mas muitas vezes podem ser substituídos por `MIN`/`MAX` com mais clareza.
4. **Conjuntos explícitos (`IN`)** são excelentes para filtros com poucos valores fixos (como cursos específicos ou status).
