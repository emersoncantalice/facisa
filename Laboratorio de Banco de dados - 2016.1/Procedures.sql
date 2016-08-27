﻿CREATE TABLE PESSOAS (
	ID_PESSOA INT,
	NOME_PESSOA VARCHAR(100) UNIQUE,
	FUNCAO VARCHAR(100),
	CONSTRAINT PK_PESSOA PRIMARY KEY(ID_PESSOA)
);

CREATE TABLE CURRICULOS (
	ID_CURRICULO INT,
	DATA_ATUALIZACAO DATE,
	ID_PESSOA INT,
	CONSTRAINT PK_CURRICULOS PRIMARY KEY(ID_CURRICULO),
	CONSTRAINT FK_CURRICULO_PESSOA FOREIGN KEY (ID_PESSOA) REFERENCES PESSOAS(ID_PESSOA)
);

CREATE TABLE EXPERIENCIAS (
	ID_EXPERIENCIA INT,
	TITULO VARCHAR(100),
	DATA_INICIO DATE NOT NULL,
	DATA_FIM DATE,
	ID_PESSOA INT,
	CONSTRAINT FK_EXPERIENCIA_PESSOA FOREIGN KEY (ID_PESSOA) REFERENCES PESSOAS(ID_PESSOA) ON DELETE CASCADE
);

INSERT INTO PESSOAS VALUES (1, 'Emerson Cantalice',  'DESENVOLVEDOR'),
			   (2, 'Adriano Santos', 'DBA'),
			   (3, 'Luan Cantalice', 'Estudante');

INSERT INTO CURRICULOS VALUES (1, '2016-08-15',1),
			      (2, '2016-06-13',3),
			      (3, '2015-05-12',2);


INSERT INTO EXPERIENCIAS VALUES (1, 'Millenium Impressos', '2013-02-12', '2014-06-26', 1),
				(2, 'Stefanini IT', '2015-08-17', null, 1),
				(3, 'NASA', '2013-01-11', '2014-10-18', 2),
				(4, 'LTI Facisa', '2015-01-01', null, 2),
				(5, 'Estagio IFPB', '2015-04-12', '2016-03-30', 3);

CREATE OR REPLACE FUNCTION inserePessoa(
    IN ID INT,
    IN NOME VARCHAR(100),
    IN FUNCAO VARCHAR(100))
  RETURNS VOID AS
'
 INSERT INTO PESSOAS VALUES (ID, NOME, FUNCAO)
'
LANGUAGE 'sql';	

SELECT inserePessoa(4,'Thayle Duarte','Advogada');
SELECT * FROM PESSOAS;

CREATE OR REPLACE FUNCTION insereCurriculo(
	    IN ID_PESSOA INT,
	    IN NOME VARCHAR(100),
	    IN FUNCAO VARCHAR(100),
	    IN ID_CURRICULO INT,
            IN DATA_ATUALIZACAO DATE,
   	    IN ID_EXPERIENCIA INT,
	    IN TITULO_EXPERIENCIA VARCHAR(100),
	    IN DATA_INICIO DATE,
	    IN DATA_FIM DATE)
	  RETURNS VOID AS
	$$
	BEGIN
	 INSERT INTO PESSOAS VALUES (ID_PESSOA, NOME, FUNCAO);
	 INSERT INTO EXPERIENCIAS VALUES (ID_EXPERIENCIA , TITULO_EXPERIENCIA, DATA_INICIO, DATA_FIM,ID_PESSOA);
	 INSERT INTO CURRICULOS VALUES (ID_CURRICULO , DATA_ATUALIZACAO, ID_PESSOA);
	END;
	$$
LANGUAGE 'plpgsql';

DELETE FROM PESSOAS WHERE ID_PESSOA = 4;
SELECT insereCurriculo(4,'Thayle Duarte','Advogada',4,'13-08-2016',6,'OAB','12-05-2015',null);
SELECT * FROM PESSOAS;

CREATE OR REPLACE FUNCTION recuperaCurriculo(int)
 RETURNS TABLE(NOME VARCHAR(100), DATA_ATUALIZACAO DATE, TITULO VARCHAR(100)) AS
	$$
	BEGIN
		RETURN QUERY
		SELECT P.NOME_PESSOA, C.DATA_ATUALIZACAO, E.TITULO FROM PESSOAS P, CURRICULOS C, EXPERIENCIAS E
		WHERE P.ID_PESSOA = C.ID_PESSOA AND P.ID_PESSOA = E.ID_PESSOA AND P.ID_PESSOA = $1 ;
	END;
	$$
LANGUAGE 'plpgsql';

SELECT recuperaCurriculo(1);

CREATE OR REPLACE FUNCTION verificaEmpregado(int) RETURNS BOOLEAN AS
	$$
	DECLARE
		verifica boolean;
		quantidade int;
	BEGIN
		quantidade := (SELECT COUNT(*) FROM EXPERIENCIAS WHERE DATA_FIM IS NULL AND ID_PESSOA = $1) ;

		if (quantidade > 0) then
			return true;
		else
			return false;
		end if;
	END;
	$$
LANGUAGE 'plpgsql';

SELECT verificaEmpregado(3);


