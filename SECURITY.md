# Security Policy

## Supported Scope

This repository contains Terraform Infrastructure-as-Code for an Azure hub-spoke landing zone (network, identity, secrets, observability, and governance modules) plus its GitHub Actions CI/CD pipeline. Security concerns in scope include:

- Misconfigured Azure resources (overly permissive NSG rules, public storage/Key Vault access, missing encryption)
- Secrets or credentials committed to the repository
- Overly broad IAM/RBAC role assignments
- CI/CD pipeline weaknesses (unpinned actions, missing OIDC scoping, workflow injection risks)

## Reporting a Vulnerability

If you discover a security issue in this repository:

1. Do **not** open a public GitHub Issue for the finding.
2. Report it privately by contacting the repository owner directly, or by using GitHub's private vulnerability reporting feature under the Security tab.
3. Include the affected file/module, a description of the issue, and — if applicable — the potential impact (e.g. data exposure, privilege escalation).

## Automated Scanning

This repository uses the following automated tooling to catch issues before merge:

- **terraform fmt / validate** — syntax and formatting checks on every pull request
- **tfsec / Checkov** — static analysis for insecure Terraform configurations
- **GitHub Secret Scanning** — detects committed credentials
- **Dependabot** — flags outdated GitHub Actions dependencies

Findings from these tools are triaged and remediated before merge to main. No plaintext secrets, connection strings, or credentials are permitted in this repository — all sensitive values are sourced from Azure Key Vault at runtime or stored as encrypted GitHub Secrets.

## Response Expectations

As a training/portfolio project, response times are best-effort. Genuine findings will be acknowledged and remediated as promptly as possible.
