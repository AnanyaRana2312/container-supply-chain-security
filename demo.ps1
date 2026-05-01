# demo.ps1
Clear-Host
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " CONTAINER SUPPLY CHAIN SECURITY DEMO - SLSA & SIGSTORE   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[*] Cleaning up cluster state before demo..." -ForegroundColor DarkGray
kubectl delete deployment security-app --ignore-not-found=true 2>$null
kubectl delete pod unsigned-test --ignore-not-found=true 2>$null
Start-Sleep -Seconds 3
Clear-Host

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " CONTAINER SUPPLY CHAIN SECURITY DEMO - SLSA & SIGSTORE   " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Our cluster is actively protected by Sigstore Policy Controller." -ForegroundColor Yellow
Write-Host "Let's view the active security policy we have applied:" -ForegroundColor Yellow
Write-Host ""
Write-Host "> cat k8s/cluster-image-policy.yaml" -ForegroundColor Green
Get-Content k8s/cluster-image-policy.yaml
Write-Host ""
Write-Host "Press Enter to continue to Scenario 1..." -ForegroundColor DarkGray
Read-Host

Write-Host "----------------------------------------------------------"
Write-Host "SCENARIO 1: Deploying an APPROVED, cryptographically SIGNED image" -ForegroundColor Yellow
Write-Host "This image was built, scanned by Trivy, and signed by our CI/CD pipeline." -ForegroundColor Yellow
Write-Host ""
Write-Host "> kubectl apply -f k8s/deployment.yaml" -ForegroundColor Green
kubectl apply -f k8s/deployment.yaml
Write-Host ""
Start-Sleep -Seconds 2

Write-Host "Verifying the application is running successfully..." -ForegroundColor Yellow
Write-Host "> kubectl get pods -l app=security-app" -ForegroundColor Green
kubectl get pods -l app=security-app
Write-Host ""
Write-Host "Press Enter to continue to Scenario 2..." -ForegroundColor DarkGray
Read-Host

Write-Host "----------------------------------------------------------"
Write-Host "SCENARIO 2: Attempting to deploy an UNAUTHORIZED, UNSIGNED image" -ForegroundColor Yellow
Write-Host "An attacker (or developer) tries to deploy a standard nginx image directly." -ForegroundColor Yellow
Write-Host ""
Write-Host "> kubectl run unsigned-test --image=nginx:latest" -ForegroundColor Green
# We capture the error stream explicitly because kubectl writes errors to stderr
try {
    $err = $(kubectl run unsigned-test --image=nginx:latest 2>&1)
    Write-Host $err -ForegroundColor Red
} catch {
    Write-Host $_ -ForegroundColor Red
}
Write-Host ""
Start-Sleep -Seconds 2

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " DEMO COMPLETE - ZERO TRUST SUPPLY CHAIN ENFORCED         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
