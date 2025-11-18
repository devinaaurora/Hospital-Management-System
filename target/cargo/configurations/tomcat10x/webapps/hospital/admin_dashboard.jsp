<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Doctor, com.hospital.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
    List<User> patients = (List<User>) request.getAttribute("patients");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - HMS</title>
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
                    <span class="text-xl font-bold text-gray-800">HMS - Admin Portal</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-gray-600">
                        <i class="fas fa-user-shield mr-2"></i><%= user.getFullName() %>
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
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/doctors" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-user-md mr-3"></i>Doctors
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/departments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-building mr-3"></i>Departments
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/appointments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-alt mr-3"></i>Appointments
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">
                <i class="fas fa-chart-line mr-3"></i>Admin Dashboard
            </h1>

            <!-- Stats Cards -->
            <div class="grid md:grid-cols-4 gap-6 mb-8">
                <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-blue-100 text-sm">Total Doctors</p>
                            <p class="text-3xl font-bold mt-2"><%= doctors != null ? doctors.size() : 0 %></p>
                        </div>
                        <div class="bg-white bg-opacity-20 rounded-full p-4">
                            <i class="fas fa-user-md text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-green-100 text-sm">Total Patients</p>
                            <p class="text-3xl font-bold mt-2"><%= patients != null ? patients.size() : 0 %></p>
                        </div>
                        <div class="bg-white bg-opacity-20 rounded-full p-4">
                            <i class="fas fa-users text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-purple-100 text-sm">Total Appointments</p>
                            <p class="text-3xl font-bold mt-2"><%= appointments != null ? appointments.size() : 0 %></p>
                        </div>
                        <div class="bg-white bg-opacity-20 rounded-full p-4">
                            <i class="fas fa-calendar-check text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-yellow-500 to-yellow-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-yellow-100 text-sm">Pending</p>
                            <p class="text-3xl font-bold mt-2">
                                <%= appointments != null ? appointments.stream().filter(a -> "pending".equals(a.getStatus())).count() : 0 %>
                            </p>
                        </div>
                        <div class="bg-white bg-opacity-20 rounded-full p-4">
                            <i class="fas fa-hourglass-half text-3xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Appointments -->
            <div class="bg-white rounded-lg shadow-lg mb-8">
                <div class="px-6 py-4 border-b">
                    <h2 class="text-xl font-bold text-gray-800">
                        <i class="fas fa-calendar-alt mr-2"></i>Recent Appointments
                    </h2>
                </div>
                <div class="p-6">
                    <% if (appointments != null && !appointments.isEmpty()) { %>
                        <div class="overflow-x-auto">
                            <table class="min-w-full">
                                <thead>
                                    <tr class="bg-gray-50">
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Patient</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Doctor</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200">
                                    <% for (int i = 0; i < Math.min(10, appointments.size()); i++) { 
                                        Appointment apt = appointments.get(i);
                                        String statusColor = "pending".equals(apt.getStatus()) ? "yellow" : 
                                                           "approved".equals(apt.getStatus()) ? "green" : 
                                                           "completed".equals(apt.getStatus()) ? "blue" : "red";
                                    %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">#<%= apt.getAppointmentId() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= apt.getPatientName() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= apt.getDoctorName() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <%= apt.getAppointmentDate() %> <%= apt.getAppointmentTime() %>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-<%= statusColor %>-100 text-<%= statusColor %>-800">
                                                <%= apt.getStatus().toUpperCase() %>
                                            </span>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="text-center py-8 text-gray-500">
                            <i class="fas fa-inbox text-4xl mb-4"></i>
                            <p>No appointments found</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="grid md:grid-cols-3 gap-6">
                <a href="<%= request.getContextPath() %>/admin/doctors" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition transform hover:-translate-y-1">
                    <div class="text-center">
                        <div class="text-blue-600 text-5xl mb-4">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Manage Doctors</h3>
                        <p class="text-gray-600">Add, edit, or remove doctors</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/departments" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition transform hover:-translate-y-1">
                    <div class="text-center">
                        <div class="text-green-600 text-5xl mb-4">
                            <i class="fas fa-building"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">Manage Departments</h3>
                        <p class="text-gray-600">Add, edit, or remove departments</p>
                    </div>
                </a>

                <a href="<%= request.getContextPath() %>/admin/appointments" class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition transform hover:-translate-y-1">
                    <div class="text-center">
                        <div class="text-purple-600 text-5xl mb-4">
                            <i class="fas fa-calendar-alt"></i>
                        </div>
                        <h3 class="text-xl font-bold text-gray-800 mb-2">View Appointments</h3>
                        <p class="text-gray-600">Monitor all appointments</p>
                    </div>
                </a>
            </div>
        </div>
    </div>
</body>
</html>
