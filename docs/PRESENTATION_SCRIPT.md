# Final Presentation Script

## Slide 1: Introduction
**Speaker Notes:**
"Hello everyone, my name is Ananya Rana. Today I'll be presenting my project on Container Supply Chain Security using SLSA and Sigstore. The goal of this project was to tackle a major issue in modern software: how do we mathematically prove that the code running in our cluster is the exact code we built, and hasn't been tampered with?"

## Slide 2: The Architecture
**Speaker Notes:**
"Here is the architecture of the solution. It relies on GitHub Actions for CI/CD, Cosign for image signing, and a Kubernetes admission controller.
The key innovation here is **Keyless Signing**. Instead of managing private GPG keys which can be stolen, we use GitHub's OIDC identity. Cosign issues a temporary certificate, signs the image, logs it in a public transparency log called Rekor, and then destroys the key."

## Slide 3: Shift-Left Security (Trivy)
**Speaker Notes:**
"Before we even sign the image, we scan it. I implemented Trivy in the pipeline to scan the Alpine base image and Python dependencies. The pipeline is configured to enforce a strict break-the-build policy. If any HIGH or CRITICAL vulnerabilities are detected, the pipeline fails, ensuring vulnerable code never reaches the registry."

## Slide 4: Live Demo - The Setup
**Speaker Notes:**
"For the demo, I have a local Minikube cluster running. I've installed the Sigstore Policy Controller via Helm, and applied a `ClusterImagePolicy`. This policy explicitly tells Kubernetes: 'Only allow containers to run if they were signed by AnanyaRana2312's GitHub Actions pipeline'."

## Slide 5: Live Demo - Deploying Signed Image
*(Action: Switch to Terminal)*
**Speaker Notes:**
"First, I'll deploy my Flask application. This image was built and signed by my pipeline."
*(Run: `kubectl apply -f k8s/deployment.yaml` then `kubectl get pods`)*
"As you can see, the pod is running successfully. The admission controller verified the signature in milliseconds and allowed it through."

## Slide 6: Live Demo - Blocking Unsigned Image
*(Action: Stay in Terminal)*
**Speaker Notes:**
"Now, let's see what happens if an attacker tries to sneak an unauthorized image into the cluster, or if a developer tries to deploy an unsigned image like a standard nginx container."
*(Run: `kubectl run unsigned-test --image=nginx:latest`)*
"Notice the error. The API server completely rejects the request. The webhook explicitly states that no matching signatures were found. The cluster is completely locked down to our trusted supply chain."

## Slide 7: Conclusion
**Speaker Notes:**
"In conclusion, by combining automated vulnerability scanning with cryptographic keyless signing and Kubernetes admission control, we've achieved a Zero-Trust deployment environment. This ensures high SLSA compliance and protects against supply chain attacks. Thank you!"
