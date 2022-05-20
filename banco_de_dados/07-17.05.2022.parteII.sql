
-- TDE 17.05.2022 - Revisão APII

-- 1) Crie um procedimento que passado o código do cliente, o código do tipo de incidente e a data, gere um chamado. O procedimento deverá criar automaticamente um código para o chamado.

CREATE OR REPLACE PROCEDURE ADDCOD
   (cod_cliente VARCHAR,
    cod_tipoincidente INTEGER,
    date_inci DATE);
  IS
    cod INTEGER;
  BEGIN
    SELECT MAX(pkchamado) INTO cod FROM tbchamado;
    cod := cod+1;
    INSERT INTO tbchamado(pkchamado, dataabertura, fkcliente, fktipo)
    VALUES (cod, date_inci, cod_cliente, cod_tipoincidente);
    DBMS_OUTPUT.PUT_LINE(' DEU BOUM! ');
END ADDCOD;

-- 2) Crie uma função que passado o código do técnico e um parâmetro chamado acao, execute e retorne:
        -- Se acao por 1 retorne a quantidade de chamados que o respectivo técnico possui que estão em execução onde ele é o último técnico a realizar o registro cujos chamados estão com status igual a 1
        -- Se acao por 2 retorne a quantidade de chamados que o respectivo técnico possui que estão em execução onde ele é o último técnico a realizar o registro cujos chamados estão com status igual a 2
        -- Se acao por 3 retorne a quantidade de registros de lançamentos que o técnico teve

CREATE OR REPLACE FUNCTION functecnico
        (cod_tecnico INTEGER, 
         acao INTEGER)
         RETURN INTEGER
      IS 
        dado_retorno INTEGER;
      BEGIN 
        IF acao = 1 THEN 
            SELECT COUNT(c.pkchamado) INTO dado_retorno FROM tbchamado c
            INNER JOIN tbregistro r ON c.pkchamado = r.fkchamado
            WHERE r.fktecnico = cod_tecnico  AND c.status = 1 AND c.fkultimotecnico = cod_tecnico;
          ELSIF acao = 2 THEN 
            SELECT COUNT(c.pkchamado) INTO dado_retorno FROM tbchamado c
            INNER JOIN tbregistro r ON c.pkchamado = r.fkchamado
            WHERE r.fktecnico = cod_tecnico  AND c.status = 2 AND c.fkultimotecnico = cod_tecnico;
          ELSIF acao = 3 THEN 
            SELECT COUNT(*) INTO dado_retorno FROM tbregistro r WHERE r.fktecnico = cod_tecnico;
          ELSE 
            DBMS_OUTPUT.PUT_LINE(' DEU RUIM! ');
        END IF;
  RETURN dado_retorno;
END functecnico;



-- 3) Crie um procedimento que receba o código do técnico, o numero da chamada, a descrição de registro e o status do lançamento do registro. O Procedimento deverá:
        -- x Realizar a inserção de um novo registro na tabela de tbregistro
        -- x Trocar o status do chamado de acordo com o novo status passado
        -- x Trocar o código do ultimo técnico que realizou o registro na tabela de chamados.
        -- Atualizar os campos quantChamadoAberto, quantChamadoExec e quantChamadoConc da tabela de tbcliente
        -- Atualizar os campos quantChamadoAberto,quantChamadoExec e quantChamadoConc da tabela de tbtipoincidente
        -- Atualizar os campos quantChamadoExec e quantChamadoConc da tabela de tbtecnico

  CREATE OR REPLACE PROCEDURE proregistro
      (cod_tecnico INTEGER,
       num_chamado INTEGER, 
       des_reg VARCHAR, 
       status_reg INTEGER)
    IS 
      cod INTEGER;
      quant_CA INTEGER;
      quant_CE INTEGER;
      quant_CC INTEGER;
      cod_cliente INTEGER;
      cod_tipo INTEGER;
    BEGIN

      SELECT MAX(pkregistro) INTO cod FROM tbregistro;
      cod := cod + 1;

      INSERT INTO tbregistro(pkregistro, dataregistro, fkchamado, fktecnico, descricao)
      VALUES(cod, null, num_chamado, cod_tecnico, des_reg);

      UPDATE tbchamado cha
        SET  cha.status = status_reg,
             cha.fkultimotecnico = cod_tecnico
      WHERE  cha.pkchamado = num_chamado;

      SELECT  tp.quantchamadoaberto, tp.quantchamadoexec, tp.quantchamadoconc, cli.pkcliente, tp.pktipo
      INTO quant_CA, quant_CE, quant_CC , cod_cliente, cod_tipo 
      FROM tbchamado cha
      INNER JOIN tbtipoincidente tp ON tp.pktipo = cha.fktipo
      inner JOIN tbcliente cli on cha.fkcliente = cli.pkcliente
      WHERE  cha.pkchamado = num_chamado;
      

      UPDATE tbcliente cli
        SET  cli.quantChamadoAberto = quant_CA + 1,
             cli.quantChamadoExec = quant_CE + 1,
             cli.quantChamadoConc = quant_CC + 1
        WHERE cli.pkcliente = cod_cliente;

      UPDATE tbtipoincidente tp
        SET  tp.quantChamadoAberto = quant_CA + 1,
             tp.quantChamadoExec = quant_CE + 1,
             tp.quantChamadoConc = quant_CC + 1
        WHERE tp.pktipo = cod_tipo;
        
      UPDATE tbtecnico tec
        SET tec.quantChamadoExec = quant_CE + 1,
            tec.quantChamadoConc = quant_CC + 1
        WHERE tec.pktecnico = num_chamado;

