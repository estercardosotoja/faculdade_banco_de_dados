-- Exercicios TDE 

-- 1) Crie uma Função que passado o nome da tabela sempre retorne o próximo código que corresponde a chave primária da tabela.

    CREATE OR REPLACE FUNCTION PROX_COD 
        (NAME_TABLE VARCHAR)
        RETURN INTEGER
    IS 
        COD INTEGER;
    BEGIN
        IF NAME_TABLE = 'tbcliente' THEN 
            SELECT MAX(pkcodcli) INTO COD FROM tbparcela;
        ELSIF NAME_TABLE = 'tbparcela' THEN 
            SELECT MAX(pkcodparcela) INTO COD FROM tbparcela;
        ELSIF NAME_TABLE = 'tbitenscobertura' THEN
            SELECT MAX(pkitens) INTO COD  FROM tbitenscobertura;
        ELSIF NAME_TABLE = 'tbapolice' THEN 
            SELECT MAX(pknumapolice) INTO COD FROM tbapolice;
        ELSIF NAME_TABLE = 'tbcobertura' THEN 
            SELECT MAX(pkcodcobert) INTO COD FROM tbcobertura;
        ELSIF NAME_TABLE = 'tbveiculo' THEN 
            SELECT MAX(pkcodvei) INTO COD FROM tbveiculo;
        ELSE
            DBMS_OUTPUT.PUT_LINE(' ERROR ');
        END IF;

        COD:= COD + 1;
        RETURN  COD;

    END PROX_COD;

-- 2) Crie um procedimento que passado o número da apólice (fknumapolice) o código da cobertura ( fkcodcobert) e o valor da cobertura( valorcobertura) insira um registro na tabela tbitenscobertura. Contudo, o procedimento deverá respeitar as seguintes regras para inserir dados.
    -- Somente deverá inserir se o número de apólice existir,
    -- Somente deverá inserir se o código da cobertura existir,
    -- Se o valor da cobertura for menor ou igual a zero, o valor de cobertura deverá ser alterado para o valor da franquia (valorfranquiapadrao) multiplicado por 8.
    -- Assim que adicionado o registro na tabela tbitenscobertura, o procedimento deverá alterar o valor total da apólice (valortotalapolice) acrescido do respectivo valor de cobertura (valorcobertura) que acabamos de inserir.
    -- Após inserir os dados na tabela tbitenscobertura, o procedimento também deverá listar em tela, o nome do cliente da respectiva apólice (nomecli), a descrição da cobertura(nomecobert) e o novo valor total da apólice (valortotalapolice)

