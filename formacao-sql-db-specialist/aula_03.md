# História e Evolução dos SGBDs e Modelos de Dados

## Visão geral

Os Sistemas Gerenciadores de Banco de Dados (SGBDs) surgiram para organizar dados de forma mais eficiente, reduzir custos e diminuir inconsistencias. Antes deles, os dados eram armazenados em sistemas de arquivos, com muitos problemas de redundÛncia, integridade e manutençº£o.

A evoluçº£o passou por modelos hierÚºrquicos, em rede e, finalmente, relacionais. O modelo relacional, proposto por Ted Codd em 1970, introduziu ÚÝ©lgebra relacional, tabelas e transparÛncia entre o modelo lÓ©gico e a forma fÝ©sica de armazenamento. Posteriormente, surgiram linguagens como SQL e produtos comerciais como Oracle, IBM SQL/DS e DB2.[web:98][web:110]

## Como surgiram os SGBDs

### Contexto dos anos 1960

Na dÉ©cada de 1960, os dados eram armazenados principalmente em sistemas de arquivos. Cada aplicaçº£o criava seus prÓ©prios arquivos, com estruturas prÓ©prias. Isso gerava:

- **InconsistÛncia de dados:** o mesmo dado podia aparecer em vÚºrios arquivos, com valores diferentes.
- **Custo pessoal elevado:** muitas pessoas gastavam tempo corrigindo dados, reconciliando relatÓ©rios e mantendo cÓ©pias.
- **Falta de padronizaçº£o:** nØ£o havia uma visØ£o ÚÛnica dos dados da organizaçº£o.
- **Dificuldade de compartilhamento:** era complicado fazer vÚºrias aplicaçºµes usarem os mesmos dados de forma segura.

Esses problemas levaram ao desenvolvimento de modelos e sistemas que centralizassem o gerenciamento dos dados.

### Objetivo inicial

Os primeiros SGBDs buscavam:

- Diminuir custos operacionais.
- Reduzir redundÛncia e inconsistÛncia.
- Centralizar o controle dos dados.
- Facilitar a manutençº£o.
- Oferecer acesso compartilhado e seguro.

## Modelos de dados

### Modelo baseado em sistema de arquivos

Antes dos SGBDs, cada aplicaçº£o gerenciava seus prÓ©prios arquivos.

**CaracterÝ©sticas:**

- Dados duplicados em vÚºrios arquivos.
- Estrutura dependente da aplicaçº£o.
- Pouca ou nenhuma integridade entre arquivos.
- Dificuldade para alterar estruturas.
- Alto custo de manutençº£o.

Esse modelo motivou a criaçº£o de modelos mais estruturados, como hierÚºrquico e em rede.

## Modelo HierÚºrquico

### Conceito

O modelo hierÚºrquico organiza os dados em uma estrutura de ÚÝºrvore, com registros dispostos em nÝ©veis de pai e filho. Cada registro pode ter vÚºrios filhos, mas apenas um pai.

**CaracterÝ©sticas principais:**

- Estrutura em ÚÝºrvore com raiz.
- Relacionamento 1:N (um para muitos).
- Navegaçº£o hierÚºrquica, do topo para baixo.
- Ponteiros entre registros pai e filho.
- Eficiente para certas hierarquias naturais.

### IMS - Information Management System

O IMS, da IBM, Éa um dos principais exemplos de SGBD hierÚºrquico, lançººdo no final dos anos 1960. Foi desenvolvido inicialmente para o programa Apollo da NASA e depois amplamente usado em grandes empresas.[web:99][web:101][web:104]

**Estrutura do IMS:**

- Registros compostos por segmentos.
- Segmentos organizados em ÚÝºrvore.
- Links entre segmentos pai e filho.
- Navegaçº£o por percursos predefinidos.

### Linguagens associadas

Linguagens como COBOL, Clipper e FoxPro foram frequentemente usadas com bancos hierÚºrquicos e posteriores, em diferentes contextos.

### Vantagens

- Simples para hierarquias bem definidas.
- Desempenho bom para percursos previsÝ©veis.
- Adequado para estruturas como organogramas e listas de materiais.

### Desvantagens

- Dificuldade para representar relacionamentos muitos-para-muitos.
- RigidÊ©z na estrutura.
- Alteraçºµes na hierarquia exigem mudançººs significativas.
- Navegaçº£o complexa para consultas nØ£o hierÚºrquicas.

## Modelo em Rede

