# git-repo-query-tooltest

A demonstration repository showcasing GitHub's security features and branch protection rules.

## 🔒 Security Features Implemented

This repository demonstrates the following GitHub security and protection features:

### 1. ✅ Required Reviewers / Merge Approvals
- **CODEOWNERS file** (`.github/CODEOWNERS`) defines required reviewers
- Branch protection rules require approval before merging
- Code owner review is mandatory for all changes

### 2. ✅ Commit Signing Enforcement
- **Commit signature verification workflow** (`.github/workflows/commit-signature-check.yml`)
- Validates that all commits are signed with GPG/SSH keys
- Rejects unsigned commits automatically
- Configured via branch protection rules

### 3. ✅ Secrets Detection
- **Secret scanning workflow** (`.github/workflows/secret-scanning.yml`)
- Uses multiple tools: `detect-secrets` and `TruffleHog`
- Scans all pull requests and pushes
- GitHub push protection prevents secrets from being committed

### 4. ✅ Default Branch Push Permission
- Branch protection rules enforce strict controls
- Direct pushes to main branch are restricted
- All changes must go through pull requests
- Force pushes are disabled

### 5. ✅ Merge Request Settings
- Pull request template enforces quality standards
- Required status checks must pass before merging
- Automated checks for code quality and security
- Linear history option available

## 📁 Repository Structure

```
.
├── .github/
│   ├── workflows/
│   │   ├── commit-signature-check.yml  # Enforces signed commits
│   │   ├── secret-scanning.yml         # Detects secrets
│   │   └── pr-checks.yml               # General PR validation
│   ├── CODEOWNERS                      # Required reviewers
│   ├── SECURITY.md                     # Security policy
│   ├── PULL_REQUEST_TEMPLATE.md        # PR template
│   └── branch-protection-rules.md      # Configuration guide
├── src/
│   └── main.py                         # Sample application
├── package.json                        # Project metadata
├── .gitignore                          # Git ignore rules
└── README.md                           # This file
```

## 🚀 Getting Started

### Prerequisites
- Git with GPG/SSH signing configured
- GitHub account
- Repository admin access (for applying settings)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/Shauntankj/git-repo-query-tooltest.git
   cd git-repo-query-tooltest
   ```

2. **Configure commit signing** (if not already done)
   ```bash
   # For GPG signing
   git config --global commit.gpgsign true
   git config --global user.signingkey YOUR_GPG_KEY_ID
   
   # For SSH signing (GitHub supports this too)
   git config --global gpg.format ssh
   git config --global user.signingkey ~/.ssh/id_ed25519.pub
   ```

3. **Apply branch protection rules**
   - Follow the guide in `.github/branch-protection-rules.md`
   - Configure through GitHub Settings → Branches
   - Or use the GitHub API/CLI/Terraform examples provided

4. **Enable security features**
   - Go to Settings → Security → Code security and analysis
   - Enable: Dependency graph, Dependabot, Secret scanning, Push protection

## 🛡️ Branch Protection Configuration

The following branch protection rules should be applied to the `main` branch:

| Setting | Status | Description |
|---------|--------|-------------|
| Require pull request reviews | ✅ | At least 1 approval required |
| Require review from Code Owners | ✅ | CODEOWNERS must approve |
| Require status checks to pass | ✅ | CI/CD must succeed |
| Require signed commits | ✅ | All commits must be signed |
| Require linear history | ⚠️ Optional | Prevent merge commits |
| Restrict force pushes | ✅ | No force pushes allowed |
| Prevent deletion | ✅ | Branch cannot be deleted |

See `.github/branch-protection-rules.md` for detailed configuration instructions.

## 🔐 Security Workflows

### Commit Signature Verification
Automatically runs on every PR and push to verify all commits are signed:
- ✅ Passes: All commits have valid signatures
- ❌ Fails: One or more commits are unsigned

### Secret Scanning
Scans for exposed credentials and sensitive data:
- Uses `detect-secrets` for pattern matching
- Uses `TruffleHog` for verified secret detection
- Prevents accidental credential exposure

### PR Validation
Validates pull request quality:
- Checks for required description
- Scans for large files
- Reports TODO/FIXME comments
- Lints YAML configuration files

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. **Sign your commits** (`git commit -S -m 'Add amazing feature'`)
5. Push to your branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

All pull requests must:
- Have commits signed with GPG/SSH keys
- Pass all security and validation checks
- Receive approval from code owners
- Have no detected secrets or vulnerabilities

## 📚 Documentation

- [Branch Protection Rules](.github/branch-protection-rules.md) - Detailed configuration guide
- [Security Policy](.github/SECURITY.md) - How to report vulnerabilities
- [Pull Request Template](.github/PULL_REQUEST_TEMPLATE.md) - PR checklist

## 🔗 Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Commit Signing](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [GitHub Secret Scanning](https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning)
- [GitHub CODEOWNERS](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)

## ⚙️ Technology Stack

- **CI/CD**: GitHub Actions
- **Security Scanning**: TruffleHog, detect-secrets
- **Version Control**: Git with GPG/SSH signing
- **Code Review**: GitHub CODEOWNERS

## 📄 License

This project is licensed under the MIT License.

## 🤝 Support

If you encounter any issues or have questions:
- Check the documentation in `.github/`
- Open an issue on GitHub
- Review the security policy for vulnerability reporting