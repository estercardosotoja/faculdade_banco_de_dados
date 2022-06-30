-- Com base no diagrama ER, crie uma trigger que após a inserção, alteração e ou remoção de um registro na tabela “tbcontrato” altere o atributo “numeroContratosAtivos” da tabela “tbproprietario”. O atributo numeroContratosAtivo armazena a quantidade de contratos ativos existentes do proprietário. Para ser ativo, um contrato deve conter em seu atributo "statusCont" o valor 1. Observa-se que neste cenário, poderá ocorrer: 

-- Troca de proprietário
-- Status de status
-- Remoção de contrato
-- Inclusão de novo contrato

CREATE OR REPLACE TRIGGER TBCONTRATO_BUID
AFTER UPDATE OR INSERT DELETE ON tbcontrato 
FOR EACH ROW 
DECLARE
    integer cod;
BEGIN
    if inserting then 
        cod := :new.fkcodpro

        update tbproprietario 
        set numeroContratosAtivo = numeroContratosAtivo + 1
        where pkcodpro = cod;

    end if;

    if deleting then 
        cod := :old.fkcodpro

        update tbproprietario 
        set numeroContratosAtivo = numeroContratosAtivo - 1
        where pkcodpro = cod;
    end if;

    if updating then
        if :old.fkcodpro <> :new.fkcodpro and old.statusCont = 1 then  

            update tbproprietario 
                set numeroContratosAtivo = numeroContratosAtivo - 1
            where pkcodpro = :old.fkcodpro;

            update tbproprietario 
                set numeroContratosAtivo = numeroContratosAtivo + 1
            where pkcodpro = :new.fkcodpro;

        elsif :old.statusCont <> :new.statusCont and old.statusCont = 0 then  

          update tbproprietario 
                set numeroContratosAtivo = numeroContratosAtivo + 1
            where pkcodpro = :new.fkcodpro;

        elsif :old.statusCont <> :new.statusCont and old.statusCont = 1 then  

          update tbproprietario 
                set numeroContratosAtivo = numeroContratosAtivo - 1
            where pkcodpro = :new.fkcodpro;
        end if;
    end if;
END;


-- Tendo como base o diagrama ER que segue e que  exista uma sequence “sec_loteitens” no banco de dados, crie uma trigger que ao manipular um registro em tblotesitens execute as seguintes ações:

-- x Ao adicionar um novo registro Adicionar automaticamente o “pkcoditenslote” com o valor da sequence “sec_loteitens”.

-- x Altere o campo “quantidadelote” da tabela “tblote”, ao adicionar alterar ou remover o valor informado no atributo “quantlote” da tabela “tblotesitens”.  Não esqueça que pode ocorrer alteração do campo “fkcodlote” o que implica em análise de sua parte.

-- Altere o campo “estoque” da tabela “tbproduto”, ao adicionar alterar ou remover o valor informado no atributo “quantlote” da tabela “tblotesitens”. Não esqueça que pode ocorrer alteração do campo “fkcodlote” o que implica em análise de sua parte.

CREATE SEQUENCE sec_loteitens;

CREATE OR REPLACE TRIGGER TBLOTESITENS_BIU
BEFORE INSERT OR UPDATE ON tblotesitens
DECLARE
    cod_pro integer;
    cod_lote integer; 
    BEGIN
    cod := sec_loteitens;

    if inserting then 
        update tblote 
        set quantidadelote = :new.quatlote
        where pkcodlote = :new.fkcodlote;

        select pro.pkcodprod into cod_prod from tbproduto pro 
        inner join tblotesitens lote on lote.pkcodlote = pro.fkcodlote
        where pkcodlote = :new.fkcodlote;

        update tbproduto 
        set estoque = :new.quatlote
        where pkcodlote = cod_pro;

    end if;

    if updating then 
        if :old.fkcodlote <> :new.fkcodlote then 
            if :old.quantlote <> :new.quantlote then 
                update tblote 
                set pkcodlote = :new.fkcodlote,
                    quantidadelote = :new.quantlote
                where pkcodlote = :old.fkcodlote;
            elsif
                update tblote 
                set pkcodlote = :new.fkcodlote
                where pkcodlote = :old.fkcodlote;
            end if;    
        end if;
    end if;


    if deleting then 
        update tblote 
        set quantidadelote = 0
        where fkcodprod = :old.fkcodlote;
    end if;
