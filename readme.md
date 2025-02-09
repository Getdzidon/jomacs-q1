# Harridee E-commerce App (Harridee Marketplace)

This project, developed by Dzissah Donatus Dziedzorm for Jomacs IT, details the design and deployment of the Harridee E-commerce App (Harridee Marketplace).  It covers the architecture, CI/CD pipeline, Infrastructure as Code (IaC), Dependabot integration, and AWS Web Application Firewall (WAF) configuration.

## Technologies Used

*   AWS (EC2, ALB, WAF, Route 53)
*   Terraform
*   Node.js
*   GitHub Actions (CI/CD)
*   Security Tools (npm audit)

## Setup Instructions

1.  Clone the repository:

    ```bash
    git clone [https://github.com/getdzidon/jomacs-q1.git](https://github.com/getdzidon/jomacs-q1.git)
    cd jomacs-q1
    ```

The app was deployed adhering to SOC2 regulations.

Feel free to connect on LinkedIn or reach out if you have any questions or enhancements for this project.

## Architecture Diagram

![Project Architecture](docs/achitecture_diag1.jpg "Screenshot of Project Architecture")

## Application Link

[https://market.harridee.com/](https://market.harridee.com/)

![Harridee Marketplace Website](docs/website.jpg "Screenshot of Harridee Marketplace Website")

# Mapping Features and Controls to Meet SOC2 Standards

## CI/CD Pipeline Configuration

The CI/CD workflow automates building, vulnerability scanning, and deployment of the application to an AWS EC2 instance.

![CI/CD Run](docs/CI_CD.jpg "Screenshot of CI/CD Run")

### Dependency Installation and Security Scanning

The pipeline uses Node.js, installs libraries, and runs vulnerability checks (`npm audit`) on every code push.

![Security Scan](docs/security_scan.jpg "Screenshot of GitHub Actions Run Showing Successful Security Scan")

**Control Alignment with SOC2:** CC701, CC7.2

## Artifact Storage and Logging

*   **Description:** (Add description here)
*   **Control Alignment with SOC2:** (Add SOC2 control alignment here)

## Controlled Deployment / Release Management

*   **Description:** (Add description here)
*   **Control Alignment with SOC2:**
    *   **Change Management:** This confirms that all changes are authorized, tested, and validated before a new release. **Ref: CC8.1**
    *   **System Operations:** Automated checks reduce and prevent human error, providing consistent security enforcement. **Ref: CC7.2**

## Use of GitHub Secrets

*   **Description:** Secrets such as EC2 SSH keys, host DNS, user credentials, access keys, and IDs are stored in GitHub Secrets to be retrieved in the pipeline, rather than being hardcoded in the workflow.

![GitHub Secrets](docs/github_secretes.jpg "Screenshot of GitHub Secrets")

*   **Control Alignment with SOC2:**
    *   **Logical Access Controls:** Ensures credentials and sensitive information are confidential and their access is properly restricted. **Ref: CC6.1 - CC6.3**
    *   **Encryption and Key Management:** Data at rest in GitHub Secrets is protected using encryption. **Ref: CC6.6**

## Automating Updates Using Dependabot

Dependabot is configured to automatically create pull requests for new versions of npm, GitHub Actions, and Terraform dependencies. This ensures the project stays current with security patches and feature updates.