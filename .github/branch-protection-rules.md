# Branch Protection Rules Configuration

This document describes the branch protection rules that should be enabled for this repository.

## Recommended Settings for Main/Master Branch

### 1. Require Pull Request Reviews Before Merging
- **Enable**: ✅ Required
- **Required approving reviews**: 1 (or more)
- **Dismiss stale pull request approvals when new commits are pushed**: ✅ Recommended
- **Require review from Code Owners**: ✅ Required (uses CODEOWNERS file)
- **Restrict who can dismiss pull request reviews**: Optional

### 2. Require Status Checks Before Merging
- **Enable**: ✅ Required
- **Require branches to be up to date before merging**: ✅ Recommended
- **Required status checks**:
  - `Verify Commit Signatures` (from commit-signature-check.yml)
  - `Scan for Secrets` (from secret-scanning.yml)

### 3. Require Commit Signing
- **Enable**: ✅ Required
- **Require signed commits**: ✅ Required
- All commits must be signed with verified GPG, SSH, or S/MIME signatures

### 4. Require Linear History
- **Enable**: ✅ Optional (Recommended)
- Prevents merge commits, requires rebase or squash merging

### 5. Include Administrators
- **Enable**: ⚠️  Optional
- When enabled, administrators must also follow these rules

### 6. Restrict Force Pushes
- **Enable**: ✅ Required
- Prevents force pushes to the protected branch

### 7. Allow Deletions
- **Enable**: ❌ Disabled
- Prevents deletion of the protected branch

### 8. Require Deployments to Succeed
- **Enable**: Optional
- Useful for production branches

## How to Apply These Settings

### Via GitHub Web Interface:
1. Go to your repository on GitHub
2. Click on "Settings" tab
3. Click on "Branches" in the left sidebar
4. Under "Branch protection rules", click "Add rule"
5. Enter branch name pattern (e.g., `main` or `master`)
6. Configure the settings as described above
7. Click "Create" or "Save changes"

### Via GitHub API:
```bash
# Example using GitHub CLI
gh api repos/{owner}/{repo}/branches/{branch}/protection \
  --method PUT \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"require_code_owner_reviews":true}' \
  --field required_status_checks='{"strict":true,"contexts":["Verify Commit Signatures","Scan for Secrets"]}' \
  --field enforce_admins=true \
  --field required_linear_history=true \
  --field allow_force_pushes=false \
  --field allow_deletions=false \
  --field required_signatures=true
```

### Via Terraform (Infrastructure as Code):
```hcl
resource "github_branch_protection" "main" {
  repository_id = github_repository.repo.node_id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 1
    require_code_owner_reviews     = true
    dismiss_stale_reviews          = true
  }

  required_status_checks {
    strict = true
    contexts = [
      "Verify Commit Signatures",
      "Scan for Secrets"
    ]
  }

  enforce_admins          = true
  require_signed_commits  = true
  require_linear_history  = true
  allow_force_pushes     = false
  allow_deletions        = false
}
```

## Secret Scanning Configuration

### GitHub Advanced Security Features:
1. Go to Settings > Security > Code security and analysis
2. Enable the following features:
   - **Dependency graph**: ✅ Enabled
   - **Dependabot alerts**: ✅ Enabled
   - **Dependabot security updates**: ✅ Enabled
   - **Secret scanning**: ✅ Enabled (requires GitHub Advanced Security for private repos)
   - **Push protection**: ✅ Enabled (prevents secrets from being pushed)

## Merge Request Settings

### Pull Request Settings:
1. Go to Settings > General
2. Under "Pull Requests" section:
   - ✅ Allow merge commits (optional)
   - ✅ Allow squash merging (recommended)
   - ✅ Allow rebase merging (recommended)
   - ✅ Always suggest updating pull request branches
   - ✅ Allow auto-merge
   - ✅ Automatically delete head branches (recommended)

## Additional Recommendations

### Repository Security Settings:
- Enable private vulnerability reporting
- Configure security policy (SECURITY.md)
- Enable dependency review
- Set up code scanning with CodeQL

### Webhooks and Notifications:
- Configure webhooks for critical events
- Set up notification rules for security alerts
- Enable email notifications for failed builds

## Testing the Configuration

After applying these settings, test them by:
1. Creating a test branch
2. Making a commit (unsigned)
3. Opening a pull request
4. Verify that the commit signature check fails
5. Sign the commit and force push
6. Verify that the checks pass
7. Verify that approval is required before merging
