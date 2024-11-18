#!/bin/bash

# Define ANSI escape sequences for colors
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"
CYAN="\033[36m"
BOLD="\033[1m"


# Define sublists of URLs for BlueXP and Azure
BlueXPconnector_urls=(
    "https://support.netapp.com"
    "https://mysupport.netapp.com"
    "https://cloudmanager.cloud.netapp.com/tenancy"
    "https://stream.cloudmanager.cloud.netapp.com"
    "https://production-artifacts.cloudmanager.cloud.netapp.com"
    "https://azuresdkdocs.blob.core.windows.net" 
	"https://cloudmanagerinfraprod.azurecr.io"
)

SaaS_features_services_url=(
    "https://api.bluexp.netapp.com"
    "https://cloudmanager.cloud.netapp.com"
    "https://netapp-cloud-account.auth0.com"

)
azure_urls_Azurepublicregions=( 
    "https://login.microsoftonline.com"
	"https://management.azure.com"
	"https://public.blob.core.windows.net" 
	"https://azuresdkdocs.blob.core.windows.net" 
	
)
azure_urls_AzureChinaregions=( 
	"https://management.chinacloudapi.cn"
	"https://login.chinacloudapi.cn"
    "https://management.core.chinacloudapi.cn" 
	"https://test.blob.core.chinacloudapi.cn" 

)

awsGlobal_endpoints_urls=(
    "https://iam.amazonaws.com"
)

Gcp_Urls=(
	"https://www.googleapis.com/compute/v1/"
	"https://compute.googleapis.com/compute/v1"
	"https://cloudresourcemanager.googleapis.com/v1/projects"
	"https://www.googleapis.com/compute/beta"
	"https://storage.googleapis.com/storage/v1"
	"https://www.googleapis.com/storage/v1"
	"https://iam.googleapis.com/v1"
	"https://cloudkms.googleapis.com/v1"
	"https://www.googleapis.com/deploymentmanager/v2/projects"
)
#function to check Azure Urls for Alias
check_Url_Alias_string() {  
    # Check if the string matches the provided parameter value
    if [ "$1" ==  "https://azuresdkdocs.blob.core.windows.net" ]; then
        result="https://*.blob.core.windows.net"
    elif [ "$1" ==  "https://public.blob.core.windows.net" ]; then
        result="https://*.core.windows.net"
	elif [ "$1" ==  "https://azuresdkdocs.blob.core.windows.net" ]; then
        result="https://*.blob.core.windows.net"		
	elif [ "$1" ==  "https://management.core.chinacloudapi.cn" ]; then
        result="https://*.core.chinacloudapi.cn"		
	elif [ "$1" ==  "https://test.blob.core.chinacloudapi.cn" ]; then
        result="https://*.blob.core.chinacloudapi.cn"	
    else
        echo -e "$1"	
    fi	
    # Return the result
    echo "$result"
}
# Function to check URL connectivity
check_connectivity() {
   local sublist_name=$1
  shift
   local urls=("$@")  
  echo -e "${GREEN}${BOLD}************************************${RESET}"
  echo -e "${CYAN}${BOLD}Checking $sublist_name URLs:${RESET}"
  timeout_value=1
  
  for url in "${urls[@]}"; do
    response=$(wget --timeout=$timeout_value --spider  "$url" 2>&1)
    # calling the function to return Alias Url string
	outputUrl=$(check_Url_Alias_string "$url")
	if [[ $response == *"connected."* ]]; then	 
       echo -e "${GREEN}${BOLD}$outputUrl is reachable. ${RESET}"  # Print in green if connected or if it returns 4xx error
    elif [[ $response == *"failed: Connection timed out"* ]]; then	  
      echo -e "${YELLOW}${BOLD} $outputUrl connection timed out. ${RESET}"  # Print in red if connection timed out
    else	   
      echo -e "${RED}${BOLD} $outputUrl is not reachable. ${RESET}"  # Print in red if not connected
	  echo -e "${RED}${BOLD} $response ${RESET}" | grep "wget:"
    fi	
	sleep 2
  done
  echo ""

}



# Check connectivity for BlueXP Connector URLs
check_connectivity "Connectivity to Core BlueXP Endpoint" "${BlueXPconnector_urls[@]}"
  echo -e "-----------------------------------------------------------------------------------------------------------------" 
# Check connectivity for SaaS Features Services URLs
check_connectivity "Endpoint Connectivity for BlueXP SaaS Features and Services" "${SaaS_features_services_url[@]}"
  echo -e "-----------------------------------------------------------------------------------------------------------------"
# Check connectivity for Azure Public Regions URLs
check_connectivity "Endpoint Connectivity for Azure Public Regions" "${azure_urls_Azurepublicregions[@]}"
  echo -e "-----------------------------------------------------------------------------------------------------------------"
# Check connectivity for Azure China Regions URLs
check_connectivity "Endpoint Connectivity for Azure China Regions" "${azure_urls_AzureChinaregions[@]}"
  echo -e "-----------------------------------------------------------------------------------------------------------------"
