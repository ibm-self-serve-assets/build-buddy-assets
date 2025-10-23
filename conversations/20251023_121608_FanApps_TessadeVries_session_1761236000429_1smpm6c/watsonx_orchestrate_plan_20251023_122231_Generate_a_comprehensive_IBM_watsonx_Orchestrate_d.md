# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-23 12:22:31
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan for InnovateCorp

## Overview
This execution plan provides a comprehensive, step-by-step guide for creating an IBM watsonx Orchestrate demo tailored to InnovateCorp, a fast-growing technology company. InnovateCorp faces challenges with disconnected and manual business processes in its Human Resources (HR) and Sales departments. This demo will showcase a powerful multi-agent architecture designed to automate key workflows, thereby increasing efficiency, reducing manual errors, and providing a seamless operational experience.

The solution involves a supervisor agent that intelligently routes tasks to specialized HR and Sales agents. The HR agent will automate new hire onboarding by collaborating with a ServiceNow agent to provision IT equipment and by using tools to generate offer letters and update HR systems. The Sales agent will streamline the proposal generation process by using tools to fetch customer data, calculate pricing, and draft documents and communications. This plan provides all necessary code, configuration files, and commands to build and run this end-to-end demonstration.

## Prerequisites
Before beginning, ensure your development environment is set up with the following components. This setup is essential for building, importing, and testing the agents and tools outlined in this plan.

1.  **Python**: Ensure you have Python 3.10 or later installed. This is required to run the watsonx Orchestrate ADK and create Python-based tools.
2.  **IBM watsonx Orchestrate Agent Development Kit (ADK)**: The ADK is the core library for this project. Install it using pip:
    ```bash
    pip install "ibm-watsonx-orchestrate[all]"
    ```
3.  **watsonx Orchestrate Environment**: You must have an active watsonx Orchestrate environment configured. Follow the ADK documentation to initialize your environment, whether it's the Developer Edition (local) or a SaaS instance.
    ```bash
    # Run this command and follow the prompts to add and activate your environment
    orchestrate env add
    ```
4.  **Text Editor/IDE**: A code editor like Visual Studio Code is highly recommended for editing YAML and Python files.
5.  **Command-Line Interface (CLI)**: You will need a terminal or command prompt to execute the `orchestrate` CLI commands for importing and managing assets.

## Step 1: Project Structure Setup

A well-organized project structure is crucial for managing agents and their associated tools. Create the following directory structure in your local workspace. This separation of concerns simplifies development, debugging, and future maintenance.

```
innovatecorp-demo/
├── agents/
│   ├── 01_servicenow_agent.yaml
│   ├── 02_hr_automation_agent.yaml
│   ├── 03_sales_automation_agent.yaml
│   └── 04_supervisor_agent.yaml
├── tools/
│   ├── servicenow_tools.py
│   ├── hr_tools.py
│   └── sales_tools.py
└── requirements.txt
```

Create a `requirements.txt` file. For this demo, our Python tools only use standard libraries, but it is a best practice to include this file for any potential future dependencies.

```text
# requirements.txt
# Add any third-party Python libraries here. For example:
# requests
# python-dotenv
```

## Step 2: Develop the Python Tools

Tools are the building blocks that enable agents to perform actions. We will create three Python files, each containing tools for a specific domain (ServiceNow, HR, Sales). These tools will generate realistic synthetic data to simulate interactions with external systems.

### 1. ServiceNow Tools (`tools/servicenow_tools.py`)

**Business Value:** This tool simulates the creation of IT support tickets in ServiceNow, a critical step in the new hire onboarding process. Automating this ensures that new employees have their necessary equipment (laptop, monitor, etc.) provisioned on time, eliminating manual requests and reducing the risk of delays. It provides a clear audit trail and standardizes the IT setup process for all new hires.

**Technical Implementation:** The `create_servicenow_ticket` function accepts details about the new hire and the required equipment. It generates a unique ticket number and returns a structured dictionary containing the ticket details, simulating a successful API call to ServiceNow. This function uses standard Python libraries to generate dynamic and realistic-looking data for the demo.

