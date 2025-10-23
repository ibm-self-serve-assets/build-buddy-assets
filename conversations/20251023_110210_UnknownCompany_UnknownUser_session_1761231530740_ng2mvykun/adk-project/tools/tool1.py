# tools/order_processing_tools.py
import json
import random
from datetime import datetime, timedelta
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(permission=ToolPermission.ADMIN)
def validate_order_data(order_id: str, customer_id: str, items: list) -> str:
    """
    Validates the structure and completeness of incoming sales order data.

    This tool simulates checking an order against business rules, such as ensuring all required fields
    (order_id, customer_id, items) are present and correctly formatted. It is the first quality gate in the
    order processing workflow.

    Args:
        order_id (str): The unique identifier for the sales order.
        customer_id (str): The unique identifier for the customer.
        items (list): A list of dictionaries, where each dictionary contains 'sku' and 'quantity'.

    Returns:
        str: A JSON string indicating validation status, a message, and the validated data.
    """
    if not all([order_id, customer_id, items]):
        return json.dumps({"status": "Failed", "message": "Validation Error: Missing required order data."})
    if not isinstance(items, list) or len(items) == 0:
        return json.dumps({"status": "Failed", "message": "Validation Error: Items list cannot be empty."})
    for item in items:
        if 'sku' not in item or 'quantity' not in item:
            return json.dumps({"status": "Failed", "message": "Validation Error: Each item must have a 'sku' and 'quantity'."})
        if not isinstance(item['quantity'], int) or item['quantity'] <= 0:
            return json.dumps({"status": "Failed", "message": f"Validation Error: Quantity for SKU {item['sku']} must be a positive integer."})

    return json.dumps({
        "status": "Success",
        "message": "Order data is valid and well-formed.",
        "validated_order": {"order_id": order_id, "customer_id": customer_id, "items": items}
    })

@tool(permission=ToolPermission.ADMIN)
def check_inventory_levels(items: list) -> str:
    """
    Checks the availability of stock for items in a sales order.

    This tool simulates a real-time query to an inventory management system. It checks if the requested
    quantity for each product SKU is available in the warehouse. This is critical for confirming an order
    and providing accurate fulfillment estimates.

    Args:
        items (list): A list of dictionaries, where each dictionary contains 'sku' and 'quantity'.

    Returns:
        str: A JSON string detailing the stock availability for each item and an overall status.
    """
    # Synthetic inventory data: In a real scenario, this would be an API call.
    inventory_db = {
        "PROD-123": {"name": "Industrial Widget A", "stock": 150, "location": "WH-A"},
        "PROD-456": {"name": "Industrial Widget B", "stock": 80, "location": "WH-B"},
        "PROD-789": {"name": "Industrial Component C", "stock": 0, "location": "WH-A"},
        "PROD-101": {"name": "Industrial Gadget D", "stock": 500, "location": "WH-C"},
    }
    
    availability_report = []
    all_items_available = True
    for item in items:
        sku = item['sku']
        quantity_needed = item['quantity']
        stock_info = inventory_db.get(sku)

        if stock_info and stock_info["stock"] >= quantity_needed:
            availability_report.append({
                "sku": sku,
                "status": "In Stock",
                "available": stock_info["stock"],
                "requested": quantity_needed,
                "location": stock_info["location"]
            })
        else:
            all_items_available = False
            availability_report.append({
                "sku": sku,
                "status": "Out of Stock" if not stock_info or stock_info["stock"] == 0 else "Insufficient Stock",
                "available": stock_info["stock"] if stock_info else 0,
                "requested": quantity_needed,
                "location": stock_info["location"] if stock_info else "N/A"
            })
    
    overall_status = "Available" if all_items_available else "Partial or No Availability"
    return json.dumps({"overall_status": overall_status, "details": availability_report})