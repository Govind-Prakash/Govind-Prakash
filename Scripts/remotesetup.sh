#!/bin/bash

# Stop the script on any error
set -e

echo "Starting remote setup..."

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential curl wget git unzip software-properties-common

# Install Chromium Browser
sudo apt install -y chromium-browser

# Install Wine
sudo dpkg --add-architecture i386
sudo mkdir -pm755 /etc/apt/keyrings
wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -cs)/winehq-$(lsb_release -cs).sources
sudo apt update
sudo apt install -y --install-recommends winehq-stable

# Install R and R Base
sudo apt install -y r-base

# Install RStudio
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-2023.09.2-567-amd64.deb -O ~/rstudio.deb
sudo apt install -y ~/rstudio.deb
rm ~/rstudio.deb

# Install Python3 and pip
sudo apt install -y python3 python3-pip

# Install Anaconda (full version)
if [ ! -d "$HOME/anaconda" ]; then
    echo "Installing Anaconda..."
    wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
    bash ~/anaconda.sh -b -p $HOME/anaconda
    echo 'export PATH="$HOME/anaconda/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    rm ~/anaconda.sh
else
    echo "Anaconda already installed."
fi

# Install Miniconda (lightweight version)
if [ ! -d "$HOME/miniconda" ]; then
    echo "Installing Miniconda..."
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
    bash ~/miniconda.sh -b -p $HOME/miniconda
    echo 'export PATH="$HOME/miniconda/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    rm ~/miniconda.sh
else
    echo "Miniconda already installed."
fi

# Configure Bioconda Channels for Conda
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Create Data Analysis Environment
conda create -n data_analysis_env -y python=3.9 numpy pandas matplotlib seaborn jupyter

# Create Bioinformatics Environment
conda create -n bioinformatics_env -y python=3.9 samtools bwa snakemake

# Create Machine Learning Environment
conda create -n ml_env -y python=3.9 tensorflow pytorch torchvision torchaudio scikit-learn glmnet -c pytorch -c conda-forge

# Install VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update
sudo apt install -y code

# Install Docker
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Install JupyterLab for all environments
conda install -n data_analysis_env -y jupyterlab
conda install -n bioinformatics_env -y jupyterlab
conda install -n ml_env -y jupyterlab

# Install VS Code Server (for remote development)
if [ ! -d "$HOME/vscode-server" ]; then
    echo "Installing VS Code Server..."
    wget https://code.visualstudio.com/sha/download?build=stable&os=linux-x64 -O ~/vscode-server.tar.gz
    mkdir -p $HOME/vscode-server
    tar -xvzf ~/vscode-server.tar.gz -C $HOME/vscode-server --strip-components 1
    rm ~/vscode-server.tar.gz
    echo 'export PATH="$HOME/vscode-server/bin:$PATH"' >> ~/.bashrc
else
    echo "VS Code Server already installed."
fi

# Cleanup unnecessary files
echo "Cleanup..."
conda clean -a -y

echo "Remote setup complete! Please restart your terminal or run 'source ~/.bashrc' to apply changes."
