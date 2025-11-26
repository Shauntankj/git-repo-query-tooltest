# Terraform configuration for GitHub repository settings
# This file demonstrates how to configure branch protection and security settings using Infrastructure as Code

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  # Token should be provided via GITHUB_TOKEN environment variable
  # or through GitHub App authentication
}

# Repository configuration
variable "repository_name" {
  description = "Name of the GitHub repository"
  type        = string
  default     = "git-repo-query-tooltest"
}

variable "repository_owner" {
  description = "Owner of the GitHub repository"
  type        = string
  default     = "Shauntankj"
}

# Branch protection for main branch
resource "github_branch_protection" "main" {
  repository_id = "${var.repository_owner}/${var.repository_name}"
  pattern       = "main"

  # Require pull request reviews before merging
  required_pull_request_reviews {
    required_approving_review_count      = 1
    require_code_owner_reviews          = true
    dismiss_stale_reviews               = true
    restrict_dismissals                 = false
    require_last_push_approval          = false
  }

  # Require status checks to pass before merging
  required_status_checks {
    strict   = true
    contexts = [
      "Verify Commit Signatures",
      "Scan for Secrets",
      "Pull Request Validation",
      "Lint YAML Files"
    ]
  }

  # Additional settings
  enforce_admins                  = true
  require_signed_commits          = true
  require_linear_history          = true
  require_conversation_resolution = true
  allow_force_pushes             = false
  allow_deletions                = false
  lock_branch                    = false
}

# Repository settings
resource "github_repository" "main" {
  name        = var.repository_name
  description = "Demonstration repository for GitHub security and branch protection settings"
  
  visibility = "public"  # or "private"
  
  # Security settings
  has_issues             = true
  has_wiki              = false
  has_downloads         = true
  
  # Vulnerability alerts
  vulnerability_alerts   = true
  
  # Merge settings
  allow_merge_commit     = true
  allow_squash_merge     = true
  allow_rebase_merge     = true
  allow_auto_merge       = true
  delete_branch_on_merge = true
  allow_update_branch    = true
  
  # Squash merge commit settings
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "PR_BODY"
  
  # Merge commit settings
  merge_commit_title   = "PR_TITLE"
  merge_commit_message = "PR_BODY"
}

# Repository security and analysis features
resource "github_repository_security_and_analysis" "main" {
  repository = github_repository.main.name

  # Advanced security features (requires GitHub Advanced Security for private repos)
  advanced_security {
    status = "enabled"
  }

  # Secret scanning
  secret_scanning {
    status = "enabled"
  }

  # Secret scanning push protection
  secret_scanning_push_protection {
    status = "enabled"
  }
}

# Outputs
output "repository_url" {
  description = "URL of the GitHub repository"
  value       = github_repository.main.html_url
}

output "branch_protection_applied" {
  description = "Branch protection rules applied"
  value       = "Branch protection rules have been applied to the main branch"
}
