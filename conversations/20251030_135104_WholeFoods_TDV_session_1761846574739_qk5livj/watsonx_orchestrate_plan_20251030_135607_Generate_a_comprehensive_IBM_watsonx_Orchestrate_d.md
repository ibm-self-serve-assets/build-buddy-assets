# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-30 13:56:07
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: HR and Sales Automation

## 1. Overview

This execution plan provides a comprehensive, step-by-step guide for creating a powerful IBM watsonx Orchestrate demonstration tailored to your client's specific needs in Human Resources (HR) and Sales automation. The plan implements a multi-agent architecture where a supervisor agent intelligently routes tasks to specialized collaborator agents for HR and Sales. This showcases Orchestrate's ability to create sophisticated digital labor patterns that automate complex, multi-domain business processes.

The demo will feature an **HR Specialist Agent** capable of managing employee data, handling leave requests, and listing open positions. A **Sales Assistant Agent** will manage leads, generate quotes, and provide sales forecasts. Both agents will leverage a central **Knowledge Agent**, which uses a knowledge base to answer company policy questions, ensuring consistent and accurate information delivery. This layered approach demonstrates modularity, scalability, and the power of collaborative AI agents to streamline operations, reduce manual effort, and provide immediate, data-driven responses to business users.

## 2. Prerequisites

Before beginning, ensure your development environment is properly configured. This is crucial for a smooth implementation process.

*   **Python Environment**: A working installation of Python (version 3.9 or higher) is required.
*   **IBM watsonx Orchestrate ADK**: The Agent Development Kit (ADK) must be installed. If you haven't installed it, run the following command:
    ```bash
    pip install "ibm-watsonx-orchestrate"
    ```
*   **Orchestrate Environment**: You must have an active watsonx Orchestrate environment configured. This can be a SaaS environment or a local Developer Edition. Initialize your environment using:
    ```bash
    orchestrate env init
    ```
*   **Project Directory**: Create a dedicated directory for this demo to keep all files organized.
    ```bash
    mkdir orchestrate-hr-sales-demo
    cd orchestrate-hr-sales-demo
    mkdir -p agents tools knowledge_base/documents
    ```
*   **Required Python Packages**: Create a `requirements.txt` file with the following content. These packages will be used by our custom tools.
    ```text
    # requirements.txt
    requests
    ```
    Install them using:
    ```bash
    pip install -r requirements.txt
    ```

## 3. Step-by-Step Instructions

We will build the solution from the ground up, starting with the foundational knowledge base, then creating the tools, defining the specialized agents, and finally, orchestrating them with a supervisor agent.

### Step 1: Create the Knowledge Base

The Knowledge Base will serve as the single source of truth for company policies, enabling our agents to provide grounded, accurate answers to HR and Sales policy questions. We'll use the built-in Milvus vector store for simplicity.

**1. Create Mock Policy Documents:**

First, create two text files with sample content inside the `knowledge_base/documents/` directory.

*   **`knowledge_base/documents/employee_handbook.txt`**:
    ```text
    Innovate Inc. Employee Handbook

    Remote Work Policy:
    Employees are permitted to work remotely up to three days per week with manager approval. All remote work must be conducted from the employee's primary residence within the country. Requests for exceptions must be submitted to HR.

    Paid Time Off (PTO) Policy:
    Full-time employees accrue 15 days of PTO annually. PTO requests should be submitted through the HR portal at least two weeks in advance. For unplanned leave, employees must notify their manager as soon as possible.
    ```

*   **`knowledge_base/documents/sales_playbook.txt`**:
    ```text
    Innovate Inc. Sales Playbook

    Discounting Policy:
    Sales representatives are authorized to offer a standard discount of up to 10% without approval. Discounts between 10% and 20% require approval from the regional sales manager. Any discount exceeding 20% requires VP of Sales approval. All discounts must be documented in the CRM.

    Lead Engagement Protocol:
    All new inbound leads must be contacted within 4 business hours. The initial contact should be a personalized email, followed by a phone call within 24 hours. All interactions must be logged in the CRM.
    ```

**2. Define the Knowledge Base Configuration:**

Create the YAML file that defines the knowledge base and points to these documents.

*   **`knowledge_base/company_policy_kb.yaml`**:
    ```yaml
    spec_version: v1
    kind: knowledge_base
    name: company_policy_kb
    description: >
      Contains official company policies and procedures from the Innovate Inc. employee handbook and sales playbook.
      This knowledge base is the primary source for answering questions about remote work, paid time off, sales discounting, and lead engagement protocols.
    documents:
      - "knowledge_base/documents/employee_handbook.txt"
      - "knowledge_base/documents/sales_playbook.txt"
    vector_index:
      embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
    ```

### Step 2: Create Python Tools

Tools are the building blocks that allow agents to interact with external systems and perform actions. We will create two Python files: one for HR-related tools and one for Sales-related tools. These tools will generate realistic synthetic data to simulate interactions with real enterprise systems like an HRIS or CRM.

**1. Create HR Tools (`tools/hr_tools.py`)**

This file contains functions for common HR tasks. The data is hardcoded to simulate API responses from an HR system, providing realistic details for the demo.

*   **`tools/hr_tools.py`**:
    ```python
    import json
    from datetime import datetime, timedelta
    from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

    @tool(name="get_employee_details", description="Retrieves detailed information for a specific employee by their ID.")
    def get_employee_details(employee_id: str) -> str:
        """
        Retrieves detailed information for a specific employee, including their name, role, department, manager, and start date.

        Args:
            employee_id (str): The unique identifier for the employee (e.g., "E1001").

        Returns:
            str: A JSON string containing the employee's details or an error message if not found.
        """
        employees = {
            "E1001": {"name": "Alice Johnson", "role": "Software Engineer", "department": "Technology", "manager": "Bob Williams", "start_date": "2022-08-15"},
            "E1002": {"name": "David Chen", "role": "Product Manager", "department": "Product", "manager": "Carol White", "start_date": "2021-05-20"},
            "E1003": {"name": "Grace Lee", "role": "Sales Director", "department": "Sales", "manager": "Frank Miller", "start_date": "2019-11-01"},
        }
        if employee_id in employees:
            return json.dumps(employees[employee_id])
        else:
            return json.dumps({"error": f"Employee with ID {employee_id} not found."})

    @tool(name="list_open_positions", description="Lists all currently open job positions within the company.")
    def list_open_positions() -> str:
        """
        Provides a list of all open job positions, including the title, department, and location.

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
