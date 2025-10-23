#!/bin/bash
# Generated deployment script

# Script block 1
pip install ibm-watsonx-orchestrate
    ```
2.  **Python Environment**: A working Python environment (version 3.10 or later) is required to create the custom tools.
3.  **Orchestrate Environment Configuration**: Your ADK must be configured to connect to your watsonx Orchestrate environment. If this is your first time, run `orchestrate login` and follow the prompts. Verify your active environment with `orchestrate env`.
4.  **Project Directory Structure**: To keep the project organized, create the following directory structure in your workspace:
    ```
    /deal-desk-demo
    |-- /agents
    |-- /tools
    |-- /knowledge_base_docs
    |-- requirements.txt
    ```

## Step 1: Create the Knowledge Base for Compliance

The `Compliance_Agent` will use a knowledge base to verify that sales deals adhere to company policies. We will create a simple policy document and a YAML configuration file to define this knowledge base.

1.  **Create the Policy Document**:
    Inside the `/knowledge_base_docs` directory, create a file named `sales_policy.pdf`. For this demo, a simple text file converted to PDF will suffice. The content should outline basic discount rules.

    *Example Content for `sales_policy.txt` (to be saved as PDF):*
    ```
    Global Tech Solutions Inc. - Official Sales Policy
    Document Version: 4.1

    1. Standard Discount Tiers:
       - Up to 15% discount can be approved by Sales Directors.
       - Discounts between 15% and 25% require VP approval.
       - Any discount exceeding 25% requires Deal Desk review and CFO approval.

    2. Bundled Products:
       - The "Enterprise Suite" bundle has a maximum allowable discount of 30%.
       - Hardware components bundled with software subscriptions have a maximum discount of 10% on the hardware portion.

    3. Strategic Accounts:
       - Designated strategic accounts are eligible for an additional 5% discount, but the total must not exceed 30%.
    ```

2.  **Create the Knowledge Base YAML Configuration**:
    Inside the root `deal-desk-demo` directory, create a file named `sales_policy_kb.yaml`. This file tells Orchestrate how to create the knowledge base from our document.

    ```yaml
    # sales_policy_kb.yaml
    spec_version: v1
    kind: knowledge_base
    name: sales_policy_kb
    description: >
      Contains the official sales, discount, and bundling policies for Global Tech Solutions Inc.
      Use this to verify if a proposed deal's discount structure is compliant with company rules.
    documents:
      - "knowledge_base_docs/sales_policy.pdf"
    vector_index:
      embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
    ```

## Step 2: Create Custom Python Tools

The tools are the functional backbone of our agents, performing specific actions like fetching data from external systems. We will create three sets of tools, each in its own Python file within the `/tools` directory.

### 2.1. Salesforce Data Tools

These tools simulate fetching data from a Salesforce CRM system.

**Business Value**: Automates the retrieval of critical customer and deal information, eliminating manual data entry and ensuring the agent works with the most current data from the system of record.

**Technical Implementation**: The functions generate realistic, structured synthetic data representing typical Salesforce objects like Opportunities and Accounts.

Create the file `/tools/salesforce_tools.py`:

