/* COPY TABLES - X, Y, Z */

CREATE TABLE XDOCENTES AS SELECT * FROM GTD10.xdocentes;
CREATE TABLE YDOCENTES AS SELECT * FROM GTD10.xdocentes;
CREATE TABLE ZDOCENTES AS SELECT * FROM GTD10.xdocentes;

CREATE TABLE XDSD AS SELECT * FROM GTD10.xdsd;
CREATE TABLE YDSD AS SELECT * FROM GTD10.xdsd;
CREATE TABLE ZDSD AS SELECT * FROM GTD10.xdsd;

CREATE TABLE XOCORRENCIAS AS SELECT * FROM GTD10.xocorrencias;
CREATE TABLE YOCORRENCIAS AS SELECT * FROM GTD10.xocorrencias;
CREATE TABLE ZOCORRENCIAS AS SELECT * FROM GTD10.xocorrencias;

CREATE TABLE XTIPOSAULA AS SELECT * FROM GTD10.xtiposaula;
CREATE TABLE YTIPOSAULA AS SELECT * FROM GTD10.xtiposaula;
CREATE TABLE ZTIPOSAULA AS SELECT * FROM GTD10.xtiposaula;

CREATE TABLE XUCS AS SELECT * FROM GTD10.xucs;
CREATE TABLE YUCS AS SELECT * FROM GTD10.xucs;
CREATE TABLE ZUCS AS SELECT * FROM GTD10.xucs;

/* CREATE PRIMARY AND FOREIGN KEY CONSTRAINTS Y */

ALTER TABLE YDOCENTES ADD CONSTRAINT YDOCENTES_PK PRIMARY KEY (NR);
ALTER TABLE YDSD ADD CONSTRAINT YDSD_PK PRIMARY KEY (NR, ID);
ALTER TABLE YOCORRENCIAS ADD CONSTRAINT YOCORRENCIAS_PK PRIMARY KEY (CODIGO, ANO_LETIVO, PERIODO);
ALTER TABLE YTIPOSAULA ADD CONSTRAINT YTIPOSAULA_PK PRIMARY KEY (ID);
ALTER TABLE YUCS ADD CONSTRAINT YUCS_PK PRIMARY KEY (CODIGO);

ALTER TABLE YDSD ADD CONSTRAINT YDSD_FK1 FOREIGN KEY (NR) REFERENCES YDOCENTES(NR);
ALTER TABLE YDSD ADD CONSTRAINT YDSD_FK2 FOREIGN KEY (ID) REFERENCES YTIPOSAULA(ID);
ALTER TABLE YOCORRENCIAS ADD CONSTRAINT YOCORRENCIAS_FK FOREIGN KEY (CODIGO) REFERENCES YUCS(CODIGO);
ALTER TABLE YTIPOSAULA ADD CONSTRAINT YTIPOSAULA_FK FOREIGN KEY (ANO_LETIVO, PERIODO, CODIGO) REFERENCES YOCORRENCIAS(ANO_LETIVO, PERIODO, CODIGO);

/* CREATE PRIMARY AND FOREIGN KEY CONSTRAINTS Z */

ALTER TABLE ZDOCENTES ADD CONSTRAINT ZDOCENTES_PK PRIMARY KEY (NR);
ALTER TABLE ZDSD ADD CONSTRAINT ZDSD_PK PRIMARY KEY (NR, ID);
ALTER TABLE ZOCORRENCIAS ADD CONSTRAINT ZOCORRENCIAS_PK PRIMARY KEY (CODIGO, ANO_LETIVO, PERIODO);
ALTER TABLE ZTIPOSAULA ADD CONSTRAINT ZTIPOSAULA_PK PRIMARY KEY (ID);
ALTER TABLE ZUCS ADD CONSTRAINT ZUCS_PK PRIMARY KEY (CODIGO);

