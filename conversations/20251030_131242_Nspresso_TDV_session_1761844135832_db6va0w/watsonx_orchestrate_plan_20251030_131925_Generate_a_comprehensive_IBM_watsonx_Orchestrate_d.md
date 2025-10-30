# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-30 13:19:25
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: Nespresso AI Concierge

## 1. Overview

This execution plan provides a comprehensive, step-by-step guide for building the "Nespresso AI Concierge," a multi-agent Proof of Concept (POC) for a client in the premium coffee industry. The solution is designed to elevate the customer experience by seamlessly integrating sales and support functions into a single, intelligent conversational interface. The AI Concierge will act as a primary point of contact, intelligently understanding customer intent and routing requests to specialized collaborator agents for order processing, product recommendations, and machine troubleshooting.

This demo will showcase the power of IBM watsonx Orchestrate's supervisor-collaborator agent architecture to create sophisticated, scalable, and efficient customer service solutions. By automating routine queries, the Nespresso AI Concierge will demonstrate a clear path to reducing operational costs, increasing average order value through intelligent upselling, and freeing human agents to focus on high-value, complex customer interactions, ultimately enhancing brand loyalty and customer satisfaction. This plan is a direct response to previous feedback, ensuring a complete, executable, and client-aligned implementation.

## 2. Prerequisites

Before beginning the implementation, ensure your environment is configured with the following components. This setup is crucial for developing, importing, and testing the agents and tools.

*   **Python:** A recent version of Python (3.9 or later) must be installed on your system.
*   **IBM watsonx Orchestrate ADK:** The Agent Development Kit (ADK) is the core command-line tool for this project. If not already installed, run the following command:
    ```bash
    pip install ibm-watsonx-orchestrate
    ```
*   **Orchestrate Environment:** You must have an active IBM watsonx Orchestrate environment configured. This involves initializing the environment and logging in. If you have not done so, run:
    ```bash
    orchestrate env init
    orchestrate login
    ```
*   **Text Editor/IDE:** A code editor like Visual Studio Code is recommended for creating and editing the required YAML and Python files.
*   **Project Directory:** Create a dedicated folder for this project to keep all files organized.

    ```bash
    # Create the main project directory
    mkdir nespresso-ai-concierge
    cd nespresso-ai-concierge

    # Create subdirectories for organization
    mkdir agents
    mkdir tools
    mkdir knowledge_base
    mkdir knowledge_base/documents
    ```

## 3. Step-by-Step Implementation

This section details the creation of all components of the Nespresso AI Concierge, from the underlying knowledge base and tools to the specialized collaborator agents and the central supervisor agent.

### Step 1: Create the Knowledge Base

The knowledge base is a critical component for the `support_agent`, allowing it to answer frequently asked questions about machine maintenance and troubleshooting by retrieving information from trusted documents.

**Business Value:** This provides the Support Agent with a reliable source of truth, ensuring consistent and accurate answers to common customer problems. It reduces the need for the agent to be explicitly trained on every possible issue, allowing it to leverage existing documentation and scale its expertise easily.

1.  **Create a Dummy Document:** For this demo, we will create a placeholder text file representing a PDF manual. In a real-world scenario, this would be an actual PDF, DOCX, or HTML file.
    *   Create a new file: `knowledge_base/documents/nespresso_machine_troubleshooting_guide.txt`
    *   Add the following content to simulate a real guide:
        ```text
        Nespresso Machine Troubleshooting Guide

        Issue: Machine is not brewing coffee.
        Solution 1: Ensure the water tank is full and properly seated.
        Solution 2: Check if a Nespresso capsule is correctly inserted.
        Solution 3: The machine may need descaling. Refer to the descaling section.

        Issue: Coffee is leaking from the machine.
        Solution 1: Check the drip tray; it may be full and require emptying.
        Solution 2: The capsule holder may be dirty. Clean it with a soft cloth.
        Solution 3: Ensure the capsule was not previously used or damaged.

        Issue: Blinking lights.
        Orange Light: The machine is in the descaling process or needs descaling.
        Red Light: General error. Turn the machine off for 10 minutes and restart. Contact support if the issue persists.
        ```

