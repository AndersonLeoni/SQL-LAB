# História e Evolução dos SGBDs e Modelos de Dados

## Visão geral

Os Sistemas Gerenciadores de Banco de Dados (SGBDs) surgiram para organizar dados de forma mais eficiente, reduzir custos e diminuir inconsistências. Antes deles, os dados eram armazenados em sistemas de arquivos, com muitos problemas de redundância, integridade e manutenção.

A evolução passou por modelos hierárquicos, em rede e, finalmente, relacionais. O modelo relacional, proposto por Ted Codd em 1970, introduziu álgebra relacional, tabelas e transparência entre o modelo lógico e a forma física de armazenamento. Posteriormente, surgiram linguagens como SQL e produtos comerciais como Oracle, IBM SQL/DS e DB2.

## Como surgiram os SGBDs

### Contexto dos anos 1960

Na década de 1960, os dados eram armazenados principalmente em sistemas de arquivos. Cada aplicação criava seus próprios arquivos, com estruturas próprias. Isso gerava:

- **Inconsistência de dados:** o mesmo dado podia aparecer em vários arquivos, com valores diferentes.
- **Custo pessoal elevado:** muitas pessoas gastavam tempo corrigindo dados, reconciliando relatórios e mantendo cópias.
- **Falta de padronização:** não havia uma visão única dos dados da organização.
- **Dificuldade de compartilhamento:** era complicado fazer várias aplicações usarem os mesmos dados de forma segura.

Esses problemas levaram ao desenvolvimento de modelos e sistemas que centralizassem o gerenciamento dos dados.

### Objetivo inicial

Os primeiros SGBDs buscavam:

- Diminuir custos operacionais.
- Reduzir redundância e inconsistência.
- Centralizar o controle dos dados.
- Facilitar a manutenção.
- Oferecer acesso compartilhado e seguro.

## Modelos de dados

### Modelo baseado em sistema de arquivos

Antes dos SGBDs, cada aplicação gerenciava seus próprios arquivos.

**Características:**

- Dados duplicados em vários arquivos.
- Estrutura dependente da aplicação.
- Pouca ou nenhuma integridade entre arquivos.
- Dificuldade para alterar estruturas.
- Alto custo de manutenção.

Esse modelo motivou a criação de modelos mais estruturados, como o hierárquico e o modelo em rede.

## Modelo hierárquico

### Conceito

O modelo hierárquico organiza os dados em uma estrutura de árvore, com registros dispostos em níveis de pai e filho. Cada registro pode ter vários filhos, mas apenas um pai.

**Características principais:**

- Estrutura em árvore com raiz.
- Relacionamento 1:N (um para muitos).
- Navegação hierárquica, do topo para baixo.
- Ponteiros entre registros pai e filho.
- Eficiente para certas hierarquias naturais.

### IMS — Information Management System

O IMS, da IBM, é um dos principais exemplos de SGBD hierárquico, lançado no final dos anos 1960. Foi desenvolvido inicialmente para o programa Apollo da NASA e depois amplamente utilizado em grandes empresas.

**Estrutura do IMS:**

- Registros compostos por segmentos.
- Segmentos organizados em árvore.
- Links entre segmentos pai e filho.
- Navegação por percursos predefinidos.

### Linguagens associadas

Linguagens como COBOL, Clipper e FoxPro foram frequentemente usadas com bancos hierárquicos e sistemas de arquivos, em diferentes contextos.

### Vantagens

- Simples para hierarquias bem definidas.
- Bom desempenho para percursos previsíveis.
- Adequado para estruturas como organogramas e listas de materiais.

### Desvantagens

- Dificuldade para representar relacionamentos muitos-para-muitos.
- Rigidez na estrutura.
- Alterações na hierarquia exigem mudanças significativas.
- Navegação complexa para consultas não hierárquicas.

## Modelo em rede

### Conceito

O modelo em rede surgiu como uma evolução do modelo hierárquico, permitindo que um registro tivesse mais de um pai. Isso possibilitou representar relacionamentos mais complexos.

**Características principais:**

- Estrutura em grafo, não apenas árvore.
- Relacionamentos N:M (muitos para muitos).
- Links como ponteiros entre nós.
- Mais flexibilidade que o modelo hierárquico.

### CODASYL

O padrão CODASYL, definido em 1964, formalizou o modelo em rede. Ele estabeleceu:

- Definições de esquemas.
- Tipos de registros.
- Tipos de links.
- Linguagem de manipulação de dados (DML) associada.

**Elementos principais:**

- **Registros:** unidades de dados.
- **Links:** ponteiros entre registros.
- **Conjuntos:** grupos de registros relacionados.

### Vantagens

- Representa melhor relacionamentos complexos.
- É mais flexível que o modelo hierárquico.
- Permite múltiplos caminhos de navegação.

### Desvantagens

- Complexidade de programação.
- Dependência de ponteiros e percursos.
- Dificuldade de manutenção e evolução.
- Pouca transparência entre modelo lógico e físico.

## Modelo relacional

### Origem

O modelo relacional foi proposto por **Edgar F. “Ted” Codd**, em 1970, no artigo *A Relational Model of Data for Large Shared Data Banks*. Codd, matemático da IBM, apresentou uma nova forma de organizar e acessar dados, baseada em relações, álgebra relacional e cálculo relacional.

**Principais ideias de Codd:**

- Dados organizados em tabelas (relações).
- Uso de álgebra relacional para manipular dados.
- Separação entre modelo lógico e estrutura física.
- Acesso por linguagens de alto nível.
- Transparência para o usuário.

### System R e SQL

Na década de 1970, a IBM desenvolveu o projeto **System R**, para demonstrar a viabilidade do modelo relacional. Nesse projeto foram desenvolvidos:

