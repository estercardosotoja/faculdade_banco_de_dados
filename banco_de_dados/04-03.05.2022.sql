
-- Exercicios TDE 

-- #1 - Crie uma constraint que não permita armazenar no atributo “Valorvenda” da tabela de veículo um valor inferior a zero.
    ALTER TABLE     tbveiculo 
    ADD CONSTRAINT  valorvneda_not_zero 
    CHECK           (valorvenda > 0 )

-- Validando a construção da constraint
    INSERT INTO tbveiculo(pkcodvei, placa, modelo, valorcompra, 
                        valorvenda, somatoriodespesa, quantdespesas, 
                        mediapordespesa, lucrovenda, fkcodmarca, vendido) 
    VALUES (1, 'IXX-4952', 'Corsa', 1000 , 1500, 200, 5, 750, 5, 2, 1) ;

    INSERT INTO tbveiculo(pkcodvei, placa, modelo, valorcompra, 
                        valorvenda, somatoriodespesa, quantdespesas, 
                        mediapordespesa, lucrovenda, fkcodmarca, vendido) 
     VALUES (1, 'IXX-4952', 'Corsa', 0 , 1500, 200, 5, 750, 5, 2, 1) ;


-- #2 - Faça uma função que passando somente o nome da tabela retorne como resposta o próximo código a ser cadastrado. O próximo código sempre será o maior código incrementado mais um. Por exemplo, se passado como parâmetro “tbveiculo”, a função deverá encontrar o maior código de veículo cadastrado (pkcodvei) e incrementar mais um como resposta. Já se for informado no parâmetro “tbmarca”, a função deverá encontrar o maior código de marca (pkcodmarca) e incrementar mais um como resposta.

create or replace
FUNCTION PROX_COD
      (NAMETABLE VARCHAR)
      RETURN INTEGER
  IS
      COD INTEGER;
  BEGIN
    IF NAMETABLE = 'TBVEICULO' THEN 
      SELECT NVL(MAX(PKCODVEI),0) INTO COD FROM TBVEICULO; 
    ELSIF NAMETABLE = 'TBMARCA' THEN 
      SELECT MAX(PKCODMARCA) INTO COD FROM TBMARCA;
    ELSIF NAMETABLE = 'TBDESPESASVEI' THEN 
      SELECT NVL(MAX(PKCODDESPVEI),0) INTO COD FROM TBDESPESASVEI;
    ELSIF NAMETABLE = 'TBTIPODESPESA' THEN 
      SELECT NVL(MAX(PKTIPODESP),0) INTO COD FROM TBTIPODESPESA;
    ELSE 
      DBMS_OUTPUT.PUT_LINE(' ERROR ');
      COD := -2;
    END IF;
    COD := COD +1;
    RETURN COD;
END PROX_COD;

-- #3 - Crie um procedimento que receba somente o nome da marca e o procedimento deve cadastrar uma nova marca, chamando a função definida na questão 2.

create or replace
PROCEDURE NOVA_MARCA 
  (NOVAMARCA VARCHAR)
  IS
    COD INTEGER;
  BEGIN 
   COD := PROX_COD('TBMARCA');
   INSERT INTO TBMARCA(PKCODMARCA, NOMEMARCA, QUANTVEICULOS) VALUES(COD, NOVAMARCA, 5);
   DBMS_OUTPUT.PUT_LINE( COD);
  END NOVA_MARCA;

-- #4 - Crie uma função que passado somente a placa do veículo e um número (1 ou 2), onde 1 representa produto e 2 representa serviço, retorne como resposta: a soma de todas as despesas do veículo (valordespesa) da placa informada, onde o tipo de despesa (tbtipodespesa), seja do tipo informado como o segundo parâmetro da função (número). Neste caso, teste o atributo servicoproduto da tabela de tbtipodespesa . A função não poderá retornar NULL, desta forma caso não exista valor deverá retornar 0(zero).

CREATE OR REPLACE FUNCTION ADDCAR
      (PLACA VARCHAR,
       NUM INTEGER )
     RETURN NUMBER
  IS 
    VALOR INTEGER;
  BEGIN
      SELECT NVL(SUM(D.VALORDESPESA),0) INTO VALOR  FROM TBVEICULO V
      INNER JOIN TBMARCA M ON M.PKCODMARCA = V.FKCODMARCA
      INNER JOIN TBDESPESASVEI D ON D.FKCODVEI = V.PKCODVEI
      INNER JOIN TBTIPODESPESA TD ON D.FKTIPODESP = TD.PKTIPODESP
      WHERE V.PLACA = PLACA AND D.FKTIPODESP = NUM;
    RETURN VALOR;
