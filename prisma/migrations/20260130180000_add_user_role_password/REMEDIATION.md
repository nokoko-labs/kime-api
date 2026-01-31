# Migration: Manual remediation for orphan users (tenantId IS NULL)

**Copy the section below into the PR description** so maintainers know how to proceed if this migration fails.

---

## Migration safety gate: users with null tenantId

**Problem:** This migration no longer auto-assigns orphan users to a tenant. If any row in `users` has `tenantId` IS NULL, the migration **fails** with an exception. This avoids assigning users to an arbitrary (first) tenant.

**Manual remediation required** before re-running the migration (applies to **all environments** where pre-existing data may have `tenantId` NULL: local, staging, production):

1. **List orphan users:**
   ```sql
   SELECT id, email FROM users WHERE "tenantId" IS NULL;
   ```

2. **For each orphan, choose one:**
   - **Option A — Assign to the correct tenant:**  
     `UPDATE users SET "tenantId" = '<correct_tenant_id>' WHERE id = '<user_id>';`
   - **Option B — Delete if they must not exist:**  
     `DELETE FROM users WHERE id = '<user_id>';`

3. **Re-run the migration:**  
   `pnpm run prisma:migrate:deploy` (or `prisma migrate dev` locally).

Until remediation is done, the migration will keep failing. Document this in your runbook for deploy so operators know the steps.