ALTER TABLE ZDSD ADD CONSTRAINT ZDSD_FK1 FOREIGN KEY (NR) REFERENCES ZDOCENTES(NR);
ALTER TABLE ZDSD ADD CONSTRAINT ZDSD_FK2 FOREIGN KEY (ID) REFERENCES ZTIPOSAULA(ID);
ALTER TABLE ZOCORRENCIAS ADD CONSTRAINT ZOCORRENCIAS_FK FOREIGN KEY (CODIGO) REFERENCES ZUCS(CODIGO);
ALTER TABLE ZTIPOSAULA ADD CONSTRAINT ZTIPOSAULA_FK FOREIGN KEY (ANO_LETIVO, PERIODO, CODIGO) REFERENCES ZOCORRENCIAS(ANO_LETIVO, PERIODO, CODIGO);

/* QUESTION 1 */

SELECT xucs.codigo, xucs.designacao, xocorrencias.ano_letivo, xocorrencias.inscritos, xtiposaula.tipo, xtiposaula.turnos
FROM xucs JOIN xocorrencias ON xucs.codigo=xocorrencias.codigo JOIN xtiposaula ON xocorrencias.ano_letivo=xtiposaula.ano_letivo and xocorrencias.codigo=xtiposaula.codigo and xocorrencias.periodo=xtiposaula.periodo
WHERE   xucs.designacao = 'Bases de Dados' and 
        xucs.curso = 275;
        
SELECT yucs.codigo, yucs.designacao, yocorrencias.ano_letivo, yocorrencias.inscritos, ytiposaula.tipo, ytiposaula.turnos
FROM yucs JOIN yocorrencias ON yucs.codigo=yocorrencias.codigo JOIN ytiposaula ON yocorrencias.ano_letivo=ytiposaula.ano_letivo and yocorrencias.codigo=ytiposaula.codigo and yocorrencias.periodo=ytiposaula.periodo
WHERE   yucs.designacao = 'Bases de Dados' and 
        yucs.curso = 275;
        
CREATE INDEX ZUCS_DESIGNACAO ON ZUCS(DESIGNACAO);

SELECT zucs.codigo, zucs.designacao, zocorrencias.ano_letivo, zocorrencias.inscritos, ztiposaula.tipo, ztiposaula.turnos
FROM zucs JOIN zocorrencias ON zucs.codigo=zocorrencias.codigo JOIN ztiposaula ON zocorrencias.ano_letivo=ztiposaula.ano_letivo and zocorrencias.codigo=ztiposaula.codigo and zocorrencias.periodo=ztiposaula.periodo
WHERE   zucs.designacao = 'Bases de Dados' and 
        zucs.curso = 275;
        
/* QUESTION 2 */

SELECT xtiposaula.tipo, sum(xtiposaula.turnos*xtiposaula.horas_turno) as "CLASS_HOURS"
FROM xucs JOIN xtiposaula ON xucs.codigo=xtiposaula.codigo
WHERE xtiposaula.ano_letivo = '2004/2005' and xucs.curso = 233
GROUP BY xtiposaula.tipo; 
 
SELECT ytiposaula.tipo, sum(ytiposaula.turnos*ytiposaula.horas_turno) as "CLASS_HOURS"
FROM yucs JOIN ytiposaula ON yucs.codigo=ytiposaula.codigo
WHERE ytiposaula.ano_letivo = '2004/2005' and yucs.curso = 233
GROUP BY ytiposaula.tipo;   

CREATE INDEX ZUCS_CURSO ON ZUCS(CURSO);

SELECT ztiposaula.tipo, sum(ztiposaula.turnos*ztiposaula.horas_turno) as "CLASS_HOURS"
FROM zucs JOIN ztiposaula ON zucs.codigo=ztiposaula.codigo
WHERE ztiposaula.ano_letivo = '2004/2005' and zucs.curso = 233
GROUP BY ztiposaula.tipo; 
        
/* QUESTION 3 a) */

SELECT CODIGO
FROM XOCORRENCIAS
WHERE CODIGO NOT IN (SELECT CODIGO FROM XOCORRENCIAS WHERE INSCRITOS IS NOT NULL AND ANO_LETIVO = '2003/2004') AND ANO_LETIVO = '2003/2004'; 

