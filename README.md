# landing_zone_key_valult_v2
Landing_Zone_KeyVault_v2.0/
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── backend.tf
│   │
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       ├── providers.tf
│       └── backend.tf
│
├── modules/
│   ├── azurerm_rg/
│   ├── azurerm_vnet/
│   ├── azurerm_subnet/
│   ├── azurerm_bastion/
│   ├── azurerm_public_ip/
│   ├── azurerm_vm/
│   ├── azurerm_keyvault/
│   ├── azurerm_storage/
│   ├── azurerm_firewall/       # New
│   ├── azurerm_vnet_peering/   # New
│   ├── azurerm_nsg/            # New
│   ├── azurerm_route_table/    # New
│   └── azurerm_recovery_vault/ # New, if using Azure Backup
│
├── .gitignore
└── README.md

# Azure Hub-and-Spoke Landing Zone using Terraform

## 1. Project Overview

This project implements a reusable Azure Landing Zone using Terraform and the Hub-and-Spoke network architecture.

The solution separates shared network services from application workloads and supports independent Dev and Prod environments through reusable Terraform modules.

### Objectives

- Implement a secure and scalable Azure Landing Zone.
- Centralize network connectivity and security services in the Hub VNet.
- Isolate Dev and Prod workloads in separate Spoke VNets.
- Reuse Terraform modules to reduce code duplication.
- Apply network segmentation, NSGs, routing and private connectivity.
- Support separate environment configurations and Terraform state files.
- Enable backup, disaster recovery, monitoring and governance.

## 2. Repository Structure

```text
Landing_Zone_KeyVault_v2.0/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       ├── outputs.tf
│       ├── providers.tf
│       └── backend.tf
├── modules/
│   ├── azurerm_rg/
│   ├── azurerm_vnet/
│   ├── azurerm_subnet/
│   ├── azurerm_bastion/
│   ├── azurerm_public_ip/
│   ├── azurerm_vm/
│   ├── azurerm_keyvault/
│   ├── azurerm_storage/
│   ├── azurerm_firewall/
│   ├── azurerm_vnet_peering/
│   ├── azurerm_nsg/
│   ├── azurerm_route_table/
│   └── azurerm_recovery_vault/
├── .gitignore
└── README.md
```

The additional modules are proposed extensions to the existing repository and must be created before they can be referenced.

## 3. Hub-and-Spoke Architecture

### Hub VNet

The Hub VNet provides centralized network services shared by application spokes.

Recommended components:

- Azure Firewall for centralized traffic inspection and egress control.
- Azure Bastion for secure VM administration without public IPs on VMs.
- Azure DNS Private Resolver or suitable DNS infrastructure when required.
- Dedicated AzureBastionSubnet and AzureFirewallSubnet.
- Network monitoring, diagnostic settings and security policies.

### Dev Spoke VNet

The Dev Spoke hosts development and testing workloads.

Example address space: 10.10.0.0/16.

Recommended subnets include application workloads, VM workloads and private endpoints, according to application requirements.

### Prod Spoke VNet

The Prod Spoke hosts production workloads.

Example address space: 10.20.0.0/16.

Production workloads should have stricter access controls, controlled deployments, monitoring and backup policies.

### VNet Peering and Routing

Configure peering between the Hub and each Spoke.

- Hub-to-Dev peering.
- Hub-to-Prod peering.
- Configure forwarding and gateway transit options only when required.
- Use user-defined routes to direct selected traffic through Azure Firewall.
- Apply NSGs to restrict traffic between network segments.
- Do not assume VNet peering automatically provides transitive routing between spokes.

If Dev-to-Prod communication is required, implement explicit routing and security controls.

## 4. Terraform Module Responsibilities

| Module | Responsibility |
|---|---|
| azurerm_rg | Creates resource groups |
| azurerm_vnet | Creates Hub and Spoke VNets |
| azurerm_subnet | Creates workload and service subnets |
| azurerm_vnet_peering | Establishes Hub-Spoke connectivity |
| azurerm_firewall | Creates the centralized firewall |
| azurerm_nsg | Defines subnet or NIC traffic rules |
| azurerm_route_table | Controls traffic paths through UDRs |
| azurerm_bastion | Provides secure VM access |
| azurerm_public_ip | Creates public IPs for services that require them |
| azurerm_vm | Deploys virtual machines |
| azurerm_keyvault | Stores secrets, keys and certificates |
| azurerm_storage | Creates storage for application or state requirements |
| azurerm_recovery_vault | Supports Azure VM backup when configured |

Each module should contain its own main.tf, variables.tf and outputs.tf.

## 5. Environment Separation

The environments/dev and environments/prod directories are independent Terraform root modules.

Each environment should define:

- Provider and subscription configuration.
- Environment-specific variables.
- Module calls.
- Resource naming and address ranges.
- Backend configuration for remote state.
- Outputs for important resource IDs and network information.

Use separate remote state keys for Dev and Prod. Keep state in a secured Azure Storage Account with restricted access, state locking, versioning and recovery protections as appropriate.

## 6. Security Best Practices

- Use Microsoft Entra ID and least-privilege RBAC.
- Prefer managed identities over embedded credentials.
- Store secrets in Azure Key Vault.
- Enable Key Vault soft delete and purge protection.
- Avoid public IP addresses on application VMs unless explicitly required.
- Use Azure Bastion for administrative access.
- Restrict inbound and outbound traffic with NSGs and Azure Firewall.
- Use private endpoints and private DNS where supported and appropriate.
- Enable diagnostic settings and centralized logging.
- Never commit terraform.tfstate, secret files or credentials to Git.

## 7. Backup and Disaster Recovery

- Enable Azure Backup for supported production workloads.
- Define retention policies based on business requirements.
- Protect critical storage and state data with suitable redundancy and recovery controls.
- Use Azure Site Recovery where VM replication and regional failover are required.
- Define recovery point objective (RPO) and recovery time objective (RTO).
- Test restores and disaster recovery procedures periodically.
- Keep the recovery region and dependent services aligned with the DR design.

A Recovery Services vault provides backup and/or Site Recovery capabilities depending on the configured solution; creating the vault alone does not configure disaster recovery.

## 8. Deployment Workflow

1. Configure Azure authentication and subscription context.
2. Configure the remote state backend.
3. Initialize Terraform.
4. Validate Terraform configuration.
5. Run formatting and security scans.
6. Review the Terraform plan.
7. Apply the approved plan.
8. Validate Hub-Spoke peering, routing, DNS and security.
9. Verify monitoring and backup configuration.

Example commands from the Dev environment:

```powershell
cd environments/dev

terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Review the plan and obtain required approval before applying changes, particularly in production.

## 9. Expected Outcome

The completed Landing Zone will provide a reusable and governed foundation for Azure workloads, with centralized shared services, isolated Dev and Prod networks, modular infrastructure code and a defined security, monitoring and recovery strategy.



