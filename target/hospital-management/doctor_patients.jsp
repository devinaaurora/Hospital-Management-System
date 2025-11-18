<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.MedicalRecord, java.util.List, java.util.Map, java.util.stream.Collectors" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<MedicalRecord> records = (List<MedicalRecord>) request.getAttribute("medicalRecords");
    // Group records by patient
    Map<Integer, List<MedicalRecord>> patientRecords = records != null ? 
        records.stream().collect(Collectors.groupingBy(MedicalRecord::getPatientId)) : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Patients - Doctor Portal</title>
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
                    <a href="<%= request.getContextPath() %>/doctor/dashboard" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-home mr-3"></i>Dashboard
                    </a>
                    <a href="<%= request.getContextPath() %>/doctor/appointments" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-calendar-check mr-3"></i>Appointments
                    </a>
                    <a href="<%= request.getContextPath() %>/doctor/patients" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-users mr-3"></i>Patients
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-users mr-3"></i>My Patients
                </h1>
                <p class="text-gray-600 mt-2">View and manage your patients' medical records</p>
            </div>

            <!-- Statistics Cards -->
            <div class="grid md:grid-cols-3 gap-6 mb-8">
                <div class="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-blue-100 text-sm">Total Patients</p>
                            <p class="text-3xl font-bold mt-2"><%= patientRecords != null ? patientRecords.size() : 0 %></p>
                        </div>
                        <div class="bg-blue-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-users text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-green-100 text-sm">Total Records</p>
                            <p class="text-3xl font-bold mt-2"><%= records != null ? records.size() : 0 %></p>
                        </div>
                        <div class="bg-green-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-file-medical text-3xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-lg p-6 text-white">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-purple-100 text-sm">This Month</p>
                            <p class="text-3xl font-bold mt-2">
                                <%= records != null ? records.stream().filter(r -> {
                                    java.util.Calendar cal = java.util.Calendar.getInstance();
                                    cal.setTime(r.getDate());
                                    java.util.Calendar now = java.util.Calendar.getInstance();
                                    return cal.get(java.util.Calendar.MONTH) == now.get(java.util.Calendar.MONTH) &&
                                           cal.get(java.util.Calendar.YEAR) == now.get(java.util.Calendar.YEAR);
                                }).count() : 0 %>
                            </p>
                        </div>
                        <div class="bg-purple-400 bg-opacity-50 rounded-full p-4">
                            <i class="fas fa-calendar-alt text-3xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="bg-white rounded-lg shadow mb-6 p-4">
                <div class="flex items-center">
                    <i class="fas fa-search text-gray-400 mr-3"></i>
                    <input type="text" id="searchPatient" 
                           placeholder="Search patients by name..." 
                           onkeyup="searchPatients()"
                           class="flex-1 px-4 py-2 focus:outline-none">
                </div>
            </div>

            <!-- Patients List -->
            <div class="grid gap-6">
                <% if (patientRecords != null && !patientRecords.isEmpty()) { 
                    for (Map.Entry<Integer, List<MedicalRecord>> entry : patientRecords.entrySet()) {
                        List<MedicalRecord> patientMedicalRecords = entry.getValue();
                        MedicalRecord latest = patientMedicalRecords.get(0);
                %>
                <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition patient-card" data-patient-name="<%= latest.getPatientName().toLowerCase() %>">
                    <div class="flex justify-between items-start">
                        <div class="flex-1">
                            <div class="flex items-center mb-4">
                                <div class="bg-blue-100 rounded-full p-3 mr-4">
                                    <i class="fas fa-user text-blue-600 text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-gray-800"><%= latest.getPatientName() %></h3>
                                    <p class="text-sm text-gray-600">Patient ID: #<%= latest.getPatientId() %></p>
                                </div>
                            </div>

                            <div class="grid md:grid-cols-3 gap-4 mb-4">
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-file-medical mr-2"></i>Total Records</p>
                                    <p class="text-2xl font-bold text-gray-800"><%= patientMedicalRecords.size() %></p>
                                </div>
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-calendar mr-2"></i>Last Visit</p>
                                    <p class="font-semibold text-gray-800"><%= latest.getDate() %></p>
                                </div>
                                <div class="bg-gray-50 rounded-lg p-3">
                                    <p class="text-sm text-gray-600 mb-1"><i class="fas fa-stethoscope mr-2"></i>Last Diagnosis</p>
                                    <p class="font-semibold text-gray-800 text-sm truncate"><%= latest.getDiagnosis() != null ? latest.getDiagnosis() : "N/A" %></p>
                                </div>
                            </div>

                            <!-- Recent Records Preview -->
                            <div class="border-t pt-4">
                                <button onclick="toggleRecords(<%= latest.getPatientId() %>)" 
                                        class="text-blue-600 hover:text-blue-800 font-semibold text-sm">
                                    <i class="fas fa-eye mr-2"></i>View Medical History (<%= patientMedicalRecords.size() %> records)
                                </button>
                            </div>
                        </div>

                        <div class="ml-4">
                            <button onclick="addNewRecord(<%= latest.getPatientId() %>, '<%= latest.getPatientName() %>')" 
                                    class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded transition">
                                <i class="fas fa-plus mr-2"></i>Add Record
                            </button>
                        </div>
                    </div>

                    <!-- Collapsible Medical Records -->
                    <div id="records-<%= latest.getPatientId() %>" class="hidden mt-6 border-t pt-6">
                        <h4 class="font-bold text-gray-800 mb-4">
                            <i class="fas fa-history mr-2"></i>Medical History
                        </h4>
                        <div class="space-y-4">
                            <% for (MedicalRecord record : patientMedicalRecords) { %>
                            <div class="bg-gray-50 rounded-lg p-4 border-l-4 border-blue-600">
                                <div class="flex justify-between items-start mb-3">
                                    <div>
                                        <p class="font-semibold text-gray-800">
                                            <i class="fas fa-calendar mr-2"></i><%= record.getDate() %>
                                        </p>
                                        <p class="text-xs text-gray-600 mt-1">Record #<%= record.getRecordId() %></p>
                                    </div>
                                </div>
                                <div class="grid md:grid-cols-2 gap-4">
                                    <div>
                                        <p class="text-sm font-semibold text-gray-700 mb-1">
                                            <i class="fas fa-stethoscope mr-2 text-red-600"></i>Diagnosis
                                        </p>
                                        <p class="text-gray-800"><%= record.getDiagnosis() != null ? record.getDiagnosis() : "N/A" %></p>
                                    </div>
                                    <div>
                                        <p class="text-sm font-semibold text-gray-700 mb-1">
                                            <i class="fas fa-notes-medical mr-2 text-green-600"></i>Treatment
                                        </p>
                                        <p class="text-gray-800"><%= record.getTreatment() != null ? record.getTreatment() : "N/A" %></p>
                                    </div>
                                    <% if (record.getPrescription() != null && !record.getPrescription().isEmpty()) { %>
                                    <div class="md:col-span-2">
                                        <p class="text-sm font-semibold text-gray-700 mb-1">
                                            <i class="fas fa-pills mr-2 text-purple-600"></i>Prescription
                                        </p>
                                        <p class="text-gray-800"><%= record.getPrescription() %></p>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="bg-white rounded-lg shadow-lg p-12 text-center">
                    <i class="fas fa-user-friends text-gray-400 text-6xl mb-4"></i>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">No Patient Records</h3>
                    <p class="text-gray-600">You haven't created any medical records yet.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Add Record Modal -->
    <div id="addRecordModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-screen overflow-y-auto">
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-800">
                        <i class="fas fa-stethoscope mr-2 text-blue-600"></i>Add New Medical Record
                    </h2>
                    <button onclick="closeAddRecordModal()" class="text-gray-600 hover:text-gray-800">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>

                <form action="<%= request.getContextPath() %>/doctor/patients" method="post">
                    <input type="hidden" name="action" value="addRecord">
                    <input type="hidden" name="patientId" id="new_patientId">

                    <div class="mb-4">
                        <label class="block text-gray-700 font-semibold mb-2">Patient</label>
                        <input type="text" id="new_patientName" readonly 
                               class="w-full px-4 py-2 bg-gray-100 border rounded cursor-not-allowed">
                    </div>

                    <div class="mb-4">
                        <label class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-stethoscope mr-2"></i>Diagnosis *
                        </label>
                        <textarea name="diagnosis" required rows="4"
                                  class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                                  placeholder="Enter patient diagnosis..."></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-notes-medical mr-2"></i>Treatment Plan *
                        </label>
                        <textarea name="treatment" required rows="4"
                                  class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                                  placeholder="Enter treatment plan and recommendations..."></textarea>
                    </div>

                    <div class="mb-6">
                        <label class="block text-gray-700 font-semibold mb-2">
                            <i class="fas fa-pills mr-2"></i>Prescription
                        </label>
                        <textarea name="prescription" rows="4"
                                  class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500"
                                  placeholder="Enter medications and dosage instructions..."></textarea>
                    </div>

                    <div class="flex space-x-4">
                        <button type="submit" 
                                class="flex-1 bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded font-semibold transition">
                            <i class="fas fa-save mr-2"></i>Save Record
                        </button>
                        <button type="button" onclick="closeAddRecordModal()" 
                                class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-3 rounded font-semibold transition">
                            <i class="fas fa-times mr-2"></i>Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function searchPatients() {
            const searchTerm = document.getElementById('searchPatient').value.toLowerCase();
            const cards = document.querySelectorAll('.patient-card');
            
            cards.forEach(card => {
                const patientName = card.getAttribute('data-patient-name');
                if (patientName.includes(searchTerm)) {
                    card.style.display = '';
                } else {
                    card.style.display = 'none';
                }
            });
        }

        function toggleRecords(patientId) {
            const recordsDiv = document.getElementById('records-' + patientId);
            if (recordsDiv.classList.contains('hidden')) {
                recordsDiv.classList.remove('hidden');
            } else {
                recordsDiv.classList.add('hidden');
            }
        }

        function addNewRecord(patientId, patientName) {
            document.getElementById('new_patientId').value = patientId;
            document.getElementById('new_patientName').value = patientName;
            document.getElementById('addRecordModal').classList.remove('hidden');
        }

        function closeAddRecordModal() {
            document.getElementById('addRecordModal').classList.add('hidden');
        }

        // Close modal on escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeAddRecordModal();
            }
        });
    </script>
</body>
</html>
