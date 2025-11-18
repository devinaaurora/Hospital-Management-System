<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
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
                    <a href="<%= request.getContextPath() %>/patient/dashboard" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/doctors" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
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
                <i class="fas fa-home mr-3"></i>Patient Dashboard
            </h1>

            <!-- Stats Cards -->
            <div class="grid md:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-blue-100 rounded-full p-3 mr-4">
                            <i class="fas fa-calendar-check text-blue-600 text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Total Appointments</p>
                            <p class="text-2xl font-bold text-gray-800"><%= appointments != null ? appointments.size() : 0 %></p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-yellow-100 rounded-full p-3 mr-4">
                            <i class="fas fa-clock text-yellow-600 text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Pending</p>
                            <p class="text-2xl font-bold text-gray-800">
                                <%= appointments != null ? appointments.stream().filter(a -> "pending".equals(a.getStatus())).count() : 0 %>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-green-100 rounded-full p-3 mr-4">
                            <i class="fas fa-check-circle text-green-600 text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Approved</p>
                            <p class="text-2xl font-bold text-gray-800">
                                <%= appointments != null ? appointments.stream().filter(a -> "approved".equals(a.getStatus())).count() : 0 %>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-purple-100 rounded-full p-3 mr-4">
                            <i class="fas fa-clipboard-check text-purple-600 text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Completed</p>
                            <p class="text-2xl font-bold text-gray-800">
                                <%= appointments != null ? appointments.stream().filter(a -> "completed".equals(a.getStatus())).count() : 0 %>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Appointments -->
            <div class="bg-white rounded-lg shadow">
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
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date & Time</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Doctor</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Reason</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200">
                                    <% for (int i = 0; i < Math.min(5, appointments.size()); i++) { 
                                        Appointment apt = appointments.get(i);
                                        String statusColor = "pending".equals(apt.getStatus()) ? "yellow" : 
                                                           "approved".equals(apt.getStatus()) ? "green" : 
                                                           "completed".equals(apt.getStatus()) ? "blue" : "red";
                                    %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <div class="text-sm text-gray-900"><%= apt.getAppointmentDate() %></div>
                                            <div class="text-sm text-gray-500"><%= apt.getAppointmentTime() %></div>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                            <%= apt.getDoctorName() %>
                                        </td>
                                        <td class="px-6 py-4 text-sm text-gray-900">
                                            <%= apt.getReason() %>
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
                            <i class="fas fa-calendar-times text-4xl mb-4"></i>
                            <p>No appointments found</p>
                            <a href="<%= request.getContextPath() %>/patient/book-appointment" class="mt-4 inline-block bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition">
                                Book Your First Appointment
                            </a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
