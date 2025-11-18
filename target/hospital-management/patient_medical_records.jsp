<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.MedicalRecord, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("medicalRecords");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Medical Records - HMS</title>
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
                    <a href="<%= request.getContextPath() %>/patient/appointments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-check mr-3"></i>My Appointments
                    </a>
                    <a href="<%= request.getContextPath() %>/patient/medical-records" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-file-medical mr-3"></i>Medical Records
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-file-medical mr-3"></i>My Medical Records
                </h1>
                <p class="text-gray-600 mt-2">View your complete medical history and treatment records</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-blue-100 text-sm">Total Records</p>
                            <p class="text-3xl font-bold mt-2"><%= records != null ? records.size() : 0 %></p>
                        </div>
                        <div class="bg-blue-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-file-medical text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-green-100 text-sm">Last Visit</p>
                            <p class="text-xl font-bold mt-2">
                                <%= records != null && !records.isEmpty() ? records.get(0).getDate() : "N/A" %>
                            </p>
                        </div>
                        <div class="bg-green-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-calendar-check text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-purple-100 text-sm">Doctors Consulted</p>
                            <p class="text-3xl font-bold mt-2">
                                <%= records != null ? records.stream().map(r -> r.getDoctorName()).distinct().count() : 0 %>
                            </p>
                        </div>
                        <div class="bg-purple-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-user-md text-3xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Medical Records Timeline -->
            <div class="bg-white rounded-lg shadow-lg p-6">
                <h2 class="text-2xl font-bold text-gray-800 mb-6">
                    <i class="fas fa-history mr-2"></i>Medical History
                </h2>

                <% if (records != null && !records.isEmpty()) { %>
                <div class="space-y-6">
                    <% for (MedicalRecord record : records) { %>
                    <div class="border-l-4 border-blue-600 bg-gray-50 p-6 rounded-r-lg hover:shadow-md transition">
                        <div class="flex justify-between items-start mb-4">
                            <div class="flex items-center">
                                <div class="bg-blue-100 rounded-full p-3 mr-4">
                                    <i class="fas fa-notes-medical text-blue-600 text-xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-lg font-bold text-gray-800">
                                        <i class="fas fa-calendar mr-2"></i><%= record.getDate() %>
                                    </h3>
                                    <p class="text-sm text-gray-600">
                                        <i class="fas fa-user-md mr-2"></i>Dr. <%= record.getDoctorName() %>
                                    </p>
                                </div>
                            </div>
                            <span class="text-xs text-gray-500">Record #<%= record.getRecordId() %></span>
                        </div>

                        <div class="grid md:grid-cols-2 gap-6">
                            <div class="bg-white rounded-lg p-4 border border-gray-200">
                                <h4 class="font-semibold text-gray-700 mb-2 flex items-center">
                                    <i class="fas fa-stethoscope mr-2 text-red-600"></i>Diagnosis
                                </h4>
                                <p class="text-gray-800"><%= record.getDiagnosis() != null ? record.getDiagnosis() : "No diagnosis recorded" %></p>
                            </div>

                            <div class="bg-white rounded-lg p-4 border border-gray-200">
                                <h4 class="font-semibold text-gray-700 mb-2 flex items-center">
                                    <i class="fas fa-pills mr-2 text-green-600"></i>Treatment
                                </h4>
                                <p class="text-gray-800"><%= record.getTreatment() != null ? record.getTreatment() : "No treatment recorded" %></p>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mt-4 flex space-x-3">
                            <button onclick="printRecord(<%= record.getRecordId() %>)" 
                                    class="text-blue-600 hover:text-blue-800 text-sm font-semibold">
                                <i class="fas fa-print mr-1"></i>Print
                            </button>
                            <button onclick="downloadRecord(<%= record.getRecordId() %>)" 
                                    class="text-green-600 hover:text-green-800 text-sm font-semibold">
                                <i class="fas fa-download mr-1"></i>Download
                            </button>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="text-center py-12">
                    <i class="fas fa-file-medical-alt text-gray-400 text-6xl mb-4"></i>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">No Medical Records Yet</h3>
                    <p class="text-gray-600 mb-6">Your medical records will appear here after your appointments are completed.</p>
                    <a href="<%= request.getContextPath() %>/patient/doctors" class="inline-block bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition duration-300">
                        <i class="fas fa-calendar-plus mr-2"></i>Book an Appointment
                    </a>
                </div>
                <% } %>
            </div>

            <!-- Health Tips Section -->
            <div class="mt-8 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg shadow-lg p-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4">
                    <i class="fas fa-heartbeat mr-2 text-red-500"></i>Health Tips
                </h3>
                <div class="grid md:grid-cols-2 gap-4">
                    <div class="flex items-start">
                        <i class="fas fa-check-circle text-green-600 mt-1 mr-3"></i>
                        <p class="text-gray-700">Keep all your medical documents in one secure place</p>
                    </div>
                    <div class="flex items-start">
                        <i class="fas fa-check-circle text-green-600 mt-1 mr-3"></i>
                        <p class="text-gray-700">Share your medical history with new doctors</p>
                    </div>
                    <div class="flex items-start">
                        <i class="fas fa-check-circle text-green-600 mt-1 mr-3"></i>
                        <p class="text-gray-700">Download and backup your records regularly</p>
                    </div>
                    <div class="flex items-start">
                        <i class="fas fa-check-circle text-green-600 mt-1 mr-3"></i>
                        <p class="text-gray-700">Follow up on all prescribed treatments</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function printRecord(recordId) {
            alert('Print functionality for record #' + recordId + ' will be implemented.');
            // TODO: Implement print functionality
        }

        function downloadRecord(recordId) {
            alert('Download functionality for record #' + recordId + ' will be implemented.');
            // TODO: Implement download as PDF functionality
        }
    </script>
</body>
</html>
