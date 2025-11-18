<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hospital Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gradient-to-br from-blue-50 to-blue-100 min-h-screen">
    <!-- Navigation -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <i class="fas fa-hospital text-blue-600 text-3xl mr-3"></i>
                    <span class="text-2xl font-bold text-gray-800">Hospital Management System</span>
                </div>
                <div class="flex items-center">
                    <a href="login.jsp" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg transition duration-300">
                        <i class="fas fa-sign-in-alt mr-2"></i>Login
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div class="text-center mb-12">
            <h1 class="text-5xl font-bold text-gray-900 mb-4">Welcome to Our Hospital</h1>
            <p class="text-xl text-gray-600">Quality Healthcare Services at Your Fingertips</p>
        </div>

        <!-- Features Grid -->
        <div class="grid md:grid-cols-3 gap-8 mb-12">
            <!-- Patient Features -->
            <div class="bg-white rounded-lg shadow-lg p-8 hover:shadow-xl transition duration-300">
                <div class="text-blue-600 text-5xl mb-4">
                    <i class="fas fa-user-injured"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-800 mb-4">For Patients</h3>
                <ul class="text-gray-600 space-y-2">
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Book Appointments Online</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>View Doctor Availability</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Access Medical Records</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Track Appointment Status</li>
                </ul>
            </div>

            <!-- Doctor Features -->
            <div class="bg-white rounded-lg shadow-lg p-8 hover:shadow-xl transition duration-300">
                <div class="text-blue-600 text-5xl mb-4">
                    <i class="fas fa-user-md"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-800 mb-4">For Doctors</h3>
                <ul class="text-gray-600 space-y-2">
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Manage Appointments</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Update Patient Records</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>View Schedule</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Add Diagnoses & Prescriptions</li>
                </ul>
            </div>

            <!-- Admin Features -->
            <div class="bg-white rounded-lg shadow-lg p-8 hover:shadow-xl transition duration-300">
                <div class="text-blue-600 text-5xl mb-4">
                    <i class="fas fa-user-shield"></i>
                </div>
                <h3 class="text-2xl font-bold text-gray-800 mb-4">For Administrators</h3>
                <ul class="text-gray-600 space-y-2">
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Manage Doctors</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Manage Departments</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>View All Appointments</li>
                    <li><i class="fas fa-check text-green-500 mr-2"></i>Hospital Operations</li>
                </ul>
            </div>
        </div>

        <!-- Call to Action -->
        <div class="bg-blue-600 rounded-lg shadow-xl p-8 text-center text-white">
            <h2 class="text-3xl font-bold mb-4">Ready to Get Started?</h2>
            <p class="text-xl mb-6">Access your account to manage your healthcare needs</p>
            <a href="login.jsp" class="bg-white text-blue-600 hover:bg-gray-100 px-8 py-3 rounded-lg text-lg font-semibold inline-block transition duration-300">
                Login Now <i class="fas fa-arrow-right ml-2"></i>
            </a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-gray-800 text-white py-8 mt-12">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
            <p>&copy; 2024 Hospital Management System. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
