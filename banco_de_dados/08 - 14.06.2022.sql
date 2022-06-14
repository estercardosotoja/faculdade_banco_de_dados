/* Revisando
** Criando Trigger

- por instrução
    create or replace trigger cadona_BIUD
    before|after or update| or replace on tbteste 
    --por instrução
    declare
        x integer;
    begin 
    --cod
    END;

- por linha
    create or replace trigger cadona_BIUD
    before|after or update| or replace on tbteste 
    for each row  -- por linha
    declare
        x integer;
    begin 
    :new
    :old
    END;

** Criando sequencia 
    create sequence x90
    select x90.nexval from dual;
    select x90.corval from dual;

    :new.media=60
*/

Tendo como base a tabela que segue, crie:
 
CREATE TABLE tbaluno(
  pkcodigoalu   integer NOT NULL,
  nomealu  VARCHAR2(30),
   NAp1 number(15,2),
   NAp2 number(15,2),
   NAS number(15,2),
   NAF number(15,2),
   media number(15,2),
   situacao varchar(30),
   primary key(pkcodigoalu)
   )
 
-- uma sequence que inicie com valor 50

    create sequence codigo_x 
        start with 50

-- se estiver inserindo o pkcodigoalu deve possuir o valor no próximo elemento da sequence criada anteriormente

    insert into tbaluno(pkcodigoalu, nomealu, NAp1, NAp2, NAS, NAF, media, situacao)
    values(codigo_x.nextval, 'Aluno A', 1.0, 2.0, 4.0, 0, 1, 'Aprovado');

    /*
    - uma sequence que inicie com valor 50
    - se estiver inserindo o pkcodigoalu deve possuir o valor no próximo elemento da sequence criada anteriormente
    -Crie uma trigger que antes de inserir ou alterar um registro  realize:
    -Valores de NAp1 maiores do que 1,5  colocar 1,5
    -Valores de NAp1 menores do que 0  colocar 0
    -Valores de NAp2 maiores do que 2,5  colocar 2,5
    -Valores de NAp2 menores do que 0  colocar 0
    -Valores de NAS maiores do que 6  colocar 6
    -Valores de NAS menores do que 0  colocar 0
    -Valores de NAF maiores do que 10  colocar 10
    -Valores de NAF menores do que 0  colocar 0
    -Calcule a média (media) somando NAP1+ NAP1+ AS
    - se existir valor em NAF maior do que zero  e o valor da média for inferior a 7 o valor da média deve ser NAF
    -Se a media for maior ou igual a 7 situação recebe “Aprovado” senão “Reprovado”
    */

CREATE OR REPLACE TRIGGER MEDIA_ULBRA_BUI
    BEFORE INSERT OR UPDATE ON tbaluno
    FOR EACH ROW
    DECLARE
        MEDIA INTEGER;
    BEGIN 
        --AP1
        IF (:new.NAp1 > 1.5) THEN 
            :new.NAp1 := 1.5;
        ELSIF (:new.NAp1 < 0) THEN 
            :new.NAp1 := 0;
        ELSE
            :new.NAP1 := :new.NAP1;
        END IF;

        -- AP2
        IF (:new.NAp2 > 2.5) THEN 
            :new.NAp2 := 2.5;
        ELSIF (:new.NAp2 < 0) THEN 
            :new.NAp2 := 0;
        ELSE
          :new.NAP2 := :new.NAP2;
        END IF;

        --AS
        IF (:new.NAS > 6) THEN 
            :new.NAS := 6;
        ELSIF (:new.NAS < 0) THEN 
            :new.NAS := 0;
        ELSE
            :new.NAS := :new.NAS;
        END IF;

        --AF
        IF (:new.NAF > 10) THEN 
            :new.NAF := 10;
        ELSIF (:new.NAF < 0) THEN 
            :new.NAF := 0;
        ELSE
            :new.NAF := :new.NAF;
        END IF;

        IF (:new.NAF > 0) AND (MEDIA < 7) THEN 
            :new.media := :new.NAF;
        ELSE
            MEDIA := :new.NAP1 + :new.NAP2 + :new.NAS;
            :new.media := MEDIA;
        END IF;

        IF MEDIA >= 7 THEN 
            :new.situacao := 'Aprovado';
        ELSE 
            :new.situacao := 'Reprovado';
        END IF;
END;