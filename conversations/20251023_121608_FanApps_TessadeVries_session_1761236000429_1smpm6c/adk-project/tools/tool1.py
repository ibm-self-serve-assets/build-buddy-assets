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