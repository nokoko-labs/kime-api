import { z } from 'zod';

/**
 * Schema for login payload (email + password).
 */
export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

export type LoginPayload = z.infer<typeof loginSchema>;
