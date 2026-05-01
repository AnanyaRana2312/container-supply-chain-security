# Final Presentation Script

## Slide 1: Supply Chain Security with SLSA & Sigstore
**Speaker Notes:**
"Hello everyone, my name is Ananya Rana. Today I'll be presenting my project on Container Supply Chain Security using SLSA and Sigstore. The goal of this project was to tackle a major issue in modern software: how do we mathematically prove that the code running in our cluster is the exact code we built, and hasn't been tampered with?"

## Slide 2: The Supply Chain Problem
**Speaker Notes:**
"Modern software supply chains are incredibly vulnerable to unauthorized modifications. If an attacker gains access to a registry, they can swap a legitimate image with a malicious one. To solve this, my project implements a Zero-Trust architecture using Cosign for Keyless signing and the Sigstore Policy Controller for strict Kubernetes admission control."

## Slide 3: Application Setup & Hardening
*(Action: Point to the Dockerfile code snippet on the slide)*
**Speaker Notes:**
"Here you can see the Dockerfile for my Python Flask application. A major part of supply chain security is minimizing the attack surface. As shown in the code snippet, I migrated the base image to `python:3.9-alpine` and implemented an aggressive `apk upgrade` and dependency pinning strategy to eliminate OS-level vulnerabilities before the image is even built."

## Slide 4: Automated CI/CD with GitHub Actions
*(Action: Point to the build.yml screenshot on the slide)*
**Speaker Notes:**
"This is the 'Shift-Left' portion of the project. In the GitHub Actions pipeline shown here, every build is automatically scanned by Trivy. I implemented a strict break-the-build policy: if any HIGH or CRITICAL vulnerabilities are detected, the pipeline fails with exit-code 1, preventing vulnerable code from ever reaching our container registry."

## Slide 5: Cosign & Keyless OIDC Signing
*(Action: Point to the Rekor or Architecture screenshot on the slide)*
**Speaker Notes:**
"Once the image passes the scan, it is pushed to GitHub Container Registry. The key innovation here is Keyless Signing. Instead of managing private keys which can be stolen, Cosign uses the GitHub Actions OIDC token to authenticate. It receives an ephemeral certificate, signs the image, logs that signature in the public Rekor transparency log shown here, and discards the key."

## Slide 6: Sigstore Policy Controller
*(Action: Point to the ClusterImagePolicy YAML snippet on the slide)*
**Speaker Notes:**
"To enforce this on the infrastructure side, I deployed the Sigstore Policy Controller into my local Minikube cluster. As you can see in the `ClusterImagePolicy` YAML, the cluster is strictly configured to only allow containers that possess a valid keyless signature issued specifically from my GitHub identity."

## Slide 7: Zero-Trust Enforcement Results
*(Action: Point to the terminal screenshots showing the allow and block events)*
**Speaker Notes:**
"Finally, here are the validation results from the live cluster. In Scenario 1, deploying my signed GHCR image succeeds instantly because the admission webhook mathematically verifies the signature. In Scenario 2, when attempting to deploy an unsigned standard Nginx container, the API server completely rejects the request with a 'no matching policies' error. The cluster is completely locked down to our trusted supply chain. Thank you!"
