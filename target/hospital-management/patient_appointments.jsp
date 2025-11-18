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
    <title>My Appointments - HMS</title>
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
                        <i class="fas fa-user mr-2"></i><%= user.getFullName() %>
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
                    <a href="<%= request.getContextPath() %>/patient/doctors" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-user-md mr-3"></i>Doctors
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/appointments" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
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
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-calendar-check mr-3"></i>My Appointments
                </h1>
                <a href="<%= request.getContextPath() %>/patient/book-appointment" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition duration-300">
                    <i class="fas fa-plus mr-2"></i>Book New Appointment
                </a>
            </div>

            <!-- Filter Tabs -->
            <div class="bg-white rounded-lg shadow mb-6">
                <div class="flex border-b">
                    <button onclick="filterAppointments('all')" class="px-6 py-3 font-semibold text-blue-600 border-b-2 border-blue-600" id="tab-all">
                        All (<%= appointments != null ? appointments.size() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('pending')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800" id="tab-pending">
                        Pending (<%= appointments != null ? appointments.stream().filter(a -> "pending".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('approved')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800" id="tab-approved">
                        Approved (<%= appointments != null ? appointments.stream().filter(a -> "approved".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('completed')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800" id="tab-completed">
                        Completed (<%= appointments != null ? appointments.stream().filter(a -> "completed".equals(a.getStatus())).count() : 0 %>)
                    </button>
                    <button onclick="filterAppointments('cancelled')" class="px-6 py-3 font-semibold text-gray-600 hover:text-gray-800" id="tab-cancelled">
                        Cancelled (<%= appointments != null ? appointments.stream().filter(a -> "cancelled".equals(a.getStatus()) || "rejected".equals(a.getStatus())).count() : 0 %>)
                    </button>
                </div>
            </div>

            <!-- Success/Error Messages -->
            <% if (request.getParameter("success") != null) { 
                String successMsg = "cancelled".equals(request.getParameter("success")) ? "Appointment cancelled successfully!" : "Action completed!";
            %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i><%= successMsg %>
            </div>
            <% } %>

            <!-- Appointments List -->
            <div class="grid gap-6">
                <% if (appointments != null && !appointments.isEmpty()) { 
                    for (Appointment apt : appointments) { 
                        String statusColor = "pending".equals(apt.getStatus()) ? "yellow" : 
                                           "approved".equals(apt.getStatus()) ? "green" : 
                                           "completed".equals(apt.getStatus()) ? "blue" : "red";
                        String statusIcon = "pending".equals(apt.getStatus()) ? "clock" : 
                                          "approved".equals(apt.getStatus()) ? "check-circle" : 
                                          "completed".equals(apt.getStatus()) ? "check-double" : "times-circle";
                %>
                <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition appointment-card" data-status="<%= apt.getStatus() %>">
                    <div class="flex justify-between items-start">
                        <div class="flex-1">
                            <div class="flex items-center mb-4">
                                <div class="bg-blue-100 rounded-full p-3 mr-4">
                                    <i class="fas fa-user-md text-blue-600 text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-gray-800"><%= apt.getDoctorName() %></h3>
                                    <p class="text-sm text-gray-600">Appointment #<%= apt.getAppointmentId() %></p>
                                </div>
                            </div>
                            
                            <div class="grid md:grid-cols-2 gap-4">
                                <div>
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-calendar mr-2"></i>Date</p>
                                    <p class="font-semibold text-gray-800"><%= apt.getAppointmentDate() %></p>
                                </div>
                                <div>
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-clock mr-2"></i>Time</p>
                                    <p class="font-semibold text-gray-800"><%= apt.getAppointmentTime() %></p>
                                </div>
                                <div class="md:col-span-2">
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-notes-medical mr-2"></i>Reason</p>
                                    <p class="text-gray-700"><%= apt.getReason() %></p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="ml-4 text-right">
                            <span class="px-4 py-2 inline-flex text-sm leading-5 font-semibold rounded-full bg-<%= statusColor %>-100 text-<%= statusColor %>-800">
                                <i class="fas fa-<%= statusIcon %> mr-2"></i><%= apt.getStatus().toUpperCase() %>
                            </span>
                            
                            <% if ("pending".equals(apt.getStatus())) { %>
                            <div class="mt-4 space-y-2">
                                <button onclick="cancelAppointment(<%= apt.getAppointmentId() %>)" 
                                        class="block w-full bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm transition">
                                    <i class="fas fa-times mr-2"></i>Cancel
                                </button>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="bg-white rounded-lg shadow-lg p-12 text-center">
                    <i class="fas fa-calendar-times text-gray-400 text-6xl mb-4"></i>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">No Appointments Yet</h3>
                    <p class="text-gray-600 mb-6">You haven't booked any appointments. Book your first appointment now!</p>
                    <a href="<%= request.getContextPath() %>/patient/book-appointment" class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition duration-300">
                        <i class="fas fa-plus mr-2"></i>Book Appointment
                    </a>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function filterAppointments(status) {
            const cards = document.querySelectorAll('.appointment-card');
            const tabs = document.querySelectorAll('[id^="tab-"]');
            
            // Update tab styles
            tabs.forEach(tab => {
                tab.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600');
                tab.classList.add('text-gray-600');
            });
            document.getElementById('tab-' + status).classList.remove('text-gray-600');
            document.getElementById('tab-' + status).classList.add('text-blue-600', 'border-b-2', 'border-blue-600');
            
            // Filter cards
            cards.forEach(card => {
                const cardStatus = card.getAttribute('data-status');
                if (status === 'all') {
                    card.style.display = '';
                } else if (status === 'cancelled') {
                    card.style.display = (cardStatus === 'cancelled' || cardStatus === 'rejected') ? '' : 'none';
                } else {
                    card.style.display = cardStatus === status ? '' : 'none';
                }
            });
        }
        
        function cancelAppointment(appointmentId) {
            if (confirm('Are you sure you want to cancel this appointment?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/patient/cancel-appointment';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'appointmentId';
                idInput.value = appointmentId;
                
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
