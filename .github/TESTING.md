# Testing and Validation Guide

This document provides instructions for testing and validating the branch protection and security settings.

## ✅ Pre-Deployment Checklist

Before applying the branch protection rules, ensure:

- [ ] Repository exists and you have admin access
- [ ] GitHub CLI (`gh`) is installed and authenticated
- [ ] Git is configured with GPG/SSH signing keys
- [ ] All workflows are committed and pushed to the repository

## 🧪 Testing Workflows

### 1. Test Commit Signature Verification

**Test Case 1: Unsigned Commit (Should Fail)**
```bash
# Temporarily disable commit signing
git config commit.gpgsign false

# Create a test branch
git checkout -b test/unsigned-commit

# Make a change
echo "Test" > test.txt
git add test.txt
git commit -m "Test unsigned commit"

# Push and create PR - workflow should fail
git push origin test/unsigned-commit
```

**Expected Result**: ❌ Commit signature check workflow should fail

**Test Case 2: Signed Commit (Should Pass)**
```bash
# Enable commit signing
git config commit.gpgsign true

# Create a test branch
git checkout -b test/signed-commit

# Make a change
echo "Test" > test2.txt
git add test2.txt
git commit -S -m "Test signed commit"

# Push and create PR - workflow should pass
git push origin test/signed-commit
```

**Expected Result**: ✅ Commit signature check workflow should pass

### 2. Test Secret Detection

**Test Case 1: With Secret (Should Detect)**
```bash
# Create a test branch
git checkout -b test/secret-detection

# Add a file with a fake secret (DO NOT use real secrets!)
echo "API_KEY=AKIAIOSFODNN7EXAMPLE" > config.txt
git add config.txt
git commit -S -m "Test secret detection"

# Push and create PR
git push origin test/secret-detection
```

**Expected Result**: ⚠️ Secret scanning workflow should detect the pattern

**Test Case 2: Without Secrets (Should Pass)**
```bash
# Create a test branch
git checkout -b test/no-secrets

# Add a safe file
echo "APP_NAME=MyApp" > config.txt
git add config.txt
git commit -S -m "Test without secrets"

# Push and create PR
git push origin test/no-secrets
```

**Expected Result**: ✅ Secret scanning workflow should pass

### 3. Test PR Validation

**Test Case 1: PR with Description (Should Pass)**
- Create a PR with a meaningful description
- All validation checks should pass

**Test Case 2: PR without Description (Should Fail)**
- Create a PR with empty description
- PR validation should fail

### 4. Test CODEOWNERS

**Test Case: Verify Required Reviewers**
```bash
# Create a test PR
git checkout -b test/codeowners
echo "Test" > test-file.txt
git add test-file.txt
git commit -S -m "Test CODEOWNERS"
git push origin test/codeowners

# Open PR - should automatically request review from code owners
```

**Expected Result**: PR should automatically request review from @Shauntankj

## 🔐 Applying Branch Protection Rules

### Method 1: GitHub Web Interface

1. Navigate to repository Settings
2. Click "Branches" in sidebar
3. Click "Add rule" under Branch protection rules
4. Enter branch pattern: `main`
5. Configure settings:
   - ✅ Require a pull request before merging
   - ✅ Require approvals: 1
   - ✅ Dismiss stale pull request approvals
   - ✅ Require review from Code Owners
   - ✅ Require status checks to pass
   - ✅ Require branches to be up to date
   - ✅ Status checks: Select all workflow jobs
   - ✅ Require signed commits
   - ✅ Require linear history
   - ✅ Do not allow bypassing the above settings
   - ❌ Allow force pushes
   - ❌ Allow deletions
6. Click "Create" or "Save changes"

### Method 2: GitHub CLI Script

```bash
# Run the provided script
cd .github/scripts
./apply-branch-protection.sh
```

### Method 3: Terraform

```bash
cd .github/terraform

# Initialize Terraform
terraform init

# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

## 🛡️ Enabling Security Features

### Enable Secret Scanning

1. Go to Settings → Security → Code security and analysis
2. Enable "Secret scanning"
3. Enable "Push protection" (prevents secrets from being pushed)

### Enable Dependabot

1. Go to Settings → Security → Code security and analysis
2. Enable "Dependency graph"
3. Enable "Dependabot alerts"
4. Enable "Dependabot security updates"

### Enable Code Scanning

1. Go to Settings → Security → Code security and analysis
2. Click "Set up" under Code scanning
3. Choose "Default" or configure CodeQL manually

## 📊 Validation Checklist

After applying all settings, verify:

### Branch Protection
- [ ] Cannot push directly to main branch
- [ ] Cannot merge PR without approval
- [ ] Cannot merge PR with failing checks
- [ ] Cannot merge unsigned commits
- [ ] Cannot force push to main
- [ ] Cannot delete main branch

### Security Features
- [ ] Secret scanning alerts appear for test secrets
- [ ] Push protection blocks commits with secrets
- [ ] Dependabot creates alerts for vulnerable dependencies
- [ ] Code scanning runs on PRs

### Workflows
- [ ] Commit signature check runs on PRs
- [ ] Secret scanning runs on PRs
- [ ] PR validation checks run on PRs
- [ ] YAML linting runs on workflow changes

### Code Review
- [ ] CODEOWNERS are automatically assigned to PRs
- [ ] Cannot merge without CODEOWNERS approval
- [ ] Stale reviews are dismissed on new commits

## 🐛 Troubleshooting

### Workflow Failures

**Issue**: Commit signature check fails for signed commits
**Solution**: Ensure GPG key is added to GitHub account and verified

**Issue**: Secret scanning has false positives
**Solution**: Update `.secrets.baseline` file to mark false positives

**Issue**: YAML linting fails
**Solution**: Run `yamllint .github/workflows/` locally to identify issues

### Branch Protection

**Issue**: Cannot apply branch protection (403 error)
**Solution**: Ensure you have admin access to the repository

**Issue**: Status checks not appearing
**Solution**: Workflows must run at least once before they appear in settings

## 📈 Monitoring

### Regular Checks
- Review security alerts weekly
- Update dependencies monthly
- Audit CODEOWNERS quarterly
- Review and update branch protection rules as needed

### Metrics to Track
- Number of PRs requiring rework due to unsigned commits
- Number of secrets detected and prevented
- Average time to merge PRs
- Number of security vulnerabilities found and fixed

## 🔄 Continuous Improvement

1. **Feedback Loop**: Collect feedback from contributors
2. **Adjust Rules**: Modify protection rules based on team needs
3. **Update Workflows**: Keep workflows updated with latest actions
4. **Documentation**: Keep this guide up-to-date

## ✨ Success Criteria

The setup is successful when:
- ✅ All workflows pass on clean PRs
- ✅ Unsigned commits are rejected
- ✅ Secrets are detected and blocked
- ✅ All PRs require approval from code owners
- ✅ Main branch is fully protected
- ✅ Team can work efficiently with the rules in place
