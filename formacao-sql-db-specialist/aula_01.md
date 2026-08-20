# Introdução a Bancos de Dados, DBA e Big Data

## Visão geral

Um banco de dados é uma coleção organizada de dados, estruturada para permitir armazenamento, consulta, atualização, proteção e recuperação de informações. Um sistema gerenciador de banco de dados, conhecido como SGBD, fornece os recursos para criar tabelas, controlar acessos, executar consultas e manter a integridade dos dados.

O trabalho com bancos envolve muito mais do que escrever comandos `SELECT`. Também inclui interpretar e extrair dados, construir modelos, manter procedures, controlar desempenho, administrar acessos e trabalhar em equipe. A administração de bancos inclui atividades como projeto, segurança, armazenamento, backup, recuperação e monitoramento de desempenho.[web:68][web:71]

## O que são bancos de dados

Um banco de dados organiza informações relacionadas em estruturas que podem ser consultadas por aplicações e usuários. Em bancos relacionais, os dados são normalmente organizados em tabelas compostas por linhas e colunas.

### Exemplo relacional

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    data_cadastro DATE
);
```

Nesse exemplo:

- A tabela é `clientes`.
- Cada linha representa um cliente.
- Cada coluna representa um atributo do cliente.
- `id_cliente` identifica cada registro.
- `NOT NULL` impede que o nome fique sem valor.

### SGBD

O SGBD é o software responsável por administrar o banco. Exemplos incluem:

- MySQL.
- SQL Server.
- Oracle Database.
- PostgreSQL.
- MariaDB.

Além de armazenar dados, o SGBD controla transações, permissões, concorrência, integridade e recuperação após falhas.

## Contexto

O contexto é o cenário em que os dados serão usados. Antes de criar tabelas, é necessário entender o negócio e as perguntas que o banco deverá responder.

### Perguntas importantes

- Quem usará o sistema?
- Quais informações precisam ser armazenadas?
- Quais consultas serão frequentes?
- Quais dados são obrigatórios?
- Que informações são sensíveis?
- Qual volume de dados é esperado?
- Existe necessidade de histórico?
- Qual disponibilidade é necessária?

### Exemplo

Em um sistema de vendas, o contexto pode exigir:

- Cadastro de clientes.
- Cadastro de produtos.
- Registro de pedidos.
- Controle de estoque.
- Relatórios de faturamento.
- Permissões diferentes para vendedores e administradores.

O contexto influencia a modelagem, os tipos de dados, os índices e as políticas de segurança.

## Acesso à conta

O acesso à conta envolve autenticação, autorização e controle de privilégios.

- **Autenticação:** verifica quem é o usuário.
- **Autorização:** define o que o usuário pode fazer.
- **Privilégio:** permite uma ação específica, como consultar ou inserir dados.
- **Auditoria:** registra ações realizadas no banco.

### Exemplo conceitual no MySQL

```sql
CREATE USER 'relatorio'@'localhost'
IDENTIFIED BY 'SenhaForte_123!';

