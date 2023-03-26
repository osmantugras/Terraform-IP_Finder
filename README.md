# Terraform-IP_Finder
Using ip_finder.sh script you can avoid IP collision before creating a VM on Proxmox. The example is for /24 subnet mask. Also, you can change the max value for the different subnet masks.

1. Firstly run the ip_finder.sh script with `source ip_finder.sh`. You must use the source command to assign the environment value to the VM_IP value. 

2. The script creat vars.tf variable file that includes the unique IP address.

3. Finally you can run the commands `terraform init`, `terraform plan` and `terraform apply`

