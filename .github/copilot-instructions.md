# Copilot Instructions for This Repository

This repository contains Terraform for an Azure hub-spoke landing zone. When generating or suggesting HCL in this repo, follow these conventions:

## Provider & Version Pinning

- Use the \zurerm\ provider, pinned via \~>\ constraint in the root \	erraform\ block — do not introduce a second provider version constraint in a module.
- Do not hardcode a provider block inside any module — modules inherit the provider from the root.

## Naming Conventions

- Resource group names: \g-<scope>-<environment>\ (e.g. \g-spoke-dev\, \g-hub-landingzone\)
- VNets: \net-<scope>-<environment>\ (e.g. \net-spoke-prod\)
- NSGs: \
sg-<environment>-<subnet-purpose>\
- Key Vaults / Storage Accounts: must be globally unique — suffix with a short deterministic hash, not a random value, so plans stay stable across runs.

## Module Structure

- Every module has exactly three files: \main.tf\, \ariables.tf\, \outputs.tf\.
- Every variable requires a \description\.
- Prefer \or_each\ over \count\ for anything keyed by a meaningful identifier (environment name, subnet name) rather than a numeric index.
- Never use \count\ or \or_each\ conditioned on a value that is unknown until apply (e.g. an attribute of a resource created earlier in the same plan) — use a plain boolean variable instead.

## Tagging

- Every taggable resource must include at minimum: \environment\ and \managed_by = "terraform"\.

## Secrets

- Never hardcode secrets, connection strings, or credentials in \.tf\ files.
- Any secret-shaped value must come from a Key Vault data source or a variable with no committed default.

## Lifecycle & Safety

- Core shared infrastructure (hub resource group, hub VNet) must carry \lifecycle { prevent_destroy = true }\.
- Outputs exposing subnet IDs, connection details, or anything sensitive must be marked \sensitive = true\.

Suggestions that violate these conventions should be revised before acceptance, not merged as-is.
