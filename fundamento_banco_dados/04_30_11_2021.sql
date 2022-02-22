1) Mostre o SQL que liste o nome do cliente, a data de partida de sua passagem, 
o número do assento de sua passagem e o destino de sua passagem, de todos os 
clientes que possuem como destino o estado do ‘RS’ ou ‘SC’ cujo valor de
passagem seja superior a R$ 38,87

	SELECT 		c.nomeCli , p.dataPartidaPas, p.numAssentoPas, d.nomeDest
	FROM		tbCliente c 
	INNER JOIN 	tbPassagem p ON c.pkCodCli = p.fkCodcli		
	INNER JOIN 	tbDestino d ON d.pkCodDes = p.fkCodDest
	WHERE 		d.estado == "RS" OR "SC"
	AND 		p.valor > 38.87
	
	--- CORREÇÃO  DO PROFESSOR  ---
	
	SELECT 		c.nomeCli , p.dataPartidaPas, p.numAssentoPas, d.nomeDest
	FROM		tbCliente c 
	INNER JOIN 	tbPassagem p ON c.pkCodCli = p.fkCodcli		
	INNER JOIN 	tbDestino d ON d.pkCodDes = p.fkCodDest
	WHERE 		(UPPER(d.estado) = "RS" OR UPPER(d.estado) = "SC")
	AND 		p.valor > 38.87
	

2) Apresente o SQL que lista o nome da marca e quantidade de ônibus que possuem 
a respectiva marca, tendo ou não ônibus vinculado.

	SELECT 		m.nomeMarca, count(*)
	FROM		tbOnibus o
	RIGHT JOIN 	tbMarca m ON o.pkCodOnibus = m.fkCodMarca
	GROUP BY 	m.nomeMarca;
		
	--- Tendo ou não onibus vinculado irá mostrar a marca igual ---
	
	SELECT 		m.nomeMarca, count(*)
	FROM		tbMarca m
	LEFT JOIN 	tbOnibus o ON o.pkCodOnibus = m.fkCodMarca
	GROUP BY 	m.nomeMarca;
	
	SELECT 		m.nomeMarca, count(o.fkCodMarca)
	FROM		tbMarca m
	LEFT JOIN 	tbOnibus o ON o.pkCodOnibus = m.fkCodMarca
	GROUP BY 	m.nomeMarca;
	

3) Qual SQL que lista em tela o nome do destino, a quantidade de passagens vendidas 
para este destino cujas passagenssão de ônibus com ano de fabricação superior a 2018 
e sua marca (do ônibus) contenha o termo “SUL” em seu nome, e que as passagens sejam 
vendidas para clientes do estado de “SP”. Liste somente destinos que tiveram mais do 
que 5 passagens vendidas.

	SELECT 		de.nomedest,COUNT(*) FROM tbdestino de
	INNER JOIN 	tbpassagem pas ON pas.fkcoddest = de.pkcoddest
	INNER JOIN 	tbonibus oni ON oni.pkcodonibus = pas.fkcodonibus
	INNER JOIN 	tbmarca mar ON mar.pkcodmarca = oni.fkcodmarca
	INNER JOIN 	tbcliente cli ON cli.pkcodcli = pas.fkcodcli
	WHERE 		oni.anofabricacaoonibus > 2018
	AND 		UPPER(mar.nomemarca) LIKE UPPER('%SUL%')
	AND 		UPPER(cli.estadocli) = UPPER('SP')
	HAVING 		COUNT(*) > 5
	GROUP 		BY de.nomedest
	
	--- ou ---
	
	SELECT 		de.nomedest,COUNT(pas.pkcodPas) FROM tbdestino de
	INNER JOIN 	tbpassagem pas ON pas.fkcoddest = de.pkcoddest
	INNER JOIN 	tbonibus oni ON oni.pkcodonibus = pas.fkcodonibus
	INNER JOIN 	tbmarca mar ON mar.pkcodmarca = oni.fkcodmarca
	INNER JOIN 	tbcliente cli ON cli.pkcodcli = pas.fkcodcli
	WHERE 		oni.anofabricacaoonibus > 2018
	AND 		UPPER(mar.nomemarca) LIKE UPPER('%SUL%')
	AND 		UPPER(cli.estadocli) = UPPER('SP')
	HAVING 		COUNT(*) > 5
	GROUP 		BY de.nomedest
	
	
