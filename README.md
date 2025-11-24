# Kali Linux RunPod Serverless Worker

Dette repository indeholder koden til at køre en **Kali Linux** container som en Serverless Endpoint på [RunPod.io](https://runpod.io).

## Funktioner
- Baseret på `kalilinux/kali-rolling`.
- Installerer Python og RunPod SDK.
- Inkluderer `kali-tools-top10` (metasploit, nmap, wireshark, etc.).
- Accepterer shell-kommandoer via JSON input.

## Installation & Deployment

### 1. Byg Docker Image
Du skal have Docker installeret lokalt.

```bash
docker build --platform linux/amd64 -t dit-brugernavn/runpod-kali:v1 .
```

### 2. Push til Docker Hub
For at RunPod kan hente billedet, skal det ligge i et offentligt eller privat register (f.eks. Docker Hub).

```bash
docker push dit-brugernavn/runpod-kali:v1
```

### 3. Opret Template på RunPod

1. Gå til RunPod Console -> Serverless -> My Templates.
2. Klik New Template.
3. Udfyld felterne:
    - **Template Name**: Kali Serverless
    - **Container Image**: `dit-brugernavn/runpod-kali:v1` (Navnet fra trin 2)
    - **Container Disk**: 5 GB (Eller mere hvis du installerer store tools)
    - **Docker Command**: (Lad stå tom, Dockerfile styrer dette)

### 4. Opret Endpoint

1. Gå til Serverless -> New Endpoint.
2. Vælg din "Kali Serverless" template.
3. Vent på at worker'en starter (Cold start kan tage et par minutter første gang).

## Brug
Send en POST request til din Endpoint URL med din API Key.

**Eksempel Input (JSON):**
```json
{
  "input": {
    "command": "nmap -sV scanme.nmap.org"
  }
}
```

**Forventet Output:**
```json
{
  "output": {
    "stdout": "Starting Nmap 7.94 ...\nNmap scan report for ...",
    "stderr": "",
    "return_code": 0
  }
}
```
