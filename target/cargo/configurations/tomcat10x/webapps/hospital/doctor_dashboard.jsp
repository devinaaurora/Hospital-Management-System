<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Appointment, com.hospital.model.Doctor, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Doctor doctor = (Doctor) session.getAttribute("doctor");
    List<Appointment> appointments = (List<Appointment>) request.getAttribute("appointments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard - HMS</title>
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
                    <span class="text-xl font-bold text-gray-800">HMS - Doctor Portal</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-gray-600">
                        <i class="fas fa-user-md mr-2"></i><%= user.getFullName() %>
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
                    <a href="<%= request.getContextPath() %>/doctor/dashboard" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/doctor/appointments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-alt mr-3"></i>Appointments
                    </a>
                    <a href="<%= request.getContextPath() %>/doctor/patients" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-users mr-3"></i>Patients
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">
                <i class="fas fa-home mr-3"></i>Doctor Dashboard
            </h1>

            <!-- Success Messages -->
            <% if (request.getParameter("success") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i>
                Operation completed successfully!
            </div>
            <% } %>

            <!-- Stats Cards -->
            <div class="grid md:grid-cols-4 gap-6 mb-8">
                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-blue-100 rounded-full p-3 mr-4">
                            <i class="fas fa-calendar-day text-blue-600 text-2xl"></i>
                        </div>
                        <div>
                            <p class="text-gray-600 text-sm">Today's Appointments</p>
                            <p class="text-2xl font-bold text-gray-800">
                                <%= appointments != null ? appointments.stream().filter(a -> 
                                    java.sql.Date.valueOf(java.time.LocalDate.now()).equals(a.getAppointmentDate())).count() : 0 %>
                            </p>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg shadow p-6">
                    <div class="flex items-center">
                        <div class="bg-yellow-100 rounded-full p-3 mr-4">
                            <i class="fas fa-hourglass-half text-yellow-600 text-2xl"></i>
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
                            <i class="fas fa-user-check text-purple-600 text-2xl"></i>
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

            <!-- Pending Appointments -->
            <div class="bg-white rounded-lg shadow mb-6">
                <div class="px-6 py-4 border-b flex justify-between items-center">
                    <h2 class="text-xl font-bold text-gray-800">
                        <i class="fas fa-clock mr-2"></i>Pending Appointments
                    </h2>
                </div>
                <div class="p-6">
                    <% 
                    List<Appointment> pendingAppts = appointments != null ? 
                        appointments.stream().filter(a -> "pending".equals(a.getStatus())).collect(java.util.stream.Collectors.toList()) : 
                        new java.util.ArrayList<>();
                    if (!pendingAppts.isEmpty()) { %>
                        <div class="space-y-4">
                            <% for (Appointment apt : pendingAppts) { %>
                            <div class="border rounded-lg p-4 hover:shadow-md transition">
                                <div class="flex justify-between items-start">
                                    <div class="flex-1">
                                        <h3 class="font-bold text-gray-800"><%= apt.getPatientName() %></h3>
                                        <p class="text-sm text-gray-600 mt-1">
                                            <i class="fas fa-calendar mr-2"></i><%= apt.getAppointmentDate() %>
                                            <i class="fas fa-clock ml-4 mr-2"></i><%= apt.getAppointmentTime() %>
                                        </p>
                                        <p class="text-sm text-gray-700 mt-2"><strong>Reason:</strong> <%= apt.getReason() %></p>
                                    </div>
                                    <div class="flex space-x-2 ml-4">
                                        <form action="<%= request.getContextPath() %>/doctor" method="post" class="inline">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>">
                                            <button type="submit" class="bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded transition">
                                                <i class="fas fa-check mr-1"></i>Approve
                                            </button>
                                        </form>
                                        <form action="<%= request.getContextPath() %>/doctor" method="post" class="inline">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>">
                                            <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded transition">
                                                <i class="fas fa-times mr-1"></i>Reject
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="text-center py-8 text-gray-500">
                            <i class="fas fa-check-circle text-4xl mb-4"></i>
                            <p>No pending appointments</p>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- Today's Schedule -->
            <div class="bg-white rounded-lg shadow">
                <div class="px-6 py-4 border-b">
                    <h2 class="text-xl font-bold text-gray-800">
                        <i class="fas fa-calendar-day mr-2"></i>Today's Schedule
                    </h2>
                </div>
                <div class="p-6">
                    <% 
                    List<Appointment> todayAppts = appointments != null ? 
                        appointments.stream().filter(a -> 
                            java.sql.Date.valueOf(java.time.LocalDate.now()).equals(a.getAppointmentDate())).collect(java.util.stream.Collectors.toList()) : 
                        new java.util.ArrayList<>();
                    if (!todayAppts.isEmpty()) { %>
                        <div class="overflow-x-auto">
                            <table class="min-w-full">
                                <thead>
                                    <tr class="bg-gray-50">
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Time</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Patient</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Reason</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-200">
                                    <% for (Appointment apt : todayAppts) { 
                                        String statusColor = "pending".equals(apt.getStatus()) ? "yellow" : 
                                                           "approved".equals(apt.getStatus()) ? "green" : 
                                                           "completed".equals(apt.getStatus()) ? "blue" : "red";
                                    %>
                                    <tr>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm"><%= apt.getAppointmentTime() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium"><%= apt.getPatientName() %></td>
                                        <td class="px-6 py-4 text-sm"><%= apt.getReason() %></td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <span class="px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-<%= statusColor %>-100 text-<%= statusColor %>-800">
                                                <%= apt.getStatus().toUpperCase() %>
                                            </span>
                                        </td>
                                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                                            <% if ("approved".equals(apt.getStatus())) { %>
                                            <form action="<%= request.getContextPath() %>/doctor" method="post" class="inline">
                                                <input type="hidden" name="action" value="complete">
                                                <input type="hidden" name="appointmentId" value="<%= apt.getAppointmentId() %>">
                                                <button type="submit" class="text-blue-600 hover:text-blue-900">
                                                    <i class="fas fa-check-double"></i> Complete
                                                </button>
                                            </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="text-center py-8 text-gray-500">
                            <i class="fas fa-calendar-times text-4xl mb-4"></i>
                            <p>No appointments scheduled for today</p>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