- SQL, inicialmente chamado SEQUEL.
- Otimização de consultas.
- Mecanismos de transação e bloqueio.
- Conceitos que influenciaram o padrão ACID.

A partir do System R, surgiram produtos comerciais como:

- **IBM SQL/DS** (1981).
- **IBM DB2** (1983).
- **Oracle**, lançado pela Relational Software em 1977, um dos primeiros SGBDs relacionais comerciais.

### Características do modelo relacional

- Dados organizados em tabelas.
- Linhas representam registros.
- Colunas representam atributos.
- Relacionamentos por chaves primárias e estrangeiras.
- Uso de álgebra relacional e cálculo relacional.
- Linguagem SQL para definição e manipulação.

### Exemplo de tabela

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150)
);
```

### Vantagens

- Separação entre modelo lógico e físico.
- Flexibilidade para consultas.
- Suporte a relacionamentos complexos.
- Padronização com SQL.
- Melhor integridade e consistência.

### Desvantagens

- Pode exigir mais recursos para certas operações.
- Necessidade de modelagem cuidadosa.
- Desempenho dependente de índices e otimização.

## Comparação entre modelos

| Característica | Hierárquico | Rede | Relacional |
|---|---|---|---|
| Estrutura | Árvore | Grafo | Tabelas |
| Relacionamentos | 1:N | N:M | N:M por meio de chaves |
| Navegação | Percursos hierárquicos | Ponteiros e conjuntos | Consultas SQL |
| Flexibilidade | Baixa | Média | Alta |
| Transparência | Baixa | Média | Alta |
| Exemplos | IMS | CODASYL | Oracle, DB2, MySQL e SQL Server |

## Usuários de bancos de dados

### Usuário convencional

O usuário convencional interage com o banco por meio de aplicações ou consultas.

**Características:**

- Altera e extrai informações.
- Não precisa conhecer os detalhes internos do SGBD.
- Usa formulários, relatórios, telas e APIs.
- Beneficia-se da durabilidade dos dados.

### Administrador de banco de dados (DBA)

O DBA é responsável pela administração técnica do banco.

**Atividades principais:**

- Definição de tabelas e constraints.
- Controle de acessos e permissões.
- Backup e recuperação.
- Monitoramento de desempenho.
- Planejamento de capacidade.
- Aplicação de patches e atualizações.
- Garantia de integridade e segurança.

### Processador de LDD

O processador de Linguagem de Definição de Dados (LDD) interpreta comandos como:

- `CREATE TABLE`
- `ALTER TABLE`
- `DROP TABLE`
- `CREATE INDEX`

Esses comandos definem a estrutura do banco. O SGBD traduz essas definições em metadados e estruturas internas.

## Componentes internos de um SGBD

### Gerenciador de armazenamento

Responsável por:

- Alocar espaço em disco.
- Organizar páginas e blocos.
- Gerenciar arquivos de dados e índices.
- Controlar o acesso físico aos dados.

### Gerenciador de buffer

Responsável por:

- Manter páginas em memória.
- Reduzir acessos ao disco.
- Implementar políticas de substituição.
- Garantir consistência entre memória e disco.

Esses componentes trabalham juntos para oferecer desempenho e durabilidade.

## Repositórios centralizados e mediadores

### Repositórios centralizados

Um repositório centralizado concentra metadados e, em alguns casos, dados compartilhados.

**Características:**

- Visão única dos dados.
- Controle central de acesso.
- Facilita governança e segurança.
- Pode se tornar um ponto único de falha se não houver redundância.

### Mediadores

Mediadores são camadas que ficam entre aplicações e fontes de dados.

**Funções:**

- Traduzir consultas.
- Integrar múltiplas fontes.
- Aplicar regras de negócio.
- Oferecer uma visão unificada.
- Controlar acesso e auditoria.

Essa arquitetura é comum em sistemas distribuídos e integrações.

## Exemplos em SQL e MySQL

### Criação de tabela no modelo relacional

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### Inserção de dados

```sql
INSERT INTO clientes (nome, email)
VALUES ('Ana Souza', 'ana@exemplo.com');
```

### Consulta

```sql
SELECT id_cliente, nome, email
FROM clientes
WHERE id_cliente = 1;
```

### Definição de constraint

```sql
ALTER TABLE clientes
ADD CONSTRAINT ck_clientes_email
CHECK (email LIKE '%@%.%');
```

Esses comandos ilustram o uso de SQL no modelo relacional, com tabelas, chaves e constraints.

## Resumo da evolução

- **Anos 1960:** sistemas de arquivos e modelo hierárquico, como o IMS.
- **1964:** modelo em rede, associado ao CODASYL.
- **1970:** modelo relacional proposto por Ted Codd.
- **Anos 1970:** projeto System R e criação do SQL.
- **1977:** Oracle como um dos primeiros SGBDs relacionais comerciais.
- **1981:** IBM SQL/DS.
- **1983:** IBM DB2.
- **Décadas seguintes:** consolidação do modelo relacional e do padrão SQL.

## Conclusão

Os SGBDs surgiram para resolver problemas de inconsistência, custo e manutenção em sistemas baseados em arquivos. A evolução passou por modelos hierárquicos e em rede até chegar ao modelo relacional, baseado em álgebra relacional e tabelas. O trabalho de Ted Codd, o projeto System R e o surgimento do SQL marcaram a transição para SGBDs modernos, como Oracle, IBM SQL/DS e DB2. No modelo atual, usuários convencionais e administradores interagem com o banco por meio de linguagens de definição e manipulação, enquanto componentes internos como os gerenciadores de armazenamento e de buffer garantem desempenho e durabilidade.
