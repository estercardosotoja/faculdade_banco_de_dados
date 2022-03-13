0) Crie as tabelas acima relacionadas juntamente com suas chaves primárias e estrangeiras
        
        SELECT * FROM USER_CONSTRAINTS;
        
        CREATE TABLE TbGenero (
            PkcodGen INTEGER NOT NULL,  
            NomeGen VARCHAR(20) NOT NULL,
            PRIMARY KEY(PkcodGen)
        );
                    
        CREATE TABLE Tbfilme( 
            PkCodfilme INTEGER NOT NULL,  
            Titulo VARCHAR(30)NOT NULL,
            FkCodGen INTEGER NOT NULL,  
            FkCodClass INTEGER NOT NULL,  
            PRIMARY KEY(PkCodfilme)
        );
        
        CREATE TABLE Tbclassificacao (
            PkCodclass INTEGER NOT NULL,  
            NomeClass  VARCHAR(20)NOT NULL, 
            ValorDiaria NUMBER(10,2),  
            PRIMARY KEY(PkCodclass)
        );
        
        CREATE TABLE TbRelFilmeLoc(
            PkCodRel INTEGER NOT NULL,  
            FkCodFilme INTEGER NOT NULL,  
            FkCodLoc INTEGER NOT NULL,
            PRIMARY KEY(PkCodRel)
        );
        
        CREATE TABLE TbLocacao(
            PkCodLoc INTEGER NOT NULL,  
            DataLoc DATE NOT NULL, 
            FkCodCli INTEGER NOT NULL
        );
        
        CREATE TABLE TbCliente (
            PkCodCli INTEGER NOT NULL,  
            NomeCli VARCHAR(30)NOT NULL,
            EndCli VARCHAR(30)NOT NULL,
            CidadeCli VARCHAR(30)NOT NULL,
            UfCli VARCHAR(2)NOT NULL,
            PRIMARY KEY(PkCodCli)
        );
        
            ALTER TABLE Tbfilme  
            ADD CONSTRAINT ConstFkCodGen
            FOREIGN KEY(FkCodGen)
            REFERENCES TbGenero(PkcodGen);
        
            ALTER TABLE Tbfilme  
            ADD CONSTRAINT ConstFkCodClass
            FOREIGN KEY(FkCodClass)
            REFERENCES Tbclassificacao(PkCodclass);
        
            ALTER TABLE TbRelFilmeLoc  
            ADD CONSTRAINT ConstFkCodFilme
            FOREIGN KEY(FkCodFilme )
            REFERENCES Tbfilme(PkCodfilme);
        
            ALTER TABLE TbRelFilmeLoc  
            ADD CONSTRAINT ConstFkCodLoc
            FOREIGN KEY(FkCodLoc)
            REFERENCES TbLocacao(PkCodLoc);
        
            ALTER TABLE TbLocacao  
            ADD CONSTRAINT ConstFkCodCli 
            FOREIGN KEY(FkCodCli )
            REFERENCES TbCliente(PkCodCli );
                    
1) Tendo como base que as tabelas já existam crie o código SQL necessário para inserir a
classificação de nome “Novo” de código “5” e valor R$ “12,23” na tabela classificação

            INSERT INTO  Tbclassificacao(PkCodclass, NomeClass , ValorDiaria)
            VALUES (5, 'Novo', 12.23);
 
            SELECT * FROM TBCLASSIFICACAO;
            
2) Descreva o código SQL necessário para alterar o nome da classificação para “Bem Novo”, e o
valor da diária para R$ 13,41 da classificação de código 5.

            UPDATE Tbclassificacao c
                 SET c.NomeClass = 'Bem Novo',
                     c.ValorDiaria = 13.41
                 WHERE PkCodClass = 5;

            SELECT * FROM TBCLASSIFICACAO;
            
