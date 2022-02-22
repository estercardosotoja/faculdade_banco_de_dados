1) Mostre o SQL necessário para listar o nome do proprietário e a cidade 
que reside de todos os proprietários que estão na área “51”(número de telefone) 
em ordem de nome de proprietário.

		SELECT 		nomePro, CidadePro, fonePro
		FROM 		Tbproprietario
		WHERE 		fonePro  like ('51%')
		ORDER BY 	nomePro;	

2) Apresente o SQL que lista apenas o código de contrato “pkcodcont”, a data do  contrato “datacont” 
de todos os contratos de clientes que possuem idade superior a 21 anos 
que estejam vinculados a proprietários  que iniciem com o nome “João” ou
“Ana”, onde os contratos possuam em seus pertences “Cama Box” (descricaoPert)

		SELECT 		co.pkcodcont, co.datacont
		FROM  		tbcontrato co 
		INNER JOIN 	tbcliente cli ON cli.pkcodcli = co.fkcodcli
		INNER JOIN 	tbproprietario p ON p.pkcodpro = co.fkcodpro
		INNER JOIN  tbrelcontpert rel ON rel.fkcodcont = co.pkcodcont
		INNER JOIN  tbpertences per ON per.pkcodper = rel.fkcodcont	
		WHERE 		cli.idade > 21    
		AND		( 
				  upper(p.nomepro) like upper('João%') OR 
				  upper(p.nomepro) like upper('ANA%') 
				 )				  
		AND 	 upper(per.descricaopert) like upper('Cama Box'); 	

3) Qual SQL que lista o nome do cliente a quantidade de contratos que este cliente possui.

		SELECT  c.nomecli , count(*)
		FROM 	tbcliente cli
		INNER JOIN tbcontrato co ON cli.pkcodcli = co.fkcodcli
		WHERE tbcliente where nomecli = 'Joaozinho';

4) Escreva o SQL que altera o nome do proprietário para “Bozo” e seu fone para 
“51-98765-1234” do proprietário de código 78

		 UPDATE tbproprietario
		 SET nomepro = 'Bozo',
		  fonepro = '51-98765-1234'
		 WHERE codpro = 78;

5) Mostre uma listagem contendo o nome do proprietário (independente deste ter contrato  ou não),
 a quantidade de contratos vinculados ao proprietário 
 e a média de valor de contrato, de todos os proprietários que residem da cidade de “Porto Alegre”
	
		SELECT p.nomePro, AVG(c.valorcont), count(c.pkcodcont)
		FROM tbproprietario p 
		LEFT JOIN  tbcontrato c ON p.pkcodpro = c.fkcodpro
		WHERE upper(cidade) = upper('Porto Alegre')
		GROUP BY nomepro;
		
		
PERGUNTAR PRO PROFESSOR -> 6) Apresente o SQL que liste somente o nome de todos os pertences (“descricaoPert”) 
que possuem mais do que 20 contratos vinculados a eles

		SELECT per.descricaopert
		FROM tbpertences per 
		INNER JOIN tbrelcontpert rel ON per.pkcodpert = rel.fkcodpert
		WHERE 
		
7) Qual SQL que altera a idade de todos os clientes para mais 2 anos dos clientes
que  possuem o maior e menor código de cliente
		
		UPDATE tbcliente c
		SET c.idadecli = 3,
		WHERE MAX(c.pkcodcli) AND MIN(c.fkcodcli) ;

8) Mostre o SQL que lista em uma única listagem (uma única coluna) o nome do cliente e 
o nome de proprietário que possuem mais do que 2 contratos vinculados em seu nome
	
		SELECT 		c.nomecli FROM tbcliente c
		UNION 
	    SELECT 		p.nomepro 
		FROM 		tbproprietario p 
		INNER JOIN  tbcontrato c  ON p.pkcodpro = c.fkcodpro
		WHERE 		fkCodCont 	;
		

9) Qual SQL que apaga o(s) pertence(s) relacionado ao contrato (tbrelcontpert) que 
possui como cliente o sr. “Carlos já aprovei” .

		DELETE FROM tbrelcontpert per WHERE per.fkCodCont IN (
		   SELECT  		co.pkCodCont
           FROM    		tbcontrato co
		   INNER JOIN 	tbcliente cli ON cli.pkcodcli = co.fkcodcli
           WHERE   		upper(cli.namecli) like upper('Carlos já aprovei')
		);
    
10) Tendo como premissa que as tabelas “Tbpertences” e “tbrelcontpert” já foram criadas com suas respectivas chaves primárias, apresente o SQL que cria a constraint de chave estrangeira “fkCopPert” da tabela “tbrelcontpert”

	   ALTER TABLE tbpertences 
       ADD CONSTRAINT constfkCopPert
       FOREIGN KEY(fkCopPert) 
       REFERENCES tbrelcontpert (pkCodPert);