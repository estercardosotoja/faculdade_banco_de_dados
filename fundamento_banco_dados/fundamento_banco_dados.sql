Aula 11 -  Modelo Fisico SQL

    Tipo de Dados 
        Inteiro = integer 
            ex:. x integer 

        Float = number(numero_dados) = Escala e Precisão
            ex:. number(10,2) = 1234567890,12 
            #PRECISO DETERMINAR QUANTAS CASAS DEPOIS DA VÍRGULA
        
        Date = 
        21/05/2021 oracle utiliza como foi configurado COMO SERA USADO
        ‘2021-05-21’ mysql

        Varchar = 
            varchar(10) - mais rápido mais consome mais espaço
            varchar2() - utiliza melhor o espaço porém perde tempo em caso de alteração constantes no campo.
    
        Ana da Sil = vai salvar nos 10 bits
        Ana  = vai salvar somente o que tiver ocupado
        ex:. nome varchar(10) 
        ex:. nome varchar2 (10) 

    Criar uma tabela 
        create table NOME_TABELA{
            ATRIBUTO TIPO_DO_ATRIBUTO DEFINICAO,
            ATRIBUTO TIPO_DO_ATRIBUTO DEFINICAO,
            ATRIBUTO TIPO_DO_ATRIBUTO DEFINICAO
        }

        Atributo: nome da variável do campo
        Tipo de Atributo:  Tipo de Dado
        Definições: not null = não pode ficar vazio;

        ex:.
        create table TB_ANIMAL(
            pkcodigoaninal integer not null, 
            nomeanimal varchar(20) not null,
            datanascimentoanimal date,
        );
    Alterar dados da Tabela  
        
        Adicionando Coluna:
        alter table <nometabela> add <nome_coluna> <tipodado>

        Alterando nome Coluna:
        alter table <nometabela>  rename <nomecoluna> to <newnamecoluna>

        Alterando tamanho do dado na Coluna:
        alter table <nometabela>  in<nome_coluna> <tipo_de_dado>
        obs: Sempre posso aumentar o tamanho dos dados mais nunca diminuir

    Excluindo Dado da Tabela  
        alter table <nometabela> drop column <nome_coluna>

    Chave Primária
        Depois de criada a tabela :
        alter table <nometabela> add constraint  <nome_da_constraint> primary key <atributo>

    Criando tabela com Chave Primária:
        create table TB_ANIMAL{
            pkcodigoaninal integer not null,  
            nomeanimal varchar(20) not null,
            datanascimentoanimal date,
            constraint tbanimal_pk primary key(pkcodigoaninal)
        }

        ou posso adicionar sem colocar nome na constraint

    create table TB_ANIMAL{
        pkcodigoaninal integer not null,  primary key 
        nomeanimal varchar(20) not null,
        datanascimentoanimal date
    }

    Chave Estrangeira 
        alter table <nome_da_tabela> add constraint <nome_da_constraint>
        foreign key (atributo) references <nome_da_tabela_referenciada>
        (<atributo_chave_primaria>);

        alter table tbfuncionario add constraint	
        key(fk<nome_campo>) references tbdepartamento(pk<nome_campo>)
        
    Ver dados da Tabela
        desc <nome_tabela>;


