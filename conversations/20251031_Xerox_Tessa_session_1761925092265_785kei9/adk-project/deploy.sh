#!/bin/bash
# Generated deployment script

# Script block 1
pip install --upgrade "ibm-watsonx-orchestrate[adk]"
    ```
3.  **Python Environment**: A working Python environment (version 3.10 or later) is required to create the custom tools. You should have `pip` available for installing packages.
4.  **ADK Environment Initialization**: You must have an active watsonx Orchestrate environment configured in your ADK. Initialize and activate it using the following commands:
    ```bash
    # Log in to your IBM Cloud account
    orchestrate login

    # Initialize your environment (follow the prompts)
    orchestrate env init

    # Activate the environment you created
    orchestrate env use <your_env_name>
    ```
5.  **Project Directory Structure**: To keep the project organized, create the following directory structure. This plan will reference these paths.
    ```
    empower_demo/
    ├── agents/
    │   ├── customer_care_agent.yaml
    │   ├── service_now_agent.yaml
    │   └── empower_agent.yaml
    ├── tools/
    │   ├── customer_care/
    │   │   ├── get_healthcare_benefits.py
    │   │   ├── get_my_claims.py
    │   │   └── search_healthcare_providers.py
    │   └── service_now/
    │       ├── create_service_now_incident.py
    │       ├── get_my_service_now_incidents.py
    │       └── get_service_now_incident_by_number.py
    ├── knowledge/
    │   ├── faqs/
    │   │   └── employee_faq.pdf
    │   └── employee_knowledge_base.yaml
    └── requirements.txt
    ```
6.  **Dummy Knowledge Base Document**: Create a simple PDF document named `employee_faq.pdf` inside the `empower_demo/knowledge/faqs/` directory. Add sample Q&A content like:
    *   "What is the company's remote work policy?"
    *   "How do I request vacation time?"
    *   "What are the guidelines for expense reports?"

## Step 1: Create Python Tools
Tools are the foundational components that perform specific actions. We will create two sets of tools: one for customer care (benefits, claims) and another for IT support (ServiceNow incidents).

### 1.1 Customer Care Tools

#### `get_healthcare_benefits.py`
**Business Value**: This tool provides employees with immediate, self-service access to detailed information about their healthcare plans. It eliminates the need to manually search through complex benefits documents or contact HR for common questions, saving time for both employees and the HR department. By offering clear comparisons between plans, it empowers employees to make informed decisions about their healthcare coverage.

**Technical Implementation**: This Python tool uses the `requests` library to call an external mock API that returns benefits data. It defines a Pydantic `Enum` to enforce valid inputs for the `plan` argument, ensuring data integrity. The function is decorated with `@tool` to make it discoverable by Orchestrate agents, and includes error handling for API call failures.

Create the file `empower_demo/tools/customer_care/get_healthcare_benefits.py`:

