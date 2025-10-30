# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-30 20:36:12
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: Automated Daily Sales Intelligence Agent

## 1. Overview

This execution plan provides a comprehensive, step-by-step guide to building the **"Daily Sales Reporter"** agent, a Proof-of-Concept (POC) for your organization. This plan is tailored specifically to your business need for timely, accessible business intelligence. The "Daily Sales Reporter" is a native watsonx Orchestrate agent designed to provide managers with instant, conversational access to the previous day's sales performance metrics, completely automating the current manual report generation process.

By following this plan, you will create an intelligent agent that directly addresses key business challenges. The final solution will demonstrate significant business value by:
*   **Increasing Efficiency:** Eliminating the manual effort required to compile daily sales figures.
*   **Accelerating Decision-Making:** Providing managers with immediate, on-demand access to critical metrics.
*   **Enhancing Data Accessibility:** Empowering non-technical users to query sales data using natural language.
*   **Establishing a Scalable Pattern:** Creating a foundational automation that can be extended to other reporting needs across departments like marketing, inventory, and operations.

This plan leverages the **Native Agent with Custom Python Tools** pattern, utilizing the IBM watsonx Orchestrate Agent Development Kit (ADK) to build, configure, and deploy all necessary components.

## 2. Prerequisites

Before beginning the implementation, ensure your environment meets the following requirements:

*   **Python Environment:** Python version 3.9 or higher installed on your development machine.
*   **IBM watsonx Orchestrate ADK:** The Agent Development Kit must be installed. If not, install it using pip:
    ```bash
    pip install ibm-watsonx-orchestrate-sdk
    ```
*   **watsonx Orchestrate Account:** You need an active IBM watsonx Orchestrate account with the necessary permissions to create and manage agents and tools.
*   **ADK Configuration:** Your ADK must be configured to connect to your watsonx Orchestrate instance. This typically involves setting environment variables or using the `orchestrate config set` command to provide your credentials. Verify your setup with:
    ```bash
    orchestrate config list
    ```
*   **Text Editor/IDE:** A code editor such as Visual Studio Code is recommended for creating and editing Python and YAML files.

## 3. Step-by-Step Execution

This section details the entire process, from setting up the project structure to deploying and testing the agent.

### Step 3.1: Project Setup and Directory Structure

A well-organized project structure is essential for managing your agent's assets. Create a main project folder and the necessary subdirectories to house your agent configuration, tool definitions, and dependencies.

1.  Create the main project directory:
    ```bash
    mkdir daily_sales_reporter_poc
    cd daily_sales_reporter_poc
    ```

2.  Create subdirectories for agents and tools:
    ```bash
    mkdir agents
    mkdir tools
    ```

3.  Create an empty `requirements.txt` file. While our current tools only use standard Python libraries, this file is crucial for managing dependencies as you add more complex tools in the future.
    ```bash
    touch requirements.txt
    ```

Your final directory structure will look like this:

```
daily_sales_reporter_poc/
├── agents/
│   └── daily_sales_reporter.yaml
├── tools/
│   └── sales_tools.py
└── requirements.txt
```

### Step 3.2: Create Python Tools for Sales Data Retrieval

The agent's capabilities are defined by its tools. We will create two Python-based tools that generate realistic, synthetic sales data for the demo. These tools will be placed in a single Python file.

**File:** `tools/sales_tools.py`

#### Tool 1: `get_daily_sales_metrics`

**Business Value:** This tool provides a high-level, aggregate view of the previous day's business performance. It instantly delivers the key performance indicators (KPIs) that managers need to assess overall health, eliminating the need to manually calculate these figures from raw sales data. This accelerates the daily performance review process and enables faster identification of trends or anomalies.

**Technical Implementation:** The tool generates a dictionary containing core sales metrics like total revenue, transaction count, and average order value. It uses Python's `datetime` and `random` libraries to produce dynamic, realistic data for the previous calendar day, ensuring the demo feels current and relevant. The `@tool` decorator registers the function as a watsonx Orchestrate tool, and the detailed docstring serves as the description that the agent's LLM uses to understand its function, inputs, and outputs.

#### Tool 2: `get_top_selling_products`

**Business Value:** This tool provides critical insight into product performance, which is fundamental for inventory management, marketing focus, and sales strategy. By automatically identifying the top-performing products, it allows managers to quickly see what is resonating with customers without sifting through extensive sales logs. This data is crucial for making informed decisions about stock levels, promotional activities, and product placement.

**Technical Implementation:** This function generates a list of synthetic product data, including product names, units sold, and revenue generated. It simulates a real-world scenario where a few products drive a significant portion of sales. The output is a clean, structured list of dictionaries, which the agent can easily parse and present in a formatted table or summary. The docstring clearly defines its purpose, enabling the agent to call it correctly when a user asks about product performance.

**Create the `tools/sales_tools.py` file with the following complete code:**

```python
# tools/sales_tools.py

import datetime
import random
from typing import List, Dict, Any

from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

@tool(name="get_daily_sales_metrics", description="Retrieves key sales performance metrics for the previous calendar day.")
def get_daily_sales_metrics() -> Dict[str, Any]:
    """
    Fetches a summary of key sales metrics from the previous day's business activities.
    This includes total revenue, number of transactions, average order value, and conversion rate.

    Returns:
        dict: A dictionary containing the sales metrics:
              - 'report_date' (str): The date the report is for (YYYY-MM-DD).
              - 'total_revenue' (float): The total revenue in USD.
              - 'transaction_count' (int): The total number of transactions.
              - 'average_order_value' (float): The average value of each order in USD.
              - 'conversion_rate' (float): The percentage of website visits that resulted in a sale.
    """
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
    
    # Generate realistic synthetic data
    revenue = round(random.uniform(25000.0, 75000.0), 2)
    transactions = random.randint(400, 950)
    avg_order_value = round(revenue / transactions, 2)
    conversion = round(random.uniform(1.5, 4.5), 2)

    return {
        "report_date": yesterday.strftime("%Y-%m-%d"),
        "total_revenue": revenue,
        "transaction_count": transactions,
        "average_order_value": avg_order_value,
        "conversion_rate": conversion
    }

@tool(name="get_top_selling_products", description="Retrieves a list of the top 5 selling products from the previous calendar day, ranked by revenue.")
def get_top_selling_products() -> List[Dict[str, Any]]:
    """
    Fetches a list of the top 5 selling products from the previous day, including their
    product ID, name, units sold, and total revenue generated.

    Returns:
        list[dict]: A list of dictionaries, where each dictionary represents a top-selling product:
                    - 'product_id' (str): The unique identifier for the product.
                    - 'product_name' (str): The name of the product.
                    - 'units_sold' (int): The number of units sold.
                    - 'total_revenue' (float): The total revenue generated by the product in USD.
    """
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
    
    products = [
        "Quantum Widget", "HyperStream Router", "NovaSync Keyboard", "AetherPod Pro", 
        "StellarCharge Cable", "Orion Headset", "Galaxy Mousepad", "Cosmic Desk Lamp"
    ]
    
    top_products = []
    for i in range(5):
        product_name = random.choice(products)
        products.remove(product_name) # Ensure unique products
        
        units_sold = random.randint(50 - (i * 5), 200 - (i * 20))
        price = round(random.uniform(20.0, 150.0), 2)
        revenue = round(units_sold * price, 2)
        
        top_products.append({
            "product_id": f"PROD-{random.randint(1000, 9999)}",
            "product_name": product_name,
            "units_sold": units_sold,
            "total_revenue": revenue
        })
        
    # Sort by revenue descending
    top_products.

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
