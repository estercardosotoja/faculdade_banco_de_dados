1)Mostre o SQL necessário para criar as chaves primárias e estrangeiras das 
tabelas existentes no script

 //Chaves_Primárias
       ALTER TABLE tbcategoria 
       ADD CONSTRAINT constpkcodcat 
       PRIMARY KEY(pkcodcat);

       ALTER TABLE tbmarca 
       ADD CONSTRAINT constpkcodmarc 
       PRIMARY KEY(pkcodmarc);
       
       ALTER TABLE tbproduto 
       ADD CONSTRAINT constpkcodprod 
       PRIMARY KEY(pkcodprod);
       
       ALTER TABLE tbmateriaprima 
       ADD CONSTRAINT constpkcomprod
       PRIMARY KEY(pkcodmat);
       
       ALTER TABLE tbcomproduto 
       ADD CONSTRAINT constpkcomprod
       PRIMARY KEY(pkcomprod);

 //Chaves_Foreign    
       ALTER TABLE tbproduto 
       ADD CONSTRAINT constfkcodcat
       FOREIGN KEY(fkcodcat) 
       REFERENCES tbcategoria (pkcodcat);
       
       ALTER TABLE tbmateriaprima 
       ADD CONSTRAINT constfkcodcat
       FOREIGN KEY(fkcodcat) 
       REFERENCES tbcategoria (pkcodcat);
   
       ALTER TABLE tbmateriaprima 
       ADD CONSTRAINT constfkcodmarc
       FOREIGN KEY(fkcodmarc) 
       REFERENCES tbmarca (pkcodmarc);
       
       ALTER TABLE tbcomproduto 
       ADD CONSTRAINT constfkcodmat
       FOREIGN KEY(fkcodmat) 
       REFERENCES tbmateriaprima (pkcodmat);            
     
       ALTER TABLE tbcomproduto 
       ADD CONSTRAINT constfkcodprod
       FOREIGN KEY(fkcodprod) 
       REFERENCES tbproduto (pkcodprod);                       
			
			
2) Apresente o SQL que lista o nome de todos os produtos que possuem estoque 
inferior a 20 unidade e quantidade de itens (Quantitensprod) superior a 1 
unidade em ordem de nome de produto

      SELECT    nomeprod
      FROM      tbproduto
      WHERE     estoqueprod < 20
      AND       quantitensprod > 1
      ORDER BY  nomeprod;

3) Apresente código SQL necessário para alterar o nome da matéria prima para 
‘teste’ com valor unitário de R$ 2,99 da matéria prima de código 5

      UPDATE tbmateriaprima
      SET nomemat = 'teste',
          valorunit = '2,99'
      WHERE pkcodmat = 5;

4) Apresente SQL necessário para listar o nome da matéria prima,o nome da 
categoria e o nome da marca de todas as matérias primas (todos os registros de 
matéria prima), em ordem de nome da marca e em seguida em ordem de nome da 
matéria prima que possuem estoque entre 0 e 200 unidades

      SELECT      nomemarc, nomemat, nomecat,estoquemat
      FROM        tbmateriaprima p 
      LEFT JOIN   tbmarca m 
      ON          p.fkcodmarc = m.pkcodmarc
      INNER JOIN  tbcategoria c 
      ON          p.fkcodcat = c.pkcodcat
      WHERE       estoquemat > 0 
      AND         estoquemat < 200
      ORDER BY    nomemarc, nomemat ASC;
            
5) Liste o nome do produto, o valor de venda, e o valor de venda acrescido de 
10% , e o nome da categoria de todos os produtos
      
      SELECT      p.nomeprod, p.valorvendaprod,p.valorvendaprod*1.10, c.nomecat
      FROM        tbproduto p
      RIGHT JOIN  tbcategoria c 
      ON          p.fkcodcat = c.pkcodcat;

6) Liste o nome de todas as categorias(todas) e a quantidade de matérias primas vinculadas com cada
categoria

      SELECT      p.nomeprod, p.valorvendaprod,p.valorvendaprod*1.10, c.nomecat
      FROM        tbproduto p
      INNER JOIN  tbcategoria c 
      ON          p.fkcodcat = c.pkcodcat;

7) Liste o nome de todas as categorias(todas) e a quantidade de matérias primas 
vinculadas a cada categoria, e a quantidade de produtos vinculada a cada 
matéria prima.

      SELECT  c.nomecat
            ,(SELECT COUNT(*) FROM tbmateriaprima mp WHERE mp.fkcodcat = c.pkcodcat) as quantmateria
            ,(SELECT COUNT(*) FROM tbproduto p WHERE p.fkcodcat=c.pkcodcat) AS quantproduto
      FROM      tbcategoria c;
      
