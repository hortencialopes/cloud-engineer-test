echo "Define your alb service acc before running this script"
export ALB_SERVICE_ACCOUNT_NAME="CHANGE HERE"

echo "Adding EKS chart repository..."
helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

# Install the controller
helm install aws-lbc-server-prd eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=server-prd \
  --set serviceAccount.create=false \
  --set serviceAccount.name=$ALB_SERVICE_ACCOUNT_NAME

echo ""
echo "--- Verification ---"
echo "Waiting for controller deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/aws-lbc-server-prd-aws-load-balancer-controller -n kube-system

echo "AWS Load Balancer Controller installed successfully!"