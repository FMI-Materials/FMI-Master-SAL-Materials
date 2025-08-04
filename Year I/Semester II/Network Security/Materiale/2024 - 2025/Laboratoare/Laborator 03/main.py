import pandas as pd

df = pd.read_csv("packetz.csv")

encr_flag = ""
text = ""
for i in range(len(df["Differentiated Services Field"])):
    text += bytes.fromhex(df["Differentiated Services Field"][i][2:]).decode("utf-8")
    encr_flag += df["Differentiated Services Field"][
        len(df["Differentiated Services Field"]) - i - 1
    ][2:]

# print(text)
# print(encr_flag)


flag = ""
key = "OLKC" * 17 + "OL"
for i in range(len(df["Differentiated Services Field"])):
    flag += chr(
        int(
            df["Differentiated Services Field"][
                len(df["Differentiated Services Field"]) - i - 1
            ],
            0,
        )
        ^ ord(key[i])
    )

print(flag)
