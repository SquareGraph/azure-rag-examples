# RAG Application Infrastructure

## GENERAL COMMENT
Deploying this template on a free azure account is not possible. OpenAI paid PTU is pretty expensive, so when you run:
```bash
az deployment group create \
     --resource-group <YourResourceGroup> \
     --template-file iac/main.bicep \
     --parameters @iac/parameters.json
```
You get error that says:
```bash
{"code": "InvalidTemplateDeployment", "message": "The template deployment 'main' is not valid according to the validation procedure. The tracking id is 'db56ebe7-e6ca-4cea-aba3-2c5efdc2d614'. See inner errors for details."}

Inner Errors: 
{"code": "InsufficientQuota", "message": "Insufficient quota. Cannot create/update/move resource 'ragapp-openai-ptu'."}
```

## Overview

This repository contains Infrastructure as Code (IaC) templates written in [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview) for deploying a comprehensive Azure-based application architecture. The deployed infrastructure supports a Retrieval-Augmented Generation (RAG) application, leveraging various Azure services to provide scalable, reliable, and efficient operations.

## Architecture Components

### 1. API Management (APIM)
- **Modules**:
  - `apim-main.bicep`: Deploys the main APIM instance.
  - `apim-backend.bicep`: Configures backend services for OpenAI (PTU & PAYG).
  - `apim-subscription.bicep`: Manages APIM subscriptions.
  - `apim-utils.bicep`: Integrates utilities like Redis cache with APIM.
  - `apipm-api.bicep`: Defines APIs handled by APIM, including handlers and OpenAI integrations.
- **Description**: APIM serves as the gateway for API requests, managing access, enforcing policies, and facilitating communication between frontend applications and backend services.

### 2. Azure OpenAI Services
- **Module**:
  - `utils/openai.bicep`: Deploys OpenAI services with Provisioned (PTU) and Serverless (PAYG) throughput modes.
- **Description**: Provides AI capabilities for processing queries and generating responses, integrated with the APIM backend.

### 3. Event Grid
- **Module**:
  - `events/eventGrid.bicep`: Sets up an Event Grid topic for event-driven architectures.
- **Description**: Facilitates event routing and handling, enabling decoupled and scalable event-driven workflows.

### 4. Service Bus
- **Module**:
  - `events/serviceBus.bicep`: Deploys Service Bus namespaces and queues for message handling.
- **Description**: Manages message queues for handling high and low priority tasks, ensuring reliable and ordered message processing.

### 5. Azure Functions
- **Modules**:
  - `functions/azureFunctionHighPriority.bicep`: Deploys high-priority Azure Functions.
  - `functions/azureFunctionLowPriority.bicep`: Deploys low-priority Azure Functions integrated with Service Bus.
- **Description**: Executes serverless functions for processing tasks, with separate deployments for high and low priority workloads to optimize performance and cost.

### 6. Knowledge Base Services
- **Modules**:
  - `knowledge_base/blobStorage.bicep`: Sets up Blob Storage for storing files and data.
  - `knowledge_base/cognitiveSearch.bicep`: Deploys Cognitive Search for indexing and searching content.
  - `knowledge_base/cosmosDb.bicep`: Configures Cosmos DB for scalable and globally distributed database services.
- **Description**: Provides storage, search, and database capabilities essential for the RAG application's knowledge base.

### 7. Redis Cache
- **Module**:
  - `utils/redis.bicep`: Deploys Redis Cache for caching data to enhance performance.
- **Description**: Caches frequently accessed data to reduce latency and improve application responsiveness.

## Deployment

### Prerequisites
- **Azure Subscription**: Ensure you have an active Azure subscription.
- **Azure CLI**: Install the [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli).
- **Bicep CLI**: Install the [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install).
- **Permissions**: Sufficient permissions to create and manage Azure resources.

### Steps to Deploy

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/rag-application-infrastructure.git
   cd rag-application-infrastructure
   ```

2. **Customize Parameters**:
   Modify `iac/parameters.json` to set your desired configuration values such as `prefix`, `env`, `apimName`, etc.

3. **Deploy the Infrastructure**:
   ```bash
   az deployment group create \
     --resource-group <YourResourceGroup> \
     --template-file iac/main.bicep \
     --parameters @iac/parameters.json
   ```

## File Structure

- `iac/`
  - `main.bicep`: Entry point for deploying all infrastructure modules.
  - `api/`: Contains APIM-related Bicep templates.
  - `events/`: Contains Event Grid and Service Bus Bicep templates.
  - `functions/`: Contains Azure Functions Bicep templates.
  - `knowledge_base/`: Contains Blob Storage, Cognitive Search, and Cosmos DB Bicep templates.
  - `utils/`: Contains utility services like OpenAI and Redis Bicep templates.
  - `parameters.json`: Parameter file for deployment configurations.

## Configuration

### Parameters

The deployment relies on several parameters to customize the infrastructure:

- **General**:
  - `location`: Azure region for resource deployment.
  - `prefix`: Prefix for resource naming.
  - `env`: Environment identifier (`dev`, `test`, `prod`).

- **APIM**:
  - `apimName`: Name of the APIM instance.
  - `apiGatewayName`: Name of the API Gateway.

- **Cosmos DB**:
  - `cosmosAccountName`: Cosmos DB account name.
  - `databaseName`: Name of the Cosmos DB database.
  - `containerName`: Name of the Cosmos DB container.
  - Additional parameters for consistency levels and scaling.

- **Service Bus**:
  - `sbNamespaceName`: Service Bus namespace name.

- **Azure Functions**:
  - `workerRuntime`: Runtime environment for Azure Functions (e.g., `python`).
  - `sbNamespaceName`: Service Bus namespace name for low-priority functions.

### Outputs

After deployment, several outputs are provided for integration:

- **APIM**:
  - APIM instance details and endpoints.

- **Service Bus**:
  - Connection strings and queue names.

- **Azure Functions**:
  - Function App IDs and hostnames.

- **Redis Cache**:
  - Connection strings and hostnames.

## Best Practices

- **Modularization**: The templates are modularized for maintainability and scalability. Each Azure service has its own Bicep file, promoting reuse and separation of concerns.

- **Parameterization**: Use the `parameters.json` file to manage configurations, making deployments adaptable to different environments.

- **Security**: Sensitive information like connection strings should be managed securely, possibly using Azure Key Vault.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your enhancements.

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any questions or support, please contact [mrcndabrowski@gmail.com](mailto:mrcndabrowski@gmail.com).
