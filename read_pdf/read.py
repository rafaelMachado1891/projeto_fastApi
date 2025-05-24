import os
import camelot
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv
import psycopg2

load_dotenv()

database = os.getenv("DB_NAME_PROD")
username = os.getenv("DB_USER_PROD")
host = os.getenv("DB_HOST_PROD")
password = os.getenv("DB_PASS_PROD")
port = os.getenv("DB_PORT_PROD")

# URL de conexão com o banco de dados
DATABASE_URL = (f"postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}")

engine = create_engine(DATABASE_URL)

print(matplotlib.get_backend())

file_name = "BALANCETE MAIO 2023 DITAL"
#path = os.path.abspath(f"..\data\{file_name}.pdf")
path = (f'..\data\{file_name}.pdf')

tables = camelot.read_pdf(
    path,
    flavor="stream",
    table_areas=["12, 759,549,31"],
    #columns=["70, 105, 160, 230, 285, 340, 380, 446"],
    #strip_text=".\n",
    pages="1-4",
)

pages_end = camelot.read_pdf(
    path,
    flavor="stream",
    table_areas=["12, 759,549,224"],
    pages="5"
)

# print(tables[0].parsing_report)

camelot.plot(tables[0], kind="contour")

# plt.show()

# print(tables[0].df)

df_total = pd.concat(
    [table.df for table in tables] + [table.df for table in pages_end],
    ignore_index=True
)

df = df_total

df.columns = df.iloc[0]

df = df[df['Reduzido'] != 'Reduzido']

def tratar_coluna_saldo(saldo):
    i= saldo.replace(".","").replace(",",".")
    i=i.split(")")
    i=i[0]
    i=i.replace("(", "-")
    return i 

def tratar_coluna_conta(conta):
    i=conta.replace("(-)", "")
    i=i.strip()
    return i

df["Saldo atual"] = df["Saldo atual"].apply(tratar_coluna_saldo)
df["Nome da conta"] = df["Nome da conta"].apply(tratar_coluna_conta)

df = df.rename(columns={"Reduzido": "id_conta",
                        "Nome da conta": "conta",
                        "Saldo atual": "saldo"
                        })

tipo_de_dados = {
    "id_conta": int,
    "conta": str,
    "saldo": float
}

df=df.astype(tipo_de_dados)

df.to_sql(
    name="balancete",
    schema=os.getenv('DB_SCHEMA_PROD'),  # Schema do banco de destino
    if_exists='replace',          # Adicionar dados à tabela existente,
    con=engine,
    index=False                  # Não incluir o índice do DataFrame
    )