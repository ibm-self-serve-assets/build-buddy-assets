#!/bin/bash
# Generated deployment script

# Script block 1
pip install ibm-watsonx-orchestrate
    ```
2.  **Python Environment**: A Python 3.9+ environment is required. It is recommended to use a virtual environment to manage dependencies.
3.  **Project Directory**: Create a dedicated project directory to organize all configuration files, tools, and documents.
    ```bash
    mkdir innovatehealth_demo
    cd innovatehealth_demo
    mkdir agents tools knowledge_base_docs
    ```
4.  **Required Python Packages**: Create a `requirements.txt` file in the root of your project directory with the following content. These packages will be used by the custom Python tools.
    ```text
    # requirements.txt
    requests
    python-dotenv
    ```
    Install them using:
    ```bash
    pip install -r requirements.txt
    ```
5.  **Sample Documents for Knowledge Base**: Create two sample documents inside the `knowledge_base_docs` directory to populate the knowledge base.
    *   `knowledge_base_docs/employee_handbook.txt`: A text file containing sample FAQ content about company policies.
    *   `knowledge_base_docs/remote_work_policy.pdf`: A placeholder PDF document (can be any simple PDF) representing a policy document.

## Step 1: Create the Knowledge Base

The knowledge base will enable the "Empower" agent to answer general questions about company policies using Retrieval-Augmented Generation (RAG). This component is crucial for deflecting common inquiries from specialized support teams. We will create a built-in knowledge base that ingests local documents.

**Business Value**: This provides instant, 24/7 access to authoritative company information, reducing the burden on HR staff and ensuring employees receive consistent, accurate answers to policy-related questions.

Create the file `empower_kb.yaml` in the project's root directory:

**`empower_kb.yaml`**

