## Security Policy

### Reporting Security Vulnerabilities

If you discover a security vulnerability in this repository, please report it by:

1. **DO NOT** open a public issue
2. Use GitHub's private vulnerability reporting feature
3. Or email the maintainers directly

### Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |

### Security Measures

This repository implements the following security measures:

#### 1. Commit Signing Enforcement
- All commits must be signed with verified GPG, SSH, or S/MIME signatures
- Unsigned commits are rejected by GitHub Actions workflow

#### 2. Secret Scanning
- Automated secret detection runs on all pull requests and pushes
- GitHub's push protection prevents secrets from being committed
- TruffleHog scans for exposed credentials

#### 3. Branch Protection Rules
- Required pull request reviews before merging
- Required status checks must pass
- Force pushes are disabled
- Branch deletion is disabled

#### 4. Code Review Requirements
- All changes require approval from code owners (see CODEOWNERS file)
- Stale reviews are dismissed when new commits are pushed

#### 5. Dependency Scanning
- Dependabot alerts for vulnerable dependencies
- Automated security updates for dependencies

### Best Practices

When contributing to this repository:

1. **Sign your commits**: 
   ```bash
   git config --global commit.gpgsign true
   git config --global user.signingkey YOUR_KEY_ID
   ```

2. **Never commit secrets**:
   - Use environment variables for sensitive data
   - Add `.env` files to `.gitignore`
   - Use GitHub Secrets for CI/CD credentials

3. **Keep dependencies updated**:
   - Review Dependabot alerts promptly
   - Update dependencies regularly

4. **Follow secure coding practices**:
   - Validate all inputs
   - Use parameterized queries
   - Implement proper authentication and authorization

### Incident Response

In case of a security incident:
1. The issue will be assessed within 24 hours
2. A fix will be developed and tested
3. The fix will be deployed as soon as possible
4. Affected users will be notified if necessary

### Contact

For security concerns, please contact the repository maintainers.
