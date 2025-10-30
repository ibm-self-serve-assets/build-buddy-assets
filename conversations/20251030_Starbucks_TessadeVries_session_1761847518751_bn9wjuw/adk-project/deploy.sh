#!/bin/bash
# Generated deployment script

# Script block 1
pip install "ibm-watsonx-orchestrate[adk]"
    ```
2.  **Python Environment**: A working Python environment (version 3.9 or higher) is required.
3.  **Project Directory**: Create a dedicated folder structure to organize all agents, tools, and knowledge base files. This ensures a clean and manageable project.
    ```bash
    mkdir -p empower_demo/{agents,tools/{customer_care,service_now},knowledge_base}
    cd empower_demo
    ```
4.  **Text Editor**: A code editor like Visual Studio Code is recommended for creating and editing Python and YAML files.
5.  **Orchestrate Environment**: You must have an active watsonx Orchestrate environment initialized via the ADK CLI.
    ```bash
    # Run this if you haven't already configured your environment
    orchestrate env init
    ```

## Step 1: Create the Knowledge Base

The knowledge base will serve as the first line of support, answering common employee questions from a curated set of documents, simulating access to an internal SharePoint or FAQ repository.

### Business Value

A knowledge base provides instant, 24/7 answers to frequently asked questions, deflecting simple queries from human support teams. This empowers employees with self-service capabilities and allows HR personnel to focus on more complex, high-value tasks. For this demo, it will handle general policy and procedure questions.

### Implementation

1.  **Create a Mock FAQ Document**: Inside the `knowledge_base` directory, create a file named `employee_faqs.txt` with the following content.

    `knowledge_base/employee_faqs.txt`:
    ```text
    Employee FAQs

    Q: What is the company's policy on remote work?
    A: The company supports a hybrid work model. Employees can work remotely up to 3 days per week, subject to manager approval and team requirements. Core collaboration days are typically Tuesdays and Thursdays.

    Q: How do I submit an expense report?
    A: Expense reports must be submitted through the Concur portal within 30 days of the expense date. Please include all original receipts. For travel expenses, pre-approval is required for flights and hotels.

    Q: What are the available health insurance plans?
    A: We offer three main health insurance plans: HDHP, HDHP Plus, and PPO. Detailed comparisons of benefits, deductibles, and co-pays are available on the employee benefits portal. You can ask the Empower agent to get specific benefit details for each plan.

    Q: How do I reset my corporate password?
    A: You can reset your password by visiting the self-service password reset portal. If you are unable to access the portal, please create a ServiceNow ticket for IT support.
    ```

2.  **Create the Knowledge Base YAML Configuration**: In the root of your `empower_demo` directory, create a file named `empower_kb.yaml`. This file defines the knowledge base and points to the FAQ document.

    `empower_kb.yaml`:
    ```yaml
    spec_version: v1
    kind: knowledge_base 
    name: empower_kb
    description: >
      A knowledge base containing answers to frequently asked questions (FAQs) for employees. 
      It covers topics such as company policies, HR procedures, IT support, and benefits information.
    documents:
      - "knowledge_base/employee_faqs.txt"
    vector_index:
      embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
    ```

## Step 2: Create the Agent Tools

Tools are the functional building blocks of agents, allowing them to interact with external systems and perform actions. We will create six distinct Python-based tools, three for customer care and three for ServiceNow, each populated with realistic synthetic data.

### 2.1 Customer Care Tools

These tools empower the `customer_care_agent` to answer questions about healthcare plans, claims, and providers.

#### `get_healthcare_benefits.py`

*   **Business Value**: This tool provides employees with on-demand access to detailed health plan information, enabling them to compare plans and understand their coverage without needing to contact HR. This self-service capability is crucial during open enrollment or when employees have questions about specific medical procedures.
*   **Technical Implementation**: The Python function uses Pydantic models for structured input (`Plan` Enum) and returns a filtered list of benefits from a comprehensive synthetic dataset. It simulates calling an internal benefits API.

`tools/customer_care/get_healthcare_benefits.py`:

