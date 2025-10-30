# tools/data_processing_tools.py
import json
import random
from datetime import datetime, timedelta
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(name="collect_transaction_data", description="Collects raw transaction data from source systems for a given date range.", permission=ToolPermission.ADMIN)
def collect_transaction_data(days_ago: int = 7) -> str:
    """
    Simulates fetching a list of financial transactions from the last few days from various source systems.

    Args:
        days_ago (int): The number of past days to collect transaction data for. Defaults to 7.

    Returns:
        str: A JSON string representing a list of transaction records.
    """
    transactions = []
    sources = ["Wire Transfer", "ACH", "Internal Transfer", "Crypto Exchange"]
    companies = ["Innovate Corp", "Global Exports LLC", "Tech Solutions Inc.", "Secure Holdings", "Quantum Traders", " sanctioned_entity_co"]
    for i in range(15):
        transaction_date = datetime.now() - timedelta(days=random.randint(0, days_ago))
        transactions.append({
            "transaction_id": f"TXN{random.randint(10000, 99999)}{i}",
            "date": transaction_date.isoformat(),
            "amount": round(random.uniform(500.0, 75000.0), 2),
            "currency": "USD",
            "source": random.choice(sources),
            "sender": random.choice(companies),
            "recipient": "FinCorp Internal Account",
            "metadata": {"raw_status": random.choice(["completed", "pending", "flagged", "failed", "COMPLETED", "C"])}
        })
    # Add a transaction that is clearly high risk
    transactions.append({
        "transaction_id": "TXN-HIGH-RISK-001", "date": (datetime.now() - timedelta(days=1)).isoformat(),
        "amount": 99000.00, "currency": "USD", "source": "Wire Transfer",
        "sender": "Shady Deals Inc.", "recipient": "FinCorp Internal Account",
        "metadata": {"raw_status": "completed"}
    })
    return json.dumps(transactions)

@tool(name="cleanse_and_normalize_data", description="Cleanses and normalizes a list of raw transaction data.", permission=ToolPermission.ADMIN)
def cleanse_and_normalize_data(raw_transactions_json: str) -> str:
    """
    Takes a JSON string of raw transactions, cleanses the data, and standardizes field values.

    Args:
        raw_transactions_json (str): A JSON string representing a list of raw transaction records.

    Returns:
        str: A JSON string representing a list of cleansed and normalized transaction records.
    """
    raw_transactions = json.loads(raw_transactions_json)
    cleansed_data = []
    status_map = {"completed": "COMPLETED", "pending": "PENDING", "flagged": "FLAGGED", "failed": "FAILED", "c": "COMPLETED"}
    
    for tx in raw_transactions:
        raw_status = str(tx["metadata"]["raw_status"]).lower()
        normalized_status = status_map.get(raw_status, "UNKNOWN")
        
        cleansed_tx = {
            "transaction_id": tx["transaction_id"],
            "date": tx["date"],
            "amount": float(tx["amount"]),
            "currency": tx["currency"],
            "source": tx["source"],
            "sender": tx["sender"],
            "recipient": tx["recipient"],
            "status": normalized_status
        }
        cleansed_data.append(cleansed_tx)
    return json.dumps(cleansed_data)