# podGrabber

- ![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
- ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
- ![Rss](https://img.shields.io/badge/rss-F88900?style=for-the-badge&logo=rss&logoColor=white)
- ![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

Uma ferramenta leve de linha de comando para **baixar episódios de podcasts** diretamente. O PodGrabber faz o parsing de feeds RSS/XML, extrai os metadados dos episódios e baixa os arquivos. Projetado para ambientes Linux e fluxos de automação.

---

## Funcionalidades

- *Parsing de feeds RSS/XML*
- *Download automático de MP3*
- *Arquivos nomeados com data*
- *Sanitização segura de nomes de arquivos*
- *Continuação de downloads interrompidos*
- *Fluxo otimizado para Linux*
- *Compatível com Megaphone, Podbean e feeds RSS padrão*
- *Implementação simples usando Bash + Python*

---

## Requisitos
- GNU/Linux Debian / GNU/Linux Ubuntu / Linux
- Python 3
- wget
- requests
- Instale as dependências: ```text python3 python3-pip wget```


## Como usar

1. Edite a URL do feed RSS dentro do script:
   FEED="[insira o link do rss ou feed]"


2. Execute no terminal:
   ```text $ chmod +x baixar_podcast.sh```
   
- *Os episódios baixados serão salvos em:*
```text /home/[usuário]/podcast/```


3. Estrutura do projeto:
```text
podgrabber/
├── baixar_podcast.sh
├── README.md
├── LICENSE
├── .gitignore
└── downloads/
```

4. Script

```python
#!/bin/bash

# URL do feed RSS do podcast
FEED="h[insira o link do rss ou feed]"

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
```
5. Como funciona

O script executa os seguintes passos:
1. Baixa o feed RSS/XML
2. Faz o parsing de todos os itens <item>
3. Extrai:
título do episódio
data de publicação
URL do MP3
4. Formata os arquivos como:
```aaaa-mm-dd - Título do Episódio.mp3```
5. Faz o download usando wget

6. Plataformas compatíveis
O PodGrabber funciona com feeds RSS padrão, incluindo:
> Megaphone
> Podbean
> RSS genérico

📚 Também serve como exemplo prático de:
- `Parsing XML`
- `Requisições HTTP`
- `Integração Bash/Python`
- `Automação via CLI`
- `Manipulação de arquivos no Linux`
- `Expressões regulares`
- `Gerenciamento de processos`

#python · #automação · #parsing · #xml · #rss · #cli · #bash · #linux

