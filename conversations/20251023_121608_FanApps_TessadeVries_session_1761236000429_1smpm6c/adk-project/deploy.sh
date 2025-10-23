#!/bin/bash
# Generated deployment script

# Script block 1
pip install "ibm-watsonx-orchestrate[all]"
    ```
3.  **watsonx Orchestrate Environment**: You must have an active watsonx Orchestrate environment configured. Follow the ADK documentation to initialize your environment, whether it's the Developer Edition (local) or a SaaS instance.
    ```bash
    # Run this command and follow the prompts to add and activate your environment
    orchestrate env add
    ```
4.  **Text Editor/IDE**: A code editor like Visual Studio Code is highly recommended for editing YAML and Python files.
5.  **Command-Line Interface (CLI)**: You will need a terminal or command prompt to execute the `orchestrate` CLI commands for importing and managing assets.

## Step 1: Project Structure Setup

A well-organized project structure is crucial for managing agents and their associated tools. Create the following directory structure in your local workspace. This separation of concerns simplifies development, debugging, and future maintenance.

