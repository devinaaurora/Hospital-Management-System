<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Hospital Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-blue-50 to-blue-100 min-h-screen flex items-center justify-center">
    <div class="max-w-md w-full mx-4">
        <!-- Login Card -->
        <div class="bg-white rounded-lg shadow-2xl p-8">
            <!-- Header -->
            <div class="text-center mb-8">
                <div class="text-blue-600 text-6xl mb-4">
                    <i class="fas fa-hospital"></i>
                </div>
                <h2 class="text-3xl font-bold text-gray-800">Hospital Management</h2>
                <p class="text-gray-600 mt-2">Sign in to your account</p>
            </div>

            <!-- Error Message -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <i class="fas fa-exclamation-circle mr-2"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <!-- Login Form -->
            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="mb-6">
                    <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
                        <i class="fas fa-user mr-2"></i>Username
                    </label>
                    <input 
                        class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                        id="username" 
                        name="username" 
                        type="text" 
                        placeholder="Enter your username"
                        required>
                </div>

                <div class="mb-6">
                    <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
                        <i class="fas fa-lock mr-2"></i>Password
                    </label>
                    <input 
                        class="shadow appearance-none border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                        id="password" 
                        name="password" 
                        type="password" 
                        placeholder="Enter your password"
                        required>
                </div>

                <div class="flex items-center justify-between mb-6">
                    <label class="flex items-center">
                        <input class="mr-2 leading-tight" type="checkbox">
                        <span class="text-sm text-gray-600">Remember me</span>
                    </label>
                    <a href="#" class="text-sm text-blue-600 hover:text-blue-800">
                        Forgot Password?
                    </a>
                </div>

                <button 
                    class="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-4 rounded focus:outline-none focus:shadow-outline transition duration-300" 
                    type="submit">
                    <i class="fas fa-sign-in-alt mr-2"></i>Sign In
                </button>
            </form>

            <!-- Register Link -->
            <div class="mt-6 text-center">
                <p class="text-gray-600">
                    Don't have an account? 
                    <a href="<%= request.getContextPath() %>/register.jsp" class="text-blue-600 hover:text-blue-800 font-semibold">
                        <i class="fas fa-user-plus mr-1"></i>Register here
                    </a>
                </p>
            </div>

            <!-- Demo account credentials removed for security -->
        </div>

        <!-- Back to Home -->
        <div class="text-center mt-4">
            <a href="<%= request.getContextPath() %>/index.jsp" class="text-blue-600 hover:text-blue-800">
                <i class="fas fa-arrow-left mr-2"></i>Back to Home
            </a>
        </div>
    </div>
</body>
</html>