Aula 12 - 26/10/2021 - Inserindo dados na tabela SQL
    
    Adicionar dados na tabela:
        insert into tbdepartamento(pkcoddep, nomedep)
        values (1,’Comercial’)

    Selecionar a tabela (buscar os dados):
        Selecionar todos os dados da tabela :
            Selecionar todos os dados para serem exibidos da tabela. 
                select * from <tabela>;
                    ex:
                    select * from tbcliente;
        Selecionar dados de uma coluna da tabela :
            Selecionar dados de algumas colunas para serem exibidos da tabela. 
                select <coluna1>,<coluna2> from <tabela>;
                select <tabela>.<coluna1>,<tabela>.<coluna2> from <tabela>;
                    ex:
                    select nomecli,salariocli from tbcliente;
                    select tbcliente.nomecli,tbcliente.salariocli from tbcliente;

        Selecionar dados de uma coluna da tabela nomeando apelidando tabela:
            Selecionar dados de algumas colunas as quais tem o nome da tabela apelidado de x para serem exibidos da tabela. 
                select x.<coluna1>,x.<coluna2> from <tabela> x;
                select ca.<coluna1>,CA.<coluna2> from <tabela> ca;
                    ex:
                    select x.nomecli,x.salariocli from tbcliente x;
                    select ca.nomecli,CA.salariocli from tbcliente ca;

        Selecionar dados de uma coluna da tabela nomeando apelidando :
            Selecionar dados de algumas colunas as quais são renomeadas na pesquisa
                select x.<coluna1> as <nome_da_para_a_coluna>,x.<coluna2> as <nome_da_para_a_coluna> from <tabela> x;
                    ex1: 
                    select x.nomecli as candidato,x.salariocli as salario from tbcliente x;
                    ex2: 
                    select x.nomecli as "Nome do candidato",x.salariocli as "Sálario do Candidato" from tbcliente x;

        Selecionar dados de uma coluna da tabela adicionando dados :
            Selecionar dados de algumas colunas as quais são renomeadas na pesquisa

                select nomecli,salariocli,(salariocli+1000)as euquero from tbcliente;
                select nomecli,salariocli,(salariocli+pkcodcli)as euquero from tbcliente;
                select x.nomecli,x.salariocli,'testando' as olhaso from tbcliente x;

        Selecionar dados de uma coluna ordenando as colunas :
            Seleciona todas as colunas  da tabela x ordenadas pela coluna
                select * from <tabela> x order by x.<coluna>;
                    ex:
                    select * from tbcliente x order by x.nomecli;
                    select * from tbcliente x order by x.salariocli;

        Seleciona todas as colunas da tabela x ordenadas pela coluna de forma decrescente
            select * from <tabela> x order by x.<coluna> desc;
                ex:
                select * from tbcliente x order by x.salariocli desc;

        Seleciona todas as colunas da tabela x ordenadas pela coluna de forma crescente
            select * from <tabela> x order by x.<coluna> asc;
                ex:
                select * from tbcliente x order by x.salariocli asc;

        Seleciona todas colunas da tabela são ordenadas pelo sexo em seguida pelo salario
            select * from <tabela> x order by x.<coluna>,x.<coluna>;
                ex:.
                select * from tbcliente x order by x.sexocli,x.salariocli;
                select * from tbcliente x order by x.sexocli desc, x.salariocli;

        Seleciona  a partir da 5 linha da tabela:

            select * from tbcliente x 
            order by 5;
            select nomecli,salariocli,(salariocli+1000) as euquero 
            from tbcliente 
            order by 3;

Exemplificações:

        1) liste em tela o sexo cadastrado dos clientes?
                select distinct x.sexocli 
                from tbcliente x

        ====== condições ====== 
        alguma coisa = outra coisa (igual)
        alguma coisa > outra coisa (maior)
        alguma coisa < outra coisa (menor)
        alguma coisa >= outra coisa (maior ou igual)
        alguma coisa <= outra coisa (menor ou igual)
        alguma coisa <> outra coisa (diferente) 
        alguma coisa like outra coisa (conter)

        2) liste em tela todos os dados do cliente de códido 2

            select * from tbcliente x 
            where x.pkcodcli=2

        3) liste em tela todos os clientes com salario inferior a 1000
            
            select * from tbcliente x 
            where x.salariocli<1000

        ====== operadores relacionais =====
            &&  and 
            ||  or
        
        4) liste em tela todos os dados do cliente de códido 2 ou 4

            select * from tbcliente x 
            where x.pkcodcli=2 or x.pkcodcli=4

        5) liste em tela os cliente do com salário inferior a 900 e código menor do que 5

            select * from tbcliente x 
            where x.salariocli<900 and x.pkcodcli<5

        5) liste em tela os cliente do com salário inferior a 900 e código menor do que 5 ou data de nascimento maior do que '01/01/2000'

            select * from tbcliente x 
            where (x.salariocli<900 and x.pkcodcli<5) or x.datanasccli>'01/01/2000'

        6) Mostre em tela todos os clientes do sexo Masculino

            select * from tbcliente x 
            where x.sexocli='M';

            select * from tbcliente x 
            where x.sexocli='m';

            select * from tbcliente x
            where x.sexocli=upper('m');

            select x.nomecli,upper(x.nomecli) 
            from tbcliente x

        7) liste todos os dados do  cliente 'Bozo da Silva'
            
            select * from tbcliente x
            where upper(x.nomecli)=upper('bOZo DA sILvA')

        8) liste todos os dados do  cliente que inicia com "B"

            select * from tbcliente x 

        9) liste todos os dados do  cliente que termina com "a"
            
            select * from tbcliente x
            where upper(x.nomecli) like upper('%a')

        10) liste todos os dados do  cliente que possuem no nome  "ca"

            select * from tbcliente x 
            where upper(x.nomecli) like upper('%ca%')

        ====================== Funções de Agregação =====================
            sum(parametro) retorna o somatório do atributo passado como parâmetro
            count(parametro) retorna a quantidade de elementos não nulos do registro
            avg(parametro) retorna a média aritmética do parametro passado
            max(parametro) retorna o maior elemento do parametro
            min(parametro) retorna o menor elemento do parametro
        =======================================================================

        11) Mostre a soma de todos os salários

            select sum(x.salariocli) 
            from tbcliente x

        12) Mostre quantos salarios não são nulos

            select count(x.salariocli) 
            from tbcliente x

        13) mostre a quantidade de registros

            select count(*) from tbcliente x
            insert into tbcliente(pkcodcli, nomecli, endcli, sexocli ) 
            values (66,'Bastiona ', 'rua já ', 'F');

            select count(*), count(x.salariocli) 
            from tbcliente x

        14)mostre a media do salario dos funcionários

            select avg(x.salariocli) 
            from tbcliente x

        15)mostre o maior salario dos funcionários

            select max(x.salariocli) 
            from tbcliente x

        16)mostre o menor salario dos funcionários

            select min(x.salariocli) 
            from tbcliente x

        17)mostre o menor salario dos funcionários do sexo feminino 

            select min(x.salariocli) 
            from tbcliente x
            where upper(x.sexocli)=upper('F')

        18)Liste em tela o sexo o somatório de salário de cada sexo, e a quantidade de clientes de cada sexo

            select x.sexocli,
            sum(x.salariocli),
            count(*) from tbcliente x 
            group by x.sexocli

        19)Liste em tela o sexo o somatório de salário de cada sexo, e a quantidade de clientes 
        de cada sexo dos clientes que possuem "CA" no nome 

            select x.sexocli,sum(x.salariocli),count(*)  from tbcliente x 
            where upper(x.nomecli) like upper('%ca%')
            group by x.sexocli
            
        20)Liste em tela o sexo o somatório de salário de cada sexo, e a quantidade de clientes de cada sexo onde a quantidade de cada sexo seja inferior a 5 pessoas 

            select x.sexocli,sum(x.salariocli),count(*)  from tbcliente x 
            having count(*)<5
            group by x.sexocli

        21)Liste em tela o sexo o somatório de salário de cada sexo, onde a média salarial de cada sexo seja superior a 700

            select x.sexocli,sum(x.salariocli) from tbcliente x 
            having avg(x.salariocli)>700
            group by x.sexocli
            
        22)Liste em tela o sexo o somatório de salário de cada sexo, onde a média salarial de cada sexo seja superior a 700 e o nome do cliente tenha que ter a letra "u"

            select x.sexocli,sum(x.salariocli) from tbcliente x 
            where upper(x.nomecli) like upper('%u%')
            having avg(x.salariocli)>700
            group by x.sexocli



