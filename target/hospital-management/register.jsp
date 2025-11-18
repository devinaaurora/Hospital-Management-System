<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Hospital Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .password-strength {
            height: 4px;
            border-radius: 2px;
            transition: all 0.3s;
        }
    </style>
</head>
<body class="bg-gradient-to-br from-blue-50 to-indigo-100 min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <div class="max-w-md mx-auto">
            <!-- Logo/Header -->
            <div class="text-center mb-8">
                <div class="inline-block bg-blue-600 text-white p-4 rounded-full mb-4">
                    <i class="fas fa-hospital text-4xl"></i>
                </div>
                <h1 class="text-3xl font-bold text-gray-800">Hospital Management System</h1>
                <p class="text-gray-600 mt-2">Create your patient account</p>
            </div>

            <!-- Registration Form -->
            <div class="bg-white rounded-lg shadow-xl p-8">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-user-plus mr-2 text-blue-600"></i>Register
                </h2>

                <!-- Success/Error Messages -->
                <% if (request.getParameter("success") != null) { %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                    <i class="fas fa-check-circle mr-2"></i>
                    Registration successful! Please <a href="login.jsp" class="underline font-semibold">login here</a>.
                </div>
                <% } %>
                
                <% if (request.getParameter("error") != null) { 
                    String errorMsg = "username_exists".equals(request.getParameter("error")) ? "Username already exists. Please choose another." :
                                    "email_exists".equals(request.getParameter("error")) ? "Email already registered. Please use another or login." :
                                    "weak_password".equals(request.getParameter("error")) ? "Password does not meet complexity requirements." :
                                    "passwords_mismatch".equals(request.getParameter("error")) ? "Passwords do not match." :
                                    "Registration failed. Please try again.";
                %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    <i class="fas fa-exclamation-circle mr-2"></i><%= errorMsg %>
                </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/register" method="post" id="registerForm">
                    <!-- Full Name -->
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-user mr-2"></i>Full Name *
                        </label>
                        <input type="text" name="fullName" required 
                               pattern="[A-Za-z\s]{2,}" 
                               title="Full name (letters and spaces only, minimum 2 characters)"
                               class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="John Doe">
                    </div>

                    <!-- Username -->
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-user-circle mr-2"></i>Username *
                        </label>
                        <input type="text" name="username" required 
                               pattern="[a-zA-Z0-9._@-]{4,20}" 
                               title="Username (4-20 characters, letters, numbers, and ._@- only)"
                               class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="johndoe">
                        <p class="text-xs text-gray-600 mt-1">4-20 characters, letters, numbers, and ._@- only</p>
                    </div>

                    <!-- Email -->
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-envelope mr-2"></i>Email *
                        </label>
                        <input type="email" name="email" required 
                               class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="john@example.com">
                    </div>

                    <!-- Phone -->
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-phone mr-2"></i>Phone Number *
                        </label>
                        <input type="tel" name="phone" required 
                               pattern="[0-9]{10,15}" 
                               title="Phone number (10-15 digits)"
                               class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                               placeholder="08123456789">
                        <p class="text-xs text-gray-600 mt-1">10-15 digits only</p>
                    </div>

                    <!-- Password -->
                    <div class="mb-4">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-lock mr-2"></i>Password *
                        </label>
                        <div class="relative">
                            <input type="password" name="password" id="password" required 
                                   minlength="8"
                                   pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
                                   title="Min 8 chars with uppercase, lowercase, digit, and special character"
                                   class="shadow appearance-none border rounded w-full py-3 px-4 pr-10 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   placeholder="••••••••">
                            <button type="button" onclick="togglePassword('password', 'togglePassword1')" 
                                    class="absolute right-3 top-3 text-gray-600 hover:text-gray-800">
                                <i class="fas fa-eye" id="togglePassword1"></i>
                            </button>
                        </div>
                        <!-- Password Strength Indicator -->
                        <div class="mt-2">
                            <div class="password-strength bg-gray-200" id="passwordStrength"></div>
                            <p class="text-xs text-gray-600 mt-1" id="passwordHint">
                                Min 8 characters: uppercase, lowercase, digit, special char (!@#$%^&*)
                            </p>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2">
                            <i class="fas fa-lock mr-2"></i>Confirm Password *
                        </label>
                        <div class="relative">
                            <input type="password" name="confirmPassword" id="confirmPassword" required 
                                   class="shadow appearance-none border rounded w-full py-3 px-4 pr-10 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500"
                                   placeholder="••••••••">
                            <button type="button" onclick="togglePassword('confirmPassword', 'togglePassword2')" 
                                    class="absolute right-3 top-3 text-gray-600 hover:text-gray-800">
                                <i class="fas fa-eye" id="togglePassword2"></i>
                            </button>
                        </div>
                        <p class="text-xs text-red-600 mt-1 hidden" id="passwordMatch">Passwords do not match</p>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" 
                            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-300">
                        <i class="fas fa-user-plus mr-2"></i>Create Account
                    </button>
                </form>

                <!-- Login Link -->
                <div class="mt-6 text-center">
                    <p class="text-gray-600">
                        Already have an account? 
                        <a href="login.jsp" class="text-blue-600 hover:text-blue-800 font-semibold">
                            <i class="fas fa-sign-in-alt mr-1"></i>Login here
                        </a>
                    </p>
                </div>
            </div>

            <!-- Footer -->
            <div class="text-center mt-6 text-gray-600 text-sm">
                <p>&copy; 2025 Hospital Management System. All rights reserved.</p>
            </div>
        </div>
    </div>

    <script>
        // Toggle password visibility
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Password strength checker
        const passwordInput = document.getElementById('password');
        const strengthBar = document.getElementById('passwordStrength');
        const passwordHint = document.getElementById('passwordHint');

        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[!@#$%^&*]/)) strength++;
            
            // Update strength bar
            const colors = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-lime-500', 'bg-green-500'];
            const widths = ['20%', '40%', '60%', '80%', '100%'];
            const labels = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
            
            strengthBar.className = 'password-strength ' + (colors[strength - 1] || 'bg-gray-200');
            strengthBar.style.width = widths[strength - 1] || '0%';
            
            if (password.length > 0) {
                passwordHint.textContent = 'Password Strength: ' + (labels[strength - 1] || 'Too Weak');
                passwordHint.className = 'text-xs mt-1 ' + (strength >= 4 ? 'text-green-600' : 'text-orange-600');
            } else {
                passwordHint.textContent = 'Min 8 characters: uppercase, lowercase, digit, special char (!@#$%^&*)';
                passwordHint.className = 'text-xs text-gray-600 mt-1';
            }
        });

        // Password match checker
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');

        confirmPasswordInput.addEventListener('input', function() {
            if (this.value && this.value !== passwordInput.value) {
                passwordMatch.classList.remove('hidden');
                this.setCustomValidity('Passwords do not match');
            } else {
                passwordMatch.classList.add('hidden');
                this.setCustomValidity('');
            }
        });

        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            if (passwordInput.value !== confirmPasswordInput.value) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            // Check password complexity
            const password = passwordInput.value;
            if (password.length < 8 || 
                !password.match(/[a-z]/) || 
                !password.match(/[A-Z]/) || 
                !password.match(/[0-9]/) || 
                !password.match(/[!@#$%^&*]/)) {
                e.preventDefault();
                alert('Password must be at least 8 characters and contain uppercase, lowercase, digit, and special character.');
                return false;
            }
        });
    </script>
</body>
</html>
