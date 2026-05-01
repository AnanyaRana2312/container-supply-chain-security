# setup.ps1
Write-Host "Starting Minikube..."
minikube start

Write-Host "Installing Helm..."
winget install Helm.Helm --accept-source-agreements --accept-package-agreements
# Refresh environment path so helm can be used immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Installing Sigstore Policy Controller..."
helm repo add sigstore https://sigstore.github.io/helm-charts
helm repo update
helm install policy-controller sigstore/policy-controller --namespace cosign-system --create-namespace

# Wait for policy controller to be ready
Write-Host "Waiting for Policy Controller webhooks to be ready..."
Start-Sleep -Seconds 15

Write-Host "Applying ClusterImagePolicy..."
kubectl apply -f k8s/cluster-image-policy.yaml

Write-Host "Labeling default namespace to enable policy enforcement..."
kubectl label namespace default policy.sigstore.dev/include=true --overwrite

Write-Host "Deploying the Flask application..."
kubectl apply -f k8s/deployment.yaml

Write-Host "Verifying the deployment (should succeed since the image is signed)..."
kubectl get pods

Write-Host "Testing Policy Enforcement with an UNSIGNED image (nginx)..."
Write-Host "This command is EXPECTED TO FAIL, demonstrating that the policy blocks unsigned images."
kubectl run unsigned-test --image=nginx:latest

Write-Host "Setup and testing complete!"
