# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-23 11:24:51
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Demo Execution Plan for Sales Process Automation

## Overview

This execution plan provides a comprehensive, step-by-step guide for building and demonstrating a sophisticated Sales Process Automation solution using IBM watsonx Orchestrate. The plan is tailored for a B2B technology client aiming to streamline their quote-to-cash cycle. The core challenge is the manual, error-prone, and time-consuming process that sales representatives follow, involving multiple systems like CRM, quoting tools, and finance platforms.

This demo will showcase a powerful, multi-agent architecture where a central **Sales Process Orchestrator** agent intelligently coordinates tasks among specialized collaborator agents responsible for CRM operations, quote generation, compliance checks, and financial processing. By automating this workflow, the client will see a direct path to increased sales velocity, reduced operational overhead, improved data accuracy, and enhanced compliance adherence. The solution leverages Python-based tools with realistic synthetic data and a document-based knowledge base for product information, demonstrating the full power of the watsonx Orchestrate Agent Development Kit (ADK).

## Prerequisites

Before beginning the implementation, ensure your environment is set up with the following components. This setup is crucial for a smooth development and demonstration experience.

1.  **IBM watsonx Orchestrate ADK**: The Agent Development Kit must be installed and configured. This is the primary toolset for building, importing, and managing agents and tools. Refer to the official documentation for installation instructions.
    ```bash
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
```text
InnovateTech Solutions - Official Product Catalog

Product: QuantumLeap CRM Suite
SKU: QL-CRM-001
Description: An AI-powered Customer Relationship Management platform designed for enterprise-level sales teams. Features include predictive lead scoring, automated sales funnels, and deep analytics.
Tiers:
- Standard: $150/user/month. Includes core CRM features.
- Professional: $250/user/month. Adds advanced AI analytics and forecasting.
- Enterprise: $400/user/month. Includes all features plus dedicated support and custom integrations.

Product: DataWeave BI Platform
SKU: DW-BI-002
Description: A comprehensive Business Intelligence tool for data visualization and reporting. Connects to over 100 data sources to provide real-time dashboards.
Tiers:
- Basic: $100/user/month. Up to 10 dashboards and 5 data sources.
- Advanced: $200/user/month. Unlimited dashboards, advanced data connectors, and embedded analytics.

Product: SecureFlow Cybersecurity Shield
SKU: SF-CS-003
Description: A managed threat detection and response service. Provides 24/7 monitoring and incident response to protect corporate assets.
Tiers:
- Essentials: $5,000/month. Covers up to 50 endpoints.
- Proactive: $12,000/month. Covers up to 200 endpoints with proactive threat hunting.
```

#### 1.2. Create the Knowledge Base Configuration File

Next, define the knowledge base in a YAML file. This configuration points to the document we just created and specifies the embedding model to use for vectorization.

**File:** `knowledge_base/product_catalog_kb.yaml`
```yaml
spec_version: v1
kind: knowledge_base
name: product_catalog_kb
description: >
  Contains detailed information about InnovateTech Solutions' product offerings, including SKUs, descriptions, features, and pricing tiers for the QuantumLeap CRM, DataWeave BI, and SecureFlow Cybersecurity products. Use this to answer questions about product capabilities and pricing.
documents:
  - "knowledge_base/documents/InnovateTech_Product_Catalog.txt"
vector_index:
  embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
```

## Step 2: Create the Python Tools

Tools are the building blocks that allow agents to interact with external systems and perform actions. We will create four sets of tools, each in its own Python file, corresponding to the specialized functions of our collaborator agents. Each tool generates realistic synthetic data to simulate interactions with live systems like Salesforce, a quoting engine, a compliance database, and a billing system.

#### 2.1. CRM Tools (`crm_tools.py`)

These tools simulate interactions with a Customer Relationship Management (CRM) system. They handle tasks like fetching customer data, updating sales opportunities, and creating official records in the CRM.

**Business Value:** Automating CRM tasks is a primary driver of sales productivity. These tools eliminate manual data entry, ensure data consistency, and provide a single source of truth for customer interactions, freeing up sales reps to focus on selling.

**File:** `tools/crm_tools.py`
```python
import json
import random
from datetime import datetime, timedelta
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def get_account_details(account_name: str) -> str:
    """
    Retrieves detailed information for a given account from the CRM system.

    Args:
        account_name (str): The name of the account to search for (e.g., "Global Tech Inc.").

    Returns:
        str: A JSON string containing account details like ID, industry, annual revenue, and primary contact.
    """
    companies = ["Global Tech Inc.", "Innovate Dynamics", "Quantum Solutions", "Pioneer Digital"]
    if account_name not in companies:
        return json.dumps({"error": "Account not found."})

    account_data = {
        "Global Tech Inc.": {"id": "ACC1001", "industry": "Technology", "annual_revenue": 50000000, "primary_contact": "jane.doe@globaltech.com"},
        "Innovate Dynamics": {"id": "ACC1002", "industry": "Manufacturing", "annual_revenue": 75000000, "primary_contact": "john.smith@innovatedynamics.com"},
        "Quantum Solutions": {"id": "ACC1003", "industry": "Finance", "annual_revenue": 120000000, "primary_contact": "susan.jones@quantumsolutions.com"},
        "Pioneer Digital": {"id": "ACC1004", "industry": "Retail", "annual_revenue": 30000000, "primary_contact": "peter.williams@pioneerdigital.com"}
    }
    return json.dumps(account_data[account_name])

@tool(permission=ToolPermission.ADMIN)
def

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
