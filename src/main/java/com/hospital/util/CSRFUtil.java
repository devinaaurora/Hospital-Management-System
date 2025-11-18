package com.hospital.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.UUID;

/**
 * Utility class for CSRF (Cross-Site Request Forgery) protection
 * Generates and validates CSRF tokens for form submissions
 */
public class CSRFUtil {
    
    private static final String CSRF_TOKEN_SESSION_KEY = "csrfToken";
    private static final String CSRF_TOKEN_PARAM = "csrfToken";
    
    /**
     * Generate a new CSRF token
     * @return Random UUID as CSRF token
     */
    public static String generateToken() {
        return UUID.randomUUID().toString();
    }
    
    /**
     * Store CSRF token in session
     * @param session HTTP session
     * @return Generated token
     */
    public static String generateAndStoreToken(HttpSession session) {
        String token = generateToken();
        session.setAttribute(CSRF_TOKEN_SESSION_KEY, token);
        return token;
    }
    
    /**
     * Get CSRF token from session, create if not exists
     * @param session HTTP session
     * @return CSRF token
     */
    public static String getToken(HttpSession session) {
        String token = (String) session.getAttribute(CSRF_TOKEN_SESSION_KEY);
        if (token == null) {
            token = generateAndStoreToken(session);
        }
        return token;
    }
    
    /**
     * Validate CSRF token from request against session token
     * @param request HTTP request containing form token
     * @return true if token is valid
     */
    public static boolean validateToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_SESSION_KEY);
        String requestToken = request.getParameter(CSRF_TOKEN_PARAM);
        
        if (sessionToken == null || requestToken == null) {
            return false;
        }
        
        return sessionToken.equals(requestToken);
    }
    
    /**
     * Validate and rotate CSRF token (recommended for high security)
     * @param request HTTP request
     * @return true if token is valid (new token is generated after validation)
     */
    public static boolean validateAndRotateToken(HttpServletRequest request) {
        boolean isValid = validateToken(request);
        if (isValid) {
            // Generate new token for next request
            HttpSession session = request.getSession();
            generateAndStoreToken(session);
        }
        return isValid;
    }
    
    /**
     * Get CSRF token parameter name for forms
     * @return Parameter name
     */
    public static String getTokenParamName() {
        return CSRF_TOKEN_PARAM;
    }
    
    /**
     * Generate hidden input HTML for CSRF token
     * @param session HTTP session
     * @return HTML string for hidden input field
     */
    public static String getTokenInputHTML(HttpSession session) {
        String token = getToken(session);
        return String.format("<input type=\"hidden\" name=\"%s\" value=\"%s\">", 
                           CSRF_TOKEN_PARAM, token);
    }
}
