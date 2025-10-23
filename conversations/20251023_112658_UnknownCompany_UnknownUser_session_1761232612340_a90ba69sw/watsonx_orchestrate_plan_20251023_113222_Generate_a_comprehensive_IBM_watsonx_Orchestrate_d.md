# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-23 11:32:22
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: Deal Desk Automation

## Overview

This execution plan provides a comprehensive, step-by-step guide for creating a powerful IBM watsonx Orchestrate demo tailored for a client in the **Sales Operations** domain. The demo showcases an automated "Deal Desk" solution that addresses the common challenges of slow, manual, and error-prone approval processes for non-standard sales deals. By orchestrating multiple agents, tools, and a knowledge base, this solution automates data gathering from disparate systems (like Salesforce and SAP), performs profitability and compliance analysis, and generates a consolidated summary for a final human-in-the-loop review. This plan demonstrates how watsonx Orchestrate can significantly accelerate the sales cycle, improve decision-making accuracy, and ensure consistent policy enforcement.

The architecture consists of a `Deal_Desk_Supervisor_Agent` that coordinates three specialist collaborator agents: a `Salesforce_Agent` for CRM data, a `Financial_Agent` for ERP and pricing data, and a `Compliance_Agent` for policy verification against a knowledge base.

## Prerequisites

Before beginning, ensure your environment is set up with the following components. This setup is crucial for the successful creation, import, and execution of the agents and tools defined in this plan.

1.  **IBM watsonx Orchestrate ADK**: The Agent Development Kit must be installed. If you haven't installed it, run the following command:
    ```bash
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
```python
# /tools/salesforce_tools.py
import json
import random
from datetime import datetime, timedelta
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def get_salesforce_deal_details(opportunity_id: str) -> str:
    """
    Retrieves detailed information about a specific sales opportunity from Salesforce using its ID.

    Args:
        opportunity_id (str): The unique identifier for the sales opportunity (e.g., 'OPP-12345').

    Returns:
        str: A JSON string containing the deal's details, including account name, amount, close date, stage, and products involved.
    """
    deals = {
        "OPP-12345": {
            "opportunityId": "OPP-12345",
            "accountName": "Innovate Corp",
            "amount": 250000,
            "currency": "USD",
            "closeDate": (datetime.now() + timedelta(days=30)).strftime('%Y-%m-%d'),
            "stage": "Proposal/Price Quote",
            "products": [
                {"productName": "Quantum AI Analyzer", "quantity": 2, "unitPrice": 100000, "discount": 0.20},
                {"productName": "DataStream Pro License", "quantity": 50, "unitPrice": 1200, "discount": 0.20}
            ],
            "metadata": {"source": "Salesforce", "retrievedAt": datetime.now().isoformat()}
        }
    }
    if opportunity_id in deals:
        return json.dumps(deals[opportunity_id])
    else:
        return json.dumps({"error": "Opportunity ID not found."})

@tool(permission=ToolPermission.ADMIN)
def get_customer_account_history(account_name: str) -> str:
    """
    Fetches the historical sales and support ticket data for a given customer account name from Salesforce.

    Args:
        account_name (str): The name of the customer account (e.g., 'Innovate Corp

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
