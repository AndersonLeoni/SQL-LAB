# Operadores Lgicos, BETWEEN, UNION, INTERSECT, EXCEPT e Subqueries em SQL/MySQL

## 1. Operadores Lgicos e BETWEEN

### Conceito

Os **operadores lgicos** (`AND`, `OR`, `NOT`) permitem combinar múltiplas condições em consultas SQL, enquanto o operador **`BETWEEN`** filtra valores dentro de um intervalo específico (inclusive).

- **`AND`**: Retorna registros que satisfazem **todas** as condições.
- **`OR`**: Retorna registros que satisfazem **pelo menos uma** das condições.
- **`NOT`**: Inverte o resultado de uma condição.
- **`BETWEEN`**: Seleciona valores dentro de um intervalo (equivalente a `>= valor_inicial AND <= valor_final`).

### Exemplos em SQL/MySQL

```sql
-- Tabela de exemplo: alunos(id, nome, idade, nota_final, curso)

-- AND: Alunos com nota >= 7 E idade <= 25
SELECT * FROM alunos
WHERE nota_final >= 7 AND idade <= 25;

-- OR: Alunos do curso de 'Fisioterapia' OU 'Educao Física'
SELECT * FROM alunos
WHERE curso = 'Fisioterapia' OR curso = 'Educao Física';

-- NOT: Alunos que NÃO são do curso de 'Medicina'
SELECT * FROM alunos
WHERE NOT curso = 'Medicina';
-- ou
SELECT * FROM alunos
WHERE curso != 'Medicina';

-- BETWEEN: Alunos com idade entre 18 e 25 (inclusive)
SELECT * FROM alunos
WHERE idade BETWEEN 18 AND 25;
-- Equivalente a:
SELECT * FROM alunos
WHERE idade >= 18 AND idade <= 25;

-- BETWEEN com datas: Alunos matriculados entre 2023-01-01 e 2023-12-31
SELECT * FROM alunos
WHERE data_matricula BETWEEN '2023-01-01' AND '2023-12-31';

-- Combinando operadores lgicos
SELECT * FROM alunos
WHERE (nota_final >= 7 AND idade BETWEEN 18 AND 25)
  OR curso = 'Fisioterapia';
```

---

## 2. Comandos Baseados em Operaes Matemticas: UNION, INTERSECT e EXCEPT

### Conceito

Estes comandos realizam operaes de **conjunto** entre resultados de múltiplas consultas `SELECT`:

- **`UNION`**: Combina resultados de duas ou mais consultas, **removendo duplicatas**.
- **`UNION ALL`**: Combina resultados **mantendo duplicatas** (mais rápido que `UNION`).
- **`INTERSECT`**: Retorna apenas os registros **presentes em todas as consultas**.
- **`EXCEPT`** (ou `MINUS` em alguns SGBDs): Retorna registros da primeira consulta que **NÂ©O estão** na segunda.

> **Nota:** MySQL **nâ©£o suporta nativamente** `INTERSECT` e `EXCEPT`. É necessário usar alternativas com `JOIN` ou subqueries.

### Exemplos em SQL (Padrâ©£o)

```sql
-- Tabela 1: alunos_fisioterapia(id, nome)
-- Tabela 2: alunos_educacao_fisica(id, nome)

-- UNION: Lista única de todos os alunos (sem duplicatas)
SELECT nome FROM alunos_fisioterapia
UNION
SELECT nome FROM alunos_educacao_fisica;

-- UNION ALL: Lista todos os alunos (mantendo duplicatas)
SELECT nome FROM alunos_fisioterapia
UNION ALL
SELECT nome FROM alunos_educacao_fisica;

-- INTERSECT: Alunos matriculados em AMBOS os cursos
SELECT nome FROM alunos_fisioterapia
INTERSECT
SELECT nome FROM alunos_educacao_fisica;

-- EXCEPT: Alunos de fisioterapia que NÃO estão em educação física
SELECT nome FROM alunos_fisioterapia
EXCEPT
SELECT nome FROM alunos_educacao_fisica;
```

### Alternativas para INTERSECT e EXCEPT em MySQL

Como MySQL nâ©£o tem `INTERSECT` e `EXCEPT`, usamos `INNER JOIN` e `NOT IN`/`NOT EXISTS`:

```sql
-- INTERSECT alternativo (alunos em ambos os cursos)
SELECT f.nome
FROM alunos_fisioterapia f
INNER JOIN alunos_educacao_fisica ef ON f.nome = ef.nome;

-- EXCEPT alternativo (alunos de fisioterapia que NÃO estão em educação física)
SELECT nome FROM alunos_fisioterapia
WHERE nome NOT IN (SELECT nome FROM alunos_educacao_fisica);

-- Ou com NOT EXISTS
SELECT f.nome
FROM alunos_fisioterapia f
WHERE NOT EXISTS (
    SELECT 1 FROM alunos_educacao_fisica ef WHERE ef.nome = f.nome
);
```

### Requisitos para UNION/INTERSECT/EXCEPT

1. **Mesmo número de colunas** em todas as consultas.
2. **Tipos de dados compatí¬©veis** nas colunas correspondentes.
3. **Ordem das colunas** deve ser a mesma.

---

## 3. Nested Queries (Subqueries)

### Conceito

Uma **subquery** (ou *nested query*) é uma consulta `SELECT` aninhada dentro de outra consulta SQL. Ela pode aparecer em:

- **Cláº©usula `WHERE`** (mais comum)
- **Cláº©usula `FROM`** (como tabela derivada)
- **Cláº©usula `SELECT`** (como coluna calculada)

As subqueries podem ser:
- **Independentes (nâ©£o correlacionadas):** Executadas uma única vez.
- **Correlacionadas:** Referenciam colunas da consulta externa e são executadas para cada linha.

### Exemplos em SQL/MySQL

#### Subquery na Cláº©usula `WHERE`

```sql
-- Alunos com nota superior à média da turma
SELECT nome, nota_final
FROM alunos
WHERE nota_final > (
    SELECT AVG(nota_final) FROM alunos
);

-- Alunos do curso que tem mais de 50 matriculados
SELECT nome, curso
FROM alunos
WHERE curso IN (
    SELECT curso
    FROM alunos
    GROUP BY curso
    HAVING COUNT(*) > 50
);

-- Alunos que NÂ¬O fizeram determinada disciplina
SELECT nome
FROM alunos
WHERE id NOT IN (
    SELECT id_aluno
    FROM matriculas
    WHERE id_disciplina = 101
);
```

#### Subquery na Cláº©usula `FROM` (Tabela Derivada)

```sql
-- MÃ©dia de notas por curso, depois filtrar cursos com média > 7
SELECT curso, media_curso
FROM (
    SELECT curso, AVG(nota_final) AS media_curso
    FROM alunos
    GROUP BY curso
) AS medias_por_curso
WHERE media_curso > 7;
```

#### Subquery na Cláº©usula `SELECT`

```sql
-- Lista de alunos com a média geral da turma em cada linha
SELECT 
    nome,
    nota_final,
    (SELECT AVG(nota_final) FROM alunos) AS media_geral
FROM alunos;
```

#### Subquery Correlacionada

```sql
-- Alunos com nota superior à média do seu próprio curso
SELECT a1.nome, a1.curso, a1.nota_final
FROM alunos a1
WHERE a1.nota_final > (
    SELECT AVG(a2.nota_final)
    FROM alunos a2
    WHERE a2.curso = a1.curso
);
```

#### Subquery com Operadores de Comparaç±£o (`=`, `>`, `<`, `IN`, `ANY`, `ALL`)

```sql
-- Aluno(s) com a maior nota
SELECT nome, nota_final
FROM alunos
WHERE nota_final = (
    SELECT MAX(nota_final) FROM alunos
);

-- Alunos com nota maior que TODAS as notas do curso 'Medicina'
SELECT nome, nota_final
FROM alunos
WHERE nota_final > ALL (
    SELECT nota_final
    FROM alunos
    WHERE curso = 'Medicina'
);

-- Alunos com nota maior que ALGUMA nota do curso 'Medicina'
SELECT nome, nota_final
FROM alunos
WHERE nota_final > ANY (
    SELECT nota_final
    FROM alunos
    WHERE curso = 'Medicina'
);
-- Equivalente a:
SELECT nome, nota_final
FROM alunos
WHERE nota_final > (
    SELECT MIN(nota_final)
    FROM alunos
    WHERE curso = 'Medicina'
);
```

---

## Resumo Ráº©pido

| Operador/Comando | Funç±£o Principal | Suporte MySQL |
|------------------|-------------------|---------------|
| `AND` / `OR` / `NOT` | Combina/nega condições | ✅ |
| `BETWEEN` | Filtra por intervalo | ✅ |
| `UNION` / `UNION ALL` | Une resultados de consultas | ✅ |
| `INTERSECT` | Retorna interseç±£o de conjuntos | â (usar `JOIN`) |
| `EXCEPT` | Retorna diferença de conjuntos | â (usar `NOT IN`/`NOT EXISTS`) |
| Subqueries | Consultas aninhadas em `WHERE`, `FROM`, `SELECT` | ✅ |

---

## Dicas Práº©ticas

1. **Use `UNION ALL`** quando souber que nâ©£o há duplicatas (mais performáº©tico).
2. **Subqueries correlacionadas** podem ser lentas em grandes volumes de dados; avalie o uso de `JOIN`.
3. **Teste alternativas** para `INTERSECT` e `EXCEPT` em MySQL usando `JOIN` e `NOT EXISTS`.
4. **Í©ndices** nas colunas usadas em subqueries melhoram significativamente a performance.
