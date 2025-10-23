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