### Conceito

O modelo em rede surgiu como uma evoluçº£o do modelo hierÚºrquico, permitindo que um registro tivesse mais de um pai. Isso possibilitou representar relacionamentos mais complexos.

**CaracterÝ©sticas principais:**

- Estrutura em grafo, nØ£o apenas ÚÝºrvore.
- Relacionamentos N:M (muitos para muitos).
- Links como ponteiros entre nÓ©s.
- Mais flexibilidade que o modelo hierÚºrquico.

### CODASYL

O padrØ£o CODASYL, definido em 1964, formalizou o modelo em rede. Ele estabeleceu:

- Definiçºµes de esquemas.
- Tipos de registros.
- Tipos de links.
- Linguagem de manipulaçº£o de dados (DML) associada.[web:105][web:106][web:108]

**Elementos principais:**

- **Registros:** unidades de dados.
- **Links:** ponteiros entre registros.
- **Conjuntos:** grupos de registros relacionados.

### Vantagens

- Representa melhor relacionamentos complexos.
- Mais flexibilidade que o modelo hierÚºrquico.
- Permite mÚºltiplos caminhos de navegaçº£o.

### Desvantagens

- Complexidade de programaçº£o.
- DependÛncia de ponteiros e percursos.
- Dificuldade de manutençº£o e evoluçº£o.
- Pouca transparÛncia entre modelo lÓ©gico e fÝ©sico.

## Modelo Relacional

### Origem

O modelo relacional foi proposto por **Edgar F. "Ted" Codd**, em 1970, no artigo *"A Relational Model of Data for Large Shared Data Banks"*. Codd, matemÚºtico da IBM, apresentou uma nova forma de organizar e acessar dados, baseada em relaçºµes, ÚÝ©lgebra relacional e cÚºlculo relacional.[web:98][web:110][web:111]

**Principais ideias de Codd:**

- Dados organizados em tabelas (relaçºµes).
- Uso de ÚÝ©lgebra relacional para manipular dados.
- Separaçº£o entre modelo lÓ©gico e estrutura fÝ©sica.
- Acesso por linguagens de alto nÝ©vel.
- TransparÛncia para o usuÚºrio.

### System R e SQL

Na dÉ©cada de 1970, a IBM desenvolveu o projeto **System R**, para demonstrar a viabilidade do modelo relacional. Nesse projeto foram criados:

- SQL (inicialmente chamado SEQUEL).
- Otimizaçº£o de consultas.
- Mecanismos de transaçº£o e bloqueio.
- Conceitos que influenciaram o padrØ£o ACID.[web:98][web:103][web:110]

A partir do System R, surgiram produtos comerciais:

- **IBM SQL/DS** (1981).
- **IBM DB2** (1983).
- **Oracle**, lançº²do pela Relational Software em 1977, foi um dos primeiros SGBDs relacionais comerciais.[web:98][web:110]

### CaracterÝ©sticas do modelo relacional

- Dados organizados em tabelas.
- Linhas representam registros.
- Colunas representam atributos.
- Relacionamentos por chaves primÚºrias e estrangeiras.
- Uso de ÚÝ©lgebra relacional e cÚºlculo relacional.
- Linguagem SQL para definiçº£o e manipulaçº£o.

