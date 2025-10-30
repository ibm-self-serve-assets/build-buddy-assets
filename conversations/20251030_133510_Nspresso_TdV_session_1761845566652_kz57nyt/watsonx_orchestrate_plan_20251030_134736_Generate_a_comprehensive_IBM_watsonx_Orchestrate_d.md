# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-30 13:47:36
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: FinCorp Regulatory Compliance Demo

## Overview

This execution plan provides a comprehensive, step-by-step guide for building a sophisticated IBM watsonx Orchestrate demonstration tailored for a financial services client, "FinCorp." The primary business challenge this demo addresses is the complex, time-consuming, and error-prone process of regulatory compliance reporting. Manual data gathering, risk analysis, and report generation create significant operational overhead and increase the risk of non-compliance.

This plan implements a multi-agent system that automates the end-to-end compliance workflow. A central **Compliance Supervisor Agent** interprets high-level user requests from a compliance officer and orchestrates a team of specialized collaborator agents: a **Data Processing Agent** to gather and clean financial data, a **Risk Analysis Agent** to assess transactions against regulatory rules, and a **Reporting Agent** to generate audit-ready documents. This solution showcases how watsonx Orchestrate can transform a critical business process, enhancing efficiency, accuracy, and governance.

## Prerequisites

Before beginning, ensure your development environment is correctly configured. This is crucial for a smooth implementation and successful demo.

1.  **IBM watsonx Orchestrate ADK**: The Agent Development Kit (ADK) must be installed and configured. This is the core command-line tool used to build, import, and manage agents and tools.
    ```bash
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

```text
fincorp_demo/
├── agents/
│   ├── 01_data_processing_agent.yaml
│   ├── 02_risk_analysis_agent.yaml
│   ├── 03_reporting_agent.yaml
│   └── 04_compliance_supervisor_agent.yaml
├── tools/
│   ├── data_processing_tools.py
│   ├── risk_analysis_tools.py
│   └── reporting_tools.py
├── knowledge_base/
│   ├── docs/
│   │   └── fincorp_compliance_policy_v1.2.txt
│   └── regulatory_kb.yaml
└── requirements.txt
```

**Action**: Create these folders and empty files to prepare for the subsequent steps.

## Step 2: Create the Knowledge Base

The Knowledge Base will provide the Risk Analysis Agent with contextual information about FinCorp's internal compliance policies, allowing it to make more informed decisions. We will create a simple text file representing a policy document and a YAML file to define the knowledge base.

### Business Value
A knowledge base grounds the agent's responses in factual, approved documentation. This is critical in a regulatory context, as it prevents the LLM from "hallucinating" compliance rules and ensures that all analysis is based on the company's official policies, reducing legal and financial risk.

### 2.1. Create the Policy Document

Create the file `knowledge_base/docs/fincorp_compliance_policy_v1.2.txt` with the following content:

```text
# FinCorp Global Compliance Policy v1.2

## Section 1: Transaction Monitoring Thresholds
- All transactions exceeding $10,000 USD must be flagged for standard review.
- All transactions exceeding $50,000 USD must be flagged for enhanced due diligence.
- Any transaction involving a sanctioned entity, regardless of amount, must be immediately escalated to the Chief Compliance Officer.

## Section 2: Anomaly Detection Rules
- Multiple transactions from a single source to a single destination within a 24-hour period that aggregate to over $9,500 should be considered potential structuring and flagged.
- Transactions with incomplete or missing beneficiary information are considered high-risk.
- Transactions originating from or destined for high-risk jurisdictions require a risk score adjustment of +20 points.
```

### 2.2. Create the Knowledge Base YAML Configuration

Create the file `knowledge_base/regulatory_kb.yaml`. This file tells Orchestrate to create a built-in knowledge base named `regulatory_kb` and ingest the specified document.

```yaml
spec_version: v1
kind: knowledge_base
name: regulatory_kb
description: >
  Contains FinCorp's internal compliance policies, including transaction monitoring thresholds,
  rules for anomaly detection, and guidelines for handling high-risk activities. Use this to
  cross-reference transactions and analysis against official company policy.
documents:
  - "./knowledge_base/docs/fincorp_compliance_policy_v1.2.txt"
vector_index:
  embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
