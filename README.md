# Azure Hub-Spoke Landing Zone

Terraform-based Azure landing zone implementing a hub-spoke network topology with governance, identity, secrets, and observability layers, deployed via a GitHub Actions CI/CD pipeline using OIDC authentication.

## Architecture

A governance layer applies Azure Policy at the subscription level (allowed regions, required tags). A hub virtual network contains Azure Firewall, Azure Bastion, and a reserved VPN/ExpressRoute gateway subnet, providing a single point of control for inbound connectivity and outbound internet egress. Three spoke virtual networks — dev, test, and prod — peer bidirectionally with the hub. Each spoke's subnets route default traffic through the hub firewall, and each spoke has its own isolated Key Vault (RBAC mode), storage account, Log Analytics workspace, and least-privilege managed identity scoped to that spoke's resource group only.

## Module Structure

\\\
modules/
├── hub-network/       # Hub VNet, Firewall, Bastion, Gateway subnet
├── spoke-network/     # Spoke VNet, subnets, NSGs, route tables
├── spoke-peering/     # Hub <-> spoke VNet peering
├── data-secrets/      # Key Vault (RBAC) + Storage Account per spoke
├── observability/     # Log Analytics + diagnostic settings
├── identity/          # User-assigned identity + least-privilege RBAC
├── governance/        # Azure Policy definitions and assignments
└── workload/          # Parameterized compute (App Service by default)
\\\

## Prerequisites

- Terraform >= 1.1.0
- Azure CLI, authenticated to the target subscription
- An Azure AD app registration with a federated identity credential trusting this repository's GitHub Actions OIDC issuer (for CI/CD use)

## Running Locally

\\\ash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
\\\

Local runs authenticate via your logged-in Azure CLI session (\z login\).

## Running via CI/CD

Pushes and pull requests targeting \main\ automatically trigger \.github/workflows/terraform-ci.yml\, which runs \mt\, \init\, \alidate\, a security scan (tfsec/Checkov), and \plan\. All required checks must pass before a PR can merge.

Deployment (\	erraform apply\) runs via \.github/workflows/terraform-apply.yml\, authenticated through Azure AD Workload Identity Federation (OIDC) — no stored client secret. This workflow requires manual triggering, ensuring no infrastructure change is ever applied without a deliberate human action.

## Remote State

State is stored in an Azure Storage Account with blob locking enabled, configured in the \ackend \"azurerm\"\ block in the root \main.tf\.

## Security

See \SECURITY.md\ for the vulnerability disclosure policy and the automated scanning tools used in this repository.
