INSERT INTO dim_eleicoes.dim_tempo(DT_PRESTACAO_CONTAS, DIA, MES, ANO)
SELECT DISTINCT ON(dc."DT_PRESTACAO_CONTAS")
    dc."DT_PRESTACAO_CONTAS", 
    EXTRACT(DAY FROM dc."DT_PRESTACAO_CONTAS") AS DIA,
    EXTRACT(MONTH FROM dc."DT_PRESTACAO_CONTAS") AS MES,
    EXTRACT(YEAR FROM dc."DT_PRESTACAO_CONTAS") AS ANO
FROM 
   sa_eleicoes.despesas_contratadas dc
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.dim_tempo dt
    WHERE dc."DT_PRESTACAO_CONTAS" = dt.DT_PRESTACAO_CONTAS
);

INSERT INTO dim_eleicoes.dim_localidades(SG_UE, NM_UE, SG_UF)
SELECT DISTINCT ON(dc."SG_UE")
    dc."SG_UE",
    dc."NM_UE",
    dc."SG_UF" 
FROM 
   sa_eleicoes.despesas_contratadas dc
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.dim_localidades dl
    WHERE 
        dc."SG_UE" = dl.SG_UE
          );

INSERT INTO dim_eleicoes.dim_candidatos(SQ_CANDIDATO, NM_CANDIDATO, DS_CARGO)
SELECT DISTINCT ON(dc."SQ_CANDIDATO")
    dc."SQ_CANDIDATO",
    dc."NM_CANDIDATO",
    dc."DS_CARGO"
FROM 
   sa_eleicoes.despesas_contratadas dc
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.dim_candidatos dct
    WHERE dc."SQ_CANDIDATO" = dct.SQ_CANDIDATO
          );

INSERT INTO dim_eleicoes.dim_partidos(NR_PARTIDO, SG_PARTIDO, NM_PARTIDO)
SELECT DISTINCT ON(dc."NR_PARTIDO")
    dc."NR_PARTIDO",
    dc."SG_PARTIDO",
    dc."NM_PARTIDO"
FROM 
   sa_eleicoes.despesas_contratadas dc
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.dim_partidos dp
    WHERE 
          dc."NR_PARTIDO" = dp.NR_PARTIDO
          );

INSERT INTO dim_eleicoes.dim_fornecedores(NR_CPF_CNPJ_FORNECEDOR, NM_FORNECEDOR)
SELECT DISTINCT ON(dc."NR_CPF_CNPJ_FORNECEDOR")
    dc."NR_CPF_CNPJ_FORNECEDOR",
    dc."NM_FORNECEDOR"
FROM 
   sa_eleicoes.despesas_contratadas dc
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_eleicoes.dim_fornecedores df
    WHERE dc."NR_CPF_CNPJ_FORNECEDOR" = df.NR_CPF_CNPJ_FORNECEDOR
          );