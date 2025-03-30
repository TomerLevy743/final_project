#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <module_name> [apply|destroy]"
    exit 1
fi

MODULE="$1"
ACTION="$2"

if [[ "$ACTION" != "apply" && "$ACTION" != "destroy" ]]; then
    echo "Error: Invalid action '$ACTION'. Use 'apply' or 'destroy'."
    exit 1
fi

echo "⚡ Running 'terraform $ACTION' for module: $MODULE..."

terraform $ACTION -auto-approve -target=module.$MODULE

if [[ $? -ne 0 ]]; then
    echo "❌ Terraform $ACTION failed for module: $MODULE"
    exit 1
fi

echo "✅ Terraform $ACTION successful for module: $MODULE!"