END ADDCAR;

-- 5 - Crie um procedimento que passada a placa, modelo e valor de compra e código da marca do veículo cadastre um novo veículo.
--  Mostre dentro do procedimento o código que o veículo possuirá, o seu modelo, o nome da marca do veículo,  e a quantidade de veículos vinculados a respectiva marca. 
-- O procedimento também deverá incrementar em mais um, a quantidade de veículos (quantveiculo) associada da tabela de marca

CREATE OR REPLACE PROCEDURE ADDVEICULO
  (
    NOVA_PLACA VARCHAR,
    NOVO_MODELO VARCHAR,
    NOVO_VALORCOMPRA NUMBER,
    CODIGOMARCA INTEGER 
  )
  IS 
    COD INTEGER;
    QUANT INTEGER;
  BEGIN
    COD:=PROX_COD('TBVEICULO');
    
    SELECT M.QUANTVEICULOS INTO QUANT FROM TBMARCA M WHERE M.PKCODMARCA = 2;
    
    INSERT INTO TBVEICULO(PKCODVEI, PLACA, MODELO, VALORCOMPRA, VALORVENDA, SOMATORIODESPESA, QUANTDESPESAS, MEDIAPORDESPESA, LUCROVENDA, FKCODMARCA, VENDIDO)
    VALUES( COD, NOVA_PLACA,NOVO_MODELO, NOVO_VALORCOMPRA, 0, 0, 0, 0, 0, CODIGOMARCA, 0);
    QUANT := QUANT + 1;
    UPDATE TBMARCA M SET M.QUANTVEICULOS = QUANT WHERE M.PKCODMARCA = CODIGOMARCA;
END ADDVEICULO;


-- 6 - Crie um procedimento que registre uma despesa nova no veículo. Neste caso o procedimento conterá apenas os parâmetros: Placa do veículo; descrição da despesa; valor da despesa; data do registro da despesa; e código do tipo de despesa do veículo.  O procedimento dever 
--  Verifique se a placa passada como parâmetro está cadastrada e se o veículo não foi vendido. (o campo vendido na tabela de veículo armazena uma flag onde 0 representa que não foi vendido e 1 representa que foi vendido). 
-- Caso o veículo não exista insira o mesmo na tabela de veículo chamando o procedimento de inserção.
-- Defina a marca deste novo veículo como sendo o código da maior marca cadastrada.
-- Caso exista o veículo cadastrado busque o código do veículo cadastrado com a respectiva placa que não foi vendido. Se o veículo foi vendido, não execute os demais passos que seguem. Em seguida armazena na tabela de “tbdespesasvei” um registro registrando a despesa do veículo 
--  Altere os campos somatoriodespesas, quantdespesas e mediapordespesas da tabela “tbveículo” atualizando estas informações com os novos dados informados 
--  Altere o campo somatoriodesp da tabela “tipodespesa” atualizando o mesmo com os dados inseridos



CREATE OR REPLACE PROCEDURE ADDDESPESA
  (PLACACAR VARCHAR,
   DESCRICAO VARCHAR, 
   VALORDESPESACAR NUMBER, 
   DATEDESPESA DATE, 
   PKTIPODESPCAR INTEGER)
  IS 
    EXISTE INTEGER;
    FLAG INTEGER;
	  CONT INTEGER;
    SOMADESP NUMBER;
    PKCODCAR INTEGER;
    QUANT_DESPESAS INTEGER;
	  NAME_MODELO VARCHAR(30);
    MEDIAVALOR NUMBER;
  BEGIN
    SELECT COUNT(PKCODVEI) INTO EXISTE FROM TBVEICULO WHERE PLACA = PLACACAR;
    IF EXISTE <> 0 THEN 
      SELECT V.VENDIDO INTO FLAG FROM TBVEICULO V WHERE V.PLACA = PLACACAR;
        IF FLAG = 0 THEN 
          
          SELECT V.PKCODVEI INTO PKCODCAR FROM TBVEICULO V WHERE V.PLACA = PLACACAR;
  
          UPDATE TBDESPESASVEI 
            SET VALORDESPESA = VALORDESPESACAR 
          WHERE FKCODVEI = PKCODCAR;

          SELECT COUNT(PKCODDESPVEI) INTO QUANT_DESPESAS FROM TBDESPESASVEI WHERE FKCODVEI = PKCODCAR;
          SELECT AVG(VALORDESPESA) INTO MEDIAVALOR FROM TBDESPESASVEI WHERE FKCODVEI = 1;
          SOMADESP := SUNDES(PLACACAR, PKCODDESPVEI);

          UPDATE TBVEICULO 
            SET SOMATORIODESPESA = SOMADESP, QUANTDESPESAS = QUANT_DESPESAS, MEDIAPORDESPESA =1 MEDIAVALOR,
          WHERE PLACA = PLACACAR;
          
          DBMS_OUTPUT.PUT_LINE('NÃO VENDIDO: Código do veículo: ' || PKCODCAR);

        ELSIF FLAG = 1 THEN 
          
          DBMS_OUTPUT.PUT_LINE('VENDIDO');

        ELSE 
          DBMS_OUTPUT.PUT_LINE('ERROR');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('ENTROU NO IF' || EXISTE);
        
    ELSE 
      DBMS_OUTPUT.PUT_LINE('ENTROU NO ELSE' || EXISTE);
	  SELECT MAX(PKCODMARCA) INTO CONT FROM TBMARCA;
      ADDVEICULO(PLACACAR, 'DEFAULT', 20000, CONT); 
      
    END IF;
END ADDDESPESA;


-- Criação das tabelas e adição de dados


create table tbmarca(
	pkcodmarca integer not null,
	nomemarca varchar(30),
	quatveiculos integer,
primary key (pkcodmarca));

insert into tbmarca(pkcodmarca, nomemarca,quatveiculos ) values (1,'VW',0);
insert into tbmarca(pkcodmarca, nomemarca,quatveiculos ) values (2,'FORD',0);
insert into tbmarca(pkcodmarca, nomemarca,quatveiculos ) values (3,'FIAT',0);

create table tbtipodespesa(
	pktipodesp integer not null,
	descricaodesp varchar(30),
	somatoriodesp numeric(15,2),
	servicoproduto integer,
primary key (pktipodesp));

insert into tbtipodespesa(pktipodesp, descricaodesp,somatoriodesp,servicoproduto) values (55,'Auto Peças',0,1);
insert into tbtipodespesa(pktipodesp, descricaodesp,somatoriodesp,servicoproduto) values (56,'Mecânica', 0,2);
insert into tbtipodespesa(pktipodesp, descricaodesp,somatoriodesp,servicoproduto) values (57,'Despachante', 0,2);

create table tbveiculo(
	pkcodvei integer not null,
	placa varchar(8),
	modelo varchar(30),
	valorcompra numeric(15,2),
	valorvenda numeric(15,2) default 0,
	somatoriodespesa numeric(15,2) default 0,
	quantdespesas integer default 0,
	mediapordespesa numeric(15,2) default 0,
	lucrovenda numeric(15,2) default 0,
	fkcodmarca integer,
	vendido integer default 0,
primary key (pkcodvei));

insert into tbveiculo(pkcodvei, placa, modelo, valorcompra, valorvenda, somatoriodespesa, quantdespesas, mediapordespesa, lucrovenda, fkcodmarca, vendido)
values (1, 'IXX-4952', 'corsa', 4500, 5500, 500, 2, 75, 1000, 2, 0)


CREATE TABLE tbdespesasvei(
	pkcoddespvei integer not null,
	fkcodvei integer,
	fktipodesp integer,
	descricaodespesa varchar(60),
	datalanc date,
	valordespesa numeric(15,2) default 0,
PRIMARY KEY (pkcoddespvei));


INSERT INTO tbdespesasvei(pkcoddespvei, fkcodvei, fktipodesp, descricaodespesa, datalanc, valordespesa)
VALUES(1,1,55,'Auto peças','20210203', 100 );
INSERT INTO tbdespesasvei(pkcoddespvei, fkcodvei, fktipodesp, descricaodespesa, datalanc, valordespesa)
VALUES(2,2,57,'Despachante','' , 400 );