# Check connectivity for GCP URLs
check_connectivity "Endpoint Connectivity for Google Cloud" "${Gcp_Urls[@]}"
  echo -e "-----------------------------------------------------------------------------------------------------------------"
# Check connectivity for AWS Global Endpoints URLs
check_connectivity "Connectivity to Global AWS Endpoint" "${awsGlobal_endpoints_urls=[@]}"
 echo -e "-----------------------------------------------------------------------------------------------------------------"

# Declare an empty array for Aws_Urls 
Aws_Urls=()
Aws_Service_Code=(
 "Ec2"
 "KMS"
 "STS"
 "S3"
 "cloudformation"
)

Aws_Region_Code=()

# Function to print a row in the table
print_row() {
    printf "| %-40s | %-25s |\n" "$1" "$2" 
}

echo -e " ${CYAN}${BOLD}################################################################## ${RESET}"
echo -e "${YELLOW}The URLSs for AWS is described as below:.${RESET}"
echo -e "${CYAN}The format is  ${BOLD} protocol://service-code.region-code.amazonaws.com.${RESET}"
echo ""
echo " Service Codes as follows :----- " 
echo " Elastic Compute Cloud (EC2) "
echo " Key Management Service (KMS) "
echo " Security Token Service (STS) "
echo " Simple Storage Service (S3) "
echo " Simple Storage Service (cloudformation) "
echo -e " ${CYAN}${BOLD}################################################################## ${RESET}"

# Print the table header
printf "| %-40s | %-20s |\n" "Name" "Region-Code" 
printf "|------------------------------------------|---------------------------|\n"

# Print each row in the table
print_row    "US East (Ohio)"	 "us-east-1"
print_row    "US East (N. Virginia)"	"us-east-2"
print_row    "US West (N. California)"    "us-west-1"
print_row    "US West (Oregon)"    "us-west-2"
print_row    "Africa (Cape Town)"    "af-south-1"
print_row    "Asia Pacific (Hong Kong)"    "ap-east-1"
print_row    "Asia Pacific (Hyderabad)"    "ap-south-2"
print_row    "Asia Pacific (Jakarta)"    "ap-southeast-3"
print_row    "Asia Pacific (Melbourne)"    "ap-southeast-4"
print_row    "Asia Pacific (Mumbai)"    "ap-south-1"
print_row    "Asia Pacific (Osaka)"    "ap-northeast-3"
print_row    "Asia Pacific (Seoul)"    "ap-northeast-2"
print_row    "Asia Pacific (Singapore)"    "ap-southeast-1"
print_row    "Asia Pacific (Sydney)"    "ap-southeast-2"
print_row    "Asia Pacific (Tokyo)"    "ap-northeast-1"
print_row    "Canada (Central)"    "ca-central-1"
print_row    "Canada West (Calgary)"    "ca-west-1"
print_row    "Europe (Frankfurt)"    "eu-central-1"
print_row    "Europe (Ireland)"    "eu-west-1"
print_row    "Europe (London)"    "eu-west-2"
print_row    "Europe (Milan)"    "eu-south-1"
print_row    "Europe (Paris)"    "eu-west-3"
print_row    "Europe (Spain)"    "eu-south-2"
print_row    "Europe (Stockholm)"    "eu-north-1"
print_row    "Europe (Zurich)"    "eu-central-2"
print_row    "Israel (Tel Aviv)"    "il-central-1"
print_row    "Middle East (Bahrain)"    "me-south-1"
print_row    "Middle East (UAE)"    "me-central-1"
print_row    "South America (São Paulo)"    "sa-east-1"
print_row    "AWS GovCloud (US-East)"    "us-gov-east-1"
print_row    "AWS GovCloud (US-West)"    "us-gov-west-1"
echo "----------------------------------------------------------------------------------  "
echo -e "${YELLOW}${BOLD}---------------------------------------------------------------------------${RESET}"

echo -e "${YELLOW} **************************************************************************************** ${RESET}"
# Take Input from User only Region-Code
echo -e "${CYAN}${BOLD} Enter Aws Region_Code only (press Enter after each Region_Code, type Ctrl+D to finish. :${RESET} Example: ${BOLD} us-west-2${RESET} "
# Read input and populate the array Aws_Region_Code()
while IFS= read -r region_code; do	
  if [[ ! -z "$region_code" ]]; then	
    Aws_Region_Code+=("$region_code")
  fi
 done


for region_code in "${Aws_Region_Code[@]}"; do
	for srv_code in "${Aws_Service_Code[@]}"; do
		# Concatenate the user input with Service_Code and domain
		prepared_string="https://${srv_code}.${region_code}.amazonaws.com"
		Aws_Urls+=("$prepared_string")
	done
done
# Check connectivity for AWS URLs
check_connectivity "Connectivity to Regional AWS Endpoint" "${Aws_Urls[@]}"
echo -e " ${CYAN} ----------------------------------------------------------------------- ${RESET} "