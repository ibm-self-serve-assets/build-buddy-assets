#!/bin/bash
# Generated deployment script

# Script block 1
pip install "ibm-watsonx-orchestrate[adk-all]"
    ```
2.  **Python Environment**: A Python version of 3.11 or higher is required. It's highly recommended to use a virtual environment to manage dependencies.
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows use `venv\Scripts\activate`
    ```
3.  **watsonx Orchestrate Tenant**: You need access to an active watsonx Orchestrate tenant. You must have the environment credentials (API key, environment URL) ready to configure the ADK.
    ```bash
    # Run this command and follow the prompts to add your environment
    orchestrate env add
    # Activate the newly added environment
    orchestrate env activate <your_env_name>
    ```
4.  **Text Editor/IDE**: A code editor like Visual Studio Code is recommended for creating and editing the Python and YAML files.

## Step 1: Project Setup and Directory Structure

A well-organized project structure is essential for managing the various components of the demo. Create the following directory structure in your local development environment.

