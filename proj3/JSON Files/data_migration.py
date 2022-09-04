# -*- coding: utf-8 -*-
"""
Created on Sat Jun 11 20:30:39 2022

@author: joaoc
"""

import json

with open('docentes.json', 'r', encoding='utf-8') as docentes_json:
    docentes_data = json.loads(docentes_json.read())
docentes_json.close()

docentes = docentes_data['results']
docentes = docentes[0]['items']

with open('dsd.json', 'r', encoding='utf-8') as dsds_json:
    dsds_data = json.loads(dsds_json.read())
dsds_json.close()

dsds = dsds_data['results']
dsds = dsds[0]['items']

with open('ocorrencias.json', 'r', encoding='utf-8') as ocorrencias_json:
    ocorrencias_data = json.loads(ocorrencias_json.read())
ocorrencias_json.close()

ocorrencias = ocorrencias_data['results']
ocorrencias = ocorrencias[0]['items']

with open('tiposaula.json', 'r', encoding='utf-8') as tiposaula_json:
    tiposaula_data = json.loads(tiposaula_json.read())
tiposaula_json.close()

tiposaula = tiposaula_data['results']
tiposaula = tiposaula[0]['items']

with open('ucs.json', 'r', encoding='utf-8') as ucs_json:
    ucs_data = json.loads(ucs_json.read())
ucs_json.close()

ucs = ucs_data['results']
ucs = ucs[0]['items']

for ocorrencia in ocorrencias:
    for uc in ucs:
        if ocorrencia['codigo'] == uc['codigo']:
            ocorrencia['uc'] = uc
            del ocorrencia['codigo']
            break
        
for tipoaula in tiposaula:
    for ocorrencia in ocorrencias:
        if tipoaula['ano_letivo'] == ocorrencia['ano_letivo'] and tipoaula['periodo'] == ocorrencia['periodo'] and tipoaula['codigo'] == ocorrencia['uc']['codigo']:
            tipoaula['ocorrencia'] = ocorrencia
            del tipoaula['ano_letivo']
            del tipoaula['periodo']
            del tipoaula['codigo']
            break
        
for dsd in dsds:
    for docente in docentes:
        if dsd['nr'] == docente['nr']:
            dsd['docente'] = docente
            del dsd['nr']
            break
    for tipoaula in tiposaula:
        if dsd['id'] == tipoaula['id']:
            dsd['tipoaula'] = tipoaula
            del dsd['id']
            break

mongodb_string = json.dumps(dsds, indent=3)
mongodb = open("mongodb.json", "w")
mongodb.write(mongodb_string)
mongodb.close()