SELECT CODIGO
FROM YOCORRENCIAS
WHERE CODIGO NOT IN (SELECT CODIGO FROM YOCORRENCIAS WHERE INSCRITOS IS NOT NULL AND ANO_LETIVO = '2003/2004') AND ANO_LETIVO = '2003/2004'; 

SELECT CODIGO
FROM ZOCORRENCIAS
WHERE CODIGO NOT IN (SELECT CODIGO FROM ZOCORRENCIAS WHERE INSCRITOS IS NOT NULL AND ANO_LETIVO = '2003/2004') AND ANO_LETIVO = '2003/2004'; 
     
/* QUESTION 3 b) */     

SELECT XUCS.CODIGO
FROM XUCS JOIN XOCORRENCIAS ON XUCS.CODIGO = XOCORRENCIAS.CODIGO
WHERE XOCORRENCIAS.INSCRITOS IS NULL AND XOCORRENCIAS.ANO_LETIVO = '2003/2004';

SELECT YUCS.CODIGO
FROM YUCS JOIN YOCORRENCIAS ON YUCS.CODIGO = YOCORRENCIAS.CODIGO
WHERE YOCORRENCIAS.INSCRITOS IS NULL AND YOCORRENCIAS.ANO_LETIVO = '2003/2004';

SELECT ZUCS.CODIGO
FROM ZUCS JOIN ZOCORRENCIAS ON ZUCS.CODIGO = ZOCORRENCIAS.CODIGO
WHERE ZOCORRENCIAS.INSCRITOS IS NULL AND ZOCORRENCIAS.ANO_LETIVO = '2003/2004';

/* QUESTION 4 */

create view sum_horas_tipo as
select sum(horas*fator) as total_horas, nr, tipo
from xdsd join xtiposaula on xdsd.id = xtiposaula.id
where ano_letivo = '2003/2004'
group by nr, tipo;

create view max_horas_tipo as
select tipo, max(total_horas) as max_horas
from horas_doc_tipo
group by tipo;

select sum_horas_tipo.nr, nome, sum_horas_tipo.tipo, sum_horas_tipo.total_horas as classhours_factor 
from sum_horas_tipo join xdocentes on xdocentes.nr = sum_horas_tipo.nr
where sum_horas_tipo.total_horas = (select max_horas from max_horas_tipo where max_horas_tipo.tipo = sum_horas_tipo.tipo);

/* QUESTION 6 

Select the programs (curso) that have classes with all the existing types */

/*A*/
select codigo 
from (select codigo, tipo 
      from xtiposaula 
      group by codigo, tipo) 
group by codigo 
having count(codigo) = (select count(*) 
                        from (select distinct tipo 
                              from xtiposaula));

/*B*/ 
select curso 
from (select curso, tipo 
      from xtiposaula join xucs on xtiposaula.codigo = xucs.codigo
      group by curso, tipo) 
group by curso
having count(curso) = (select count(*) 
                       from (select distinct tipo 
                             from xtiposaula));
                             
select curso 
from (select curso, tipo 
      from ytiposaula join yucs on ytiposaula.codigo = yucs.codigo
      group by curso, tipo) 
group by curso
having count(curso) = (select count(*) 
                       from (select distinct tipo 
                             from ytiposaula));
                             
select curso 
from (select curso, tipo 
      from ztiposaula join zucs on ztiposaula.codigo = zucs.codigo
      group by curso, tipo) 
group by curso
having count(curso) = (select count(*) 
                       from (select distinct tipo 
                             from ztiposaula));                             
                             
/*C*/
create view aux_codigo as
select codigo 
from (select codigo, tipo 
      from xtiposaula 
      group by codigo, tipo) 
group by codigo 
having count(codigo) = (select count(*) 
                        from (select distinct tipo 
                              from xtiposaula));
                              
select distinct curso
from aux_codigo join xucs on xucs.codigo = aux_codigo.codigo;

































        
        
        
        
        
        
        
        
        