-- 1) Crie um procedimento que passado o nome, estoque e valor unitário de uma matéria prima o procedimento realize a inserção da mesma gerando automaticamente um novo código de chave primária

CREATE OR REPLACE PROCEDURE ADD_MATERIA_PRIMA
   (nome_materia VARCHAR,
    estoque_materia INTEGER,
    valor_unitmateria NUMBER)
  IS
    cod integer;
  BEGIN
    SELECT max(pkcodprod) INTO cod FROM tbproduto;
    cod := cod + 1;
    INSERT INTO tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod, tipocalculo) 
    VALUES (cod,nome_materia,estoque_materia, 0,40.00,valor_unitmateria, 0,1);
    DBMS_OUTPUT.PUT_LINE(' DEU BOM ');
END ADD_MATERIA_PRIMA;


-- 2) Crie uma função que receba apenas 3 parâmetros, custo do produto, a margem de lucro e o tipo de calculo, e retorne como resposta o valor de venda do produto. Observa-se que o cálculo irá depender do tipo de calculo. Existem 3 tipo de cálculo:
    -- se o tipo de calculo for 1 aplique a margem de lucro sobre o valor de custo para encontrar ao valor de venda
    -- se o tipo de calculo for 2 aplique a margem de lucro sobre o valor do custo do produto e em seguida subtraia 23% do valor encontrado para gerar a margem de lucro
    -- se o tipo de calculo for 3 divida pela metade a margem de lucro passada como parâmetro e em seguida aplique sobre o valor de custo para encontrar um novo valor de venda.
    -- Caso seja passado um valor diferente dos 3 parâmetros o valor de venda será o mesmo valor de custo.

        CREATE OR REPLACE FUNCTION valor_prod
            (custo_prod NUMBER,
            lucro_prod NUMBER,
            tipo_cal INTEGER)
            RETURN NUMBER
        IS 
            valorvenda NUMBER;
            valorporcen NUMBER;
        BEGIN 
            IF tipo_cal = 1 THEN 
                valorvenda := lucro_prod + custo_prod;
            ELSIF tipo_cal = 2 THEN 
                valorporcen := (((custo_prod - lucro_prod)*23)/100);
                valorvenda := (custo_prod + lucro_prod)+ valorporcen;
            ELSIF tipo_cal = 3 THEN 
                valorvenda := ((lucro_prod/2) + custo_prod);
            ELSE
                valorvenda := custo_prod;
            END IF;

            RETURN valorvenda;

        END valor_prod;

-- 3) Crie um procedimento que passado apenas o código do produto, nome do produto, estoque do produto, margem de lucro, tipo de calculo e uma variável chamada “acao” o procedimento deverá: 
    --  Se “acao” possuir 1 , deve ser inserido um novo produto, ignorando o código passado, pois o procedimento deverá criar um código para este novo produto. Neste caso os campos Custoprod,valorvendaprod e quantitensprod serão zerados.
    -- Se “acao” possuir 2, o procedimento deverá alterar todos os campos do produto, com exceção do código. 
    -- Observo que o campo custoprod deverá ser gerado buscado o somatório da Quant da tabela tbcomproduto, multiplicado pelo valorunit da tabela tbmateriaprima . 
    -- Já o campo valorvendaprod você chamará a função criada no exercício 2. E o campo quantitensprod será a contagem de todas as matérias primas da tabela tbcomproduto a que se refere o produto


create or replace
PROCEDURE acao
    (cod_prod integer,
    nome_prod varchar, 
    est_prod integer,
    lucro_prod number, 
    tipo_cal integer,
    acao integer)
  IS
    cod INTEGER;
    somaquant INTEGER;
    quantidade INTEGER;
  BEGIN
    IF acao = 1 THEN
        SELECT MAX(pkcodprod) INTO cod FROM tbproduto;  
        cod := cod+1;
        INSERT INTO tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod, tipocalculo) 
        VALUES (cod, nome_prod, est_prod, 0, lucro_prod, 0, 0, tipo_cal);
      ELSE IF acao = 2 THEN 
        SELECT SUM(quant) INTO quantidade FROM tbcomproduto WHERE fkcodmat = cod_prod;
        SELECT SUM(m.valorunit*cp.quant) FROM tbmateriaprima m
        INNER JOIN tbcomproduto cp ON cp.fkcodmat = m.pkcodmat
        WHERE cp.fkcodprod = 2; 
        UPDATE tbproduto p 
        SET p.nomeprod = nome_prod, 
            p.estoqueprod = est_prod,
            p.custoprod = somaquant, 
            p.margemprod = 0, 
            p.valorvendaprod = valor_prod(custoprod, lucro_prod, 1), 
            p.quantitensprod =  quantidade, 
            p.tipocalculo = 0
        WHERE p.pkcodprod = cod_prod;  
      ELSE 
        DBMS_OUTPUT.PUT_LINE('acao - inválido');
    END IF;
END PROCEDURE acao;


-- Massa de Testes
create sequence pkproduto start with 10;
create sequence pkmateira start with 10;
create sequence pkcomposicao start with 10;

create table tbproduto(
    pkcodprod integer not null,
    nomeprod varchar(40),
    estoqueprod integer,
    custoprod number(15,2),
    margemprod number(15,2),
    tipocalculo integer,
    valorvendaprod number(15,2),
    quantitensprod number(15,2),
constraint tbproduto_pk primary key(pkcodprod)
);

create table tbmateriaprima(
    pkcodmat integer not null,
    nomemat varchar(30),
    estoquemat integer,
    valorunit number(15,2),
constraint tbmateriaprima_pk primary key(pkcodmat)
);
create table tbcomproduto(
    pkcomprod integer not null,
    fkcodmat integer,
    fkcodprod integer,
    quant number(15,2),
constraint tbcomproduto_pk primary key(pkcomprod)
);
insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) values (1,'mat 1',10,2.00 );
insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) values (2,'mat 2',5,1.50 );
insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) values (3,'mat 3',3,5.00 );
insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) values (4,'mat 4',1,2.50 );
insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit ) values (5,'mat 5',50,4.00 );
insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod ,
quantitensprod,tipocalculo ) values (1,'produto 1',3, 8.00,50.00,12.00,2,1);
insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod ,
quantitensprod,tipocalculo ) values (2,'produto 2',0, 16.00,10.00,17.60,3,1);
insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod ,
quantitensprod,tipocalculo ) values (3,'produto 3',5, 8.00,70.00,13.60,2,2);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (1,2,1,2);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (2,3,1,1);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (3,5,2,1);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (4,3,2,2);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (5,1,2,1);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (6,1,3,2.5);
insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) values (7,2,3,2);