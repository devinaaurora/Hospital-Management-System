<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Appointment, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
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
    <title>My Appointments - Doctor Portal</title>
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
                    <a href="<%= request.getContextPath() %>/doctor/appointments" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
                        <i class="fas fa-calendar-check mr-3"></i>Appointments
                    </a>
                    <a href="<%= request.getContextPath() %>/doctor/patients" class="block text-gray-700 px-4 py-3 rounded hover:bg-gray-100 transition">
                        <i class="fas fa-users mr-3"></i>Patients
                    </a>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex-1 p-8">
            <div class="mb-8">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-calendar-check mr-3"></i>My Appointments
                </h1>
                <p class="text-gray-600 mt-2">Manage your patient appointments</p>
            </div>

            <!-- Success/Error Messages -->
            <% if (request.getParameter("success") != null) { 
                String successMsg = "approved".equals(request.getParameter("success")) ? "Appointment approved successfully!" :
                                  "rejected".equals(request.getParameter("success")) ? "Appointment rejected!" :
                                  "completed".equals(request.getParameter("success")) ? "Appointment marked as completed!" :
                                  "record_added".equals(request.getParameter("success")) ? "Medical record added successfully!" :
                                  "Action completed!";
            %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i><%= successMsg %>
            </div>
            <% } %>

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
                </div>
            </div>

            <!-- Appointments Grid -->
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
                                    <i class="fas fa-user text-blue-600 text-2xl"></i>
                                </div>
                                <div>
                                    <h3 class="text-xl font-bold text-gray-800"><%= apt.getPatientName() %></h3>
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
                            
                            <!-- Action Buttons -->
                            <div class="mt-4 space-y-2">
                                <% if ("pending".equals(apt.getStatus())) { %>
                                <button onclick="approveAppointment(<%= apt.getAppointmentId() %>)" 
                                        class="block w-full bg-green-600 hover:bg-green-700 text-white px-4 py-2 rounded text-sm transition">
                                    <i class="fas fa-check mr-2"></i>Approve
                                </button>
                                <button onclick="rejectAppointment(<%= apt.getAppointmentId() %>)" 
                                        class="block w-full bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded text-sm transition">
                                    <i class="fas fa-times mr-2"></i>Reject
                                </button>
                                <% } else if ("approved".equals(apt.getStatus())) { %>
                                <button onclick="showDiagnosisModal(<%= apt.getAppointmentId() %>, <%= apt.getPatientId() %>, '<%= apt.getPatientName() %>')" 
                                        class="block w-full bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded text-sm transition">
                                    <i class="fas fa-stethoscope mr-2"></i>Add Diagnosis
                                </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } } else { %>
                <div class="bg-white rounded-lg shadow-lg p-12 text-center">
                    <i class="fas fa-calendar-times text-gray-400 text-6xl mb-4"></i>
                    <h3 class="text-xl font-bold text-gray-800 mb-2">No Appointments</h3>
                    <p class="text-gray-600">You have no appointments scheduled at this time.</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Diagnosis Modal -->
    <div id="diagnosisModal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full mx-4 max-h-screen overflow-y-auto">
            <div class="p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-800">
                        <i class="fas fa-stethoscope mr-2 text-blue-600"></i>Add Diagnosis & Treatment
                    </h2>
                    <button onclick="closeDiagnosisModal()" class="text-gray-600 hover:text-gray-800">
                        <i class="fas fa-times text-2xl"></i>
                    </button>
                </div>

                <form action="<%= request.getContextPath() %>/doctor/appointments" method="post" id="diagnosisForm">
                    <input type="hidden" name="action" value="addRecord">
                    <input type="hidden" name="appointmentId" id="modal_appointmentId">
                    <input type="hidden" name="patientId" id="modal_patientId">

                    <div class="mb-4">
                        <label class="block text-gray-700 font-semibold mb-2">Patient</label>
                        <input type="text" id="modal_patientName" readonly 
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
                        <button type="button" onclick="closeDiagnosisModal()" 
                                class="flex-1 bg-gray-300 hover:bg-gray-400 text-gray-800 px-6 py-3 rounded font-semibold transition">
                            <i class="fas fa-times mr-2"></i>Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function filterAppointments(status) {
            const cards = document.querySelectorAll('.appointment-card');
            const tabs = document.querySelectorAll('[id^="tab-"]');
            
            tabs.forEach(tab => {
                tab.classList.remove('text-blue-600', 'border-b-2', 'border-blue-600');
                tab.classList.add('text-gray-600');
            });
            document.getElementById('tab-' + status).classList.remove('text-gray-600');
            document.getElementById('tab-' + status).classList.add('text-blue-600', 'border-b-2', 'border-blue-600');
            
            cards.forEach(card => {
                const cardStatus = card.getAttribute('data-status');
                if (status === 'all') {
                    card.style.display = '';
                } else {
                    card.style.display = cardStatus === status ? '' : 'none';
                }
            });
        }

        function approveAppointment(appointmentId) {
            if (confirm('Approve this appointment?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/doctor/appointments';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'approve';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'appointmentId';
                idInput.value = appointmentId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function rejectAppointment(appointmentId) {
            const reason = prompt('Reason for rejection (optional):');
            if (reason !== null) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/doctor/appointments';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'reject';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'appointmentId';
                idInput.value = appointmentId;
                
                const notesInput = document.createElement('input');
                notesInput.type = 'hidden';
                notesInput.name = 'notes';
                notesInput.value = reason;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                form.appendChild(notesInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function showDiagnosisModal(appointmentId, patientId, patientName) {
            document.getElementById('modal_appointmentId').value = appointmentId;
            document.getElementById('modal_patientId').value = patientId;
            document.getElementById('modal_patientName').value = patientName;
            document.getElementById('diagnosisModal').classList.remove('hidden');
        }

        function closeDiagnosisModal() {
            document.getElementById('diagnosisModal').classList.add('hidden');
            document.getElementById('diagnosisForm').reset();
        }

        // Close modal on escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeDiagnosisModal();
            }
        });
    </script>
</body>
</html>
