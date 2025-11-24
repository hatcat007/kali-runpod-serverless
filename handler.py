import runpod
import subprocess
import shlex

def handler(job):
    """
    Handler funktion der køres hver gang et job modtages.
    """
    job_input = job.get("input", {})
    
    # Hent kommandoen fra inputtet, f.eks. {"command": "nmap -sV google.com"}
    # Hvis ingen kommando gives, køres 'uname -a' som test.
    command = job_input.get("command", "uname -a")
    
    try:
        # Sikkerhedsbemærkning: I et produktionsmiljø bør man være meget påpasselig 
        # med shell=True. Her bruger vi det for at give fuld adgang til Kali-tools.
        
        print(f"Udfører kommando: {command}")
        
        # Kør kommandoen og fang output
        result = subprocess.run(
            command,
            shell=True,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        # Returner outputtet som JSON
        return {
            "stdout": result.stdout,
            "stderr": result.stderr,
            "return_code": result.returncode
        }

    except Exception as e:
        return {"error": str(e)}

# Start RunPod serverless lytteren
runpod.serverless.start({"handler": handler})
