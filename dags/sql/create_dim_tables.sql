CREATE TABLE IF NOT EXISTS dim_eleicoes.dim_tempo (

    DIM_TEMPO_ID SERIAL PRIMARY KEY,
    DT_PRESTACAO_CONTAS DATE,
    DIA SMALLINT,
    MES SMALLINT, 
    ANO SMALLINT 
);

CREATE TABLE IF NOT EXISTS dim_eleicoes.dim_localidades (

    SG_UE INT8 PRIMARY KEY,
    NM_UE TEXT,
    SG_UF VARCHAR(2)
    
);

CREATE TABLE IF NOT EXISTS dim_eleicoes.dim_candidatos(

    SQ_CANDIDATO INT8 PRIMARY KEY,
    NM_CANDIDATO TEXT,
    DS_CARGO VARCHAR(20)

);

CREATE TABLE IF NOT EXISTS dim_eleicoes.dim_partidos(

    NR_PARTIDO INT8 PRIMARY KEY,
    SG_PARTIDO VARCHAR(20),
    NM_PARTIDO TEXT

);


CREATE TABLE IF NOT EXISTS dim_eleicoes.dim_fornecedores(

    NR_CPF_CNPJ_FORNECEDOR INT8 PRIMARY KEY,
    NM_FORNECEDOR TEXT
);