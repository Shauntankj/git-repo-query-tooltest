#!/bin/bash
# Script to apply branch protection rules using GitHub CLI
# Prerequisites: gh CLI installed and authenticated
# Usage: ./apply-branch-protection.sh

set -e

REPO="Shauntankj/git-repo-query-tooltest"
BRANCH="main"

echo "Applying branch protection rules to $REPO:$BRANCH..."

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    echo "Install from: https://cli.github.com/"
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

echo "Step 1: Enabling required pull request reviews..."
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  "/repos/$REPO/branches/$BRANCH/protection" \
  -f required_pull_request_reviews[required_approving_review_count]=1 \
  -f required_pull_request_reviews[dismiss_stale_reviews]=true \
  -f required_pull_request_reviews[require_code_owner_reviews]=true \
  -F enforce_admins=true \
  -F required_linear_history=true \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F required_signatures=true

echo "Step 2: Setting required status checks..."
gh api \
  --method PUT \
  -H "Accept: application/vnd.github+json" \
  "/repos/$REPO/branches/$BRANCH/protection/required_status_checks" \
  -F strict=true \
  -f contexts[]="Verify Commit Signatures" \
  -f contexts[]="Scan for Secrets" \
  -f contexts[]="Pull Request Validation"

echo "✅ Branch protection rules applied successfully!"
echo ""
echo "Next steps:"
echo "1. Enable secret scanning: Settings → Security → Code security and analysis"
echo "2. Enable push protection for secrets"
echo "3. Enable Dependabot alerts"
echo "4. Review and test the configuration"
