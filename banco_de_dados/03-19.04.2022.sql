-- PROCEDURES AND FUNTIONS

-- Massa para testes
CREATE TABLE tbfuncionario(
    codfunc INTEGER NOT NULL,
    nomefunc VARCHAR(20),
    salariofunc NUMBER(15,2),
  CONSTRAINT funcionario_PK PRIMARY KEY(codfunc)
); 

INSERT INTO tbfuncionario(codfunc,nomefunc,salariofunc) VALUES (1,'Maria',2000);
INSERT INTO tbfuncionario(codfunc,nomefunc,salariofunc) VALUES (2,'Debora',1500);
INSERT INTO tbfuncionario(codfunc,nomefunc,salariofunc) VALUES (3,'Rosana',3500); 

-- Criando um procedimento
CREATE OR REPLACE PROCEDURE aumenta_sal
    (codigo IN tbfuncionario.codfunc%TYPE, perc IN NUMBER)
IS
BEGIN
    UPDATE tbfuncionario
    SET salariofunc = salariofunc+(salariofunc* perc/100)
    WHERE codfunc = codigo;
END aumenta_sal;
 
 -- Executando o procedimento
SELECT * FROM tbfuncionario;
EXECUTE aumenta_sal(1,17.5);
SELECT * FROM tbfuncionario;

-- Deletando o procedimento
DROP PROCEDURE aumenta_sal;

-- Criando Function:
 CREATE OR REPLACE FUNCTION dobro
    (NUMERO IN NUMBER)
    RETURN NUMBER
  IS
    N NUMBER;
  BEGIN
    N:=NUMERO*2;
    RETURN (N);
END dobro;

-- Executando uma function
SELECT * FROM tbfuncionario;
SELECT nomefunc,salariofunc,dobro(salariofunc) AS dobro_s FROM tbfuncionario;
SELECT * FROM tbfuncionario WHERE salariofunc&gt; dobro(1000);
UPDATE tbfuncionario SET salariofunc=dobro(salariofunc) WHERE codfunc=2;

-- Function retornando outro tipo de dado 
CREATE OR REPLACE FUNCTION dobro2
    (NUMERO IN NUMBER)
    RETURN VARCHAR2
  IS
    N NUMBER;
    NOME VARCHAR2(20);
  BEGIN
    N:=NUMERO*2;
    NOME:= 'O dobro é ' || N;
    RETURN (NOME);
END dobro2;


-- Dual 
SELECT dobro2(4) AS resultado FROM dual;

-- Executando Function
SELECT f.*,dobro2(f.salariofunc) AS resultado FROM tbfuncionario f;

-- Criando uma funtion que retorna o maior código
CREATE OR REPLACE FUNCTION maior
    ETURN INTEGER
  IS
    m INTEGER;
  BEGIN
    SELECT NVL(max(codfunc),0) INTO m FROM tbfuncionario;
    RETURN (m);
END maior;

-- Criando procedure que grava funcionário, usando uma funtion
CREATE OR REPLACE PROCEDURE GRAVAFUNC
    (nome IN VARCHAR2, salario IN NUMBER)
  IS
    proximo INTEGER;
  BEGIN
    proximo:=maior()+1;
    INSERT INTO tbfuncionario (codfunc,nomefunc,salariofunc)
    VALUES(proximo,nome,salario);
END GRAVAFUNC;


-- Executando a procedure:
  EXECUTE gravafunc('Carla',1250);
  EXECUTE gravafunc('Adriana',dobro(900));

