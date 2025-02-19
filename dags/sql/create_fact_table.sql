CREATE TABLE IF NOT EXISTS dim_eleicoes.fato_despesas(
    FATO_DESPESA_ID SERIAL PRIMARY KEY, 
    SK_TEMPO_ID BIGINT REFERENCES dim_eleicoes.dim_tempo(DIM_TEMPO_ID),
    SK_SG_UE BIGINT REFERENCES dim_eleicoes.dim_localidades(SG_UE),
    SK_SQ_CANDIDATO BIGINT REFERENCES dim_eleicoes.dim_candidatos(SQ_CANDIDATO),
    SK_NR_PARTIDO BIGINT REFERENCES dim_eleicoes.dim_partidos(NR_PARTIDO),
    SK_NR_CPF_CNPJ_FORNECEDOR BIGINT REFERENCES dim_eleicoes.dim_fornecedores(NR_CPF_CNPJ_FORNECEDOR),
    DS_DESPESA text,
    VR_DESPESA_CONTRATADA NUMERIC                       
);