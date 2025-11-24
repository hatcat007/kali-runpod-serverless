# Brug det officielle Kali Linux image
FROM kalilinux/kali-rolling

# Sæt environment variables for at undgå interaktive prompts under installation
ENV DEBIAN_FRONTEND=noninteractive

# Opdater systemet og installer Python, pip og basis værktøjer
# Du kan tilføje flere Kali-tools her (f.eks. sqlmap, nikto, metasploit-framework)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    kali-tools-top10 \
    nmap \
    curl \
    iputils-ping \
    libcap2-bin \
    && rm -rf /var/lib/apt/lists/*

# Fix for "Operation not permitted" on RunPod/Docker (removes file capabilities)
RUN setcap -r /usr/lib/nmap/nmap || true

# Opret et virtuelt miljø til Python (anbefalet på nyere Linux distroer)
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Kopier requirements og installer afhængigheder
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopier resten af koden (handleren)
COPY . .

# Start handleren. -u sikrer at logs printes med det samme (unbuffered)
CMD [ "python3", "-u", "handler.py" ]
