<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
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
    <title>All Appointments - HMS Admin</title>
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
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/doctors" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-user-md mr-3"></i>Doctors
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/departments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-building mr-3"></i>Departments
                    </a>
                    <a href="<%= request.getContextPath() %>/admin/appointments" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-calendar-alt mr-3"></i>Appointments
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <h1 class="text-3xl font-bold text-gray-800 mb-8">
                <i class="fas fa-calendar-alt mr-3"></i>All Appointments
            </h1>

            <!-- Filter Tabs -->
            <div class="bg-white rounded-lg shadow mb-6">
                <div class="flex border-b">
                    <button onclick="filterAppointments('all')" class="px-6 py-3 font-semibold text-blue-600 border-b-2 border-blue-600">
                        All (<%= appointments != null ? appointments.size() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('pending')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800">
                        Pending (<%= appointments != null ? appointments.stream().filter(a -> "pending".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('approved')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800">
                        Approved (<%= appointments != null ? appointments.stream().filter(a -> "approved".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('completed')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800">
                        Completed (<%= appointments != null ? appointments.stream().filter(a -> "completed".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('cancelled')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800">
                        Cancelled (<%= appointments != null ? appointments.stream().filter(a -> "cancelled".equals(a.getStatus()) || "rejected".equals(a.getStatus())).count() : 0 %>)
                    </button>
                </div>
            </div>

            <!-- Appointments Table -->
            <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-50">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Patient</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Doctor</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Date & Time</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Reason</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% if (appointments != null && !appointments.isEmpty()) { 
                                for (Appointment apt : appointments) { 
                                    String statusColor = "pending".equals(apt.getStatus()) ? "yellow" : 
                                                       "approved".equals(apt.getStatus()) ? "green" : 
                                                       "completed".equals(apt.getStatus()) ? "blue" : "red";
                            %>
                            <tr class="hover:bg-gray-50 appointment-row" data-status="<%= apt.getStatus() %>">
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">#<%= apt.getAppointmentId() %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-gray-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user text-gray-600"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900"><%= apt.getPatientName() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <div class="flex items-center">
                                        <div class="flex-shrink-0 h-10 w-10 bg-blue-100 rounded-full flex items-center justify-center">
                                            <i class="fas fa-user-md text-blue-600"></i>
                                        </div>
                                        <div class="ml-4">
                                            <div class="text-sm font-medium text-gray-900"><%= apt.getDoctorName() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                    <div><i class="fas fa-calendar mr-2"></i><%= apt.getAppointmentDate() %></div>
                                    <div class="text-gray-500"><i class="fas fa-clock mr-2"></i><%= apt.getAppointmentTime() %></div>
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
                            <% } } else { %>
                            <tr>
                                <td colspan="6" class="px-6 py-12 text-center text-gray-500">
                                    <i class="fas fa-calendar-times text-5xl mb-4"></i>
                                    <p>No appointments found</p>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        function filterAppointments(status) {
            const rows = document.querySelectorAll('.appointment-row');
            const buttons = document.querySelectorAll('.flex.border-b button');
            
            // Update button styles
            buttons.forEach(btn => {
                btn.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600');
                btn.classList.add('text-gray-600');
            });
            event.target.classList.remove('text-gray-600');
            event.target.classList.add('text-blue-600', 'border-b-2', 'border-blue-600');
            
            // Filter rows
            rows.forEach(row => {
                const rowStatus = row.getAttribute('data-status');
                if (status === 'all') {
                    row.style.display = '';
                } else if (status === 'cancelled') {
                    row.style.display = (rowStatus === 'cancelled' || rowStatus === 'rejected') ? '' : 'none';
                } else {
                    row.style.display = rowStatus === status ? '' : 'none';
                }
            });
        }
    </script>
</body>
</html>
