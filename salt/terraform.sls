# Install Terraform
terraform:
  cmd.run:
    - name: wget https://releases.hashicorp.com/terraform/1.4.4/terraform_1.4.4_linux_amd64.zip -O /tmp/terraform.zip
    
    
# Unzip terraform
terraform-Unzip:
  cmd.run:
    - name: unzip /tmp/terraform.zip -d /tmp

# Move terraform to working location
terraform-move:
  cmd.run:
    - name: mv /tmp/terraform /usr/local/bin

# Terraform init
terraform-init:
  cmd.run:
    - name: terraform init
    - cwd: /vagrant/terraform/

# Terraform plan
terraform-plan:
  cmd.run:
   - name: terraform plan
   - cwd: /vagrant/terraform/

# Terraform apply
terraform-apply:
  cmd.run:
   - name: terraform apply -auto-approve
   - cwd: /vagrant/terraform/