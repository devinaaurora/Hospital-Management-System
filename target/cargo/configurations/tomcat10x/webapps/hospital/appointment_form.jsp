<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Doctor, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Doctor> doctors = (List<Doctor>) request.getAttribute("doctors");
    String selectedDoctorId = request.getParameter("doctorId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Appointment - HMS</title>
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
                    <a href="<%= request.getContextPath() %>/patient/doctors" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-user-md mr-3"></i>Doctors
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/book-appointment" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
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
                <i class="fas fa-calendar-plus mr-3"></i>Book New Appointment
            </h1>

            <!-- Error/Success Messages -->
            <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i>
                Failed to book appointment. Please try again.
            </div>
            <% } %>

            <!-- Appointment Form -->
            <div class="bg-white rounded-lg shadow-lg p-8 max-w-2xl">
                <form action="<%= request.getContextPath() %>/patient" method="post">
                    <input type="hidden" name="action" value="book">

                    <!-- Doctor Selection -->
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="doctorId">
                            <i class="fas fa-user-md mr-2"></i>Select Doctor *
                        </label>
                        <select 
                            class="shadow border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                            id="doctorId" 
                            name="doctorId" 
                            required>
                            <option value="">-- Choose a Doctor --</option>
                            <% if (doctors != null) {
                                for (Doctor doctor : doctors) { 
                                    boolean isSelected = selectedDoctorId != null && selectedDoctorId.equals(String.valueOf(doctor.getDoctorId()));
                            %>
                                <option value="<%= doctor.getDoctorId() %>" <%= isSelected ? "selected" : "" %>>
                                    <%= doctor.getName() %> - <%= doctor.getSpecialization() %> (<%= doctor.getDepartmentName() %>)
                                </option>
                            <% } } %>
                        </select>
                    </div>

                    <!-- Appointment Date -->
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="appointmentDate">
                            <i class="fas fa-calendar mr-2"></i>Appointment Date *
                        </label>
                        <input 
                            class="shadow border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                            id="appointmentDate" 
                            name="appointmentDate" 
                            type="date" 
                            min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                            required>
                    </div>

                    <!-- Appointment Time -->
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="appointmentTime">
                            <i class="fas fa-clock mr-2"></i>Appointment Time *
                        </label>
                        <select 
                            class="shadow border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                            id="appointmentTime" 
                            name="appointmentTime" 
                            required>
                            <option value="">-- Select Time --</option>
                            <option value="09:00">09:00 AM</option>
                            <option value="10:00">10:00 AM</option>
                            <option value="11:00">11:00 AM</option>
                            <option value="12:00">12:00 PM</option>
                            <option value="14:00">02:00 PM</option>
                            <option value="15:00">03:00 PM</option>
                            <option value="16:00">04:00 PM</option>
                            <option value="17:00">05:00 PM</option>
                        </select>
                    </div>

                    <!-- Reason for Visit -->
                    <div class="mb-6">
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="reason">
                            <i class="fas fa-notes-medical mr-2"></i>Reason for Visit *
                        </label>
                        <textarea 
                            class="shadow border rounded w-full py-3 px-4 text-gray-700 leading-tight focus:outline-none focus:ring-2 focus:ring-blue-500" 
                            id="reason" 
                            name="reason" 
                            rows="4" 
                            placeholder="Please describe your symptoms or reason for visit..."
                            required></textarea>
                    </div>

                    <!-- Action Buttons -->
                    <div class="flex items-center justify-between">
                        <button 
                            class="bg-blue-600 hover:bg-blue-700 text-white font-bold py-3 px-6 rounded focus:outline-none focus:shadow-outline transition duration-300" 
                            type="submit">
                            <i class="fas fa-calendar-check mr-2"></i>Book Appointment
                        </button>
                        <a href="<%= request.getContextPath() %>/patient/appointments" class="text-gray-600 hover:text-gray-800">
                            <i class="fas fa-times mr-2"></i>Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
