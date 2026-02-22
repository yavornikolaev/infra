# Infrastructure-as-Code (IaC) for a Production-Grade AKS Platform

This repository contains Terraform configurations and a CI/CD pipeline for managing Azure (AKS) infrastructure. The project is organized into reusable modules and environments (`dev`, `prod`). The pipeline automates planning (`terraform plan`), review, and application (`terraform apply`) of infrastructure changes.

This README covers:
- How to work locally with Terraform (init / plan / apply)
- How the GitHub Actions workflow performs automated planning for pull requests
- Next steps to integrate with Ansible and Jenkins
- GitOps apps and observability stack deployed via Argo CD

## Repository layout
- `envs/` — environment-specific folders (`dev`, `prod`) with backend and environment configuration.
- `modules/` — reusable Terraform modules for Azure resources (rg, vnet, aks, iam, etc.).
- `.github/workflows/ci-cd.yaml` — GitHub Actions workflow that runs `terraform plan` on PRs and `terraform apply` on merge.
- `.terraform/` — provider binaries and lock files (not normally edited manually).
- `argocd/` — GitOps applications and Helm wrapper charts (monitoring/logging, Fluent Bit, Loki, etc.).

> Important: Never commit secrets (AWS keys, passwords) to the repository. Use GitHub Secrets and IAM roles for CI.

---

## Quick start (local)

1. Install Terraform (match the CI version if possible). Example (replace with the required version):

```bash
wget https://releases.hashicorp.com/terraform/1.4.0/terraform_1.4.0_linux_amd64.zip
unzip terraform_1.4.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

2. Configure Azure credentials locally:

```bash
az login
az account set --subscription <SUBSCRIPTION_ID>
```

3. Initialize and plan for an environment (example: `dev`):

```bash
cd envs/dev/azure
terraform init -input=false
terraform validate
terraform plan -out=tf.plan
```

4. Apply the plan (if approved):

```bash
terraform apply -input=false tf.plan
```

> Note: Use a remote backend (Azure Storage + state locking) for state storage and locking in team/production environments. Backend config lives in `envs/*/backend.tf`.

---

## GitHub Actions: `terraform-plan.yaml`

The workflow runs when a Pull Request touches `*.tf` or `*.tfvars`. Primary steps:
- Checkout the repository
- Configure Azure credentials (service principal or OIDC)
- Setup Terraform using `hashicorp/setup-terraform`
- `terraform init`, `terraform validate`, and `terraform plan`; save the plan as an artifact
- Convert the plan to plain text (`terraform show -no-color`) and publish it to workflow outputs
- Comment the plan on the PR (when the workflow is triggered by a pull_request)

This gives reviewers a clear view of the planned changes before merging.

---

## CI/Deploy (after merge)

The repo currently runs `plan` in PRs. To automate `apply`:
- Runs on `push` to `main` or on release tags.
- Require manual approval (GitHub Environments or other gating) before applying in `main`.

Example `apply` step in a workflow:

```yaml
- name: Terraform Apply
  run: |
    cd envs/dev
    terraform apply -input=false -auto-approve tf.plan
```

---

## Integration with Ansible

Recommended approaches:
- Use `terraform output -json` to export dynamic values (IPs, hostnames, kubeconfig) and feed them to Ansible as inventory or variables.
- After a successful `terraform apply`, a workflow can invoke Ansible playbooks (on the runner or a remote host) to configure software on the provisioned instances.

Typical flow:
1. Terraform apply -> produce `outputs.json`
2. Ansible job loads `outputs.json` as a dynamic inventory and runs playbooks

---

## Jenkins integration

If you prefer Jenkins, implement a similar split:

- Job A: Checkout + `terraform plan` (post plan output or comment on PR)
- Job B: Gated `terraform apply` (manual approval required)
- Job C: Run Ansible playbooks using the Terraform outputs

Security note: Use short-lived IAM credentials (STS assume-role) or Jenkins credentials store; run Jenkins in a secured network.

---

## Best practices
- Use remote state (S3 + DynamoDB) with locking
- Apply least-privilege IAM roles for CI runners
- Run static analysis / security checks: `tflint`, `tfsec`, `terraform validate`
- Add automated tests and review processes before `apply`
- Store plan and outputs as CI artifacts for auditing

---

## GitOps and Observability (Argo CD)

This repo also manages a small GitOps layer for Kubernetes apps under `argocd/`:
- **kube-prometheus-stack** (Prometheus + Grafana) with Grafana persistence and Recreate strategy for RWO PVCs.
- **Loki** (single-binary, filesystem storage) for log aggregation.
- **Fluent Bit** for log shipping to Loki.
- **Grafana provisioning** for Loki datasource.
- **Loki dashboards** (Grafana dashboards ConfigMaps) enabled by the Loki chart.

### App structure
- `argocd/argo-apps.yaml` — root app that discovers and syncs child apps.
- `argocd/applications/*` — per-app folders with `argocd-application.yaml`, `values.yaml`, and wrapper `Chart.yaml`.

### Notes
- Loki uses `X-Scope-OrgID: 1` via the Grafana datasource provisioning.
- Fluent Bit outputs are configured to send logs to Loki (not Elasticsearch).

---

## Next steps
- Add an `apply` workflow with GitHub Environment manual approval
- Add an example Ansible playbook and a GitHub Actions job that runs it after `apply`
- Provide a sample Jenkinsfile demonstrating plan -> apply -> ansible