3) Descreva o código SQL necessário para alterar valor da diária de todas os filmes para mais 18%
de todas as classificações que iniciem com a letra palavra “A” ou com a letra “D”.

            UPDATE Tbclassificacao c
                SET c.VALORDIARIA = c.VALORDIARIA*1.18
                WHERE upper(c.nomeClass) like upper('A%') or upper(c.nomeClass) like upper('D%');

            SELECT * FROM TBCLASSIFICACAO;

4) Descreva o código SQL necessário para apagar todos os registros da tabela de cliente que
possuam o estado do “RJ” ou “SC” , cujos códigos de clientes estejam no intervalo entre 9 e 12.
 
            DELETE TBCLIENTE 
            WHERE (UfCli = 'SP' OR UfCli = 'SC') 
            AND (PkCodCli > 1 AND PkCodCli < 4);
            
            SELECT * FROM TBCLIENTE;

5) Mostre o SQL necessário para listar em tela o nome do filme, o seu gênero, sua classificação e
o valor de sua diária em ordem de gênero e em seguida de nome do filme.

            SELECT f.Titulo as Filmes, g.nomeGen as Genero , c.NomeClass as Classificacao , c.ValorDiaria as ValorDiaria
            FROM TbFilme f 
            INNER JOIN TbGenero g ON f.FkCodGen = g.PkcodGen 
            INNER JOIN TbClassificacao c ON f.FkCodClass = c.PkCodClass 
            ORDER BY g.nomeGen, f.Titulo;

6) Mostre o SQL necessário para listar em tela o nome do filme, o seu gênero, sua classificação e
o valor de sua diária em ordem de gênero e em seguida de nome do filme de todos os filmes que
iniciam com o caractere “O”, e o nome do gênero termine com o Caractere “A”, cujo valor da diária
esteja no intervalo entre R$ 1,00 e R$ 8,00

            SELECT          f.Titulo as Filmes, g.nomeGen as Genero , 
                            c.NomeClass as Classificacao , 
                            c.ValorDiaria as ValorDiaria
            FROM            TbFilme f 
            INNER JOIN      TbGenero g ON f.FkCodGen = g.PkcodGen 
            INNER JOIN      TbClassificacao c ON f.FkCodClass = c.PkCodClass 
            WHERE           (c.ValorDiaria > 1 AND c.ValorDiaria < 8)
            AND             (upper(f.Titulo) LIKE upper('O%') OR upper(f.Titulo) LIKE upper('%A'))
            ORDER BY        g.nomeGen, f.Titulo;
            
7)Apresente o código SQL necessário para listar os gêneros de filmes locados pelo cliente
“Fernando Henrique Cardoso”.
            
            SELECT        g.NomeGen
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            INNER JOIN    TbGenero  g ON g.PkCodGen = f.FkCodGen
            WHERE         NOMECLI = 'Fernando Henrique Cardoso';

8) Tendo como base que os códigos de locação são dados em ordem crescente, conforme são
cadastrados, Mostre o SQL necessário para listar o(s) nome(s) e o gênero do(s) filme(s) locado(s)
na última locação do cliente “Itamar Franco”.

--> Necessário correção, correção professor 

            SELECT        g.NomeGen
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            INNER JOIN    TbGenero  g ON g.PkCodGen = f.FkCodGen
            WHERE         NOMECLI = 'Luis' 
            AND           MAX(l.PkCodLoc);         

9) Mostre o Total de Diária a ser paga na locação de código 14.

            SELECT        SUM(c.ValorDiaria) as Soma
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbClassificacao c ON f.FkCodClass = c.PkCodClass
            WHERE         l.Pkcodloc = 14;

10) Mostre o Nome dos clientes, a quantidade de filmes por eles já realizadas e a soma de todas
as diárias por eles realizadas, de todos os clientes do “RS” que locaram mais do que 4 vezes.

--> Necessário correção, correção professor 

            SELECT        c.NomeCli, count(f.PkCodFilme)as Quant_Filmes, SUM(cl.ValorDiaria) as Soma_Diarias
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli  
            INNER JOIN    TbClassificacao cl ON f.FkCodClass = cl.PkCodClass
            WHERE         c.UFCli = 'BH' 
            --AND count(f.PkCodFilme) > 2
            GROUP BY      c.NomeCli;

            SELECT * FROM  TbCliente;