END;


-- Com base no diagrama ER, crie uma um procedimento que passado o código de um cliente, 
-- liste em tela uma relação contendo "nome do cliente cliente do contrato"
-- ,  a relação de contratos do cliente contendo nesta o "código do contrato", "nome do proprietário do imóvel do contrato", a Data de contrato (datacont), o valor do contrato(valorcont), o status do contrato  "Ativo" ou "inativo", e após a impressão de cada contrato, liste a relação de pertences deste contrato conforme o exemplo que segue. 
-- Exemplo: Neste caso estamos levando em consideração que foi passado o código do cliente 3 por exemplo, o procedimento derá imprimir

-- Cliente : Caroline da Silva

-- Contrato: 55  - Proprietário :Anadeu Duarte - Data:01/12/2020 - Valor R$ 1200,00 Status :ATIVO
--   Pertences : Cama BOX
--   Pertences : cozinha planejada
--   Pertences : sofá 3 lugares

-- Contrato: 88  - Proprietário :Carlos Dorneles - Data:04/10/2019 - Valor R$ 980,00 Status :INATIVO
--   Pertences : Jardim de Inverno
--   Pertences : Cama Box

-- Neste exemplo foram impressos 2 contratos da Caroline com seus devidos pertences associados. 


CREATE OR REPLACE PROCEDURE listar_contrato
    (cod_cliente IN INTEGER)
    IS
        CURSOR C1 IS SELECT cli.namecli, cont.pkcodcont, pro.nomepro, cont.dataCont, cont.valorcont, cont.satusCont FROM tbcliente cli
        INNER JOIN tbcontrato cont ON cli.pkcodcli = cont.fkcodcli
        INNER JOIN tbproprietario pro ON cont.fkcodpro = pro.pkcodpro
        WHERE pkcodcli = cod_cliente;

        CURSOR C2 IS SELECT pert.descricaopert FROM tbcliente cli
        INNER JOIN tbcontrato cont ON cli.pkcodcli = cont.fkcodcli
        INNER JOIN tbrelcontpert relpert ON cont.pkcodcont = relpert.fkcodcont
        INNER JOIN tbpertences pert ON relpert.fkcodpert = pert.pkcodpert
        WHERE cli.pkcodcli = cod_cliente;

    BEGIN 
        OPEN C1;
            LOOP 
                IF (C1%NOTFOUND) THEN 
                    DBMS_OUTPUT.PUT_LINE('Não há contratos para este cliente');
                END IF;
            
                FETCH C1 INTO nomecliente, codigocontrato, nomeproprietario, datacontrato, valorcontrato, statuscontrato;
                    DBMS_OUTPUT.PUT_LINE('Cliente:' || nomecliente );
                    DBMS_OUTPUT.PUT_LINE('Contrato:' || codigocontrato || ' - Proprietário : ' || nomeproprietario || 'Data: ' || datacontrato || ' - Valor R$ : ' || valorcontrato || ' - Status: ' || statuscontrato );
                    EXIT WHEN C1%NOTFOUND = true;

                OPEN C2;
                    LOOP
                        IF (C2%NOTFOUND) THEN 
                            DBMS_OUTPUT.PUT_LINE('Não há pertences neste contrato');
                        END IF;

                        FETCH C2 INTO descricaopertences;
                            DBMS_OUTPUT.PUT_LINE('Pertences: ' || descricaopertences );
                        EXIT WHEN C2%NOTFOUND = true;
                    END LOOP;
                CLOSE C1;

            END LOOP;

        CLOSE C1;
    END listar_contrato;