# Container Supply Chain Security Project

This project demonstrates a basic setup for container supply chain security. It includes a simple Python Flask application, a Dockerfile for containerization, Kubernetes manifests for deployment, and a GitHub Actions workflow for CI/CD.

## Project Structure

- `app.py`: A simple Flask application with a `/health` endpoint.
- `requirements.txt`: Python dependencies.
- `Dockerfile`: Instructions to build the Docker image for the application.
- `k8s/`: Contains Kubernetes manifests (e.g., `deployment.yaml`) for deploying the application.
- `.github/workflows/`: Contains GitHub Actions workflows for continuous integration and continuous deployment.

## Getting Started

### Local Development

1.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

2.  **Run the application:**
    ```bash
    python app.py
    ```

3.  **Check the health endpoint:**
    Navigate to `http://localhost:5000/health` in your browser or use curl:
    ```bash
    curl http://localhost:5000/health
    ```

### Docker

1.  **Build the Docker image:**
    ```bash
    docker build -t security-app .
    ```

2.  **Run the Docker container:**
    ```bash
    docker run -p 5000:5000 security-app
    ```

### Next Steps for Security

This scaffolding is ready for security enhancements such as:
- **Image Scanning:** Integrating tools like Trivy or Grype in the CI pipeline.
- **SBOM Generation:** Generating a Software Bill of Materials using Syft.
- **Image Signing:** Signing container images using Cosign.
- **Kubernetes Security:** Applying Pod Security Standards or using tools like Kyverno/OPA Gatekeeper.