11) Descreva o código SQL que listaria o código, título, nome do gênero , classificação e valor da
diária de todos os filmes, em ordem de gênero e em seguida de título

            SELECT        f.PkCodFilme, f.Titulo, g.NomeGen, cl.NomeClass, cl.ValorDiaria
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            INNER JOIN    TbGenero  g ON g.PkCodGen = f.FkCodGen
            INNER JOIN    TbClassificacao cl ON f.FkCodClass = cl.PkCodClass
            ORDER BY      g.NomeGen,f.Titulo;     
            
12) Descreva o código SQL que listaria o título de todos os filmes locados na locação de código 3

            SELECT        r.PkCodRel,f.Titulo
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc 
            WHERE         l.PkCodLoc = 3;

13) Descreva o código SQL que retorna o nome da classificação e quantidade de filmes
associados a esta classificação.

            SELECT        cl.nomeClass, count(f.FkCodClass)
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbClassificacao cl ON f.FkCodClass = cl.PkCodClass
            GROUP BY     cl.nomeClass; 

14) Descreva o código SQL que listaria o título e a quantidade de vezes que o filme foi locado de
todos os filmes de gênero “Aventura”.
 
            SELECT        f.Titulo, count(l.PkcodLoc) AS Quant 
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbGenero  g ON f.FkCodGen = g.PkCodGen
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbClassificacao cl ON f.FkCodClass = cl.PkCodClass
            WHERE        g.NomeGen = 'Aventura' 
            GROUP BY     Titulo;

15) Descreva o código SQL que listaria o nome do filme e da data de locação de todos os filmes
locados pelo cliente “Jose Sarney” entre “01/03/2011” e “30/11/2011”

            SELECT        f.Titulo, l.DataLoc
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            WHERE         c.NomeCli = 'Jose Sarney'
            AND           DataLoc > '01/03/2011' and  DataLoc < '30/11/2011';
            
16) Descreva o código SQL que listaria o nome do gênero e a quantidade de filmes locados para
os clientes do “RS” ou “SC”

            SELECT        g.NomeGen, COUNT(distinct l.PkCodLoc)
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbFilme   f ON r.FkCodFilme = f.Pkcodfilme
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            INNER JOIN    TbGenero  g ON g.PkCodGen = f.FkCodGen
            WHERE         c.UFCli = 'RS' OR c.UFCli = 'SC'
            group by      g.NomeGen;

17) Descreva o código SQL que listaria o nome do cliente a data da primeira locação e da data da
ultima locação de todos os clientes de “Porto Alegre” ou “Sapucaia”
            
            SELECT        c.NomeCli, Min(l.dataLoc), Max(l.dataLoc)
            FROM          TbRelFilmeLoc r
            INNER JOIN    TbLocacao l ON r.FkCodFilme = l.PkcodLoc
            INNER JOIN    TbCliente c ON l.FkcodCli = c.PkcodCli
            WHERE         c.CidadeCli = 'Porto Alegre' OR  c.CidadeCli = 'Sapucaia'
            group by      c.NomeCli;


-- DADOS PARA O BANCO DE DADOS;
INSERT INTO  TbGenero(PkcodGen, NomeGen) VALUES (1, 'Suspense');
INSERT INTO  TbGenero(PkcodGen, NomeGen) VALUES (2, 'TERROR');
INSERT INTO  TbGenero(PkcodGen, NomeGen) VALUES (3, 'Romance');
INSERT INTO  TbGenero(PkcodGen, NomeGen) VALUES (4, 'Aventura');

