#!/bin/bash
# Generated deployment script

# Script block 1
pip install ibm-watsonx-orchestrate
    ```
2.  **Python Environment**: A Python version compatible with the ADK (e.g., Python 3.10 or later) is required. You should also set up a virtual environment to manage dependencies.
    ```bash
    python3 -m venv .venv
    source .venv/bin/activate
    ```
3.  **Orchestrate CLI Login**: You must be logged into your watsonx Orchestrate environment via the CLI. This command authenticates your session and sets the active environment for all subsequent commands.
    ```bash
    orchestrate login
    ```
4.  **Project Directory Structure**: A well-organized directory is essential for managing the various components of the demo. Create the following structure:
    ```
    orchestrate-sales-demo/
    ├── agents/
    │   ├── 01_crm_specialist_agent.yaml
    │   ├── 02_quoting_engine_agent.yaml
    │   ├── 03_compliance_checker_agent.yaml
    │   ├── 04_finance_operations_agent.yaml
    │   └── 05_sales_process_orchestrator.yaml
    ├── tools/
    │   ├── crm_tools.py
    │   ├── quoting_tools.py
    │   ├── compliance_tools.py
    │   └── finance_tools.py
    ├── knowledge_base/
    │   ├── documents/
    │   │   └── InnovateTech_Product_Catalog.txt
    │   └── product_catalog_kb.yaml
    └── requirements.txt
    ```

## Step 1: Create the Knowledge Base

The knowledge base will provide the quoting agent with essential, up-to-date information about the company's products, features, and pricing tiers. This ensures that all generated quotes are based on accurate catalog data. We will use the built-in Milvus vector store provided by watsonx Orchestrate to ingest a simple text document.

#### 1.1. Create the Product Catalog Document

First, create the source document that will populate our knowledge base. This file contains mock data about the client's product offerings.

**File:** `knowledge_base/documents/InnovateTech_Product_Catalog.txt`

