# Project Report: Supply Chain Security with SLSA & Sigstore

**Student Name:** Ananya Rana
**GitHub Username:** AnanyaRana2312
**Assignment:** Container Orchestration and Security - Assignment 2

---

## 1. Requirement Analysis & Feasibility
The core objective of this project is to establish a Zero-Trust container supply chain. Modern software supply chains are vulnerable to tampering, unauthorized image modifications, and injection of malicious code. 

**Requirements:**
- A containerized application (Python Flask).
- Automated CI/CD pipeline (GitHub Actions) for building and scanning images.
- Keyless signing mechanism (Sigstore/Cosign) to authenticate image provenance.
- A Kubernetes cluster (Minikube) configured with a policy engine to enforce zero-trust deployments.

**Feasibility:**
Using Sigstore's Cosign with GitHub Actions' OIDC (OpenID Connect) provides a feasible, highly secure keyless signing architecture. This eliminates the need for managing long-lived cryptographic keys. Sigstore Policy Controller seamlessly integrates with Kubernetes via admission webhooks to enforce these signatures.

---

## 2. Design, Architecture & Workflow
The architecture follows a "Shift-Left" security model, ensuring vulnerabilities and provenance are handled before deployment.

### Workflow:
1. **Code Commit:** Developer pushes code to the `main` branch.
2. **CI Pipeline Trigger:** GitHub Actions provisions an Ubuntu runner.
3. **Build & Scan:** 
   - A Docker image is built from the `Dockerfile`.
   - Trivy scans the image for OS and library vulnerabilities. The pipeline is configured to **break the build** if `HIGH` or `CRITICAL` vulnerabilities are found.
4. **Push & Sign:**
   - The image is pushed to GitHub Container Registry (GHCR).
   - Cosign uses GitHub's OIDC token to request an ephemeral certificate from Fulcio.
   - The signature is pushed to the Rekor transparency log.
5. **Deployment & Enforcement:**
   - Kubernetes applies a `ClusterImagePolicy` that requires signatures from `https://github.com/AnanyaRana2312/*`.
   - The Sigstore Policy Controller intercepts pod creation and verifies the signature against the transparency log before admission.

---

## 3. Implementation Details
- **Base Image Hardening:** Migrated from `python:3.9-slim` to `python:3.9-alpine` and utilized `apk upgrade` to minimize the OS attack surface.
- **Dependency Pinning:** Updated `requirements.txt` and python packaging tools (`setuptools`, `wheel`) to eliminate known CVEs.
- **GitHub Actions (build.yml):** Configured with `id-token: write` for OIDC authentication and `packages: write` for GHCR access.
- **Policy Controller:** Installed via Helm into the `cosign-system` namespace. The `default` namespace is labeled with `policy.sigstore.dev/include=true` to enable strict enforcement.

---

## 4. Results and Findings
- **Vulnerability Remediation:** The shift to Alpine and upgrading dependencies resolved all `HIGH` and `CRITICAL` vulnerabilities, allowing the Trivy scanner to pass successfully under strict policies.
- **Successful Deployment:** Deploying `ghcr.io/ananyarana2312/container-supply-chain-security:latest` succeeded as the Policy Controller successfully verified the OIDC signature against the GitHub Actions issuer.
- **Blocked Deployment:** Attempting to run an unsigned image (`nginx:latest`) resulted in an admission webhook rejection, confirming that the cluster successfully blocks unauthorized supply chain artifacts.

---

## 5. Use Case Presentation
This architecture represents the industry standard for SLSA (Supply-chain Levels for Software Artifacts) Level 3 compliance. It is directly applicable to enterprise environments where regulatory compliance (such as FedRAMP or HIPAA) mandates strict software provenance and tamper-evident audit trails. By using keyless signing, organizations can eliminate the risk of compromised private keys while maintaining cryptographic guarantees of their software's origins.
