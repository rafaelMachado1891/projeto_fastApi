import os

import camelot
import matplotlib
import matplotlib.pyplot as plt
import pandas as pd

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

plt.show()

# print(tables[0].df)

df_total = pd.concat(
    [table.df for table in tables] + [table.df for table in pages_end],
    ignore_index=True
)

print(df_total)

df_total.to_csv("dados.csv", index=False)