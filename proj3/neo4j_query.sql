LOAD CSV WITH HEADERS FROM 'file:///UCS_DATA_TABLE.csv' AS line
CREATE (:UC {CODIGO: line.CODIGO, DESIGNACAO: line.DESIGNACAO, SIGLA_UC: line.SIGLA_UC, CURSO: toInteger(line.CURSO)});

:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///OCORRENCIAS_DATA_TABLE.csv' AS line
CREATE (p:Ocorrencias {CODIGO : line.CODIGO, ANO_LETIVO: line.ANO_LETIVO, PERIODO: line.PERIODO,
INSCRITOS: toInteger(line.INSCRITOS), COM_FREQUENCIA: toInteger(line.COM_FREQUENCIA), 
APROVADOS: toInteger(line.APROVADOS), DEPARTAMENTO: line.DEPARTAMENTO});

MATCH
  (u:UC),
  (p:Ocorrencias)
WHERE u.CODIGO = p.CODIGO
CREATE (p)-[r:RELTYPE]->(u)
return type(r);

:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///TIPOSAULA_DATA_TABLE.csv' AS line
CREATE (t:TiposAula {ID: toInteger(line.ID), CODIGO: line.CODIGO, ANO_LETIVO : line.ANO_LETIVO, PERIODO : line.PERIODO,
TIPO: line.TIPO, TURNOS: toInteger(line.TURNOS), N_AULAS: line.N_AULAS, HORAS_TURNO: toInteger(line.HORAS_TURNO)});

MATCH
  (t:TiposAula),
  (p:Ocorrencias)
WHERE t.ANO_LETIVO = p.ANO_LETIVO and t.PERIODO = p.PERIODO and p.CODIGO = t.CODIGO
CREATE (t)–[:Occurs]->(p);

MATCH
  (t:TiposAula),
  (u:UC)
WHERE t.CODIGO = u.CODIGO
CREATE (t)–[r:Occur]->(u)
RETURN type(r);

LOAD CSV WITH HEADERS FROM 'file:///DOCENTES_DATA_TABLE.csv' AS line
CREATE (:Docentes { NR: toInteger(line.NR), NOME: line.NOME, SIGLA: line.SIGLA, 
CATEGORIA: toInteger(line.CATEGORIA),PROPRIO: line.PROPRIO, APELIDO: line.apelido,ESTADO: line.ESTADO});

:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///DSD_DATA_TABLE.csv' AS line
CREATE (x:Dsd { ID : toInteger(line.ID), NR: toInteger(line.NR), HORAS: toInteger(line.HORAS), FATOR: toInteger(line.FATOR), ORDEM: toInteger(line.ORDEM)});

MATCH
  (x:Dsd),
  (t:TiposAula)
WHERE t.ID = x.ID
CREATE (x)–[r:Type]->(t)
return type(r);

MATCH
  (x:Dsd),
  (d:Docentes)
WHERE d.NR = x.NR
CREATE (x)–[r:Records]->(d)
return type(r);

dbms.memory.heap.initial_size=3000m
dbms.memory.heap.max_size=5000m

Match (t:TiposAula)-[:Occur]->(u:UC)
Where u.CURSO = 233 AND t.ANO_LETIVO = '2004/2005'
Return t.TIPO, sum(t.turnos*t.horas_turno)

Match (e:Docentes)<-[z:Records]-(d:Dsd)-[y:Type]->(t:TiposAula)-[x:Occurs]->(o:Ocorrencias)
Where o.COM_FREQUENCIA <= 0.10*o.INSCRITOS
Return e.NOME

Match (d:Dsd)-[:Type]->(t:TiposAula)-[:Occur]->(u:UC)
WHERE t.ANO_LETIVO = '2003/2004'
WITH u.CODIGO as codigo, sum(t.HORAS_TURNO * t.TURNOS) as hours_required, sum(d.HORAS) as hours_assigned
WHERE hours_required <> hours_assigned
RETURN distinct codigo, hours_required, hours_assigned
Order by codigo;