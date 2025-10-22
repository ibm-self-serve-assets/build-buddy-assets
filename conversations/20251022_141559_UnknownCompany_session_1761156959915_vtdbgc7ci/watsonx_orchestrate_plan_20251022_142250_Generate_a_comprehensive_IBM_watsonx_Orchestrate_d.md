# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-22 14:22:50
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Comprehensive Demo Execution Plan for InnovateHealth

## Overview

This execution plan provides a detailed, step-by-step guide for building a comprehensive demonstration of IBM watsonx Orchestrate tailored for a large healthcare institution, "InnovateHealth". The primary business challenge at InnovateHealth is a fragmented employee support experience, where employees must navigate multiple systems for HR benefits, IT support, and general company policies. This leads to decreased productivity, employee frustration, and high overhead for support teams.

The proposed solution is to create a unified, AI-powered digital assistant named **"Empower"**. This assistant will serve as a single, intelligent point of contact for all employee inquiries. Using a sophisticated multi-agent architecture, "Empower" will understand the user's intent and delegate tasks to specialized collaborator agents for handling complex, domain-specific workflows in healthcare benefits and ServiceNow IT support. It will also leverage a Retrieval-Augmented Generation (RAG) pattern with a knowledge base to provide instant, accurate answers to general policy questions, ensuring a seamless and efficient support experience.

## Prerequisites

Before beginning the implementation, ensure the following prerequisites are met:

1.  **IBM watsonx Orchestrate ADK Installed**: The Agent Development Kit (ADK) must be installed and configured on your local development machine. This includes the `orchestrate` CLI.
    ```bash
    pip install ibm-watsonx-orchestrate
    ```
2.  **Python Environment**: A Python 3.9+ environment is required. It is recommended to use a virtual environment to manage dependencies.
3.  **Project Directory**: Create a dedicated project directory to organize all configuration files, tools, and documents.
    ```bash
    mkdir innovatehealth_demo
    cd innovatehealth_demo
    mkdir agents tools knowledge_base_docs
    ```
4.  **Required Python Packages**: Create a `requirements.txt` file in the root of your project directory with the following content. These packages will be used by the custom Python tools.
    ```text
    # requirements.txt
    requests
    python-dotenv
    ```
    Install them using:
    ```bash
    pip install -r requirements.txt
    ```
5.  **Sample Documents for Knowledge Base**: Create two sample documents inside the `knowledge_base_docs` directory to populate the knowledge base.
    *   `knowledge_base_docs/employee_handbook.txt`: A text file containing sample FAQ content about company policies.
    *   `knowledge_base_docs/remote_work_policy.pdf`: A placeholder PDF document (can be any simple PDF) representing a policy document.

## Step 1: Create the Knowledge Base

The knowledge base will enable the "Empower" agent to answer general questions about company policies using Retrieval-Augmented Generation (RAG). This component is crucial for deflecting common inquiries from specialized support teams. We will create a built-in knowledge base that ingests local documents.

**Business Value**: This provides instant, 24/7 access to authoritative company information, reducing the burden on HR staff and ensuring employees receive consistent, accurate answers to policy-related questions.

Create the file `empower_kb.yaml` in the project's root directory:

**`empower_kb.yaml`**
```yaml
spec_version: v1
kind: knowledge_base 
name: empower_kb
description: >
   Contains comprehensive information about InnovateHealth's internal company policies, including the employee handbook, remote work policies, code of conduct, and other general corporate guidelines. Use this to answer employee questions about internal procedures and policies.
documents:
   - "knowledge_base_docs/employee_handbook.txt"
   - "knowledge_base_docs/remote_work_policy.pdf"
vector_index:
   # Using the default watsonx.ai embedding model
   embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
```

## Step 2: Create the Tools

Tools are the functional building blocks that allow agents to interact with external systems and perform actions. We will create two sets of Python-based tools: one for customer care (healthcare benefits) and one for ServiceNow (IT support).

### 2.1. Customer Care Tools

