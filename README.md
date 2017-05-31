### terraform-starter

Make sure you add your own AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY within provider.tf 
I added XXXXXXXXXXXX as a place holder for my personal ones.

I personally use Environmental variables for azure, AWS. Personally I defined them in my ~/.bashrc

BTW, these are proven working for AZURE provisioning on (MAC, Linux), I don't think that I am a windows user, export these following  env vars and you are set

 ARM_CLIENT_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
 ARM_CLIENT_NAME="XXXXXXXXXXXXXXXXXXXXXX"
 ARM_CLIENT_SECRET="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX="
 ARM_SUBSCRIPTION_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 ARM_TENANT_ID="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

One important little issue, while creating kubernetes cluster using ``` resource "azurerm_container_service" ``` you will need to manually add client_ID as well as client_secret regardless if you are definning them as an environment variable or not. They coule be called definitely from variables but the environment variable won't work, I will raise an issue with hashicorp.

export AWS_ACCESS_KEY_ID=XXX
export AWS_SECRET_ACCESS_KEY=XXX
export AWS_DEFAULT_REGION=XXX          <- Make sure you set this one too!