```python
# tools/servicenow_tools.py
import random
from datetime import datetime
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def create_servicenow_ticket(employee_name: str, position: str, equipment_list: str) -> dict:
    """
    Creates a ServiceNow ticket for provisioning IT equipment for a new hire.

    Args:
        employee_name (str): The full name of the new employee.
        position (str): The job title or position of the new employee.
        equipment_list (str): A comma-separated string of required equipment (e.g., 'Laptop, Monitor, Keyboard').

    Returns:
        dict: A dictionary containing the details of the created ServiceNow ticket, including ticket number, status, and summary.
    """
    ticket_number = f"INC{random.randint(1000000, 9999999)}"
    creation_date = datetime.now().isoformat()
    
    ticket_details = {
        "ticket_number": ticket_number,
        "status": "New",
        "created_at": creation_date,
        "short_description": f"New Hire Equipment Provisioning for {employee_name}",
        "description": f"Please provision the following equipment for the new {position}, {employee_name}: {equipment_list}. Start date is imminent.",
        "assigned_to": "IT Support",
        "priority": "High"
    }
    print(f"ServiceNow ticket created: {ticket_details}")
    return ticket_details
```

### 2. HR Tools (`tools/hr_tools.py`)

**Business Value:** These tools automate core HR functions during onboarding. `generate_offer_letter` creates a standardized, professional offer letter, reducing administrative overhead and ensuring consistency. `add_employee_to_hris` simulates adding the new hire to the central Human Resource Information System (HRIS), which is essential for payroll, benefits, and record-keeping. Together, these tools accelerate the onboarding lifecycle.

**Technical Implementation:** `generate_offer_letter` takes hiring details and returns a formatted string representing the letter's content. `add_employee_to_hris` generates a unique employee ID and returns a confirmation message as a dictionary, mimicking a successful database entry into a system like Workday or SAP SuccessFactors.

```python
# tools/hr_tools.py
import random
from datetime import datetime
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def generate_offer_letter(employee_name: str, position: str, start_date: str, salary: float) -> str:
    """
    Generates the text content for an official offer letter for a new hire.

    Args:
        employee_name (str): The full name of the new employee.
        position (str): The job title being offered.
        start_date (str): The employee's official start date (e.g., '2024-08-01').
        salary (float): The annual salary for the position.

    Returns:
        str: The full text content of the generated offer letter.
    """
    letter_content = f"""
    Dear {employee_name},

    InnovateCorp is thrilled to extend an offer for the position of {position}. We were incredibly impressed with your qualifications and believe you will be a valuable asset to our team.

    Your official start date will be {start_date}. Your starting annual salary will be ${salary:,.2f}.

    This offer is contingent upon the successful completion of a background check. Please sign and return this letter to confirm your acceptance.

    We look forward to welcoming you to the team!

    Sincerely,
    The InnovateCorp HR Team
    """
    print("Generated offer letter.")
    return letter_content.strip()

@tool(permission=ToolPermission.ADMIN)
def add_employee_to_hris(employee_name: str, position: str, start_date: str, department: str) -> dict:
    """
    Adds a new employee record to the company's Human Resource Information System (HRIS).

    Args:
        employee_name (str): The full name of the new employee.
        position (str): The job title of the new employee.
        start_date (str): The employee's official start date.
        department (str): The department the employee will be joining.

    Returns:
        dict: A confirmation dictionary containing the new employee ID and status.
    """
    employee_id = f"INVC-{random.randint(1000, 9999)}"
    confirmation = {
        "status": "Success",
        "message": f"Employee {employee_name} has been added to the HRIS.",
        "employee_id": employee_id,
        "record_created_at": datetime.now().isoformat()
    }
    print(f"Added employee to HRIS: {confirmation}")
    return confirmation
```

### 3. Sales Tools (`tools/sales_tools.py`)

**Business Value:** These tools automate critical steps in the sales proposal workflow. `get_customer_details` simulates fetching data from a CRM (like Salesforce), providing the agent with necessary context. `calculate_proposal_pricing` applies business logic to generate accurate pricing, removing manual calculations and potential errors. `

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
