#!/bin/bash

# URL do feed RSS do podcast
FEED="https://feeds.megaphone.fm/GLT7015620133"

python3 <<EOF

import requests
import xml.etree.ElementTree as ET
from email.utils import parsedate_to_datetime
import re
import subprocess
import os

# Baixa o conteúdo XML do feed RSS
xml = requests.get("$FEED").content

# Faz o parsing da estrutura XML
root = ET.fromstring(xml)

# Cria o diretório de saída
os.makedirs("podcast", exist_ok=True)

# Itera sobre todos os episódios
for item in root.findall("./channel/item"):

    # Extrai o título do episódio
    title = item.findtext("title", "sem titulo")

    # Extrai a data de publicação
    pubdate = item.findtext("pubDate")

    # Extrai o enclosure (arquivo de áudio)
    enclosure = item.find("enclosure")

    # Ignora entradas inválidas
    if enclosure is None:
        continue

    # URL do áudio
    url = enclosure.attrib.get("url")

    # Converte a data do RSS
    dt = parsedate_to_datetime(pubdate)

    # Formata para YYYY-MM-DD
    date = dt.strftime("%Y-%m-%d")

    # Sanitiza o nome do arquivo
    safe_title = re.sub(r'[/]', "-", title)

    # Nome final do arquivo
    filename = f"podcast/{date} - {safe_title}.mp3"

    print("Baixando:", filename)

    # Download com suporte a continuação
    subprocess.run([
        "wget",
        "-c",
        "-O",
        filename,
        url
    ])

EOF