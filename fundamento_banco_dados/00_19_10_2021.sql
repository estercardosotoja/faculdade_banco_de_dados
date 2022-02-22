    create table TBANIMAL (
        pkcodigoaninal integer not null primary key,
        nomeanimal varchar(20) not null,
        datanascimentoanimal date,
        pesoanimal number(3,2),
        alturaanimal number(2,2),
        valorvendaanimal number(2,2),
        fkcodigoraca integer not null,
        fkcodigocliente integer not null,
        fknumeroregistrovet integer not null 
    );
        
    create table TBRACA(
        pkcodigoraca integer not null primary key,
        nomeraca varchar(20) not null
    );
	
    create table TBCLIENTE(
        pkcodigocliente integer not null primary key,
        nomecliente varchar(20) not null
    );

    create table TBVETERINARIO(
        pknumeroregistrovet integer not null primary key,
        especialidadevet varchar(20) not null,
        nomevet varchar(20) not null
    );

    alter table TBANIMAL add constraint TBANIMAL_TBRACA 
    foreign key(fkcodigoraca) 
    references TBRACA(pkcodigoraca);



    alter table TBANIMAL add constraint TBANIMAL_TBCLIENTE 
    foreign key(fkcodigocliente)
    references TBCLIENTE(pkcodigocliente);



    alter table TBANIMAL add constraint TBANIMAL_TBVETERINARIO 
    foreign key(fknumeroregistrovet) 
    references TBVETERINARIO(pknumeroregistrovet);



    Exercício 7
        create table TBPRODUTO(
            pkcodigoproduto integer not null primary key,
            nomeproduto varchar(20) not null,
            indiceicmsproduto number(3,2) not null,
        codigodebarrasproduto varchar(20) not null,
            fkcodigofornecedor integer not null,
        fkcodigoclassificacao integer not null
        );

        create table TBFORNECEDOR(
            pkcodigofornecedor integer not null primary key,
            nomefornecedor varchar(20) not null
        );


        create table TBCUPONFISCAL(
            pkcodigocuponfiscal integer not null primary key,
            datacuponfiscal date not null,
        fkcodigoproduto integer not null
        );


        create table TBCLASSIFICACAOFISCAL(
            pkcodigoclassificacao integer not null primary key,
            descricao number(3,2) not null
        );


        alter table TBPRODUTO add constraint TBPRODUTO_TBFORNECEDOR 
        foreign key(fkcodigofornecedor) 
        references TBFORNECEDOR(pkcodigofornecedor);


        alter table TBPRODUTO add constraint TBPRODUTO_TBCLASSIFICACAOFISCAL 
        foreign key(fkcodigoclassificacao) 
        references TBCLASSIFICACAOFISCAL(pkcodigoclassificacao);


        alter table TBCUPONFISCAL add constraint TBCUPONFISCAL_TBPRODUTO 
        foreign key(fkcodigoproduto) 
        references TBPRODUTO(pkcodigoproduto);


    Exercício 8

        create table TBPRODUTO(
            pkcodigoproduto integer not null primary key,
            nomeproduto varchar(20) not null,
            valorunitarioproduto number(3,2) not null,
            fkcodigocategoria integer not null,
            fkcodigofornecedor integer not null,
            fkcodigoconsumacao integer not null
        );

        create table TBCATEGORIA(
            pkcodigocategoria integer not null primary key,
            nomecategoria varchar(20) not null
        );

        create table TBFORNECEDOR(
            pkcodigofornecedor integer not null primary key,
            nomefornecedor varchar(20) not null
        );

        create table TBCONSUMACAO(
            pkcodigoconsumacao integer not null primary key,
            nomeconsumacaor varchar(20) not null,
        valorconsumo number(3,2) not null
        );

        alter table TBPRODUTO add constraint TBPRODUTO_TBCATEGORIA 
        foreign key(fkcodigocategoria) 
        references TBCATEGORIA(pkcodigocategoria);

        alter table TBPRODUTO add constraint TBPRODUTO_TBFORNECEDOR 
        foreign key(fkcodigofornecedor) 
        references TBFORNECEDOR(pkcodigofornecedor);

        alter table TBPRODUTO add constraint TBPRODUTO_TBCONSUMACAO 
        foreign key(fkcodigoconsumacao) 
        references TBCONSUMACAO(pkcodigoconsumacao);

