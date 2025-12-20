# Infrastructure-as-Code (IaC) за Production-Grade Cloud Platform

Този репозитори съдържа Terraform конфигурации и CI/CD pipeline за управление на инфраструктурата в AWS. Проектът е структуриран в модули и среди (environments) за `dev` и `prod`. Целта на pipeline-а е да автоматизира планирането (`terraform plan`), прегледа и приложението (`terraform apply`) на инфраструктурни промени.

В следващите раздели ще намерите инструкции как да:
- Работите локално с Terraform (init/plan/apply)
- Използвате GitHub Actions workflow за автоматично планиране в pull requests
- Подготвите интеграция с Ansible и Jenkins (следващи стъпки)

## Структура на репото
- `envs/` — среди (`dev`, `prod`) със собствени state/backends и конфигурации.
- `modules/` — многократно използваеми Terraform модули (vpc, ec2, eks, iam, sg и т.н.).
- `.github/workflows/terraform-plan.yaml` — workflow който изпълнява `terraform plan` при PR.
- `.terraform/` — доставчици и lock файлове.

> Важно: Никога не записвайте чувствителни данни (AWS ключове, пароли) в репото. Използвайте GitHub Secrets и IAM роли.

---

## Бърз старт (локално)

1. Инсталирайте Terraform (съобразете версията с тази в CI):

```bash
# примерна инсталация (заменете с актуална версия)
wget https://releases.hashicorp.com/terraform/1.4.0/terraform_1.4.0_linux_amd64.zip
unzip terraform_1.4.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

2. Подгответе AWS креденшъли (локално):

```bash
aws configure
# или експортиране на променливи
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=eu-central-1
```

3. Инициализация и план за дадена среда (пример `dev`):

```bash
cd envs/dev
terraform init -input=false
terraform validate
terraform plan -out=tf.plan
```

4. Приложете плана (ако е нужно):

```bash
terraform apply -input=false tf.plan
```

> Забележка: Конфигурацията на backend (S3/DynamoDB) се намира в `envs/*/backend.tf`. Препоръчително е да използвате remote backend в екипна/production среда.

---

## GitHub Actions workflow (`terraform-plan.yaml`)

Основната идея: при откриване на PR, в които се променят `*.tf` или `*.tfvars` файлове, workflow автоматично изпълнява `terraform plan` и публикува резултата като коментар в PR.

Ключови стъпки:
- Checkout на кода
- Configure AWS credentials (assume role) - `aws-actions/configure-aws-credentials`
- Setup Terraform - `hashicorp/setup-terraform`
- `terraform init`, `terraform validate`, `terraform plan` -> запис като артефакт
- `terraform show -no-color` -> запис в output и коментар в PR (при pull_request)

Така ревюиращите могат да видят точно какви ресурси ще бъдат създадени/изменени.

---

## CI/CD: apply и защита на production

За да приложите автоматично инфраструктурни промени след мердж:
- Добавете отделен workflow (или job) за `apply`, който се стартира при `push` в `main` или при release тег.
- Задължително включете manual approval / GitHub Environment protection и ограничете кой може да одобрява.

Примерна стъпка за apply (в workflow):

```yaml
- name: Terraform Apply
  if: github.ref == 'refs/heads/main'
  run: |
    cd envs/prod
    terraform init -input=false
    terraform apply -auto-approve
```

---

## Интеграция с Ansible

Подходи за интеграция:
- Използвайте `terraform output -json` за да извлечете динамични стойности (IP адреси, имена, kubeconfig) и ги подавайте на Ansible като inventory или променливи.
- След `terraform apply` workflow може да стартира Ansible playbook (в GitHub Actions runner или в отделен Jenkins job), който да конфигурира софтуера на инстанциите.

Примерен flow:
```markdown
# Infrastructure-as-Code (IaC) for a Production-Grade Cloud Platform

This repository contains Terraform configurations and a CI/CD pipeline for managing AWS infrastructure. The project is organized into reusable modules and environments (`dev`, `prod`). The pipeline automates planning (`terraform plan`), review, and application (`terraform apply`) of infrastructure changes.

This README covers:
- How to work locally with Terraform (init / plan / apply)
- How the GitHub Actions workflow performs automated planning for pull requests
- Next steps to integrate with Ansible and Jenkins

## Repository layout
- `envs/` — environment-specific folders (`dev`, `prod`) with backend and environment configuration.
- `modules/` — reusable Terraform modules (vpc, ec2, eks, iam, sg, etc.).
- `.github/workflows/terraform-plan.yaml` — GitHub Actions workflow that runs `terraform plan` on PRs.
- `.terraform/` — provider binaries and lock files (not normally edited manually).

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

2. Configure AWS credentials locally:

```bash
aws configure
# or export environment variables
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_REGION=eu-central-1
```

3. Initialize and plan for an environment (example: `dev`):

```bash
cd envs/dev
terraform init -input=false
terraform validate
terraform plan -out=tf.plan
```

4. Apply the plan (if approved):

```bash
terraform apply -input=false tf.plan
```

> Note: Use a remote backend (S3 + DynamoDB) for state storage and locking in team/production environments. Backend config lives in `envs/*/backend.tf`.

---

## GitHub Actions: `terraform-plan.yaml`

The workflow runs when a Pull Request touches `*.tf` or `*.tfvars`. Primary steps:
- Checkout the repository
- Configure AWS credentials (assume-role) via `aws-actions/configure-aws-credentials`
- Setup Terraform using `hashicorp/setup-terraform`
- `terraform init`, `terraform validate`, and `terraform plan`; save the plan as an artifact
- Convert the plan to plain text (`terraform show -no-color`) and publish it to workflow outputs
- Comment the plan on the PR (when the workflow is triggered by a pull_request)

This gives reviewers a clear view of the planned changes before merging.

---

## CI/Deploy (after merge)

The repo currently runs `plan` in PRs. To automate `apply`:
- Add a separate workflow/job that runs on `push` to `main` or on release tags.
- Require manual approval (GitHub Environments or other gating) before applying in `prod`.

Example `apply` step in a workflow:

```yaml
- name: Terraform Apply
  if: github.ref == 'refs/heads/main'
  run: |
    cd envs/prod
    terraform init -input=false
    terraform apply -auto-approve
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

## Next steps (I can add)
- Add an `apply` workflow with GitHub Environment manual approval
- Add an example Ansible playbook and a GitHub Actions job that runs it after `apply`
- Provide a sample Jenkinsfile demonstrating plan -> apply -> ansible

Tell me which option you want next and I will add it.

``` 