INSERT INTO  Tbfilme(PkCodfilme, Titulo , FkCodGen, FkCodClass) VALUES (1, 'ABC', 1, 2);
INSERT INTO  Tbfilme(PkCodfilme, Titulo , FkCodGen, FkCodClass) VALUES (2, 'CDE', 2, 2);
INSERT INTO  Tbfilme(PkCodfilme, Titulo , FkCodGen, FkCodClass) VALUES (3, 'VFR', 3, 1);
INSERT INTO  Tbfilme(PkCodfilme, Titulo , FkCodGen, FkCodClass) VALUES (4, 'ERT', 1, 3);
INSERT INTO  Tbfilme(PkCodfilme, Titulo , FkCodGen, FkCodClass) VALUES (5, 'ORA', 1, 3);

INSERT INTO  Tbclassificacao(PkCodclass, NomeClass , ValorDiaria) VALUES (1, 'usado', 14.00);
INSERT INTO  Tbclassificacao(PkCodclass, NomeClass , ValorDiaria) VALUES (2, 'estragado', 7.00);
INSERT INTO  Tbclassificacao(PkCodclass, NomeClass , ValorDiaria) VALUES (4, 'estragado', 10.00);
INSERT INTO  Tbclassificacao(PkCodclass, NomeClass , ValorDiaria) VALUES (5, 'perdido', 10.00);

INSERT INTO  TbLocacao(PkCodLoc, DataLoc , FkCodCli) VALUES (1, '12-03-2022', 2);
INSERT INTO  TbLocacao(PkCodLoc, DataLoc , FkCodCli) VALUES (2, '12-03-2022', 3);
INSERT INTO  TbLocacao(PkCodLoc, DataLoc , FkCodCli) VALUES (3, '12-03-2022', 4);
INSERT INTO  TbLocacao(PkCodLoc, DataLoc , FkCodCli) VALUES (4, '12-03-2022', 1);
INSERT INTO  TbLocacao(PkCodLoc, DataLoc,  FkCodCli) VALUES (5, '13-03-2022', 3);
INSERT INTO  TbLocacao(PkCodLoc, DataLoc,  FkCodCli) VALUES (5, '14-03-2022', 5);

iNSERT INTO  TbRelFilmeLoc( PkCodRel, FkCodFilme, FkCodLoc) VALUES ( 1, 2, 3);
iNSERT INTO  TbRelFilmeLoc( PkCodRel, FkCodFilme, FkCodLoc) VALUES ( 3, 3, 2);
iNSERT INTO  TbRelFilmeLoc( PkCodRel, FkCodFilme, FkCodLoc) VALUES ( 2, 1, 3);
iNSERT INTO  TbRelFilmeLoc( PkCodRel, FkCodFilme, FkCodLoc) VALUES ( 3, 2, 1);
iNSERT INTO  TbRelFilmeLoc( PkCodRel, FkCodFilme, FkCodLoc) VALUES ( 5, 5, 5);

INSERT INTO  TbCliente(PkCodCli, NomeCli, EndCli, CidadeCli, UfCli) VALUES (1, 'Ronaldo', 'Rua dos Bobos n0', 'Perdidos', 'DF');
INSERT INTO  TbCliente(PkCodCli, NomeCli, EndCli, CidadeCli, UfCli) VALUES (2, 'Arnaldo', 'Otarios dos Bobos n3', 'Encontrados', 'SP');
INSERT INTO  TbCliente(PkCodCli, NomeCli, EndCli, CidadeCli, UfCli) VALUES (3, 'Luis', 'Almirinda dos Bobos n5', 'Escondidos', 'BH');
INSERT INTO  TbCliente(PkCodCli, NomeCli, EndCli, CidadeCli, UfCli) VALUES (4, 'Snow', 'Joaquiim dos Bobos n07', 'Achado', 'AM');
INSERT INTO  TbCliente(PkCodCli, NomeCli, EndCli, CidadeCli, UfCli) VALUES (5, 'Fernando Henrique Cardoso', 'Rua dos Ricos', 'Brasilia', 'DF');


SELECT * FROM TBCLIENTE;
SELECT * FROM TBGENERO;
SELECT * FROM TBCLASSIFICACAO;
SELECT * FROM TBFILME;
SELECT * FROM TBLOCACAO;
SELECT * FROM TBRELFILMELOC;







