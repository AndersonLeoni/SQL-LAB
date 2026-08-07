/* versão beta tabela atletas
CREATE TABLE atletas (
	id INT NOT NULL auto_increment,
    aname VARCHAR(99),
    birth DATE,
    peso FLOAT,
    altura FLOAT,
    sexo ENUM('M', 'F'),
    ativo BOOLEAN default true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    primary key (id)
	
    );
*/
CREATE TABLE athletes (
	id INT NOT NULL auto_increment,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    weight DECIMAL (5,2),
    height DECIMAL (3,2),
    gender ENUM ('M', 'F'),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id)
    );
    
-- DROP table atletas;
-- teste de select na tabela criada
SELECT * FROM athletes;