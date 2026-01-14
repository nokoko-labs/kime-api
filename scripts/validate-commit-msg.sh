#!/bin/sh

# Validate Conventional Commits format
# Format: type(scope): description
# Rules:
# - Header must be under 80 characters
# - Type and scope must be lowercase
# - Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci
# - Scope is optional but recommended
# - Description must be imperative mood

commit_msg_file="$1"
commit_msg=$(cat "$commit_msg_file")

# Get the first line (header)
header=$(echo "$commit_msg" | head -n 1)

# Check if header is empty
if [ -z "$header" ]; then
  echo "❌ Error: Commit message is empty"
  exit 1
fi

# Check header length (must be under 80 characters)
header_length=${#header}
if [ "$header_length" -ge 80 ]; then
  echo "❌ Error: Commit header must be under 80 characters (current: $header_length)"
  echo "   Header: $header"
  exit 1
fi

# Valid commit types
valid_types="feat|fix|docs|style|refactor|perf|test|chore|ci"

# Pattern for Conventional Commits
# Format: type(scope): description
# or: type: description (without scope)
pattern_with_scope="^($valid_types)\([a-z0-9-]+\): .+"
pattern_without_scope="^($valid_types): .+"

# Check if commit message matches the pattern
if echo "$header" | grep -qE "$pattern_with_scope"; then
  # Extract type and scope
  type=$(echo "$header" | sed -E "s/^($valid_types)\([a-z0-9-]+\): .+/\1/")
  scope=$(echo "$header" | sed -E "s/^($valid_types)\(([a-z0-9-]+)\): .+/\2/")
  
  # Validate type and scope are lowercase
  if echo "$type" | grep -qE '[A-Z]'; then
    echo "❌ Error: Commit type must be lowercase"
    echo "   Found: $type"
    exit 1
  fi
  
  if echo "$scope" | grep -qE '[A-Z]'; then
    echo "❌ Error: Commit scope must be lowercase"
    echo "   Found: $scope"
    exit 1
  fi
  
  echo "✅ Commit message format is valid: $header"
  exit 0
elif echo "$header" | grep -qE "$pattern_without_scope"; then
  # Extract type
  type=$(echo "$header" | sed -E "s/^($valid_types): .+/\1/")
  
  # Validate type is lowercase
  if echo "$type" | grep -qE '[A-Z]'; then
    echo "❌ Error: Commit type must be lowercase"
    echo "   Found: $type"
    exit 1
  fi
  
  echo "⚠️  Warning: Commit message without scope (recommended but optional)"
  echo "✅ Commit message format is valid: $header"
  exit 0
else
  echo "❌ Error: Commit message does not follow Conventional Commits format"
  echo ""
  echo "   Expected format: type(scope): description"
  echo "   or: type: description"
  echo ""
  echo "   Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci"
  echo "   Scope: lowercase, alphanumeric and hyphens (optional but recommended)"
  echo "   Description: imperative mood, lowercase"
  echo ""
  echo "   Examples:"
  echo "   ✅ feat(auth): implement login with google"
  echo "   ✅ fix(user): resolve crash on invalid email"
  echo "   ✅ chore(deps): upgrade nestjs packages"
  echo ""
  echo "   Your message: $header"
  exit 1
fi