GRANT SELECT ON loja.*
TO 'relatorio'@'localhost';
```

O usuário `relatorio` poderá consultar as tabelas do banco `loja`, mas não receberá automaticamente permissão para inserir, atualizar ou excluir registros.

### Boas práticas de acesso

- Use contas individuais.
- Evite compartilhar usuários e senhas.
- Conceda somente os privilégios necessários.
- Separe contas de desenvolvimento, teste e produção.
- Use autenticação forte e, quando disponível, múltiplos fatores.
- Revogue acessos que não são mais necessários.
- Registre acessos administrativos.

A segurança e o controle de usuários fazem parte das responsabilidades tradicionais de um DBA.[web:68][web:75]

## Tipos de dados

Tipos de dados definem quais valores podem ser armazenados e como eles serão representados. A escolha correta reduz erros, economiza espaço e melhora a qualidade das consultas.

### Dados numéricos

| Tipo conceitual | Exemplos | Uso |
|---|---|---|
| Inteiro | `INT`, `BIGINT` | Identificadores, quantidades, contagens |
| Decimal exato | `DECIMAL(10,2)` | Preços, valores monetários |
| Aproximado | `FLOAT`, `REAL` | Medições e cálculos científicos aproximados |
| Booleano | `BOOLEAN`, `BIT` | Indicadores verdadeiro/falso |

Para valores financeiros, prefira tipos decimais exatos, como `DECIMAL`, em vez de tipos aproximados.

### Dados textuais

| Tipo conceitual | Exemplos | Uso |
|---|---|---|
| Texto de tamanho fixo | `CHAR(2)` | Siglas, códigos curtos |
| Texto variável | `VARCHAR(150)` | Nomes, e-mails, endereços |
| Texto longo | `TEXT`, `CLOB` | Descrições e documentos textuais |

### Datas e horários

```sql
CREATE TABLE eventos (
    id_evento INT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    inicio DATETIME,
    duracao_minutos INT
);
```

Datas permitem ordenar eventos, filtrar períodos e calcular intervalos. O tipo exato muda conforme o SGBD: MySQL usa, por exemplo, `DATETIME`; SQL Server oferece `DATETIME2`; Oracle utiliza `DATE` e `TIMESTAMP`.

## Dados são mais que texto e números

Dados podem representar diversos formatos e fenômenos:

- Imagens, áudio e vídeo.
- Documentos PDF e arquivos compactados.
- Localização geográfica.
- Datas, horários e fusos.
- Estruturas JSON e XML.
- Relações entre entidades.
- Eventos de sensores.
- Logs de aplicações.
- Grafos e redes de relacionamento.
- Vetores usados em aplicações de inteligência artificial.

### Exemplo com JSON no MySQL

```sql
CREATE TABLE eventos_api (
    id_evento INT PRIMARY KEY AUTO_INCREMENT,
    payload JSON NOT NULL,
    recebido_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

O tipo escolhido precisa refletir o modo como o dado será consultado. Armazenar tudo como texto pode dificultar validação, indexação, ordenação e análise.

## Consulta

Consulta é a solicitação feita ao banco para recuperar ou analisar dados. Em bancos relacionais, a linguagem mais comum é SQL.

### Consulta simples

```sql
SELECT id_cliente, nome, email
FROM clientes
WHERE data_cadastro >= '2026-01-01'
ORDER BY nome;
```

### Consulta com agregação

```sql
SELECT
    id_cliente,
    COUNT(*) AS quantidade_pedidos,
    SUM(valor_total) AS total_gasto
FROM pedidos
GROUP BY id_cliente
HAVING SUM(valor_total) > 1000;
```

### Consulta com relacionamento

```sql
SELECT
    c.nome,
    p.id_pedido,
    p.valor_total
FROM clientes AS c
INNER JOIN pedidos AS p
    ON p.id_cliente = c.id_cliente;
```

Interpretar uma consulta envolve entender suas tabelas, filtros, relacionamentos, agrupamentos e critérios de ordenação.

## Interpretação e extração de dados

A interpretação transforma resultados técnicos em informação útil. A extração seleciona os dados necessários, enquanto a interpretação procura significado, tendências, exceções e relações.

### Processo recomendado

1. Definir a pergunta de negócio.
2. Identificar as tabelas e colunas envolvidas.
3. Verificar a qualidade dos dados.
4. Criar a consulta.
5. Validar filtros e relacionamentos.
6. Conferir totais e amostras.
7. Interpretar o resultado no contexto correto.
8. Documentar a origem e as regras usadas.

### Exemplo

Pergunta: quais produtos venderam mais no primeiro trimestre?

```sql
SELECT
    p.id_produto,
    p.nome,
    SUM(i.quantidade) AS unidades_vendidas,
    SUM(i.quantidade * i.preco_unitario) AS faturamento
FROM produtos AS p
INNER JOIN itens_pedido AS i
    ON i.id_produto = p.id_produto
INNER JOIN pedidos AS pe
    ON pe.id_pedido = i.id_pedido
WHERE pe.data_pedido >= '2026-01-01'
  AND pe.data_pedido < '2026-04-01'
GROUP BY p.id_produto, p.nome
ORDER BY unidades_vendidas DESC;
```

A interpretação deve considerar cancelamentos, devoluções, duplicidades, período escolhido e definição de “venderam mais”.

## Construção de banco de dados

Construir um banco envolve passar dos requisitos para uma estrutura física executável.

### Etapas

- Levantamento de requisitos.
- Identificação das entidades.
- Definição de atributos.
- Definição de relacionamentos.
- Escolha das chaves primárias e estrangeiras.
- Escolha dos tipos de dados.
- Criação de tabelas e constraints.
- Criação de índices necessários.
- Definição de usuários e permissões.
- Testes, migração e documentação.

### Exemplo básico

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);
```

A construção deve ser feita preferencialmente por scripts versionados, permitindo reproduzir a estrutura em diferentes ambientes.

## Modelagem de dados

Modelagem de dados é o processo de representar os dados, seus atributos e os relacionamentos entre eles. O objetivo é organizar a informação antes da implementação física.[web:76]

### Modelagem conceitual

Representa o negócio em alto nível, sem depender de um SGBD específico.

Exemplo:

- Um cliente faz vários pedidos.
- Um pedido possui vários itens.
- Um produto pode aparecer em vários itens.

### Modelagem lógica

Transforma as entidades em tabelas, atributos e relacionamentos.

```text
CLIENTE 1 ---- N PEDIDO
PEDIDO  1 ---- N ITEM_PEDIDO
PRODUTO 1 ---- N ITEM_PEDIDO
```

### Modelagem física

Define detalhes específicos do SGBD:

- Tipos de dados.
- Índices.
- Particionamento.
- Tablespaces ou filegroups.
- Estratégias de armazenamento.
- Colunas geradas.
- Políticas de compressão.

Uma modelagem bem feita facilita manutenção, integridade e desempenho. Modelos de dados normalmente descrevem tabelas, colunas, chaves primárias, chaves estrangeiras e seus relacionamentos.[web:73]

## Manutenção dos métodos e procedures

Métodos e procedures encapsulam operações que podem ser reutilizadas. A manutenção envolve corrigir erros, adaptar regras de negócio, melhorar desempenho e preservar compatibilidade com aplicações existentes.

### Atividades de manutenção

- Revisar parâmetros e valores de retorno.
- Atualizar regras de negócio.
- Corrigir consultas lentas.
- Verificar dependências de tabelas e colunas.
- Criar testes para cenários válidos e inválidos.
- Versionar scripts de alteração.
- Documentar mudanças incompatíveis.
- Monitorar erros e tempo de execução.
- Evitar alterações diretas sem histórico.

### Exemplo de procedure versionada

```sql
DELIMITER //

