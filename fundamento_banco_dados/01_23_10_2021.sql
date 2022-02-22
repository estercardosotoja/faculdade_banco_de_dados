1) Crie as 3 tabelas informadas com seus devidos tipos de dados;

     //Criar Tabelas 
            CREATE TABLE TB_ANDAR(
              PkCodAnd INTEGER NOT NULL,  
              NomeAnd VARCHAR(20)NOT NULL
            );
            
            CREATE TABLE TB_APTO(
              PkCodAp INTEGER NOT NULL,  
              NomeAnd VARCHAR(30) NOT NULL,
              ValorDia  INTEGER NOT NULL,  
              FkCodAnd INTEGER NOT NULL,  
              FkCodCat INTEGER NOT NULL, 
              Camas INTEGER
            );
            
             CREATE TABLE TB_CATEGORIA(
              PkCodCat INTEGER NOT NULL,  
              NomeCad VARCHAR(20) NOT NULL
            );
            
            DESC TB_ANDAR;
            DESC TB_APTO;
            DESC TB_CATEGORIA;


2) Cries Chaves primárias e estrangeiras das tabelas acima citadas e em seguida 
polule as tabelas

      //Chaves_Primárias
            ALTER TABLE TB_ANDAR 
            ADD CONSTRAINT ConstPkCodAnd 
            PRIMARY KEY(PkCodAnd);
            
            ALTER TABLE TB_APTO 
            ADD CONSTRAINT ConstPkCodAp 
            PRIMARY KEY(PkCodAp);
            
            ALTER TABLE TB_CATEGORIA 
            ADD CONSTRAINT ConstPkCodCat 
            PRIMARY KEY(PkCodCat);
  
      //Chaves_Foreign    
            ALTER TABLE TB_APTO 
            ADD CONSTRAINT ConstFkCodAndForeign
            FOREIGN KEY(FkCodAnd)
            REFERENCES TB_ANDAR(PkCodAnd);
            
            ALTER TABLE TB_APTO 
            ADD CONSTRAINT ConstFkCodCatForeign
            FOREIGN KEY(FkCodCat) 
            REFERENCES TB_CATEGORIA (PkCodCat);
        
     //Descrições da Tabalas   
            DESC TB_ANDAR;
            DESC TB_APTO;
            DESC TB_CATEGORIA;
            
            
     SELECT * FROM TB_ANDAR;
      // INSERIR DADOS NA TABELA TB_ANDAR
          INSERT INTO  TB_ANDAR (PkCodAnd, NomeAnd)
          VALUES (1, 'Primeiro');
          
          INSERT INTO  TB_ANDAR (PkCodAnd, NomeAnd)
          VALUES (2 , 'Segundo');
          
          INSERT INTO  TB_ANDAR (PkCodAnd, NomeAnd)
          VALUES (3 ,'Terceiro');
        
 SELECT * FROM TB_CATEGORIA;
      // INSERIR DADOS NA TABELA TB_APTO
         INSERT INTO  TB_CATEGORIA (PkCodCat, NomeCad)
         VALUES (1, 'Standard');
        
         INSERT INTO  TB_CATEGORIA (PkCodCat, NomeCad)
         VALUES (2, 'luxo');
        
         INSERT INTO  TB_CATEGORIA (PkCodCat, NomeCad)
         VALUES (3, 'presidencial');

      SELECT PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat 
      FROM TB_APTO 
      ORDER BY PKCODAP;
      // INSERIR DADOS NA TABELA TB_APTO
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (1, 'Ap101', 210.40, 3, 1, 1);
          
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (2, 'Ap301', 10.44, 1, 3, 1);
          
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (3, 'Ap201', 182.34, 2, 2, 1);

         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (5, 'Ap102', 12.45, 2, 1, 2);

         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (6, 'Ap202', 190.33, 2, 2, 1);

         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (7, 'Ap103', 44.30, 1, 1, 2);
          
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (8, 'Ap302', 210.40, 1, 3, 2);
          
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (9, 'Ap104', 210.40, 1, 1, 3);
          
         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia, Camas, FkCodAnd, FkCodCat)
         VALUES (10, 'Ap203', 44.30, 4, 2, 3);

         INSERT INTO  TB_APTO (PkCodAp, NomeAnd, ValorDia,  Camas, FkCodAnd, FkCodCat)
         VALUES (11, 'Ap105', 75.30, 1, 1, 1);
        
3) Liste o nome do apartamento, o numero de camas de todos os apartamentos
 
         SELECT     NOMEAND, CAMAS 
         FROM       TB_APTO;
    
