#!/bin/bash
# Generated deployment script

# Script block 1
pip install "ibm-watsonx-orchestrate[adk]"
    ```
2.  **Python Environment**: A Python version compatible with the ADK (e.g., Python 3.10 or later) is required. Use a virtual environment to manage dependencies.
    ```bash
    # Create a virtual environment
    python -m venv venv

    # Activate the virtual environment (macOS/Linux)
    source venv/bin/activate
    # On Windows: venv\Scripts\activate
    ```
3.  **Project Structure**: Create a dedicated project directory to organize your files.
    ```bash
    mkdir innovate_inc_onboarding_demo
    cd innovate_inc_onboarding_demo
    mkdir agents
    mkdir tools
    mkdir tools/hris_tools
    mkdir tools/it_tools
    mkdir tools/compliance_tools
    ```
4.  **Python Dependencies**: Create a `requirements.txt` file in the root of your project directory. This is a best practice for managing dependencies. For this demo, no external packages are strictly necessary, but `requests` is commonly used and good to include.
    ```bash
    # Create the file
    touch requirements.txt
    # Add content to requirements.txt
    echo "requests" > requirements.txt
    # Install dependencies
    pip install -r requirements.txt
    ```
5.  **Orchestrate Environment Login**: Ensure you are authenticated with your watsonx Orchestrate environment via the CLI.
    ```bash
    orchestrate login
    ```

## Step 1: Create Custom Tools with Python

We will create a suite of Python-based tools that simulate interactions with Innovate Inc.'s backend systems. Each tool generates realistic synthetic data to provide a tangible and convincing demo experience.

### 1.1 HRIS Tools

These tools simulate interactions with a Human Resource Information System (HRIS), forming the foundation of the onboarding process.

**Business Value:** Automating HRIS interactions eliminates manual data entry errors, ensures consistency, and creates an immediate, official record for new employees, which is a prerequisite for all subsequent onboarding steps.

**File:** `tools/hris_tools/hr_system.py`