CREATE PROCEDURE listar_pedidos_cliente(IN p_id_cliente INT)
BEGIN
    SELECT
        id_pedido,
        data_pedido,
        valor_total
    FROM pedidos
    WHERE id_cliente = p_id_cliente
    ORDER BY data_pedido DESC;
END //

DELIMITER ;
```

Antes de alterar a procedure, é recomendável guardar o script anterior e testar a nova versão em ambiente de desenvolvimento.

## Desempenho

Desempenho é a capacidade de responder às consultas e operações dentro de um tempo aceitável, usando recursos de forma eficiente.

### Fatores que influenciam

- Quantidade de dados.
- Qualidade dos índices.
- Forma das consultas.
- Estatísticas e plano de execução.
- Memória disponível.
- Velocidade do armazenamento.
- Concorrência entre usuários.
- Bloqueios e transações longas.
- Configuração do SGBD.
- Rede e aplicação cliente.

### Boas práticas de consulta

- Selecione apenas as colunas necessárias.
- Evite `SELECT *` em aplicações e relatórios permanentes.
- Crie índices para filtros e relacionamentos frequentes.
- Não aplique funções desnecessárias sobre colunas filtradas.
- Analise o plano de execução.
- Evite trazer milhares de linhas quando apenas algumas são necessárias.
- Use paginação em telas e APIs.
- Atualize estatísticas conforme a estratégia do SGBD.
- Monitore consultas lentas.

### Exemplo de índice

```sql
CREATE INDEX IX_Pedidos_IdCliente_Data
ON pedidos (id_cliente, data_pedido);
```

Esse índice pode ajudar consultas que filtram por cliente e ordenam ou filtram por data. O índice correto depende da carga real; criar índices indiscriminadamente também aumenta o custo de inserções e atualizações.

## Poder computacional

Poder computacional é a capacidade de processamento, memória, armazenamento e comunicação disponível para executar operações. Ele afeta a velocidade com que dados podem ser armazenados, consultados e analisados.

### Componentes relevantes

- **CPU:** executa cálculos, filtros, junções e agregações.
- **Memória:** mantém páginas, índices e resultados em cache.
- **Armazenamento:** influencia leitura, escrita e recuperação.
- **Rede:** afeta o transporte entre aplicação e banco.
- **Paralelismo:** permite dividir algumas operações entre processadores.
- **Escalabilidade:** permite aumentar recursos ou distribuir carga.

Mais poder computacional não corrige automaticamente uma modelagem ruim ou uma consulta ineficiente. Primeiro é importante investigar plano de execução, índices, cardinalidade, bloqueios e volume de dados.

## Big Data

Big Data descreve cenários em que volume, velocidade, variedade ou complexidade dos dados tornam insuficientes algumas abordagens tradicionais. Uma forma comum de explicar o conceito usa os “V”:

- **Volume:** grande quantidade de dados.
- **Velocidade:** geração e processamento rápidos.
- **Variedade:** dados tabulares, documentos, imagens, eventos e outros formatos.
- **Veracidade:** qualidade, confiabilidade e origem dos dados.
- **Valor:** utilidade obtida a partir da análise.

### Exemplos de Big Data

- Eventos de navegação em sites.
- Registros de sensores industriais.
- Transações financeiras.
- Dados de redes sociais.
- Logs de aplicações distribuídas.
- Imagens e vídeos.
- Dados de dispositivos conectados.

### Banco tradicional e Big Data

| Característica | Banco relacional tradicional | Ambiente de Big Data |
|---|---|---|
| Estrutura | Tabelas e esquema definido | Pode incluir tabelas, documentos, streams e arquivos |
| Escala | Frequentemente vertical e controlada | Pode usar distribuição horizontal |
| Consulta | SQL e transações relacionais | SQL, APIs, processamento distribuído e streaming |
| Dados | Principalmente estruturados | Estruturados, semiestruturados e não estruturados |
| Prioridade | Integridade e consistência transacional | Escala, velocidade, variedade e análise |

Big Data não significa apenas “muitos dados”. Um projeto pode ter grande volume, mas também exigir processamento em tempo real, múltiplos formatos ou arquitetura distribuída.

## Equipe do DBA

DBA significa *Database Administrator*, ou administrador de banco de dados. O DBA mantém o banco disponível, seguro, consistente e com desempenho adequado. As responsabilidades normalmente incluem segurança, backup, recuperação, manutenção, monitoramento e ajuste de desempenho.[web:71][web:68]

### Papéis comuns

- **DBA de infraestrutura:** instalação, configuração, atualizações e capacidade.
- **DBA de produção:** disponibilidade, incidentes, backup e recuperação.
- **DBA de desempenho:** análise de consultas, índices e planos de execução.
- **DBA de segurança:** usuários, permissões, auditoria e proteção de dados.
- **Arquiteto de dados:** padrões, integração e decisões estruturais.
- **Modelador de dados:** entidades, relacionamentos e modelos lógicos.
- **DBA de aplicações:** apoio a desenvolvedores, procedures e consultas.
- **DBA de cloud:** serviços gerenciados, custos, escalabilidade e alta disponibilidade.

### Atividades do DBA

- Criar e configurar bancos.
- Gerenciar tabelas, índices, views e procedures.
- Controlar acessos e privilégios.
- Planejar e testar backups.
- Recuperar dados após falhas.
- Monitorar espaço e crescimento.
- Analisar desempenho.
- Planejar alta disponibilidade.
- Apoiar migrações e atualizações.
- Documentar ambientes e procedimentos.

## Relação entre as áreas

Esses temas fazem parte de um ciclo contínuo:

1. O contexto define as necessidades.
2. A modelagem organiza entidades e relacionamentos.
3. A construção implementa tabelas, chaves e regras.
4. As consultas extraem dados.
5. A interpretação transforma resultados em informação.
6. O monitoramento identifica problemas de desempenho.
7. A manutenção atualiza procedures e estruturas.
8. A equipe do DBA garante segurança, disponibilidade e recuperação.
9. Big Data amplia os tipos, a escala e a velocidade dos dados analisados.

## Checklist prático

- O contexto do sistema está documentado?
- As tabelas representam as entidades reais?
- As chaves primárias estão definidas?
- Os relacionamentos usam chaves estrangeiras?
- Os tipos de dados são adequados?
- Existem regras para valores obrigatórios e inválidos?
- Os usuários têm somente os privilégios necessários?
- Há backup testado e plano de recuperação?
- As consultas principais foram analisadas?
- As procedures e funções estão versionadas?
- O crescimento do banco é monitorado?
- Dados não estruturados e eventos de alta velocidade foram considerados?

## Conclusão

Bancos de dados são sistemas organizados para armazenar, proteger, consultar e transformar dados. O trabalho envolve modelagem, construção, extração, interpretação, manutenção de rotinas e controle de desempenho. O DBA e os demais profissionais de dados atuam em conjunto para garantir que a informação permaneça confiável, disponível e útil, desde um banco relacional tradicional até arquiteturas de Big Data.
