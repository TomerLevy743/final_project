#!/bin/bash

MODULES=(vpc eks node_group ebs security_group rds alb status-page monitoring efk route53)

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 [apply|destroy]"
    exit 1
fi

ACTION="$1"

if [[ "$ACTION" != "apply" && "$ACTION" != "destroy" ]]; then
    echo "Error: Invalid action '$ACTION'. Use 'apply' or 'destroy'."
    exit 1
fi

if [[ "$ACTION" == "destroy" ]]; then
    MODULES=("${MODULES[@]}")
    MODULES=($(printf "%s
" "${MODULES[@]}" | tac))  # Reverse the list
fi

for MODULE in "${MODULES[@]}"; do
    echo "⚡ Running 'terraform $ACTION' for module: $MODULE..."
    terraform $ACTION -auto-approve -target=module.$MODULE -parallelism=30 -var-file="terraform.tfvars"
    
    if [[ $? -ne 0 ]]; then
        echo "❌ Terraform $ACTION failed for module: $MODULE"
        exit 1
    fi

    echo "✅ Terraform $ACTION successful for module: $MODULE!"
done