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