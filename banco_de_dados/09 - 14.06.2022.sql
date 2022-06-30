 -- Exercicios 2 Triggers

-- 1) Desenvolva 3 triggers que controlem a geração automática do código do produto, código de matéria prima e código de composição de produto, tendo como base as sequences criadas no script. Desta forma, toda vez que for inserido um registro nestas tabelas o sistema seleciona um código para ser colocado na chave primária das tabelas.

CREATE OR REPLACE TRIGGER ADD_PRODUTO_BI
    BEFORE INSERT ON tbproduto
    FOR EACH ROW
    DECLARE
       cod integer;
    BEGIN 
        select pkproduto.NEXTVAL into cod from dual;
        :new.pkcodprod := cod;
    END;

CREATE OR REPLACE TRIGGER ADD_MATERIA_BI
    BEFORE INSERT ON tbmateriaprima
    FOR EACH ROW
    DECLARE
       cod integer;
    BEGIN 
        select pkmateria.NEXTVAL into cod from dual;
        :new.pkcodmat := cod;
    END;


CREATE OR REPLACE TRIGGER ADD_COMPRODUTO_BI
    BEFORE INSERT ON tbcomproduto
    FOR EACH ROW
    DECLARE
       cod integer;
    BEGIN 
        select pkcomposicao.NEXTVAL into cod from dual;
        :new.pkcomprod := cod;
    END;

--  2) Crie uma trigger que após inserir,alterar ou remover um item da composição de produto o campo seja atualizado os seguintes campos da tabela tbproduto
    
     -- “quantitensprod”, deverá ser incrementado ou decrementado em +1 ou -1 item.
     
     -- “ custoprod ”, deverá ser recalculado. O mesmo representa o somatório das quantidades (quant) multiplicado pelo valor unitário(valorunit) de cada matéria que compõe o produto 
     
     -- “valorvendaprod”, deverá ser recalculado com base no novo valor de custo “custoprod” acrescido da margem de lucro (margemprod).


--> COM ERROS: 

CREATE OR REPLACE TRIGGER ALTUALIZAR_AIUD
  AFTER UPDATE OR INSERT OR DELETE ON tbcomproduto
  FOR EACH ROW
  DECLARE
    cod INTEGER;
    quantidade INTEGER;
    valor NUMBER;
    valorvenda NUMBER;
  BEGIN

    IF inserting THEN
      cod := :new.fkcodprod;
      UPDATE tbproduto SET quantitensprod = quantitensprod + 1 WHERE PKCODPROD = cod;      
    END IF; 

    IF deleting THEN
      cod := :old.fkcodprod;
      UPDATE tbproduto SET quantitensprod = quantitensprod - 1 WHERE PKCODPROD = cod;      
    END IF;

    IF updating AND :old.quant <> :new.quant THEN
      IF :old.quant > :new.quant THEN
        cod := :new.fkcodprod;
        UPDATE tbproduto SET quantitensprod = quantitensprod - 1 WHERE PKCODPROD = cod;  
      ELSE
        cod := :new.fkcodprod;
        UPDATE tbproduto SET quantitensprod = quantitensprod + 1 WHERE PKCODPROD = cod;  
      END IF;
    END IF;
    
    SELECT m.valorunit*cp.quant INTO valor FROM tbmateriaprima m
    INNER JOIN tbcomproduto cp ON m.pkcodmat = cp.fkcodmat
    WHERE cp.fkcodprod = cod;
    
    UPDATE tbproduto SET custoprod = valor WHERE pkcodprod = cod;
    
    SELECT p.custoprod + p.margemprod INTO valorvenda FROM tbproduto p where p.pkcodprod = cod;

    UPDATE tbproduto p SET p.margemprod = valorvenda WHERE p.pkcodprod = cod;
    
  END;


-- 3) Crie uma trigger que antes alterar ou remover um item da tabela de matéria prima realize as seguintes rotinas:
    
    -- Se for alterado o valor unitário da matéria prima, deverá ser alterado os seguintes campos em produto
        
        -- “custoprod”, deverá ser recalculado. O mesmo representa o somatório das quantidades (quant) multiplicado pelo valor unitário(valorunit) de cada matéria que compõe o produto

        -- “ valorvendaprod ”, deverá ser recalculado com base no novo valor de custo “custoprod” acrescido da margem de lucro (margemprod).
    -- Se for Removido um item de matéria prima:
        -- “quantitensprod”, deverá ser incrementado ou decrementado em -1 item se o item foi removido
        -- Deverá remover os registros da tabela de composição de produto que possuem a matéria prima removida
        -- Recalcular o “custoprod” e o “valorvendaprod” da tabela de produto


