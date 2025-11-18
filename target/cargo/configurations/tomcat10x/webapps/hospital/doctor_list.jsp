<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Doctor, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Our Doctors - HMS</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <i class="fas fa-hospital text-blue-600 text-2xl mr-3"></i>
                    <span class="text-xl font-bold text-gray-800">HMS - Patient Portal</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-gray-600">
                        <i class="fas fa-user-circle mr-2"></i><%= user.getFullName() %>
                    </span>
                    <a href="<%= request.getContextPath() %>/login?action=logout" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded transition duration-300">
                        <i class="fas fa-sign-out-alt mr-2"></i>Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <div class="flex">
        <!-- Sidebar -->
        <div class="w-64 bg-white shadow-lg min-h-screen">
            <div class="p-6">
                <nav class="space-y-2">
                    <a href="<%= request.getContextPath() %>/patient/dashboard" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/doctors" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-user-md mr-3"></i>Doctors
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/book-appointment" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-plus mr-3"></i>Book Appointment
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/appointments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-check mr-3"></i>My Appointments
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/medical-records" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-file-medical mr-3"></i>Medical Records
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">
                <i class="fas fa-user-md mr-3"></i>Our Doctors
            </h1>

            <!-- Doctors Grid -->
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <% if (doctors != null && !doctors.isEmpty()) { 
                    for (Doctor doctor : doctors) { %>
                    <div class="bg-white rounded-lg shadow-lg overflow-hidden hover:shadow-xl transition duration-300">
                        <div class="bg-gradient-to-r from-blue-500 to-blue-600 p-6 text-center">
                            <div class="w-24 h-24 mx-auto mb-4 bg-white rounded-full flex items-center justify-center">
                                <i class="fas fa-user-md text-blue-600 text-4xl"></i>
                            </div>
                            <h3 class="text-xl font-bold text-white"><%= doctor.getName() %></h3>
                            <p class="text-blue-100"><%= doctor.getSpecialization() %></p>
                        </div>
                        <div class="p-6">
                            <div class="space-y-3">
                                <div class="flex items-center text-gray-700">
                                    <i class="fas fa-building w-6 text-blue-600"></i>
                                    <span class="text-sm"><%= doctor.getDepartmentName() != null ? doctor.getDepartmentName() : "N/A" %></span>
                                </div>
                                <div class="flex items-center text-gray-700">
                                    <i class="fas fa-clock w-6 text-blue-600"></i>
                                    <span class="text-sm"><%= doctor.getAvailability() != null ? doctor.getAvailability() : "N/A" %></span>
                                </div>
                                <div class="flex items-center text-gray-700">
                                    <i class="fas fa-dollar-sign w-6 text-blue-600"></i>
                                    <span class="text-sm">Fee: $<%= doctor.getConsultationFee() != null ? doctor.getConsultationFee() : "N/A" %></span>
                                </div>
                            </div>
                            <div class="mt-6">
                                <a href="<%= request.getContextPath() %>/patient/book-appointment?doctorId=<%= doctor.getDoctorId() %>" 
                                   class="block w-full bg-blue-600 hover:bg-blue-700 text-white text-center py-2 px-4 rounded transition duration-300">
                                    <i class="fas fa-calendar-plus mr-2"></i>Book Appointment
                                </a>
                            </div>
                        </div>
                    </div>
                <% } 
                } else { %>
                    <div class="col-span-3 text-center py-12 text-gray-500">
                        <i class="fas fa-user-md-slash text-5xl mb-4"></i>
                        <p>No doctors available at the moment</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
