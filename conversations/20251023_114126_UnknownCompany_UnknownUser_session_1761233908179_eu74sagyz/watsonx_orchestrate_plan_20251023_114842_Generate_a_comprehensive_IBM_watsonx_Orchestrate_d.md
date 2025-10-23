# IBM watsonx Orchestrate Execution Plan

**Generated:** 2025-10-23 11:48:42
**Question:** Generate a comprehensive IBM watsonx Orchestrate demo plan for this client
**Agent:** IBM watsonx Orchestrate Planner Agent

## Execution Plan

# IBM watsonx Orchestrate Execution Plan: AI-Powered Employee Self-Service Assistant

## Overview
This execution plan provides a comprehensive, step-by-step guide to building and deploying the "AI-Powered Employee Self-Service Assistant" for the client. The objective is to create a proof-of-concept that directly addresses the client's need for a low-friction, high-impact solution to reduce the burden on HR and IT support teams. This plan will construct a single, intelligent watsonx Orchestrate agent that leverages a curated knowledge base of internal documents for instant answers (RAG) and custom tools to automate routine transactional tasks. The resulting agent will empower employees with 24/7 self-service capabilities, demonstrating a rapid and tangible return on investment in AI automation.

The plan meticulously follows the proposed agent architecture, using a native watsonx Orchestrate agent (`Employee_Support_Agent`) equipped with a built-in knowledge base (`internal_support_kb`) and two Python-based tools (`order_supplies`, `check_system_status`). Every step is designed to be practical and actionable, with complete code examples and CLI commands based on the IBM watsonx Orchestrate Agent Development Kit (ADK) best practices.

## Prerequisites
Before beginning, ensure your development environment meets the following requirements:

1.  **IBM watsonx Orchestrate ADK**: The Agent Development Kit must be installed. If not, install it using pip:
    ```bash
    pip install "ibm-watsonx-orchestrate[all]"
    ```
2.  **Active watsonx Orchestrate Environment**: You must have an active environment configured and initialized. This can be a local developer edition or a cloud instance. Verify your setup with:
    ```bash
    orchestrate env
    ```
3.  **Python**: Python version 3.9 or higher is required.
4.  **Project Directory**: A dedicated directory to organize all configuration files, documents, and tools.
5.  **Mock Documents**: The two mock documents (`FAQs.pdf`, `Troubleshooting_Guide.docx`) must be created and available.

## Step 1: Project Setup and Mock Data Creation

First, we will establish a structured project directory to organize all the components of our agent. This ensures a clean and manageable development process.

**Action:** Create the following directory structure in your local development environment.

```
employee-assistant-demo/
├── knowledge_docs/
│   ├── FAQs.pdf
│   └── Troubleshooting_Guide.docx
├── tools/
│   ├── supply_tools.py
│   └── system_tools.py
├── knowledge_bases/
│   └── internal_support_kb.yaml
├── agents/
│   └── employee_support_agent.yaml
└── requirements.txt
```

**Action:** Create the mock data files. For this demo, you can create simple text files and save them as the specified formats (`.pdf`, `.docx`).

1.  **`knowledge_docs/FAQs.pdf`**: Create a PDF document with the following content.

    > **Employee Frequently Asked Questions**
    >
    > **Q: What is the company's policy on remote work?**
    > A: Eligible employees may work remotely up to three days per week with manager approval. The specific days should be agreed upon with your direct manager. All remote work must be conducted from your primary country of residence.
    >
    > **Q: How do I request vacation time?**
    > A: All vacation requests must be submitted through the 'HR Portal' at least two weeks in advance. Requests are subject to manager approval and business needs.
    >
    > **Q: What is the guest policy for the office?**
    > A: Employees can register guests at the front desk. Guests must be accompanied by the employee at all times while on the premises. For extended visits, please notify office management.

2.  **`knowledge_docs/Troubleshooting_Guide.docx`**: Create a Word document with the following content.

    > **IT Troubleshooting Guide**
    >
    > **Problem: Cannot connect to the office Wi-Fi.**
    > Solution: Ensure you are connecting to the 'CorpWifi' network. The password is 'CorporateAccess2024!'. If the connection fails, try forgetting the network on your device and reconnecting. If issues persist, restart your device.
    >
    > **Problem: My VPN connection is failing.**
    > Solution: First, check the status of the VPN service using the 'check_system_status' command in the employee assistant. If the service is operational, ensure you are using the latest version of the VPN client. A system restart can also resolve common connection issues.

## Step 2: Create the Knowledge Base Configuration

The knowledge base is the foundation of the agent's ability to answer questions from documents. We will define a built-in knowledge base that ingests our mock PDF and DOCX files.

**Business Value:** This component enables Retrieval-Augmented Generation (RAG), allowing the agent to provide accurate, context-aware answers based on trusted internal documentation. This directly deflects common questions from HR and IT, freeing up their time for more complex issues.

**Action:** Create the file `knowledge_bases/internal_support_kb.yaml` with the following content.

```yaml
# knowledge_bases/internal_support_kb.yaml
spec_version: v1
kind: knowledge_base 
name: internal_support_kb
description: >
   Contains internal company documents including HR policies, IT troubleshooting guides, and general office information. 
   Use this to answer employee questions about remote work, vacation policies, guest access, and common technical issues.
documents:
   - "knowledge_docs/FAQs.pdf"
   - "knowledge_docs/Troubleshooting_Guide.docx"
vector_index:
   # Using the default embedding model for simplicity
   embeddings_model_name: ibm/slate-125m-english-rtrvr-v2
```

## Step 3: Develop the Custom Python Tools

Tools empower the agent to perform actions beyond answering questions. We will create two tools to handle transactional requests for ordering supplies and checking system status.

### Tool 1: Order Office Supplies

**Business Value:** This tool automates the repetitive and low-value task of ordering office supplies. It provides an instant, 24/7 service for employees, improving their productivity while reducing the administrative workload on office management or support staff.

**Technical Implementation:** The `order_supplies`

---
*Plan generated by IBM watsonx Orchestrate Planner Agent*