--> COM ERROS: 

    CREATE OR REPLACE TRIGGER alter_tbmateriaprima_BUD
    BEFORE UPDATE OR DELETE ON tbmateriaprima 
    FOR EACH ROW 
    DECLARE
        valorvenda NUMBER;
        valor number;
        cod integer;
        cod_materia number;
    BEGIN
        IF updating and :new.valorunit <> :old.valorunit then 
          
          SELECT cp.fkcodprod into cod FROM tbcomproduto cp
          INNER JOIN tbmateriaprima m ON m.pkcodmat = cp.fkcodmat
          INNER JOIN tbproduto p ON p.pkcodprod = cp.fkcodprod
          WHERE cp.fkcodmat = :old.pkcodmat ;
          
          SELECT m.valorunit*cp.quant INTO valor FROM tbmateriaprima m
          INNER JOIN tbcomproduto cp ON m.pkcodmat = cp.fkcodmat
          WHERE cp.fkcodprod = cod;
        
          UPDATE tbproduto SET custoprod = valor WHERE pkcodprod = cod;

          SELECT p.custoprod + p.margemprod INTO valorvenda FROM tbproduto p where p.pkcodprod = cod;
        
          UPDATE tbproduto p SET p.margemprod = valorvenda WHERE p.pkcodprod = cod;
        
        END IF;
         IF deleting THEN   
      
            SELECT cp.fkcodprod into cod FROM tbcomproduto cp
            INNER JOIN tbmateriaprima m ON m.pkcodmat = cp.fkcodmat
            INNER JOIN tbproduto p ON p.pkcodprod = cp.fkcodprod
            WHERE cp.fkcodmat = :old.pkcodmat ;
            
            UPDATE tbproduto SET quantitensprod = quantitensprod - 1 WHERE PKCODPROD = cod;

            SELECT m.pkcodmat INTO cod_materia FROM tbcomproduto cp
            INNER JOIN tbmateriaprima m ON m.pkcodmat = cp.fkcodmat
            INNER JOIN tbproduto p ON p.pkcodprod = cp.fkcodprod
            WHERE cp.fkcodprod = cod;

            DELETE FROM tbcomproduto WHERE fkcodmat = cod_materia;

            SELECT m.valorunit*cp.quant INTO valor FROM tbmateriaprima m
            INNER JOIN tbcomproduto cp ON m.pkcodmat = cp.fkcodmat
            WHERE cp.fkcodprod = cod;
            
            UPDATE tbproduto SET custoprod = valor WHERE pkcodprod = cod;

            SELECT p.custoprod + p.margemprod INTO valorvenda FROM tbproduto p where p.pkcodprod = cod;
            
            UPDATE tbproduto p SET p.margemprod = valorvenda WHERE p.pkcodprod = cod;

        END IF;
    END;


-- Massa de Dados
CREATE SEQUENCE pkproduto 
    START WITH 10;

CREATE SEQUENCE pkmateria 
    START WITH 10;

CREATE SEQUENCE pkcomposicao 
    START WITH 10;

CREATE TABLE tbproduto(
    pkcodprod INTEGER NOT NULL,
    nomeprod VARCHAR(40),
    estoqueprod INTEGER,
    custoprod NUMBER(15,2),
    margemprod NUMBER(15,2),
    valorvendaprod NUMBER(15,2),
    quantitensprod NUMBER(15,2),
    CONSTRAINT tbproduto_pk PRIMARY KEY(pkcodprod)
);
CREATE TABLE tbmateriaprima(
    pkcodmat INTEGER NOT NULL,
    nomemat varchar(30),
    estoquemat INTEGER,
    valorunit NUMBER(15,2),
    CONSTRAINT tbmateriaprima_pk PRIMARY KEY(pkcodmat)
);
CREATE TABLE tbcomproduto(
    pkcomprod INTEGER NOT NULL,
    fkcodmat INTEGER,
    fkcodprod INTEGER,
    quant NUMBER(15,2),
    CONSTRAINT tbcomproduto_pk PRIMARY KEY(pkcomprod)
);
INSERT INTO tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) VALUES (1,'mat 1',10,2.00 );
INSERT INTO tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) VALUES (2,'mat 2',5,1.50 );

INSERT INTO tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) VALUES (3,'mat 3',3,5.00 );
INSERT INTO tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) VALUES (4,'mat 4',1,2.50 );
INSERT INTO tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) VALUES (5,'mat 5',50,4.00 );

INSERT INTO tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod )
VALUES (1,'produto 1',3, 8.00,50.00,12.00,2);
INSERT INTO tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod )
VALUES (2,'produto 2',0, 16.00,10.00,17.60,3);
INSERT INTO tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod )
VALUES (3,'produto 3',5, 8.00,70.00,13.60,2);

INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (1,2,1,2);
INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (2,3,1,1);
INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (3,5,2,1);

INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (4,3,2,2);
INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (5,1,2,1);
INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (6,1,3,2.5);
INSERT INTO tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) VALUES (7,2,3,2);