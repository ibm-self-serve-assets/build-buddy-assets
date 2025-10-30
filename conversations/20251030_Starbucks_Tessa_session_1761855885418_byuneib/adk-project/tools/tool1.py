# tools/data_collection_tools.py

import json
import random
from datetime import datetime, timedelta
import uuid

from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(name="fetch_transaction_data", permission=ToolPermission.ADMIN)
def fetch_transaction_data(start_date: str, end_date: str, region: str) -> str:
    """
    Fetches financial transaction data for a specified date range and region. This tool simulates querying a core banking system to retrieve all relevant transactions for a compliance period.

    Args:
        start_date (str): The start date for the data query in 'YYYY-MM-DD' format.
        end_date (str): The end date for the data query in 'YYYY-MM-DD' format.
        region (str): The geographic region to filter transactions (e.g., 'NA', 'EMEA', 'APAC').

    Returns:
        str: A JSON string representing a list of 15 to 20 transaction records.
    """
    transactions = []
    for _ in range(random.randint(15, 20)):
        transactions.append({
            "transaction_id": str(uuid.uuid4()),
            "timestamp": (datetime.strptime(start_date, "%Y-%m-%d") + timedelta(days=random.randint(0, 90))).isoformat(),
            "amount": round(random.uniform(100.0, 50000.0), 2),
            "currency": "USD",
            "source_account": f"ACC{random.randint(10000, 99999)}",
            "destination_account": f"ACC{random.randint(10000, 99999)}",
            "transaction_type": random.choice(["WIRE", "ACH", "INTERNAL_TRANSFER"]),
            "region": region,
            "status": "COMPLETED"
        })
    return json.dumps(transactions, indent=2)


@tool(name="fetch_customer_profiles", permission=ToolPermission.ADMIN)
def fetch_customer_profiles(account_ids: list[str]) -> str:
    """
    Retrieves customer profile information for a given list of account IDs. This simulates querying a Customer Relationship Management (CRM) system to enrich transaction data with customer context, which is vital for risk assessment.

    Args:
        account_ids (list[str]): A list of account IDs to fetch profiles for.

    Returns:
        str: A JSON string representing a dictionary of customer profiles, keyed by account ID.
    """
    profiles = {}
    unique_account_ids = list(set(account_ids))
    for acc_id in unique_account_ids:
        profiles[acc_id] = {
            "customer_id": f"CUST{random.randint(1000, 9999)}",
            "entity_type": random.choice(["INDIVIDUAL", "CORPORATE"]),
            "risk_rating": random.choice(["LOW", "MEDIUM", "HIGH"]),
            "onboarding_date": (datetime.now() - timedelta(days=random.randint(365, 1825))).strftime("%Y-%m-%d"),
            "country_of_residence": random.choice(["USA", "UK", "SG", "CH"])
        }
    return json.dumps(profiles, indent=2)