END proregistro;



-- Massa de Dados e Criação da Tabela 

drop table tbregistro;
drop table tbchamado;
drop table tbcliente;
drop table tbtipoinsidente;
drop table tbtecnico;

create table tbcliente(
    pkcliente integer not null,
    nomecli varchar(30) not null,
    quantChamadototal integer default 0,
    quantChamadoAberto integer default 0,
    quantChamadoExec integer default 0,
    quantChamadoConc integer default 0,
primary key(pkcliente));

insert into tbcliente(pkcliente,nomecli,quantChamadototal,quantChamadoAberto,quantChamadoExec,quantChamadoConc)
values (1,'Papelaria xxx',1,0,1,0);
insert into tbcliente(pkcliente,nomecli,quantChamadototal,quantChamadoAberto,quantChamadoExec,quantChamadoConc) 
values (2,'Industria yyy',1,0,1,0);
insert into tbcliente(pkcliente,nomecli,quantChamadototal,quantChamadoAberto,quantChamadoExec,quantChamadoConc) 
values (3,'Industria kkkk',2,1,0,1);

create table tbtipoincidente(
    pktipo integer not null,
    descricao varchar(40) not null,
    quantinsidente integer default 0,
    quantChamadoAberto integer default 0,
    quantChamadoExec integer default 0,
    quantChamadoConc integer default 0,
primary key(pktipo));

insert into tbtipoincidente(pktipo,descricao,quantinsidente,quantChamadoAberto,quantChamadoExec,quantChamadoConc) 
values (54, 'Sem internet',0,0,0,0);
insert into tbtipoincidente(pktipo,descricao,quantinsidente,quantChamadoAberto,quantChamadoExec,quantChamadoConc)
values (55,'Não loga',3,0,2,1);
insert into tbtipoincidente(pktipo,descricao,quantinsidente,quantChamadoAberto,quantChamadoExec,quantChamadoConc) 
values (56, 'Não Imprime',1,1,0,0);

create table tbtecnico(
    pktecnico integer not null,
    nometecnico varchar(30) not null,
    quantChamadoExec integer default 0,
    quantChamadoConc integer default 0,
primary key(pktecnico));

insert into tbtecnico(pktecnico,nometecnico,quantChamadoExec,quantChamadoConc) values (66,'Bozo',1,0);
insert into tbtecnico(pktecnico,nometecnico,quantChamadoExec,quantChamadoConc) values (12,'Fofão',2,1);

create table tbchamado(
    pkchamado integer not null,
    dataabertura date,
    fkcliente integer,
    fktipo integer,
    status integer default 0,
    fkultimotecnico integer,
primary key(pkchamado));

alter table tbchamado add constraint tbchamdo_fkcli foreign key(fkcliente) references tbcliente(pkcliente);
alter table tbchamado add constraint tbchamdo_fktip foreign key(fktipo) references tbtipoincidente(pktipo);
alter table tbchamado add constraint tbchamdo_fktec foreign key(fkultimotecnico) references tbtecnico(pktecnico);

create table tbregistro(
    pkregistro integer not null,
    dataregistro date,
    fkchamado integer,
    fktecnico integer,
    descricao varchar(200),
primary key(pkregistro));

alter table tbregistro add constraint tbregistro_fkcha foreign key(fkchamado) references tbchamado(pkchamado);
alter table tbregistro add constraint tbregistro_fktec foreign key(fktecnico) references tbtecnico(pktecnico);

insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao) 
values (1,'01/10/2021',20,12,'não foi identrificado problema ainda');
insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao) 
values (2,'01/10/2021',20,66,'testei e nada');


insert into tbchamado(pkchamado,dataabertura,fkcliente,fktipo,status,fkultimotecnico)
values (20,'01/10/2021',2,55,1,66);
insert into tbchamado(pkchamado,dataabertura,fkcliente,fktipo,status,fkultimotecnico) 
values (21,'01/10/2021', 3,56,0, null);
insert into tbchamado(pkchamado,dataabertura,fkcliente,fktipo,status,fkultimotecnico) 
values (22,'02/10/2021',3,55,2,12);

insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao) 
values (3,'02/10/2021',22,12,'verificando impressora');

insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao) 
values (4,'02/10/2021',22,12,'estava fora da tomada');

insert into tbchamado(pkchamado,dataabertura,fkcliente,fktipo,status,fkultimotecnico) 
values (23,'02/10/2021',1,55,1,12);

insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao)
 values (5,'02/10/2021';,23,66,'não identificado o problema');

insert into tbregistro(pkregistro,dataregistro,fkchamado,fktecnico,descricao) 
values (6,'02/10/2021',23,12,'cabeamento com fuga de corrente, deve ser refeito');