### Exemplo de tabela

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150)
);
```

### Vantagens

- Separaçº£o entre lÓ©gico e fÝ©sico.
- Flexibilidade para consultas.
- Suporte a relacionamentos complexos.
- Padronizaçº£o com SQL.
- Melhor integridade e consistÛncia.

### Desvantagens

- Pode exigir mais recursos para certas operaçºµes.
- Necessidade de modelagem cuidadosa.
- Desempenho dependente de ÝØ³ndices e otimizaçº£o.

## Comparaçº£o entre modelos

| CaracterÝ©stica | HierÚºrquico | Rede | Relacional |
|---|---|---|---|
| Estrutura | ÚÝºrvore | Grafo | Tabelas |
| Relacionamentos | 1:N | N:M | N:M (via chaves) |
| Navegaçº£o | Por percursos hierÚºrquicos | Por ponteiros e conjuntos | Por consultas SQL |
| Flexibilidade | Baixa | MÉ©dia | Alta |
| TransparÛncia | Baixa | MÉ©dia | Alta |
| Exemplos | IMS | CODASYL | Oracle, DB2, MySQL, SQL Server |

## UsuÚºrios de bancos de dados

### UsuÚºrio convencional

O usuÚºrio convencional interage com o banco por meio de aplicaçºµes ou consultas.

**CaracterÝ©sticas:**

- Altera e extrai informaçºµes.
- NØ£o precisa conhecer detalhes internos do SGBD.
- Usa formulÚºrios, relatÓ©rios, telas e APIs.
- Beneficia-se da durabilidade dos dados.

### Administrador de banco de dados (DBA)

O DBA Éa responsÚºvel pela administraçº£o tÉ©cnica do banco.

**Atividades principais:**

- Definiçº£o de tabelas e constraints.
- Controle de acessos e permissÚµes.
- Backup e recuperaçº£o.
- Monitoramento de desempenho.
- Planejamento de capacidade.
- Aplicaçº£o de patches e atualizaçºµes.
- Garantia de integridade e segurançºº.

### Processador de LDD

O processador de Linguagem de Definiçº£o de Dados (LDD) interpreta comandos como:

- `CREATE TABLE`
- `ALTER TABLE`
- `DROP TABLE`
- `CREATE INDEX`

Esses comandos definem a estrutura do banco. O SGBD traduz essas definiçºµes em metadados e estruturas internas.

## Componentes internos de um SGBD

### Gerenciador de armazenamento

ResponsÚºvel por:

- Alocar espaçºº em disco.
- Organizar pÚºginas e blocos.
- Gerenciar arquivos de dados e ÝØ³ndices.
- Controlar acesso fÝ©sico aos dados.

### Gerenciador de buffer

ResponsÚºvel por:

- Manter pÚºginas em memÓ©ria.
- Reduzir acessos a disco.
- Implementar polÝ©ticas de substituiçº£o.
- Garantir consistÛncia entre memÓ©ria e disco.

Esses componentes trabalham juntos para oferecer desempenho e durabilidade.

## RepositÓ©rios centralizados e mediadores

### RepositÓ©rios centralizados

Um repositÓ©rio centralizado concentra metadados e, em alguns casos, dados compartilhados.

**CaracterÝ©sticas:**

- VisØ£o ÚÛnica dos dados.
- Controle central de acesso.
- Facilita governançºº e segurançºº.
- Pode se tornar um ponto ÚÛnico de falha, se nØ£o houver redundÛncia.

### Mediadores

Mediadores sØ£o camadas que ficam entre aplicaçºµes e fontes de dados.

**Funçºµes:**

- Traduzir consultas.
- Integrar mÚºltiplas fontes.
- Aplicar regras de negÓ©cio.
- Oferecer uma visØ£o unificada.
- Controlar acesso e auditoria.

Essa arquitetura Éa comum em sistemas distribuíººdos e integraçºµes.

## Exemplos em SQL e MySQL

### Criaçº£o de tabela no modelo relacional

```sql
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### Inserçº£o de dados

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

### Definiçº£o de constraint

```sql
ALTER TABLE clientes
ADD CONSTRAINT ck_clientes_email
CHECK (email LIKE '%@%.%');
```

Esses comandos ilustram o uso de SQL no modelo relacional, com tabelas, chaves e constraints.

## Resumo da evoluçº£o

- **Anos 1960:** sistemas de arquivos, modelo hierÚºrquico (IMS).
- **1964:** modelo em rede (CODASYL).
- **1970:** modelo relacional proposto por Ted Codd.
- **Anos 1970:** projeto System R, criaçº£o do SQL.
- **1977:** Oracle como um dos primeiros SGBDs relacionais comerciais.
- **1981:** IBM SQL/DS.
- **1983:** IBM DB2.
- **DÉ©cadas seguintes:** consolidaçº£o do modelo relacional e padrØ£o SQL.

## ConclusØ£o

Os SGBDs surgiram para resolver problemas de inconsistÛncia, custo e manutençº£o em sistemas baseados em arquivos. A evoluçº£o passou por modelos hierÚºrquicos e em rede atÉ© chegar ao modelo relacional, baseado em ÚÝ©lgebra relacional e tabelas. O trabalho de Ted Codd, o projeto System R e o surgimento do SQL marcaram a transiçº£o para SGBDs modernos, como Oracle, IBM SQL/DS e DB2. No modelo atual, usuÚºrios convencionais e administradores interagem com o banco por meio de linguagens de definiçº£o e manipulaçº£o, enquanto componentes internos como gerenciador de armazenamento e de buffer garantem desempenho e durabilidade.
