#!/bin/bash
# Generated deployment script

# Script block 1
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

