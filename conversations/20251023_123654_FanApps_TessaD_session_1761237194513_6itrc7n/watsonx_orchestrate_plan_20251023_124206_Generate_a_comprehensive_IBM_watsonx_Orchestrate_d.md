# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-23 12:42:06
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: Automating HR Onboarding for Innovate Inc.

## Overview

This execution plan provides a comprehensive, step-by-step guide for building and demonstrating an automated HR Employee Onboarding solution for Innovate Inc. using IBM watsonx Orchestrate. Innovate Inc. currently faces significant challenges with a manual, fragmented, and error-prone onboarding process, leading to delays, inconsistent new hire experiences, and potential compliance risks. This demonstration will showcase how watsonx Orchestrate can create a seamless, efficient, and reliable end-to-end onboarding workflow by integrating disparate systems and automating complex coordination tasks.

We will construct a multi-agent architecture composed of a central `Onboarding_Coordinator_Agent` that acts as a supervisor, interpreting user requests and delegating tasks to three specialized collaborator agents: an `HRIS_Agent` for managing employee records, an `IT_Provisioning_Agent` for handling system access and equipment, and a `Compliance_Agent` for ensuring regulatory and training requirements are met. This plan includes all necessary configuration files, complete Python code for custom tools with realistic synthetic data, and precise CLI commands to build, deploy, and verify the solution, adhering strictly to IBM best practices and ADK patterns.

## Prerequisites

Before beginning, ensure your development environment is properly configured. This is crucial for the successful creation and deployment of the agents and tools outlined in this plan.

1.  **IBM watsonx Orchestrate ADK**: The Agent Development Kit (ADK) must be installed and configured.
    ```bash
    pip install "ibm-watsonx-orchestrate[adk]"
    ```
2.  **Python Environment**: A Python version compatible with the ADK (e.g., Python 3.10 or later) is required. Use a virtual environment to manage dependencies.
    ```bash
    # Create a virtual environment
    python -m venv venv

    # Activate the virtual environment (macOS/Linux)
    source venv/bin/activate
    # On Windows: venv\Scripts\activate
    ```
3.  **Project Structure**: Create a dedicated project directory to organize your files.
    ```bash
    mkdir innovate_inc_onboarding_demo
    cd innovate_inc_onboarding_demo
    mkdir agents
    mkdir tools
    mkdir tools/hris_tools
    mkdir tools/it_tools
    mkdir tools/compliance_tools
    ```
4.  **Python Dependencies**: Create a `requirements.txt` file in the root of your project directory. This is a best practice for managing dependencies. For this demo, no external packages are strictly necessary, but `requests` is commonly used and good to include.
    ```bash
    # Create the file
    touch requirements.txt
    # Add content to requirements.txt
    echo "requests" > requirements.txt
    # Install dependencies
    pip install -r requirements.txt
    ```
5.  **Orchestrate Environment Login**: Ensure you are authenticated with your watsonx Orchestrate environment via the CLI.
    ```bash
    orchestrate login
    ```

## Step 1: Create Custom Tools with Python

We will create a suite of Python-based tools that simulate interactions with Innovate Inc.'s backend systems. Each tool generates realistic synthetic data to provide a tangible and convincing demo experience.

### 1.1 HRIS Tools

These tools simulate interactions with a Human Resource Information System (HRIS), forming the foundation of the onboarding process.

**Business Value:** Automating HRIS interactions eliminates manual data entry errors, ensures consistency, and creates an immediate, official record for new employees, which is a prerequisite for all subsequent onboarding steps.

**File:** `tools/hris_tools/hr_system.py`
```python
import json
import uuid
from datetime import datetime

from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def create_employee_profile(full_name: str, role: str, start_date: str) -> str:
    """
    Creates a new employee profile in the HRIS system.

    This tool simulates the creation of an official employee record, generating a unique employee ID.
    This ID is critical for all subsequent onboarding processes, including IT provisioning and compliance tracking.

    Args:
        full_name (str): The new employee's full name (e.g., "Jane Doe").
        role (str): The job title or role of the new employee (e.g., "Senior Software Engineer").
        start_date (str): The employee's official start date in YYYY-MM-DD format.

    Returns:
        str: A JSON string containing the result of the profile creation, including the new employee ID.
    """
    try:
        datetime.strptime(start_date, '%Y-%m-%d')
        new_employee_id = f"INNOVATE-{uuid.uuid4().hex[:6].upper()}"
        result = {
            "status": "success",
            "message": f"Employee profile created successfully for {full_name}.",
            "employee_id": new_employee_id,
            "full_name": full_name,
            "role": role,
            "start_date": start_date,
            "profile_status": "Active - Pending Onboarding",
            "creation_timestamp": datetime.utcnow().isoformat()
        }
        return json.dumps(result, indent=2)
    except ValueError:
        return json.dumps({"status": "error", "message": "Invalid start_date format. Please use YYYY-MM-DD."}, indent=2)

@tool(permission=ToolPermission.ADMIN)
def get_employee_status(employee_id: str) -> str:
    """
    Retrieves the current onboarding status of an employee from the HRIS system.

    This tool provides visibility into the employee's record, allowing stakeholders to check
    if the foundational profile exists and is active before proceeding with other tasks.

    Args:
        employee_id (str): The unique ID of the employee to check.

    Returns:
        str: A JSON string containing the employee's current status details.
    """
    if "INNOVATE-" in employee_id:
        status = {
            "status": "success",
            "employee_id": employee_id,
            "full_name": "Jane Doe (Simulated)",
            "role": "Senior Software Engineer (Simulated)",
            "profile_status": "Active - Onboarding In Progress",
            "retrieval_timestamp": datetime.utcnow().isoformat()
        }
    else:
        status = {"status": "error", "message": "Employee ID not found.", "employee_id": employee_id}
    return json.dumps(status, indent=2)
```

### 1.2 IT Provisioning Tools

These tools automate the setup of essential IT accounts and the ordering of hardware, ensuring new hires are productive from day one.

**Business Value:** Automating IT provisioning eliminates manual request tickets, reduces wait times, and guarantees a standard, secure setup for all employees based on their role, dramatically improving the new hire experience.

**File:** `tools/it_tools/it_provisioning.py`
```python
import json
import random
from datetime import datetime, timedelta

from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def create_user_accounts(employee_id: str, full_name: str, role: str) -> str:
    """
    Creates necessary user accounts for a new employee (Email, Slack, Jira).

    This tool automates the creation of standard communication and project management accounts,
    which are essential for collaboration and integration into company workflows.

    Args:
        employee_id (

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