4) Liste o nome do apartamento, o numero de camas de todos os apartamentos em 
de numero de camas e em seguida em ordem de valor de diária

        SELECT      NOMEAND, CAMAS, VALORDIA 
        FROM        TB_APTO 
        ORDER BY    VALORDIA;

5) Liste o código, nome e valor de diária de todos os Aptos do Andar de código 3 
em ordem de valor de diária
    
        SELECT      PKCODAP, NOMEAND, VALORDIA
        FROM        TB_APTO 
        WHERE       FKCODAND = 3 
        ORDER BY    VALORDIA;

6) Liste o maior valor de diária dos Aptos gravados na tabela de aptos.A

    //MAIOR DIARIA 
        SELECT MAX(X.VALORDIA) 
        FROM  TB_APTO X;

8) Liste a média de valor de diária, o menor valor de diária e a soma do total 
de camas dos aptos.

    // MÉDIA 
        SELECT AVG(X.VALORDIA) 
        FROM TB_APTO X;
       
    // MENOR DIARIA 
       SELECT MIN(X.VALORDIA) 
       FROM TB_APTO X;
      
    // SOMA DAS CAMAS
       SELECT SUM(X.CAMAS) 
       FROM TB_APTO X;

9) Liste o código, nome, camas, diária e a divisão de valor de diárias pelo 
número de camas, de todos os Aptos da categoria 1 ou 4

      SELECT      PKCODAP, NOMEAND, CAMAS, VALORDIA/CAMAS
      FROM        TB_APTO 
      WHERE       FKCODCAT > 1 AND FKCODCAT < 4;

10) Construa uma lista simulando mais 10% o valor de diária, juntamente com o 
código e nome do apto;

      SELECT      VALORDIA*1.10, PKCODAP, NOMEAND  
      FROM        TB_APTO X; 

11) Liste todos os Aptos que iniciam com “a” ou “b”;

      SELECT      * 
      FROM        TB_APTO X 
      WHERE       X.NOMEAND 
      LIKE        ('A%');
      
      SELECT      * 
      FROM        TB_APTO X 
      WHERE       X.NOMEAND 
      LIKE        ('B%');
    
12) Liste todos os Aptos que possuam “ar” em seu nome e valor de diária superior 
a 354.32

      SELECT      * 
      FROM        TB_APTO X 
      WHERE       X.NOMEAND  
      LIKE        ('%ar%') 
      AND         X.VALORDIA > 354.32; 
 
13) Liste todos os Aptos que possuam o número de camas entre 2 e 5(inclusive) 
em ordem de número de camas, e em seguida em ordem de valor de diária

      SELECT      *
      FROM        TB_APTO X
      WHERE       CAMAS >= 2 AND CAMAS < 5
      ORDER BY    CAMAS, VALORDIA; 

14) Liste o código do andar (fkcodant) da tabela tbapto onde a soma total do 
valor da diária dos aptos deste andar sejam superiores a 300
    ----------------------------- PEDIR AJUDA DO PROFESSOR ------------
      SELECT      *
      FROM        TB_APTO X
      HAVING      X.VALORDIA>300
      WHERE       X.FKCODCAT;
 ----------------------------------------------------------------------------
15) Liste todos os dados dos Aptos que possuem código menor ou igual a 3 em 
ordem de nome

      SELECT      * 
      FROM        TB_APTO
      WHERE       FKCODCAT <=3
      ORDER BY    NOMEAND;
      
16) Liste o maior, menor e a média de valores dos apartamentos que possuem 
códigos entre 1 e 7
    
    // MAIOR       
      SELECT MAX(X.VALORDIA) 
      FROM TB_APTO X
      WHERE PKCODAP > 1  AND PKCODAP < 7;
      
    // MENOR       
      SELECT MIN(X.VALORDIA) 
      FROM TB_APTO X
      WHERE PKCODAP > 1  AND PKCODAP < 7;    

    // MÉDIA 
      SELECT AVG(X.VALORDIA) 
      FROM TB_APTO X
      WHERE PKCODAP > 1  AND PKCODAP < 7;
       
17) Liste o código, nome, camas e valor de diária, de todos os Aptos cujo código 
esteja entre 3 e 7 com número de camas entre 1 e 5 ou código maior do que 3 da 
categoria 3
      
      SELECT    PKCODAP, NOMEAND,CAMAS, VALORDIA
      FROM      TB_APTO 
      WHERE     PKCODAP > 3  AND PKCODAP < 7
      AND       CAMAS > 1    AND CAMAS < 5 
      OR        FKCODCAT >= 3;