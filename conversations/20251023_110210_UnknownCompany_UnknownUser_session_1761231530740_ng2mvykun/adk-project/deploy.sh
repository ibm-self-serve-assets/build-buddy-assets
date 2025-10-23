#!/bin/bash
# Generated deployment script

# Script block 1
pip install ibm-watsonx-orchestrate
    ```
3.  **watsonx Orchestrate Environment**: You must have access to an active watsonx Orchestrate environment and be logged in via the CLI.
    ```bash
    orchestrate login
    ```
4.  **Project Directory**: Create a dedicated folder structure to organize your files. This is a best practice for managing complex projects.
    ```bash
    mkdir orchestrate-logistics-demo
    cd orchestrate-logistics-demo
    mkdir agents
    mkdir tools
    ```
5.  **Text Editor/IDE**: A code editor like Visual Studio Code is recommended for editing Python and YAML files.

## Step 1: Create Python Tools for Business Automation

Our automation relies on a set of custom tools that perform specific business functions by simulating interactions with various enterprise systems (ERP, CRM, Compliance DB). Each tool is a Python function decorated with `@tool` and includes a detailed docstring that Orchestrate uses to understand its purpose, inputs, and outputs.

### 1.1. Order Processing Tools

These tools handle the initial validation and inventory checking for new sales orders, simulating interactions with an Order Management System or ERP.

**Business Value:** Automating these initial steps reduces manual data entry errors, provides immediate feedback on order feasibility, and prevents downstream issues caused by incorrect data or stockouts.

**File:** `tools/order_processing_tools.py`

