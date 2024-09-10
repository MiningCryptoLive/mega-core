
```
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
```
# sigs-mega-core
Ergo Mining Pool Operations Core made for Sigmanaut Mining Pool

## Table of Contents

1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Usage](#usage)
6. [Services](#services)
7. [Contributing](#contributing)
8. [License](#license)

## Features

- **Dashboard**: A web-based interface for monitoring mining operations
- **SharkPool Monitor**: Real-time monitoring of mining pool activities
- **Database Integration**: PostgreSQL database for storing mining data
- **Nginx Reverse Proxy**: Efficient routing and load balancing
- **Flexible Configuration**: Easy service management through YAML configuration

## Prerequisites

- Docker
- Docker Compose
- Python 3.7+
- Git

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/sigmanaut-node-core.git
   cd sigmanaut-node-core
   ```

2. Initialize and update submodules:
   ```
   git submodule update --init --recursive
   ```

3. Install required Python packages:
   ```
   pip install pyyaml
   ```

## Configuration

1. Edit `conf/conf.yaml` to enable or disable services as needed:
   ```yaml
   services:
     dash: true
     sharkui: true
     nginx: true
     bonus: false
   ```

3. (Optional) Modify environment variables in `.env` file for custom settings.

## Usage

To start the Sigmanaut Node Core services:

```
./start_services.py
```

This script will read the configuration from `conf/conf.yaml` and start the enabled services.

## Services

- **ui-db**: PostgreSQL database for storing mining data
- **dash**: Web-based dashboard for monitoring mining operations
- **sharkui**: SharkPool monitoring interface
- **nginx**: Reverse proxy for routing requests to appropriate services
- **bonus**: (Optional) Additional service for bonus calculations

## Contributing

We welcome contributions to the Sigmanaut Node Core project. Please read our [CONTRIBUTING.md](CONTRIBUTING.md) file for details on our code of conduct and the process for submitting pull requests.