8) Liste todos os dados das matérias primaS do produto que possui o maior código 
de prima

      SELECT      m.nomemat, p.nomeprod
      FROM        tbmateriaprima m
      INNER JOIN  tbcomproduto cp 
      ON          m.pkcodmat = cp.fkcodmat
      INNER JOIN  tbproduto p  
      ON          p.pkcodprod = cp.fkcodprod;
     
9) Liste o nome das marcas (sem repetir) das matérias primas, que compõe os 
produtos das categorias que possuem em seu nome o caractere ‘a’ ou o caractere ‘e’

      SELECT DISTINCT m.nomemarc FROM tbmarca m
      INNER JOIN tbmateriaprima mp ON mp.fkcodmarc = m.pkcodmarc
      INNER JOIN tbcomproduto cm ON cm.fkcodmat = mp.pkcodmat
      INNER JOIN tbproduto p ON p.pkcodprod = cm.fkcodprod
      INNER JOIN tbcategoria c ON c.pkcodcat = p.fkcodcat
      WHERE upper.(c.nomecat) like upper('%a%') OR upper.(c.nomecat) like upper('%e%');
      
10) Mostre o SQL necessário para remover 
os produtos que possuem como matérias primas,
matérias primas com estoque superior a 5 unidades.

      DELETE FROM tbproduto p WHERE p.pkcodprod IN (
           SELECT DISTINCT p.pkcodprod
           FROM        tbcomproduto cp      
           INNER JOIN  tbmateriaprima m
           ON          m.pkcodmat = cp.fkcodmat
           INNER JOIN  tbproduto p
           ON          p.pkcodprod = cp.fkcodprod
           WHERE       estoquemat >5
           );

11) Apresente o SQL que mostre como resposta uma lista contendo uma única coluna 
com a relação de nomes de produtos e nomes de matérias primas.

      SELECT nomeprod FROM tbproduto
      UNION SELECT nomemat FROM tbmateriaprima;

      --- Massa de Dados 

                create table tbcategoria(
            pkcodcat integer not null,
            nomecat varchar(40)
            );

            create table tbmarca(
            pkcodmarc integer not null,
            nomemarc varchar(40)
            );    

            create table tbproduto(
            pkcodprod integer not null,
            nomeprod varchar(40),
            estoqueprod integer,
            custoprod number(15,2),
            margemprod number(15,2),
            valorvendaprod number(15,2),
            quantitensprod number(15,2),
            fkcodcat integer
            );

            create table tbmateriaprima(
            pkcodmat integer not null,
            nomemat varchar(30),
            estoquemat integer,
            valorunit number(15,2),
            fkcodcat integer,
            fkcodmarc integer
            );      
                    
            create table tbcomproduto(
            pkcomprod integer not null,
            fkcodmat integer,
            fkcodprod integer,
            quant number(15,2)
            );
                        

            insert into tbcategoria(pkcodcat , nomecat) 
            values (1,'Doce&');

            insert into tbcategoria(pkcodcat , nomecat) 
            values (2,'bebida');

            insert into tbcategoria(pkcodcat , nomecat) 
            values (3,'padaria');

            insert into tbmarca (pkcodmarc, nomemarc) 
            values (50,'ABC');

            insert into tbmarca (pkcodmarc, nomemarc) 
            values (51,'Boa Ideia');

            insert into tbmarca (pkcodmarc, nomemarc) 
            values (52,'Marca X');

            insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit, fkcodcat, fkcodmarc )
            values (1,'agua',10,2.00,3,50);

            insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit, fkcodcat ) 
            values (2,'Chocolate',5,1.50,1);

            insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit, fkcodcat, fkcodmarc ) 
            values (3,'Leite',3,5.00,1,51 );

            insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit, fkcodcat, fkcodmarc ) 
            values (4,'Açúcar ',1,2.50,1,52 );

            insert into tbmateriaprima(pkcodmat , nomemat , estoquemat , valorunit, fkcodcat ) 
            values (5,'Baunilha',50,4.00,3 );

            insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod,fkcodcat ) 
            values (1,'Barra de chocolate',3, 8.00,50.00,12.00,2,1);

            insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod,fkcodcat ) 
            values (2,'Bolo de Baunilha',0, 16.00,10.00,17.60,3,1);

            insert into tbproduto(pkcodprod , nomeprod , estoqueprod ,custoprod , margemprod , valorvendaprod , quantitensprod,fkcodcat ) 
            values (3,'Torta de Maça',5, 8.00,70.00,13.60,2,1);


            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (1,2,1,2);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (2,3,1,1);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (3,5,2,1);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (4,3,2,2);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (5,1,2,1);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (6,1,3,2.5);

            insert into tbcomproduto(pkcomprod , fkcodmat , fkcodprod , quant) 
            values (7,2,3,2);