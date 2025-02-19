import requests
import zipfile
from io import BytesIO
import pandas as pd
from sqlalchemy.engine import Connectable
import io

def extract_load_from_zip(db_conn: Connectable,
        table: str,
        schema: str = "sa_eleicoes"):
    
    
    url_zip = "https://cdn.tse.jus.br/estatistica/sead/odsele/prestacao_contas/prestacao_de_contas_eleitorais_candidatos_2024.zip"
    print(f"connection succesfully! Reading url: {url_zip}")
    
    
    response = requests.get(url_zip, stream=True, timeout= 240)
    if response.status_code == 200:
        zip_buffer = io.BytesIO()

        for chunk in response.iter_content(chunk_size=524288):
            zip_buffer.write(chunk)
            print(f"Baixados {zip_buffer.tell()} bytes...")

    zip_buffer.seek(0)

    with zipfile.ZipFile(zip_buffer, "r") as zip_ref:
        file_list = zip_ref.namelist()
        print("Files in ZIP:", file_list)

        csv_files = [f for f in file_list if f.startswith("despesas_contratadas")]

        
        if_exists = "replace"
        for csv in csv_files: 
                
                print(f"Processing file: {csv}")

                with zip_ref.open(csv) as file:

                    for df_chunk in pd.read_csv(file, sep=";", encoding="latin1", chunksize=10000):
                        df_chunk.to_sql(table, db_conn, schema=schema, if_exists=if_exists, index=False)
                        print(f"Chunk of {len(df_chunk)} rows loaded successfully.")

                        if_exists = "append" 

    print("All CSV files processed successfully!")