Aula 27 - 09/11/2021 - Condicionais 

        1)Multiplica itens 
            select  * from produtos p, tbcategoria c 

        2)Traz
            select  * from produtos p, tbcategoria c 
            where p.fkcodcat = c.pkcodcat

        Intersecção
        3) Somente os que são iguais: aa cc
            select 	[ atributos_de_resposta] 
            from 		[tabela]
            inner join [outra_tabel] 
            on 		{como as tabelas se ligam]

            select 	* 
            from 		tbproduto p 
            inner join tbcategoria c 
            on 		p.fkcodcat = c.pkcodcat

        Intersecção
        4) Os quais não tem fornecedor 
        
        LEFT
        APRESENTA OS DADOS QUE ESTÃO A ESQUERDA DO LEFT JOIN 
        → Quando o atributo da chave estrangeira pode ser nulo
            select 	[ atributos_de_resposta] 
            from 		[tabela]
            left join [outra_tabel] 
            on 		{como as tabelas se ligam]

            select 	* 
            from 		tbproduto p 
            left 	join  tbfornecedor f
            on 		p.fkcodcat = f.pkcodfon;


            select 	* 
            from 		 tbfornecedor f
            left 	join  tbproduto p 
            on 		p.fkcodcat = f.pkcodfon;


            select 	 * 
            from 		 tbfornecedor f
            left 	join   tbproduto p 
            on 		  p.fkcodcat = f.pkcodfon AND p.fkcodcat > 10 ;

            RIGHT 
            APRESENTA OS DADOS QUE ESTÃO A DIREIRA DO RIGHT JOIN 

            select 	* 
            from 		tbproduto p 
            right 	join  tbfornecedor f
            on 		p.fkcodcat = f.pkcodfon;


            FULL
            APRESENTA OS DADOS QUE ESTÃO A DIREIRA E A ESQUERDA DO FULL JOIN 

            select 	* 
            from 		tbproduto p 
            full	join  tbfornecedor f
            on 		p.fkcodcat = f.pkcodfon;


        5) União 
        Sempre Pega da primeira pesquisa.
             select 	c.pkcodcat, c.nomecat 
             from 		tccategoria
             full	join  tbfornecedor f
             on 		p.fkcodcat = f.pkcodfon;

        6) Alterando Dados da Tabela
            update [nome_tabela] set 
                atributo1 = novo_valor,
                atributo2 = novo_valor,
                atributo3 = novo_valor
            where condicoes
            CUIDAR PARA NÃO FAZER SEM WHERE , ALTERA TODO MUNDO !!!

        6) Deletar dados da Tabela
            delete from tabela where tabela.coluna = 88
            CUIDAR PARA NÃO FAZER SEM WHERE , DELETA TODO MUNDO !!!
