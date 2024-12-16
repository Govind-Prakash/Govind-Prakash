#!/bin/bash

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y build-essential curl wget git unzip

# Install Git
sudo apt install -y git

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

# Install Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh -O ~/anaconda.sh
bash ~/anaconda.sh -b -p $HOME/anaconda
echo 'export PATH="$HOME/anaconda/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Configure Bioconda Channels for Conda
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Create Data Analysis Environment
conda create -n data_analysis_env -y python=3.9 numpy pandas matplotlib jupyter

# Create Bioinformatics Environment
conda create -n bioinformatics_env -y python=3.9 samtools bwa snakemake

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

# Cleanup
rm ~/anaconda.sh
echo "Setup complete! Please restart your terminal or run 'source ~/.bashrc'"
