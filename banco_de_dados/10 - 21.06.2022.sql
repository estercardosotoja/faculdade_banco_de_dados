-- Imprimir os dados da tabela

CREATE OR REPLACE PROCEDURE DADOS_TBPRODUTO
AS
 wcodigo tbproduto.pkcodprod%type;
 wnome tbproduto.nomeprod%type;
 westoque tbproduto.estoqueprod%type;
 wcusto tbproduto.custoprod%type;
 wmargem tbproduto.margemprod%type;
 wvalor tbproduto.valorvenda%type;
 wquant tbproduto.quantitensprod%type;

    CURSOR C1 IS SELECT pkcodprod, nomeprod, estoqueprod, custoprod, margemprod, valorvenda, quantitensprod FROM tbproduto order by pkcodprod;
 
    BEGIN

    ---- CONTINUAR 
 OPEN C1; --Abrindo o cursor
 loop --instrução de início do loop
 if (C1%FOUND) then
 dbms_output.put_line(&#39;Existe registros no cursor&#39; );
 else
 dbms_output.put_line(&#39;Não existe ninguém no cursor&#39; );
 end if;
 dbms_output.put_line(&#39;========================================&#39; );
 FETCH C1 INTO wcodigo, wnome;
 dbms_output.put_line(&#39;Código: &#39; || wcodigo);
 dbms_output.put_line(&#39;Nome: &#39; || wnome);
 dbms_output.put_line(&#39;Estou &quot;varrendo&quot; a linha &#39; || C1% ROWCOUNT);
 exit when C1%NOTFOUND=true; --condição de saída do laço loop
 end loop;
 CLOSE C1;
 if (C1%ISOPEN) then
 dbms_output.put_line(&#39;O cursor está aberto!&#39;);
 else
 dbms_output.put_line(&#39;O cursor foi fechado com sucesso!&#39;);
 end if;
 end ;