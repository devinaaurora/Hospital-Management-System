<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hospital.model.User, com.hospital.model.Department, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"admin".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Departments - HMS Admin</title>
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
                    <a href="<%= request.getContextPath() %>/admin/departments" class="block bg-blue-600 text-white px-4 py-3 rounded hover:bg-blue-700 transition">
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
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-building mr-3"></i>Manage Departments
                </h1>
                <button onclick="showAddModal()" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg transition duration-300">
                    <i class="fas fa-plus mr-2"></i>Add New Department
                </button>
            </div>

            <!-- Success/Error Messages -->
            <% if (request.getParameter("success") != null) { 
                String successMsg = "added".equals(request.getParameter("success")) ? "Department added successfully!" :
                                  "updated".equals(request.getParameter("success")) ? "Department updated successfully!" :
                                  "deleted".equals(request.getParameter("success")) ? "Department deleted successfully!" : "Operation completed!";
            %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-check-circle mr-2"></i><%= successMsg %>
            </div>
            <% } %>
            
            <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                <i class="fas fa-exclamation-circle mr-2"></i>Operation failed. Please try again.
            </div>
            <% } %>

            <!-- Departments Grid -->
            <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
                <% if (departments != null && !departments.isEmpty()) { 
                    for (Department dept : departments) { %>
                <div class="bg-white rounded-lg shadow-lg p-6 hover:shadow-xl transition">
                    <div class="flex items-start justify-between mb-4">
                        <div class="bg-blue-100 rounded-full p-3">
                            <i class="fas fa-building text-blue-600 text-2xl"></i>
                        </div>
                        <div class="flex space-x-2">
                            <button onclick='editDepartment(<%= dept.getDepartmentId() %>, `<%= dept.getDepartmentName() %>`, `<%= dept.getDescription() != null ? dept.getDescription() : "" %>`)' 
                                    class="text-blue-600 hover:text-blue-900">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button onclick='deleteDepartment(<%= dept.getDepartmentId() %>, `<%= dept.getDepartmentName() %>`)' 
                                    class="text-red-600 hover:text-red-900">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <h3 class="text-xl font-bold text-gray-800 mb-2"><%= dept.getDepartmentName() %></h3>
                    <p class="text-gray-600 text-sm"><%= dept.getDescription() != null ? dept.getDescription() : "No description" %></p>
                    <div class="mt-4 pt-4 border-t">
                        <span class="text-xs text-gray-500">ID: #<%= dept.getDepartmentId() %></span>
                    </div>
                </div>
                <% } } else { %>
                <div class="col-span-3 text-center py-12 text-gray-500">
                    <i class="fas fa-building text-5xl mb-4"></i>
                    <p>No departments found. Add your first department!</p>
                </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Add Department Modal -->
    <div id="addModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-1/2 shadow-lg rounded-md bg-white">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-2xl font-bold text-gray-900">Add New Department</h3>
                <button onclick="closeAddModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/admin" method="post">
                <input type="hidden" name="action" value="addDepartment">
                <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-bold mb-2">Department Name *</label>
                    <input type="text" name="departmentName" required class="shadow border rounded w-full py-2 px-3 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-bold mb-2">Description</label>
                    <textarea name="description" rows="3" class="shadow border rounded w-full py-2 px-3 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                </div>
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeAddModal()" class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded transition">Cancel</button>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded transition">Add Department</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit Department Modal -->
    <div id="editModal" class="hidden fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50">
        <div class="relative top-20 mx-auto p-5 border w-11/12 md:w-1/2 shadow-lg rounded-md bg-white">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-2xl font-bold text-gray-900">Edit Department</h3>
                <button onclick="closeEditModal()" class="text-gray-400 hover:text-gray-600">
                    <i class="fas fa-times text-2xl"></i>
                </button>
            </div>
            <form action="<%= request.getContextPath() %>/admin" method="post">
                <input type="hidden" name="action" value="updateDepartment">
                <input type="hidden" name="departmentId" id="editDepartmentId">
                <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-bold mb-2">Department Name *</label>
                    <input type="text" name="departmentName" id="editDepartmentName" required class="shadow border rounded w-full py-2 px-3 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div class="mb-4">
                    <label class="block text-gray-700 text-sm font-bold mb-2">Description</label>
                    <textarea name="description" id="editDescription" rows="3" class="shadow border rounded w-full py-2 px-3 text-gray-700 focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
                </div>
                <div class="flex justify-end space-x-3">
                    <button type="button" onclick="closeEditModal()" class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded transition">Cancel</button>
                    <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded transition">Update Department</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('addModal').classList.remove('hidden');
        }
        
        function closeAddModal() {
            document.getElementById('addModal').classList.add('hidden');
        }
        
        function editDepartment(id, name, description) {
            document.getElementById('editDepartmentId').value = id;
            document.getElementById('editDepartmentName').value = name;
            document.getElementById('editDescription').value = description;
            document.getElementById('editModal').classList.remove('hidden');
        }
        
        function closeEditModal() {
            document.getElementById('editModal').classList.add('hidden');
        }
        
        function deleteDepartment(id, name) {
            if (confirm('Are you sure you want to delete ' + name + '? This may affect associated doctors.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '<%= request.getContextPath() %>/admin';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'deleteDepartment';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'departmentId';
                idInput.value = id;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>