```

## Step 3: Develop the Python Tools

Tools are the building blocks that allow agents to interact with data and perform actions. We will create a set of Python functions, each decorated with `@tool`, to simulate collecting, processing, analyzing, and reporting on financial data.

### 3.1. Create `requirements.txt`

First, create the `requirements.txt` file in the root of your `fincorp_demo` directory. This ensures any necessary libraries are available.

```text
# No external libraries needed for this mock data demo
# If using real APIs, add packages like 'requests', 'pandas', etc. here.
```

### 3.2. Data Processing Tools

**Business Value**: Automating data collection and cleaning is the first step in reducing manual effort. These tools ensure that the data fed into the analysis engine is consistent, standardized, and complete, which dramatically improves the accuracy of subsequent risk assessments.

Create the file `tools/data_processing_tools.py` with the following complete code:

```python
# tools/data_processing_tools.py
import json
import random
from datetime import datetime, timedelta
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(name="collect_transaction_data", description="Collects raw transaction data from source systems for a given date range.", permission=ToolPermission.ADMIN)
def collect_transaction_data(days_ago: int = 7) -> str:
    """
    Simulates fetching a list of financial transactions from the last few days from various source systems.

    Args:
        days_ago (int): The number of past days to collect transaction data for. Defaults to 7.

    Returns:
        str: A JSON string representing a list of transaction records.
    """
    transactions = []
    sources = ["Wire Transfer", "ACH", "Internal Transfer", "Crypto Exchange"]
    companies = ["Innovate Corp", "Global Exports LLC", "Tech Solutions Inc.", "Secure Holdings", "Quantum Traders", " sanctioned_entity_co"]
    for i in range(15):
        transaction_date = datetime.now() - timedelta(days=random.randint(0, days_ago))
        transactions.append({
            "transaction_id": f"TXN{random.randint(10000, 99999)}{i}",
            "date": transaction_date.isoformat(),
            "amount": round(random.uniform(500.0, 75000.0), 2),
            "currency": "USD",
            "source": random.choice(sources),
            "sender": random.choice(companies),
            "recipient": "FinCorp Internal Account",
            "metadata": {"raw_status": random.choice(["completed", "pending", "flagged", "failed", "COMPLETED", "C"])}
        })
    # Add a transaction that is clearly high risk
    transactions.append({
        "transaction_id": "TXN-HIGH-RISK-001", "date": (datetime.now() - timedelta(days=1)).isoformat(),
        "amount": 99000.00, "currency": "USD", "source": "Wire Transfer",
        "sender": "Shady Deals Inc.", "recipient": "FinCorp Internal Account",
        "metadata": {"raw_status": "completed"}
    })
    return json.dumps(transactions)

@tool(name="cleanse_and_normalize_data", description="Cleanses and normalizes a list of raw transaction data.", permission=ToolPermission.ADMIN)
def cleanse_and_normalize_data(raw_transactions_json: str) -> str:
    """
    Takes a JSON string of raw transactions, cleanses the data, and standardizes field values.

    Args:
        raw_transactions_json (str): A JSON string representing a list of raw transaction records.

    Returns:
        str: A JSON string representing a list of cleansed and normalized transaction records.
    """
    raw_transactions = json.loads(raw_transactions_json)
    cleansed_data = []
    status_map = {"completed": "COMPLETED", "pending": "PENDING", "flagged": "FLAGGED", "failed": "FAILED", "c": "COMPLETED"}
    
    for tx in raw_transactions:
        raw_status = str(tx["metadata"]["raw_status"]).lower()
        normalized_status = status_map.get(raw_status, "UNKNOWN")
        
        cleansed_tx = {
            "transaction_id": tx["transaction_id"],
            "date": tx["date"],
            "amount": float(tx["amount"]),
            "currency": tx["currency"],
            "source": tx["source"],
            "sender": tx["sender"],
            "recipient": tx["recipient"],
            "status": normalized_status
        }
        cleansed_data.append(cleansed_tx)
    return json.dumps(cleansed_data)
```

### 3.3. Risk Analysis Tools

**Business Value**: These tools automate the core logic of compliance analysis. By programmatically assessing risk based on predefined rules and querying internal policies, they provide consistent, auditable, and rapid risk scoring, freeing up human analysts to focus on complex edge cases.

Create the file `tools/risk_analysis_tools.py` with the following complete code:

```python
# tools/risk_analysis_tools.py
import json
from ibm_watsonx_orche

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