CREATE OR REPLACE PROCEDURE addregistro
    (num_apolice INTEGER,
     cod_cobertura INTEGER, 
     valor_cobertura NUMBER)
  IS
     COD INTEGER,
     EXISTE_APOLICE INTEGER,
     EXISTE_COBERTURA INTEGER,
     VLRFRANQUIA INTEGER,
     NOME_CLIENTE VARCHAR,
     NOME_COBERTURA VARCHAR,
     VLRTOTAPOLICE NUMBER;
  BEGIN
     SELECT COUNT(pknumapolice) INTO EXISTE_APOLICE FROM TBAPOLICE WHERE pknumapolice = num_apolice;
     SELECT COUNT(pkcodcobert) INTO EXISTE_COBERTURA FROM TBCOBERTURA WHERE pkcodcobert = cod_cobertura;
     IF EXISTE_APOLICE > 0 AND EXISTE_COBERTURA > 0 THEN 
         
          IF valor_cobertura <= 0 THEN
              SELECT valorfranquiapadrao INTO VLRFRANQUIA FROM TBCOBERTURA WHERE cod_cobertura = pkcodcobert;
              VLRFRANQUIA := VLRFRANQUIA * 8;
              COD := PROX_COD('tbitenscobertura');
              INSERT INTO tbitenscobertura(pkitens, fknumapolice, fkcodcobert, valorcobertura)
              VALUES (COD ,num_apolice, cod_cobertura, valor_cobertura);
              UPDATE TBAPOLICE SET valortotalapolice = valor_cobertura WHERE fkcodcobert = cod_cobertura;
          END IF;
            
          SELECT CLI.NOMECLI, COB.NOMECOBERT, APO.VALORTOTALAPOLICE INTO NOME_CLIENTE, NOME_COBERTURA, VLRTOTAPOLICE 
          FROM TBCLIENTE CLI INNER JOIN TBAPOLICE APO ON CLI.PKCODCLI = APO.FKCODCLI,
          INNER JOIN TBITENSCOBERTURA ITENS ON APO.PKNUMAPOLICE = ITENS.FKNUMAPOLICE,
          INNER JOIN TBCOBERTURA COB ON ITENS.FKCODCOBERT = COB.PKCODCOBERT
          WHERE APO.PKNUMAPOLICE = 456;
          DBMS_OUTPUT.PUT_LINE('Cliente: '|| NOME_CLIENTE );
          DBMS_OUTPUT.PUT_LINE('Nome cobertura: '|| NOME_COBERTURA );
          DBMS_OUTPUT.PUT_LINE('Valor total apolice : '|| VLRTOTAPOLICE );
      ELSIF EXISTE_APOLICE = 0 AND EXISTE_COBERTURA = 0 THEN 
          DBMS_OUTPUT.PUT_LINE(' NÃO TEMOS EM UMA APOLICE ');
      ELSE 
          DBMS_OUTPUT.PUT_LINE(' ERROR ');
      END IF;
    END addregistro;


-- 3) Crie um procedimento que receba o número da apólice (pknumapolice) e a quantidade de parcelas que deseja gerar da respectiva apólice. O sistema deverá gerar a quantidade de parcelas informando o campo valor de parcela (valorparcela) o valor resultante da divisão do valortotalapolice pela quantidade de parcelas informada como parâmetro. 
-- Na inserção defina o campo (situacao) como zero (neste caso o campo situação é uma flag onde 0 representa que está em aberto e 1 que está pago). Quando gerada as parcelas, será necessário também que seja alterado o conteúdo do atributo valorparcelasaberto da tabela tbcliente que armazena o valor total de parcelas em aberto do respectivo cliente.

create or replace
PROCEDURE PARCELAMENTO
   ( CODAPOLICE INTEGER,
    QUANT_PARCELAS INTEGER)
  IS 
    VALOR NUMBER;
    PARCELA NUMBER;
    COD INTEGER;
  BEGIN
    SELECT VALORTOTALAPOLICE INTO VALOR FROM TBAPOLICE WHERE PKNUMAPOLICE = CODAPOLICE;
    PARCELA := VALOR / QUANT_PARCELAS;

    DBMS_OUTPUT.PUT_LINE('QUANTIDADE DE PARCCELAS: ' || QUANT_PARCELAS);
    DBMS_OUTPUT.PUT_LINE('VALOR DAS PARCELAS: R$' || PARCELA);

    COD:= PROX_COD('tbparcela');
    
    INSERT INTO TBPARCELA(PKCODPARCELA,FKNUMAPOLICE,SITUACAO,VALORPARCELA)
    VALUES(COD, CODAPOLICE, 1, VALOR);
END PARCELAMENTO;


-- Massa de Dados
uma das questões .
DROP TABLE tbparcela;
DROP TABLE tbitenscobertura;
DROP TABLE tbapolice;
DROP TABLE tbcliente;
DROP TABLE tbcobertura;
DROP TABLE tbveiculo;

CREATE TABLE tbcliente(
    pkcodcli INTEGER NOT NULL,
    nomecli VARCHAR(100),
    numapolices INTEGER DEFAULT 0,
    numparcelasaperto NUMERIC(15,2),
    valorparcelasaberto NUMERIC(15,2),
    PRIMARY KEY (pkcodcli)
);

INSERT INTO tbcliente(pkcodcli,nomecli,numapolices,numparcelasaperto,valorparcelasaberto) 
VALUES (1,"Carol",1,2,250);

