package com.hospital.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for secure password hashing using BCrypt
 * BCrypt is preferred over SHA-256 for password storage
 */
public class PasswordUtil {
    
    // BCrypt work factor (cost parameter) - higher is more secure but slower
    // 12 is recommended for 2025 hardware
    private static final int BCRYPT_ROUNDS = 12;
    
    /**
     * Hash password using BCrypt with salt
     * @param password Plain text password
     * @return BCrypt hashed password with embedded salt
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(BCRYPT_ROUNDS));
    }
    
    /**
     * Verify password against BCrypt hash
     * Also supports legacy SHA-256 hashes for backward compatibility
     * @param password Plain text password to verify
     * @param hashedPassword BCrypt or SHA-256 hashed password from database
     * @return true if password matches hash
     */
    public static boolean verifyPassword(String password, String hashedPassword) {
        if (password == null || hashedPassword == null) {
            return false;
        }
        
        try {
            // Check if it's a BCrypt hash (starts with $2a$ or $2b$)
            if (hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$")) {
                return BCrypt.checkpw(password, hashedPassword);
            }
            
            // Legacy SHA-256 support for existing users
            // TODO: Migrate old hashes to BCrypt on next login
            if (hashedPassword.length() == 64) { // SHA-256 produces 64 hex chars
                return hashPasswordSHA256(password).equals(hashedPassword);
            }
            
            // Plain text comparison (for development/seeded data only)
            return password.equals(hashedPassword);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Validate password complexity requirements
     * - Minimum 8 characters
     * - At least one lowercase letter
     * - At least one uppercase letter
     * - At least one digit
     * - At least one special character
     * @param password Password to validate
     * @return true if password meets complexity requirements
     */
    public static boolean isValidComplexity(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        boolean hasLower = password.matches(".*[a-z].*");
        boolean hasUpper = password.matches(".*[A-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        boolean hasSpecial = password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");
        
        return hasLower && hasUpper && hasDigit && hasSpecial;
    }
    
    /**
     * Get password strength message
     * @param password Password to check
     * @return Helpful message about password requirements
     */
    public static String getPasswordRequirementsMessage() {
        return "Password must be at least 8 characters long and contain: " +
               "lowercase letter, uppercase letter, digit, and special character (!@#$%^&*...)";
    }
    
    /**
     * Legacy SHA-256 hashing for backward compatibility
     * DO NOT use for new passwords - use hashPassword() instead
     */
    @Deprecated
    private static String hashPasswordSHA256(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password with SHA-256", e);
        }
    }
    
    /**
     * Check if a hash is BCrypt (vs legacy SHA-256)
     * @param hash Hash to check
     * @return true if hash is BCrypt format
     */
    public static boolean isBCryptHash(String hash) {
        return hash != null && (hash.startsWith("$2a$") || hash.startsWith("$2b$"));
    }
}