2.  **Create the Knowledge Base YAML Configuration:**
    *   Create a new file: `knowledge_base/nespresso_machine_faqs.yaml`
    *   Add the following configuration. This tells Orchestrate to create a knowledge base named `nespresso_machine_faqs`, ingest the specified document into the built-in Milvus vector database, and use the default embedding model.

    ```yaml
    spec_version: v1
    kind: knowledge_base
    name: nespresso_machine_faqs
    description: >
      Contains technical documentation, troubleshooting guides, and frequently asked questions
      for all models of Nespresso coffee machines. Use this to answer customer questions
      about machine errors, maintenance, cleaning, and operation.
    documents:
      - "knowledge_base/documents/nespresso_machine_troubleshooting_guide.txt"
    vector_index:
      embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
    ```

### Step 2: Develop the Python Tools

Tools are the building blocks that allow agents to perform actions. We will create two sets of tools: one for sales and one for support.

1.  **Create `requirements.txt`:** This file lists the Python packages our tools depend on.
    *   Create a new file: `requirements.txt`
    *   Add the following content:
    ```text
    requests
    python-dotenv
    ```

2.  **Create Sales Tools (`sales_tools.py`)**
    *   **Purpose:** This collection of tools provides the `sales_agent` with the ability to interact with a mock product catalog and ordering system. It enables searching for products, placing new orders, and retrieving the status of existing orders, covering the entire sales lifecycle.
    *   Create a new file: `tools/sales_tools.py`
    *   Add the following complete Python code:

    ```python
    import json
    import random
    from datetime import datetime, timedelta
    from typing import List, Optional
    from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission
    from pydantic import BaseModel, Field

    # --- Data Models for Structured Input ---
    class OrderItem(BaseModel):
        pod_id: str = Field(description="The unique identifier of the coffee pod, e.g., 'NP001'.")
        quantity: int = Field(description="The number of sleeves to order for this pod.")

    # --- Mock Database ---
    COFFEE_PODS = [
        {"pod_id": "NP001", "name": "Arpeggio", "intensity": 9, "profile": "Intense and Creamy", "price_per_sleeve": 8.50, "compatibility": "Original"},
        {"pod_id": "NP002", "name": "Volluto", "intensity": 4, "profile": "Sweet and Light", "price_per_sleeve": 8.20, "compatibility": "Original"},
        {"pod_id": "NP003", "name": "Ristretto", "intensity": 10, "profile": "Powerful and Contrasting", "price_per_sleeve": 8.50, "compatibility": "Original"},
        {"pod_id": "NV001", "name": "Intenso", "intensity": 9, "profile": "Deep and Dense", "price_per_sleeve": 12.50, "compatibility": "Vertuo"},
        {"pod_id": "NV002", "name": "Stormio", "intensity": 8, "profile": "Rich and Strong", "price_per_sleeve": 12.50, "compatibility": "Vertuo"},
        {"pod_id": "NV003", "name": "Odacio", "intensity": 7, "profile": "Bold and Lively", "price_per_sleeve": 12.00, "compatibility": "Vertuo"}
    ]
    
    # In-memory store for demo orders
    ORDERS_DB = {}

    @tool(name="get_coffee_pods", description="Retrieves available Nespresso coffee pods, with optional filtering by intensity or machine compatibility.")
    def get_coffee_pods(intensity: Optional[int] = None, compatible_machine: Optional[str] = None) -> str:
        """
        Searches the Nespresso product catalog for coffee pods. Can filter by intensity level (1-13)
        or machine type ('Original' or 'Vertuo').

        Args:
            intensity (int, optional): The desired coffee intensity level, from 1 (mild) to 13 (very intense).
            compatible_machine (str, optional): The type of machine to find compatible pods for. Can be 'Original' or 'Vertuo'.

        Returns:
            str: A JSON string containing a list of matching coffee pods with their details.
        """
        results = COFFEE_PODS
        if intensity:
            results = [p for p in results if p['intensity'] == intensity]
        if compatible_machine:
            results = [p for p in results if p['compatibility'].lower() == compatible_machine.lower()]
        
        if not results:
            return json.dumps({"message": "No coffee pods found matching your criteria."})
            
        return json.dumps(results)

    @tool(name="place_order", description="Places a new order for one or more types of coffee pods.")
    def place_order(items: List[OrderItem]) -> str:
        """
        Submits a new order to the system. Requires a list of items, each with a pod_id and quantity.

        Args:
            items (List[OrderItem]): A list of items to be included in the order.

        Returns:
            str: A JSON string confirming the order, including the new order ID and estimated delivery date.
        """
        if not items:
            return json.dumps({"error": "Order cannot be empty. Please provide a list of items."})

        order_id = f"NESP-{random.randint(10000, 99999)}"
        order_date = datetime.now()
        delivery_date = order_date + timedelta(days=3)
        total_

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
