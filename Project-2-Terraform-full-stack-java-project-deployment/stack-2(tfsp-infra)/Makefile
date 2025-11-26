TFDIR = .
ENVNAME=development

.PHONY: init
init:
	@echo "Initializing Terraform in environment: $(ENVNAME)"
	cd $(TFDIR) && terraform init

.PHONY: fmt
fmt:
	@echo "Formatting Terraform code"
	cd $(TFDIR) && terraform fmt $(ARG) $(FILE)

.PHONY: validate
validate:
	@echo "Validating Terraform configurations"
	cd $(TFDIR) && terraform validate

.PHONY: plan
plan:
	@echo "Planning Terraform changes in environment: $(ENVNAME)"
	cd $(TFDIR) && terraform plan -var-file=./environments/$(ENVNAME)/terraform.tfvars

.PHONY: apply
apply:
	@echo "Applying Terraform changes to environment: $(ENVNAME)"
	cd $(TFDIR) && terraform apply -var-file=./environments/$(ENVNAME)/terraform.tfvars

.PHONY: destroy
destroy:
	@echo "Destroying Terraform-managed resources in environment: $(ENVNAME)"
	cd $(TFDIR) && terraform destroy -var-file=./environments/$(ENVNAME)/terraform.tfvars

.PHONY: output
output:
	@echo "Retrieving Terraform outputs from environment: $(ENVNAME)"
	cd $(TFDIR) && terraform output $(ARG) $(NAME)

.PHONY: clean
clean:
	@echo @echo "Cleaning .terraform directory and backup files for environment: $(ENVNAME)"
	cd $(TFDIR) && rm -rf .terraform .terraform.lock.hcl