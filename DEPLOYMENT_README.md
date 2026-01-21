# Minimal GitHub Actions Workflow for .NET App Deployment

This workflow builds your .NET app, creates a Docker image, pushes it to Azure Container Registry (ACR), and deploys it to Azure App Service for Containers.

## Prerequisites
- Azure resources (ACR and App Service) must already exist (see infra/ folder).
- The following GitHub repository secrets must be set:
  - `AZURE_CLIENT_ID`: Azure service principal client ID
  - `AZURE_TENANT_ID`: Azure tenant ID
  - `AZURE_CLIENT_SECRET`: Azure service principal client secret
  - `AZURE_CONTAINER_REGISTRY`: ACR login server (e.g., myregistry.azurecr.io)
  - `AZURE_WEBAPP_NAME`: Name of the App Service Web App
  - `AZURE_RESOURCE_GROUP`: Resource group containing the App Service

## How to Configure Secrets
1. Go to your GitHub repository > Settings > Secrets and variables > Actions.
2. Add each secret above with the correct value from your Azure environment.

## Variables
- You may also set variables (e.g., `IMAGE_NAME`) as needed in the workflow file.

---

This workflow assumes your Dockerfile is in the `src/` directory and the .NET project is named `ZavaStorefront`.