INSERT INTO tbcliente(pkcodcli,nomecli, numapolices,numparcelasaperto,valorparcelasaberto) 
VALUES (2,"Ana",0,0,0);

CREATE TABLE tbcobertura(
    pkcodcobert integer not null,
    nomecobert varchar(100),
    valorpremiopadrao numeric(15,2),
    valorfranquiapadrao numeric(15,2),
    primary key (pkcodcobert)
);

INSERT INTO tbcobertura(pkcodcobert,nomecobert, valorpremiopadrao, valorfranquiapadrao)
VALUES (20,"Roubo",20000,1500);

INSERT INTO tbcobertura(pkcodcobert,nomecobert, valorpremiopadrao, valorfranquiapadrao)
VALUES (21,"Quebra Lanterna",0,150);

INSERT INTO tbcobertura(pkcodcobert,nomecobert, valorpremiopadrao, valorfranquiapadrao)
VALUES (22,"Quebra de vidro",0,250);

CREATE TABLE tbveiculo(
    pkcodvei INTEGER NOT NULL,
    placavei VARCHAR(8),
    modelo VARCHAR(100),
    anofabricacao INTEGER,
    numapolices INTEGER DEFAULT 0,
    PRIMARY KEY(pkcodvei)
);

INSERT INTO tbveiculo(pkcodvei,placavei,modelo,anofabricacao,numapolices) 
VALUES(88,"XXX-8888","Argo",2020,1);

INSERT INTO tbveiculo(pkcodvei,placavei,modelo,anofabricacao,numapolices) 
VALUES (89," AAA-9999","Fusca",1977,0);

INSERT INTO tbveiculo(pkcodvei,placavei,modelo,anofabricacao,numapolices) 
VALUES (90,"BBB-7777","Gol",2019,0);

CREATE TABLE tbapolice(
    pknumapolice INTEGER NOT NULL, 
    fkcodcli INTEGER,
    fkcodvei INTEGER,
    valortotalapolice NUMERIC(15,2),
    PRIMARY KEY (pknumapolice),
    FOREIGN KEY (fkcodvei) REFERENCES tbveiculo(pkcodvei),
    FOREIGN KEY (fkcodcli) REFERENCES tbcliente(pkcodcli)
);

INSERT INTO tbapolice( pknumapolice, fkcodcli, fkcodvei, valortotalapolice) 
VALUES(456,1,88,1000);

CREATE TABLE tbitenscobertura(
    pkitens INTEGER NOT NULL,
    fknumapolice INTEGER,
    fkcodcobert INTEGER,
    valorcobertura NUMERIC(15,2),
    PRIMARY KEY (pkitens),
    FOREIGN KEY (fknumapolice) REFERENCES tbapolice(pknumapolice),
    FOREIGN KEY (fkcodcobert) REFERENCES tbcobertura(pkcodcobert)
);
 
INSERT INTO tbitenscobertura(pkitens, fknumapolice, fkcodcobert, valorcobertura) 
VALUES (1,456,20,850);

INSERT INTO tbitenscobertura(pkitens, fknumapolice, fkcodcobert, valorcobertura) 
VALUES (2,456,22,150);
 
CREATE TABLE tbparcela(
    pkcodparcela INTEGER NOT NULL,
    fknumapolice INTEGER,
    situacao INTEGER DEFAULT 0,
    valorparcela NUMERIC(15,2),
    PRIMARY KEY (pkcodparcela),
    FOREIGN KEY (fknumapolice) REFERENCES tbapolice(pknumapolice)
);

INSERT INTO tbparcela(pkcodparcela, fknumapolice, situacao, valorparcela) 
VALUES (1,456,1,250);

INSERT INTO tbparcela(pkcodparcela, fknumapolice, situacao, valorparcela) 
VALUES (2,456,1,250);

INSERT INTO tbparcela(pkcodparcela, fknumapolice, situacao, valorparcela) 
VALUES(3,456,1,250);

INSERT INTO tbparcela(pkcodparcela, fknumapolice, situacao, valorparcela) 
VALUES(4,456,0,250);