4) Mostre o SQL que altera o nome do destino para “Grande Várzea” e o estado para “RS” 
o destino de código 78

	UPDATE tbDestino SET
		nomeDest = "Grande Várzea"
		estadoDest = "RS"
		WHERE pkcodDest = 78
		
5) Demonstre o SQL que apaga todas as passagens com valor superior a R$ 50,22 que 
possuam como destino o estado “SC”

	DELETE FROM tbpassagem p WHERE p.pkCodPas IN (
		SELECT 		p.pkCodPas
		FROM 		tbpassagem p 
		INNER JOIN 	tbDestino d ON p.fkCodPas = d.pkCodDest
		WHERE		p.valorPas > 50.22
		AND 	 	d.estadoDest = "SC"
	);
	
	---- Correção do professor 
	
	DELETE FROM tbpassagem p 
	WHERE p.valorPas > 50.22
	AND p.fkCodPas IN (
		SELECT 	 	d.pkCodDest
		FROM 		tbDestino d 
		WHERE 	  	UPPER(d.estadoDest) = "SC"
	);

6) Apresente o SQL que lista em uma única listagem (uma única coluna) o nome da marca 
de todos os ônibus que iniciam com a letra “A”, o nome dos clientes que possuem em seu 
mail “@gmail” e o nome de todos os destinos do estado “PR”. 

		SELECT 		m.nomeMarca 
		FROM 		tbMarca m 
		WHERE 		UPPER(nomeMarca) like UPPER("A%")
	UNION 
		SELECT 		c.nomeCli 
		FROM 		tbCliente c 
		WHERE 		emailCli like ("%@gmail%")
	UNION 
		SELECT 		d.nomeDest 
		FROM 		tbDestino d 
		WHERE 		estados = "PR";

7) Mostre o SQL eu liste todos os dados dos clientes que compraram a passagem com maior 
valor de passagem cadastrada

	SELECT 		* 
	FROM 		tbCliente c
	INNER JOIN  tbPassagem p ON p.pkCodCli = c.fkCodCli
	WHERE 		MAX(valorPas);
	
	---- Resposta professor 
	
	--1)
	SELECT 		* 
	FROM 		tbCliente c
	INNER JOIN  tbPassagem p ON p.pkCodCli = c.fkCodCli
	WHERE 		p.valorPas IN (SELECT MAX(p.valorPas
								FROM tbpassagem p);
	--2)
	SELECT 		* 
	FROM 		tbCliente c
	WHERE 		c.pkCodCli 
		IN (SELECT p.fkCodCli FROM 	tbPassagem p WHERE	p.valorPas  
		IN (SELECT MAX(p.valorPas FROM tbpassagem p
		
	);
	

8) Tendo como base que já exista as tabelas tbPassagem e tbCliente e que em ambas as 
chaves primárias já estejam definidas, mostre o SQL que cria a restrição de integridade 
referencial (constraint) de chave estrangeira no atributo “fkCodCli”

	ALTER TABLE tbPassagem 
    ADD CONSTRAINT constfkCodCli
    FOREIGN KEY (fkCodCli) 
    REFERENCES tbCliente (pkCodcli);

9) Apresente o SQL que apaga todas as marcas de ônibus que estiveram relacionadas a 
passagens com a data de partida 09/07/2021.

	DELETE FROM tbMarca m 
	WHERE m.pkcodmarca IN (
		SELECT 		m.pkCodMarca 
		FROM 		tbMarca m
		INNER JOIN 	tbOnibus o ON m.pkCodMarca = o.fkCodMarca
		INNER JOIN 	tbPassagem p ON o.pkCodOnibus= p.fkCodOnibus
		WHERE 		p.dataPartidaPas = "09/07/2021"
	);


REVER A QUESTÃO COM NA CORREÇÃO!!! 
10) Qual SQL que lista o nome do cliente, seu estado, a quantidade de passagens por ele 
comprada, o somatório de valor gasto por ele em passagens de todos os clientes que viajaram 
entre os dias 15/03/2021 e 25/06/2021.Ordene em ordem de estado do cliente, e em seguida 
em ordem de nome do cliente.

	SELECT c.nomeCli, c.estadoCli, count(*), SUM( p.pkCodPas)
	FROM tbCliente c
	INNER JOIN tbpassagem p ON p.fkCodCli = c.pkCodCli
	WHERE p.dataPartidaPas > '15/03/2021' 
	AND p.dataPartidaPas < '25/06/2021'
	GROUP BY c.nomeCli,c.estadoCli
	ORDER BY c.estadoCli,c.nomeCli
	);
	
	
	
	
	