These tools will empower the `customer_care_agent` to retrieve specific information related to employee health benefits.

Create the file `tools/customer_care_tools.py`:

**`tools/customer_care_tools.py`**
```python
import json
import random
from datetime import datetime, timedelta
from enum import Enum
from typing import List, Dict, Any
from pydantic import BaseModel, Field
from ibm_watsonx_orchestrate.agent_builder.tools import tool, ToolPermission

# --- Tool 1: search_healthcare_providers ---

class ContactInformation(BaseModel):
    phone: str
    email: str

class HealthcareSpeciality(str, Enum):
    GENERAL_MEDICINE = 'General Medicine'
    CARDIOLOGY = 'Cardiology'
    PEDIATRICS = 'Pediatrics'
    ORTHOPEDICS = 'Orthopedics'
    ENT = 'Ear, Nose and Throat'
    MULTI_SPECIALTY = 'Multi-specialty'

class HealthcareProvider(BaseModel):
    provider_id: str = Field(description="The unique identifier of the provider")
    name: str = Field(description="The provider's name")
    provider_type: str = Field(description="Type of provider, (e.g. Hospital, Clinic, Individual Practitioner)")
    specialty: HealthcareSpeciality = Field(description="Medical speciality, if applicable")
    address: str = Field(description="The address of the provider")
    contact: ContactInformation = Field(description="The contact information of the provider")

@tool(name="search_healthcare_providers", permission=ToolPermission.ADMIN)
def search_healthcare_providers(
        location: str,
        specialty: HealthcareSpeciality = HealthcareSpeciality.GENERAL_MEDICINE
) -> List[Dict[str, Any]]:
    """
    Retrieves a list of the nearest in-network healthcare providers based on location and optional specialty.

    Args:
        location (str): Geographic location to search for providers (e.g., city, state, zip code).
        specialty (str, optional): Medical specialty to filter providers by. Must be one of:
            "ENT", "General Medicine", "Cardiology", "Pediatrics", "Orthopedics", "Multi-specialty".

    Returns:
        list[dict]: A list of healthcare providers near the specified location for the given specialty.
    """
    # --- Synthetic Data Generation ---
    providers = [
        {"provider_id": "PRV83721", "name": "Oak Valley General Hospital", "provider_type": "Hospital", "specialty": "Multi-specialty", "address": f"100 Health Way, {location}", "contact": {"phone": "555-0101", "email": f"contact@oakvalley.{location.lower()}.org"}},
        {"provider_id": "PRV91245", "name": "City Center Cardiology", "provider_type": "Clinic", "specialty": "Cardiology", "address": f"25 Heartbeat Ave, {location}", "contact": {"phone": "555-0102", "email": f"appointments@cardiocenter.{location.lower()}.com"}},
        {"provider_id": "PRV30987", "name": "Sunset Pediatrics", "provider_type": "Individual Practitioner", "specialty": "Pediatrics", "address": f"74 Kids Corner, {location}", "contact": {"phone": "555-0103", "email": f"info@sunsetpeds.{location.lower()}.net"}},
        {"provider_id": "PRV45678", "name": "Downtown Orthopedics", "provider_type": "Clinic", "specialty": "Orthopedics", "address": f"90 Spine Street, {location}", "contact": {"phone": "555-0104", "email": f"support@dt-ortho.{location.lower()}.com"}},
    ]
    
    filtered_providers = [p for p in providers if specialty.value.lower() in p['specialty'].lower() or p['specialty'] == 'Multi-specialty']
    return filtered_providers if filtered_providers else [providers[0]]


# --- Tool 2: get_healthcare_benefits ---

class Plan(str, Enum):
    HDHP = 'HDHP'
    HDHP_Plus = 'HDHP Plus'
    PPO = 'PPO'

@tool(name="get_healthcare_benefits", permission=ToolPermission.ADMIN)
def get_healthcare_benefits(plan: Plan) -> List[Dict[str, str]]:
    """
    Retrieves a comprehensive list of health benefits for a specific plan variant.

    

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
