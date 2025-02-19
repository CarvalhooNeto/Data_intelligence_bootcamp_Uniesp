INSERT INTO dim_eleicoes.fato_despesas(SK_TEMPO_ID, SK_SG_UE, SK_SQ_CANDIDATO, SK_NR_PARTIDO, SK_NR_CPF_CNPJ_FORNECEDOR, DS_DESPESA, VR_DESPESA_CONTRATADA)
SELECT 
    dt.DIM_TEMPO_ID AS SK_TEMPO_ID,
    dl.SG_UE AS SK_SG_UE,
    dct.SQ_CANDIDATO AS SK_SQ_CANDIDATO,
    dp.NR_PARTIDO as SK_NR_PARTIDO,
    df.NR_CPF_CNPJ_FORNECEDOR as SK_NR_CPF_CNPJ_FORNECEDOR,
    dc."DS_DESPESA",
    dc."VR_DESPESA_CONTRATADA"    
FROM 
    sa_eleicoes.despesas_contratadas dc
INNER JOIN 
    dim_eleicoes.dim_tempo dt ON dc."DT_PRESTACAO_CONTAS" = dt.DT_PRESTACAO_CONTAS
INNER JOIN 
    dim_eleicoes.dim_localidades dl ON dc."SG_UE" = dl.SG_UE
INNER JOIN 
    dim_eleicoes.dim_candidatos dct ON dc."SQ_CANDIDATO" = dct.SQ_CANDIDATO
INNER JOIN 
    dim_eleicoes.dim_partidos dp ON dc."NR_PARTIDO" = dp.NR_PARTIDO
INNER JOIN 
    dim_eleicoes.dim_fornecedores df ON dc."NR_CPF_CNPJ_FORNECEDOR" = df.NR_CPF_CNPJ_FORNECEDOR
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.fato_despesas fd
    WHERE 
        dt.DIM_TEMPO_ID = fd.SK_TEMPO_ID OR
        dl.SG_UE = fd.SK_SG_UE OR
        dct.SQ_CANDIDATO = fd.SK_SQ_CANDIDATO OR
        dp.NR_PARTIDO = fd.SK_NR_PARTIDO OR
        df.NR_CPF_CNPJ_FORNECEDOR = fd.SK_NR_CPF_CNPJ_FORNECEDOR)