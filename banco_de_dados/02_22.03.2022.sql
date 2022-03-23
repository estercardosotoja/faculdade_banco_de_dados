 CRIAR TABELAS
 CREATE TABLE TbAluno(
  pkCodAlu INTEGER NOT NULL CONSTRAINT Tbalunopk PRIMARY KEY,
  nomeAlu VARCHAR(30) NOT NULL,
  idadeAlu INTEGER,
  emailAlu VARCHAR(30) NOT NULL UNIQUE,
  foneAlu NUMBER(9),
  senhaAlu VARCHAR(30)
);

CREATE TABLE TbCurso(
    pkCodCur INTEGER NOT NULL,
    nomeCur  VARCHAR(30) NOT NULL
);

CREATE TABLE TbDisciplina(
    pkCodDis INTEGER NOT NULL,
    nomeDis VARCHAR(30) NOT NULL,
    semestreDis INTEGER,
    cursoDis VARCHAR(30),
    fkCodTur INTEGER,
    fkCodProf INTEGER,
    fkCodCur INTEGER
);

CREATE TABLE TbProfessor(
    pkCodProf INTEGER NOT NULL,
    nomeProf VARCHAR(30) NOT NULL,
    cpfProf VARCHAR(11) UNIQUE,
    emailProf VARCHAR(30) NOT NULL UNIQUE,
    salarioProf NUMBER(15,2)
    CONSTRAINT check_salarioProf CHECK(salarioProf>=1042 AND salarioProf<=150000.00)
);

 CREATE TABLE TbTurma(
  pkCodTur INTEGER NOT NULL CONSTRAINT tbTurPk PRIMARY KEY,  
  notaAPI NUMBER(2,2) DEFAULT 0,
  notaAPII NUMBER(2,2) DEFAULT 0,
  notaAS NUMBER(2,2) DEFAULT 0,
  notaAF NUMBER(2,2) DEFAULT 0,
  anoDis INTEGER DEFAULT 2022, 
  fkCodAlu INTEGER,
CONSTRAINT check_api CHECK(notaAPI>=0 AND notaAPI<=1.5),
CONSTRAINT check_apii CHECK(notaAPII>=0 AND notaAPII<=2.5),
CONSTRAINT check_as CHECK(notaAS>=0 AND notaAS<= 6.0),
CONSTRAINT check_af CHECK(notaAF>=0 AND notaAF<=10),
CONSTRAINT ano_dis CHECK(anoDis >=1990 AND anoDis<=2060)
);


CHAVE ESTRANGEIRAS
    ALTER TABLE TbTurma ADD CONSTRAINT aluno_codturma
    FOREIGN KEY(fkCodAlu) REFERENCES TbAluno(pkCodAlu)
    ON DELETE CASCADE;

    ALTER TABLE TbDisciplina ADD CONSTRAINT dis_fkcodtur
    FOREIGN KEY(fkCodTur) REFERENCES TbTurma(pkCodTur)
    ON DELETE CASCADE;

    ALTER TABLE TbDisciplina ADD CONSTRAINT dis_fkcodprof
    FOREIGN KEY(fkCodProf) REFERENCES TbProfessor(pkCodProf)
    ON DELETE CASCADE;

    ALTER TABLE TbCurso ADD CONSTRAINT dis_fkcodcur
    FOREIGN KEY(fkCodCur) REFERENCES TbCurso(pkCodCur)
    ON DELETE CASCADE;