# Canva / Claude Presentation Generation Prompt

**Instructions for User:** Paste the entire text below into Claude, Canva Magic Design, or any AI presentation maker to automatically generate your slides.

---

**Prompt for AI Presentation Generator:**

Please generate a 7-slide technical presentation based exactly on the following project data. Do not invent, hallucinate, or add any data outside of what is provided below. The tone should be academic, professional, and technical.

**Project Title:** Container Supply Chain Security with SLSA & Sigstore
**Author:** Ananya Rana (GitHub: AnanyaRana2312)

**Slide 1: Title Slide**
- **Headline:** Supply Chain Security with SLSA & Sigstore
- **Sub-headline:** Zero-Trust Container Orchestration
- **Presenter:** Ananya Rana
- **Key Visual Idea:** A secure lock over a shipping container or a secure pipeline flow.

**Slide 2: Project Objective & The Problem**
- **Headline:** The Supply Chain Problem
- **Bullet Points:**
  - Modern software supply chains are vulnerable to unauthorized image modifications and tampering.
  - The goal is to establish a mathematical, cryptographic proof of origin for container images.
  - **Solution implemented:** A Zero-Trust architecture using Cosign for Keyless signing and Sigstore Policy Controller for Kubernetes admission control.

**Slide 3: Application & Image Hardening**
- **Headline:** Application Setup & Hardening
- **Bullet Points:**
  - **Application:** Python Flask web API with `/` and `/health` endpoints.
  - **Base Image:** Shifted to `python:3.9-alpine` to minimize OS-level attack surface.
  - **Patching:** Implemented `apk upgrade` and pinned dependency upgrades (`pip`, `setuptools`, `wheel`) inside the Dockerfile.
- **Layout Instruction:** Leave a large empty placeholder block on the right half of the slide for a code snippet of the `Dockerfile`.

**Slide 4: "Shift-Left" CI/CD Pipeline**
- **Headline:** Automated CI/CD with GitHub Actions
- **Bullet Points:**
  - **Build & Scan:** Pipeline builds the Docker image and scans it using AquaSecurity Trivy.
  - **Break-the-Build Policy:** Trivy is configured to block the pipeline (`exit-code: 1`) if any `HIGH` or `CRITICAL` vulnerabilities are detected.
  - **Registry:** Scanned images pushed to GitHub Container Registry (GHCR).
- **Layout Instruction:** Leave a placeholder block for a screenshot of the `build.yml` GitHub Actions pipeline code.

**Slide 5: Keyless Cryptographic Signing**
- **Headline:** Cosign & Keyless OIDC Signing
- **Bullet Points:**
  - Avoids the security risks of long-lived private keys (GPG).
  - Uses GitHub Actions OpenID Connect (OIDC) token (`id-token: write`) to authenticate.
  - Sigstore's Fulcio issues an ephemeral certificate.
  - The image signature is pushed to the Rekor public transparency log.
- **Layout Instruction:** Leave a placeholder for an architecture diagram or a screenshot of the Rekor transparency log output.

**Slide 6: Kubernetes Admission Control**
- **Headline:** Sigstore Policy Controller
- **Bullet Points:**
  - Deployed to a local Minikube cluster via Helm.
  - **ClusterImagePolicy:** Configured to strictly require a valid keyless signature matching the GitHub identity `https://github.com/AnanyaRana2312/*`.
  - The `default` namespace is actively labeled for policy enforcement.
- **Layout Instruction:** Leave a placeholder block for a code snippet showing the `ClusterImagePolicy` YAML.

**Slide 7: Validation & Results**
- **Headline:** Zero-Trust Enforcement Results
- **Bullet Points:**
  - **Scenario 1 (Success):** Deploying the exact, signed GHCR image digest is successfully admitted and runs (`security-app` deployment).
  - **Scenario 2 (Blocked):** Attempting to deploy an unsigned container (`nginx:latest`) is immediately intercepted and blocked by the admission webhook.
- **Layout Instruction:** Leave two distinct placeholder blocks on this slide for terminal screenshots: one showing the successful pod creation, and one showing the "connection refused / blocked" error.
