create type ucs_t as object(
    codigo varchar2(9),
    designacao varchar2(150),
    sigla_uc varchar2(6),
    curso number(4)
);

create table ucs_tab of ucs_t;

create type ocorrencias_t as object(
    uc REF ucs_t,
    ano_letivo varchar2(9),
    periodo varchar2(2),
    inscritos number(38),
    com_frequencia number(38),
    aprovados number(38),
    objetivos varchar2(4000),
    conteudo varchar2(4000),
    departmento varchar2(6)
);

create table ocorrencias_tab of ocorrencias_t;

create type tipos_aula_t as object(
    ID number(10),
    tipo varchar2(2),
    ocorrencia REF ocorrencias_t,
    turnos number(4,2),
    n_aulas number,
    horas_turno number(4,2)
);

create table tipos_aula_tab of tipos_aula_t;

create type docentes_t as object(
    nr number,
    nome varchar2(75),
    sigla varchar2(8),
    categoria number,
    proprio varchar2(25),
    apelido varchar2(25),
    estado varchar2(3)
); 

create table docentes_tab of docentes_t;

create type dsd_t as object(
    docente REF docentes_t,
    tipo_aula REF tipos_aula_t,    
    horas number(4,2),
    fator number(3,2),
    ordem number
); 

create table dsd_tab of dsd_t;

/* Add primary keys */

alter table ucs_tab add primary key (codigo);
alter table tipos_aula_tab add primary key (ID);
alter table docentes_tab add primary key (nr);

/* Populate the object relational model with the date in the relational database */

insert into ucs_tab (codigo, designacao, sigla_uc, curso)
select codigo, designacao, sigla_uc, curso from xucs;

insert into ocorrencias_tab (uc, ano_letivo, periodo, inscritos, com_frequencia, aprovados, objetivos, conteudo, departmento)
select (select REF(u) from ucs_tab u where u.codigo = o.codigo), o.ano_letivo, o.periodo, o.inscritos, o.com_frequencia, o.aprovados, o.objetivos, o.conteudo, o.departamento from zocorrencias o;

insert into tipos_aula_tab (id, tipo, ocorrencia, turnos, n_aulas, horas_turno)
select ta.id, ta.tipo, (select ref(o) from ocorrencias_tab o join ucs_tab u on ref(u) = o.uc where u.codigo = ta.codigo and o.ano_letivo = ta.ano_letivo and o.periodo = ta.periodo), ta.turnos, ta.n_aulas, ta.horas_turno from xtiposaula ta;

insert into docentes_tab (nr, nome, sigla, categoria, proprio, apelido, estado)
select nr, nome, sigla, categoria, proprio, apelido, estado from xdocentes;

insert into dsd_tab (docente, tipo_aula, horas, fator, ordem)
select (select ref(doc) from docentes_tab doc where d.nr = doc.nr), (select ref(ta) from tipos_aula_tab ta where ta.id = d.id), d.horas, d.fator, d.ordem from xdsd d;

/* Methods */

alter type dsd_t add member function horasfator return number cascade;

create type body dsd_t as
    member function horasfator return number is
    begin
    return horas * fator;
    end horasfator;
end;

/* QUERIES */

/* a) How many class hours of each type did the program 233 got in year 2004/2005? */

alter type tipos_aula_t add member function getclasshours return number cascade;
alter type tipos_aula_t add member function getcurso return number cascade;
alter type tipos_aula_t add member function getanoletivo return varchar2 cascade;

create or replace type body tipos_aula_t as
    member function getclasshours return number is
    begin
    return turnos * horas_turno;
    end getclasshours;
    member function getcurso return number is
    curso number;
    begin
    select u.curso into curso from ucs_tab u join ocorrencias_tab o on ref(u) = o.uc where self.ocorrencia = ref(o);
    return curso;
    end getcurso;
    member function getanoletivo return varchar2 is
    anoletivo varchar2(9);
    begin
    select o.ano_letivo into anoletivo from ocorrencias_tab o where self.ocorrencia = ref(o);
    return anoletivo;
    end getanoletivo;
end;

SELECT ta.tipo, sum(ta.getclasshours()) as "CLASS_HOURS"
FROM tipos_aula_tab ta
WHERE ta.getanoletivo() = '2004/2005' and ta.getcurso() = 233
GROUP BY ta.tipo; 