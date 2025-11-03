#!/usr/bin/env python3

import yaml
import os
import subprocess

def print_banner():
    banner = '''
 ______     __     ______     __    __     ______     __   __     ______     __  __     ______  
/\  ___\   /\ \   /\  ___\   /\ "-./  \   /\  __ \   /\ "-.\ \   /\  __ \   /\ \/\ \   /\__  _\ 
\ \___  \  \ \ \  \ \ \__ \  \ \ \-./\ \  \ \  __ \  \ \ \-.  \  \ \  __ \  \ \ \_\ \  \/_/\ \/ 
 \/\_____\  \ \_\  \ \_____\  \ \_\ \ \_\  \ \_\ \_\  \ \_\\"\_\  \ \_\ \_\  \ \_____\    \ \_\ 
  \/_____/   \/_/   \/_____/   \/_/  \/_/   \/_/\/_/   \/_/ \/_/   \/_/\/_/   \/_____/     \/_/ 
                                                                                                 
 __    __     ______     ______     ______                                                       
/\ "-./  \   /\  ___\   /\  ___\   /\  __ \                                                      
\ \ \-./\ \  \ \  __\   \ \ \__ \  \ \  __ \                                                     
 \ \_\ \ \_\  \ \_____\  \ \_____\  \ \_\ \_\                                                    
  \/_/  \/_/   \/_____/   \/_____/   \/_/\/_/                                                    
                                                                                                 
 ______     ______     ______     ______                                                         
/\  ___\   /\  __ \   /\  == \   /\  ___\                                                        
\ \ \____  \ \ \/\ \  \ \  __<   \ \  __\                                                        
 \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\                                                      
  \/_____/   \/_____/   \/_/ /_/   \/_____/                                        
'''
    print(banner)

def read_config():
    with open('conf/conf.yaml', 'r') as file:
        return yaml.safe_load(file)

def start_services(config):
    services = config.get('services', {})

    # Define startup order for proper dependencies
    startup_order = [
        'postgres',      # Database first
        'redis',         # Cache second
        'miningcore',    # Pool third (depends on DB and Redis)
        'mining-wave-api',  # API (depends on DB)
        'nurse-shark-bot',  # Bot
        'nginx'          # Nginx last (reverse proxy for everything)
    ]

    print("\nStarting services in dependency order...\n")

    for service in startup_order:
        if services.get(service, False):
            print(f"✓ Starting {service}...")
            result = subprocess.run(
                ['docker-compose', 'up', '-d', service],
                capture_output=True,
                text=True
            )
            if result.returncode != 0:
                print(f"  ✗ Error starting {service}: {result.stderr}")
            else:
                print(f"  ✓ {service} started successfully")
        else:
            print(f"⊘ {service} is disabled in configuration")

if __name__ == "__main__":
    print_banner()
    print("Starting Sigmanaut Node Core services...")
    config = read_config()
    start_services(config)
    print("Startup complete.")