# 🏥 Hospital Management System - Quality Check Control Procedure

## 📋 Document Information
- **Project**: Hospital Management System (HMS)
- **Version**: 1.0.0
- **Last Updated**: November 14, 2025
- **Technology Stack**: JSP, Servlets (Jakarta EE 5.0), PostgreSQL, TailwindCSS, Apache Tomcat 10

---

## 🎯 0. High-Level Acceptance Rules

Before proceeding with detailed testing, verify these core requirements are met:

### 0.1 CRUD Operations
- [ ] All CRUD operations from requirements are implemented
- [ ] All operations reachable via UI + servlet endpoints
- [ ] All features listed in requirements.md are functional

### 0.2 List Views & Sorting ⚠️ **NOT IMPLEMENTED**
- [ ] All lists default to sorted by primary ID ascending
- [ ] Visible "Sort by" control on every list page
- [ ] Sort options: ID, name, date, status (entity-specific)
- [ ] Server-side whitelist validation for sort_by parameter
- [ ] SQL injection prevention in dynamic ORDER BY clauses

**Status**: ❌ **Missing** - Lists currently show data without sorting controls

### 0.3 Pagination ⚠️ **NOT IMPLEMENTED**
- [ ] Pagination present on every list (doctors, appointments, departments)
- [ ] Page size options: 10/25/50 items per page
- [ ] Page navigation (Previous, Next, Page Numbers)
- [ ] SQL LIMIT/OFFSET implemented server-side
- [ ] Total count displayed (e.g., "Showing 1-10 of 45")

**Status**: ❌ **Missing** - No pagination implemented on any list views

### 0.4 Role-Based Access Control (RBAC)
- [x] Pages enforce role permissions (patient, doctor, admin)
- [x] APIs validate user role before processing
- [x] Unauthorized access redirects to login
- [ ] CSRF token validation on forms ⚠️ **NOT IMPLEMENTED**

**Status**: ✅ Partial - Basic RBAC implemented, CSRF missing

### 0.5 Password Security
- [ ] Passwords hashed with bcrypt or Argon2 ⚠️ **CURRENTLY SHA-256**
- [x] Passwords not stored in plaintext
- [ ] Password complexity requirements enforced ⚠️ **NOT ENFORCED**
- [ ] Session timeout configurable (default: 20 minutes)
- [x] Server sessions used for authentication

**Status**: ⚠️ **Needs Improvement** - Using SHA-256 instead of bcrypt/Argon2

### 0.6 Input Validation & Security
- [x] Prepared statements used (SQL injection prevention)
- [ ] Client-side validation on all forms ⚠️ **PARTIAL**
- [x] Server-side validation on all inputs
- [ ] XSS prevention (HTML escaping) ⚠️ **NEEDS VERIFICATION**
- [ ] CSRF protection implemented ⚠️ **NOT IMPLEMENTED**

**Status**: ⚠️ **Partial** - Prepared statements used, but missing client validation & CSRF

### 0.7 Accessibility (WCAG AA)
- [ ] All form inputs properly labeled
- [ ] Alt text on images/icons
- [ ] Keyboard navigation functional
- [ ] Color contrast meets WCAG AA standards
- [ ] Screen reader compatible

**Status**: ⚠️ **Needs Testing** - TailwindCSS used but accessibility not verified

### 0.8 Responsive Design
- [x] TailwindCSS framework used
- [ ] Desktop layout tested (1920x1080, 1366x768)
- [ ] Mobile layout tested (375x667, 768x1024)
- [ ] Responsive sidebar/navigation
- [ ] Touch-friendly buttons on mobile

**Status**: ⚠️ **Partial** - TailwindCSS used but not fully tested

---

## 🚨 Critical Missing Features

### Priority 1: Must Implement Before Production
1. **Sorting Controls** - All list views need sort functionality
2. **Pagination** - Lists can become unusable with many records
3. **CSRF Protection** - Critical security vulnerability
4. **Password Hashing Upgrade** - bcrypt/Argon2 instead of SHA-256
5. **Client-side Validation** - Improve UX with immediate feedback

### Priority 2: Should Implement Soon
6. **Session Timeout** - Configurable inactivity timeout
7. **Password Complexity** - Enforce strong passwords
8. **XSS Prevention Audit** - Verify all output is escaped
9. **Accessibility Testing** - WCAG AA compliance
10. **Audit Logging** - Track sensitive operations

### Priority 3: Nice to Have
11. **Soft Delete** - Prevent accidental data loss
12. **CSV Export** - Admin export functionality
13. **Rate Limiting** - Prevent brute force attacks
14. **Email Notifications** - Appointment status updates
15. **Real-time Availability** - AJAX doctor availability check

---

## ✅ 1. Pre-Deployment Checklist

### 1.1 Environment Setup
- [ ] PostgreSQL server installed and running
- [ ] Apache Tomcat 10+ installed (Jakarta EE compatible)
- [ ] Java JDK 11+ configured
- [ ] Maven build tool installed
- [ ] Database connection configured in `database.properties`

### 1.2 Database Verification
```bash
# Run database setup script
setup_database.bat

# Verify tables created
psql -U postgres -d hospital_db -c "\dt"
```

**Expected Output**: 5 tables created
- ✅ users
- ✅ doctors
- ✅ departments
- ✅ appointments
- ✅ medical_records

**Verify Sample Data**:
```sql
SELECT COUNT(*) FROM users;        -- Should return 5
SELECT COUNT(*) FROM doctors;      -- Should return 3
SELECT COUNT(*) FROM departments;  -- Should return 5
SELECT COUNT(*) FROM appointments; -- Should return 4
```

### 1.3 Build Verification
```bash
# Clean build
mvn clean package

# Expected: BUILD SUCCESS
# Expected: WAR file created in target/hospital-management.war
```

**Check for**:
- [ ] No compilation errors
- [ ] All 16 Java files compiled successfully
- [ ] WAR file size > 0 KB

---

## 🧪 2. Functional Testing

### 2.1 Authentication & Authorization

#### Test Case 1: Admin Login
**URL**: `http://localhost:8080/hospital-management/login.jsp`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Enter username: `admin` | Field accepts input | ⬜ |
| 2 | Enter password: `admin123` | Password masked | ⬜ |
| 3 | Click "Login" button | Redirect to `/admin/dashboard` | ⬜ |
| 4 | Check session | User object in session with role='admin' | ⬜ |

#### Test Case 2: Doctor Login
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Enter username: `dr.smith` | Field accepts input | ⬜ |
| 2 | Enter password: `doctor123` | Password masked | ⬜ |
| 3 | Click "Login" button | Redirect to `/doctor/dashboard` | ⬜ |
| 4 | Verify role | User role='doctor' | ⬜ |

#### Test Case 3: Patient Login
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Enter username: `patient1` | Field accepts input | ⬜ |
| 2 | Enter password: `patient123` | Password masked | ⬜ |
| 3 | Click "Login" button | Redirect to `/patient/dashboard` | ⬜ |
| 4 | Verify role | User role='patient' | ⬜ |

#### Test Case 4: Invalid Credentials
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Enter wrong username/password | Error message displayed | ⬜ |
| 2 | Check redirect | Stays on login page | ⬜ |
| 3 | Session check | No user session created | ⬜ |

#### Test Case 5: Unauthorized Access
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Access `/admin/dashboard` without login | Redirect to login.jsp | ⬜ |
| 2 | Login as patient | Successfully logged in | ⬜ |
| 3 | Try accessing `/admin/doctors` | Redirect to login.jsp | ⬜ |
| 4 | Logout | Session destroyed | ⬜ |

---

### 2.2 Admin Features Testing

#### Test Case 6: Add New Doctor
**URL**: `/admin/doctors`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click "Add New Doctor" button | Modal opens | ⬜ |
| 2 | Fill username: `dr.newdoc` | Field accepts input | ⬜ |
| 3 | Fill password: `password123` | Password masked | ⬜ |
| 4 | Fill name: `Dr. New Doctor` | Field accepts input | ⬜ |
| 5 | Fill email: `newdoc@hospital.com` | Valid email format | ⬜ |
| 6 | Fill phone: `1234567890` | Phone number accepted | ⬜ |
| 7 | Select department: `Cardiology` | Dropdown works | ⬜ |
| 8 | Fill specialization: `Heart Surgery` | Field accepts input | ⬜ |
| 9 | Fill availability: `Mon-Fri 9AM-5PM` | Text accepted | ⬜ |
| 10 | Fill consultation fee: `150.00` | Decimal accepted | ⬜ |
| 11 | Submit form | Success message: "Doctor added successfully!" | ⬜ |
| 12 | Verify in database | New doctor record exists | ⬜ |
| 13 | Verify user account | User account created with role='doctor' | ⬜ |

#### Test Case 7: Duplicate Username Validation
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click "Add New Doctor" | Modal opens | ⬜ |
| 2 | Use existing username: `dr.smith` | Fill form completely | ⬜ |
| 3 | Submit form | Error: "Username already exists. Please choose a different username." | ⬜ |
| 4 | Check database | No duplicate user created | ⬜ |

#### Test Case 8: Edit Doctor Information
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Find existing doctor | Doctor card displayed | ⬜ |
| 2 | Click edit icon | Modal opens with pre-filled data | ⬜ |
| 3 | Change specialization | New value entered | ⬜ |
| 4 | Change consultation fee | New fee entered | ⬜ |
| 5 | Update availability | Schedule modified | ⬜ |
| 6 | Submit | Success: "Doctor updated successfully!" | ⬜ |
| 7 | Verify changes | Updated data displayed | ⬜ |

#### Test Case 9: Delete Doctor
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click delete icon on doctor | Confirmation dialog appears | ⬜ |
| 2 | Confirm deletion | Success: "Doctor deleted successfully!" | ⬜ |
| 3 | Verify removal | Doctor no longer in list | ⬜ |
| 4 | Check database | Record deleted | ⬜ |

#### Test Case 10: Add Department
**URL**: `/admin/departments`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click "Add New Department" | Modal opens | ⬜ |
| 2 | Enter name: `Neurology` | Field accepts input | ⬜ |
| 3 | Enter description: `Brain and nervous system` | Textarea accepts input | ⬜ |
| 4 | Submit | Success: "Department added successfully!" | ⬜ |
| 5 | Verify display | Department card appears | ⬜ |

#### Test Case 11: Edit Department
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click edit on department | Modal opens with data | ⬜ |
| 2 | Modify description | New text entered | ⬜ |
| 3 | Submit | Success: "Department updated successfully!" | ⬜ |
| 4 | Verify update | Changes displayed | ⬜ |

#### Test Case 12: Delete Department
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click delete on department | Confirmation dialog | ⬜ |
| 2 | Confirm | Success: "Department deleted successfully!" | ⬜ |
| 3 | Verify removal | Department removed | ⬜ |

#### Test Case 13: View All Appointments
**URL**: `/admin/appointments`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Access appointments page | Table displays all appointments | ⬜ |
| 2 | Check filters | Tabs: All, Pending, Approved, Completed, Cancelled | ⬜ |
| 3 | Click "Pending" filter | Shows only pending appointments | ⬜ |
| 4 | Click "Approved" filter | Shows only approved appointments | ⬜ |
| 5 | Click "Completed" filter | Shows only completed appointments | ⬜ |
| 6 | Click "Cancelled" filter | Shows cancelled/rejected appointments | ⬜ |
| 7 | Verify data | Patient names, doctor names, dates visible | ⬜ |

---

### 2.3 Patient Features Testing

#### Test Case 14: View Dashboard (Patient)
**URL**: `/patient/dashboard`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Login as patient | Dashboard loads | ⬜ |
| 2 | Check welcome message | Patient name displayed | ⬜ |
| 3 | View statistics | Upcoming/completed appointments count | ⬜ |
| 4 | Check navigation | Sidebar has all patient menu items | ⬜ |

#### Test Case 15: View Doctor List
**URL**: `/patient/doctors`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click "Doctors" menu | Doctor list page loads | ⬜ |
| 2 | Verify doctors displayed | All doctors shown in cards | ⬜ |
| 3 | Check doctor info | Name, specialization, department visible | ⬜ |
| 4 | Check availability | Schedule displayed | ⬜ |
| 5 | Check consultation fee | Fee amount shown | ⬜ |
| 6 | Find "Book Appointment" button | Button visible on each card | ⬜ |
| 7 | **Check default sort** | ⚠️ Sorted by doctor_id ASC | ⬜ |
| 8 | **Check sort control** | ⚠️ Dropdown/header sorting visible | ⬜ |
| 9 | **Sort by name** | ⚠️ List re-orders alphabetically | ⬜ |
| 10 | **Sort by department** | ⚠️ List re-orders by department | ⬜ |
| 11 | **Check pagination** | ⚠️ Shows 10/25/50 options | ⬜ |
| 12 | **Navigate pages** | ⚠️ Next/Previous buttons work | ⬜ |
| 13 | **Filter by department** | ⚠️ Department filter dropdown | ⬜ |
| 14 | **Search by name** | ⚠️ Search box filters results | ⬜ |

**⚠️ Note**: Steps 7-14 are NOT currently implemented

#### Test Case 16: Book Appointment
**URL**: `/patient/book-appointment`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Click "Book Appointment" | Appointment form loads | ⬜ |
| 2 | Select doctor from dropdown | Doctors list populated | ⬜ |
| 3 | Choose date | Date picker works | ⬜ |
| 4 | Select time | Time picker works | ⬜ |
| 5 | Enter reason: `Regular checkup` | Textarea accepts input | ⬜ |
| 6 | Submit form | Success message displayed | ⬜ |
| 7 | Check status | Appointment status='pending' | ⬜ |
| 8 | Verify in database | Record created with patient_id | ⬜ |

#### Test Case 17: View Appointment Status
**URL**: `/patient/appointments`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Access appointments list | Patient's appointments shown | ⬜ |
| 2 | Verify data | Date, time, doctor, status visible | ⬜ |
| 3 | Check status colors | Pending=yellow, Approved=green, etc. | ⬜ |
| 4 | Check filters | Can filter by status | ⬜ |
| 5 | **Check default sort** | ⚠️ Sorted by appointment_id ASC | ⬜ |
| 6 | **Sort options** | ⚠️ date, time, status, doctor_name | ⬜ |
| 7 | **Pagination controls** | ⚠️ 10/25/50 per page | ⬜ |
| 8 | **Date range filter** | ⚠️ Filter by date range | ⬜ |
| 9 | **Doctor filter** | ⚠️ Filter by doctor dropdown | ⬜ |

**⚠️ Note**: Steps 5-9 are NOT currently implemented

#### Test Case 18: Cancel Appointment
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Find pending appointment | Appointment listed | ⬜ |
| 2 | Click "Cancel" button | Confirmation dialog | ⬜ |
| 3 | Confirm cancellation | Success message | ⬜ |
| 4 | Verify status | Status changed to 'cancelled' | ⬜ |

#### Test Case 19: View Medical Records
**URL**: `/patient/medical-records`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Access medical records | List of records shown | ⬜ |
| 2 | Verify data | Date, doctor, diagnosis, treatment visible | ⬜ |
| 3 | Check chronological order | Latest records first | ⬜ |

---

### 2.4 Doctor Features Testing

#### Test Case 20: View Dashboard (Doctor)
**URL**: `/doctor/dashboard`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Login as doctor | Dashboard loads | ⬜ |
| 2 | Check welcome | Doctor name displayed | ⬜ |
| 3 | View statistics | Today's/upcoming appointments count | ⬜ |
| 4 | Check navigation | Sidebar menu functional | ⬜ |

#### Test Case 21: View Assigned Appointments
**URL**: `/doctor/appointments`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Access appointments | List of doctor's appointments | ⬜ |
| 2 | Verify filtering | Can filter by date/status | ⬜ |
| 3 | Check patient info | Patient name, reason visible | ⬜ |
| 4 | Verify actions | Approve/Reject buttons for pending | ⬜ |
| 5 | **Check default sort** | ⚠️ Upcoming appointments by date/time | ⬜ |
| 6 | **Sort options** | ⚠️ date, time, status, patient_name | ⬜ |
| 7 | **Date range filter** | ⚠️ Filter by date range | ⬜ |
| 8 | **Pagination** | ⚠️ 10/25/50 per page | ⬜ |

**⚠️ Note**: Steps 5-8 are NOT currently implemented

#### Test Case 22: Approve Appointment
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Find pending appointment | Appointment listed | ⬜ |
| 2 | Click "Approve" button | Confirmation dialog | ⬜ |
| 3 | Confirm | Success message | ⬜ |
| 4 | Verify status | Status='approved' | ⬜ |
| 5 | Check patient view | Patient sees approved status | ⬜ |

#### Test Case 23: Reject Appointment
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Find pending appointment | Appointment listed | ⬜ |
| 2 | Click "Reject" button | Confirmation dialog | ⬜ |
| 3 | Confirm | Status changed to 'rejected' | ⬜ |

#### Test Case 24: Mark Appointment Complete
| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Find approved appointment | Appointment listed | ⬜ |
| 2 | Click "Complete" button | Confirmation or form appears | ⬜ |
| 3 | Confirm | Status='completed' | ⬜ |

#### Test Case 25: Add/Update Medical Record
**URL**: `/doctor/medical-record`

| Step | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 1 | Select completed appointment | Patient info displayed | ⬜ |
| 2 | Enter diagnosis | Textarea accepts input | ⬜ |
| 3 | Enter treatment | Textarea accepts input | ⬜ |
| 4 | Submit | Success message | ⬜ |
| 5 | Verify record | Medical record created | ⬜ |
| 6 | Check patient access | Patient can view record | ⬜ |

---

## 🔒 3. Security Testing

### 3.1 Session Management
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Session creation | Login successfully | Session ID created | ⬜ |
| Session persistence | Navigate pages | Session maintained | ⬜ |
| Session timeout | Idle for 30 minutes | Auto logout | ⬜ |
| Session destruction | Click logout | Session cleared | ⬜ |
| Multiple sessions | Login twice different browsers | Independent sessions | ⬜ |

### 3.2 Password Security
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Password hashing | Check database | ⚠️ **SHOULD USE bcrypt/Argon2** (currently SHA-256) | ⬜ |
| Password masking | Enter password in UI | Characters masked (•••) | ⬜ |
| Password validation | Empty password | Error message | ⬜ |
| **Password complexity** | ⚠️ Weak password (e.g., "123") | ⚠️ Should reject (NOT IMPLEMENTED) | ⬜ |
| **Password requirements** | ⚠️ Check minimum 8 chars, uppercase, lowercase, digit, special | ⚠️ NOT ENFORCED | ⬜ |

**⚠️ Security Risk**: Current SHA-256 hashing is less secure than bcrypt/Argon2 for password storage

### 3.3 Role-Based Access Control (RBAC)
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Patient → Admin | Access `/admin/*` | Redirect to login | ⬜ |
| Patient → Doctor | Access `/doctor/*` | Redirect to login | ⬜ |
| Doctor → Admin | Access `/admin/*` | Redirect to login | ⬜ |
| Doctor → Patient | Access `/patient/*` (other user) | Denied | ⬜ |
| Admin → All | Access all pages | Granted | ⬜ |

### 3.4 SQL Injection Prevention
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Login field | Enter `' OR '1'='1` | Login fails safely | ⬜ |
| Search field | Enter `'; DROP TABLE users; --` | Query sanitized | ⬜ |
| Form inputs | Special characters | Escaped properly | ⬜ |
| **Sort parameter** | ⚠️ `/appointments?sort_by=appointment_id;DROP TABLE users` | ⚠️ Whitelist validation (NOT YET TESTABLE) | ⬜ |
| **Dynamic ORDER BY** | ⚠️ Test SQL injection in sort fields | ⚠️ Prepared statements only (NOT YET IMPLEMENTED) | ⬜ |

**✅ Good**: Current implementation uses PreparedStatement for all queries  
**⚠️ Future Risk**: When adding sort functionality, must whitelist sort_by values

### 3.5 XSS Prevention
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Script injection | Enter `<script>alert('XSS')</script>` in doctor name | Escaped/sanitized | ⬜ |
| HTML injection | Enter `<img src=x onerror=alert(1)>` in reason | Rendered as text | ⬜ |
| **JSP output escaping** | Check all `<%= user.getName() %>` uses escaping | ⚠️ NEEDS AUDIT | ⬜ |
| **JSTL c:out** | Verify using `<c:out value="${user.name}"/>` | ⚠️ Currently using <%= %> | ⬜ |

**⚠️ Recommendation**: Replace `<%= %>` with JSTL `<c:out>` for automatic XSS protection

### 3.6 CSRF Protection ⚠️ **NOT IMPLEMENTED**
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| **CSRF token generation** | ⚠️ View page source of forms | ⚠️ Hidden token field present | ⬜ |
| **Token validation** | ⚠️ Submit form without token | ⚠️ Request rejected | ⬜ |
| **Token in session** | ⚠️ Check session attributes | ⚠️ CSRF token stored | ⬜ |
| **Form submission** | ⚠️ Valid token accepted | ⚠️ Request processed | ⬜ |

**❌ Critical**: CSRF protection is NOT implemented - forms are vulnerable to cross-site request forgery

---

## 🎨 4. UI/UX Testing

### 4.1 Responsive Design
| Device | Resolution | Test | Status |
|--------|-----------|------|--------|
| Desktop | 1920x1080 | All pages render correctly | ⬜ |
| Laptop | 1366x768 | Sidebar/content responsive | ⬜ |
| Tablet | 768x1024 | Mobile menu works | ⬜ |
| Mobile | 375x667 | Cards stack vertically | ⬜ |

### 4.2 Visual Consistency
- [ ] Color scheme: Medical blue (#3B82F6) consistent
- [ ] Font: Sans-serif readable throughout
- [ ] Icons: Font Awesome icons visible
- [ ] Buttons: Consistent styling (hover, active states)
- [ ] Forms: Aligned labels, proper spacing
- [ ] Tables: Alternating row colors, proper borders

### 4.3 Navigation
- [ ] All menu links functional
- [ ] Breadcrumbs show current location
- [ ] Back buttons work correctly
- [ ] Logout accessible from all pages
- [ ] Home/dashboard link always available

### 4.4 Forms & Validation
- [ ] Required fields marked with *
- [ ] Client-side validation works
- [ ] Error messages clear and helpful
- [ ] Success messages visible
- [ ] Form resets after submission
- [ ] Cancel buttons close modals

---

## ⚡ 5. Performance Testing

### 5.1 Page Load Times
| Page | Target Time | Actual Time | Status |
|------|------------|-------------|--------|
| Login | < 1s | | ⬜ |
| Dashboard | < 2s | | ⬜ |
| Doctor List | < 2s | | ⬜ |
| Appointments | < 3s | | ⬜ |

### 5.2 Database Query Performance
```sql
-- Check slow queries
EXPLAIN ANALYZE SELECT * FROM appointments WHERE patient_id = 1;
EXPLAIN ANALYZE SELECT * FROM doctors WHERE department_id = 1;
```

- [ ] All queries execute in < 100ms
- [ ] Indexes used properly
- [ ] No N+1 query problems

### 5.3 Concurrent Users
| Test | Users | Expected | Status |
|------|-------|----------|--------|
| Single user | 1 | All features work | ⬜ |
| Light load | 5 | No slowdown | ⬜ |
| Medium load | 10 | < 10% slowdown | ⬜ |
| Heavy load | 20 | < 25% slowdown | ⬜ |

---

## 🐛 6. Error Handling Testing

### 6.1 Database Errors
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| Connection lost | Stop PostgreSQL | Graceful error page | ⬜ |
| Duplicate key | Add duplicate | User-friendly error | ⬜ |
| Foreign key violation | Delete referenced record | Error message | ⬜ |
| Invalid data type | Submit text in number field | Validation error | ⬜ |

### 6.2 Server Errors
| Test | Action | Expected Result | Status |
|------|--------|----------------|--------|
| 404 Not Found | Access invalid URL | Custom 404 page | ⬜ |
| 500 Internal Error | Trigger exception | Error page with message | ⬜ |
| Session timeout | Idle timeout | Redirect to login | ⬜ |

### 6.3 Input Validation
| Test | Input | Expected Result | Status |
|------|-------|----------------|--------|
| Empty required field | Submit blank | Error: "This field is required" | ⬜ |
| Invalid email | `notanemail` | Error: "Invalid email format" | ⬜ |
| Invalid date | `2025-13-40` | Error: "Invalid date" | ⬜ |
| Negative fee | `-50.00` | Error: "Must be positive" | ⬜ |

---

## 📦 7. Deployment Testing

### 7.1 Local Deployment
- [ ] Database setup script runs successfully
- [ ] Maven build completes without errors
- [ ] Tomcat starts on port 8080
- [ ] Application accessible at `http://localhost:8080/hospital-management`
- [ ] All static resources load (CSS, JS, images)

### 7.2 Configuration Files
- [ ] `database.properties` contains correct credentials
- [ ] `context.xml` database pool configured
- [ ] `web.xml` servlet mappings correct
- [ ] `pom.xml` dependencies resolved

### 7.3 Production Readiness
- [ ] Remove debug/console logs
- [ ] Set secure session cookies
- [ ] Configure HTTPS (if applicable)
- [ ] Set proper database connection limits
- [ ] Enable error logging to file

---

## 📊 8. Test Results Summary

### Completion Metrics
- **Total Test Cases**: ___ / ___
- **Passed**: ___ ✅
- **Failed**: ___ ❌
- **Pending**: ___ ⏳
- **Pass Rate**: ____%

### Critical Issues Found
1. **No CSRF Protection** - **Severity**: HIGH - **Status**: ❌ Open - Forms vulnerable to CSRF attacks
2. **SHA-256 Password Hashing** - **Severity**: MEDIUM - **Status**: ⚠️ Open - Should use bcrypt/Argon2
3. **No Pagination** - **Severity**: MEDIUM - **Status**: ❌ Open - Lists unusable with many records
4. **No Sorting Controls** - **Severity**: MEDIUM - **Status**: ❌ Open - Poor UX for data browsing
5. **No Password Complexity** - **Severity**: MEDIUM - **Status**: ⚠️ Open - Weak passwords allowed
6. **XSS Risk in JSP** - **Severity**: MEDIUM - **Status**: ⚠️ Open - Using <%= %> instead of <c:out>
7. **No Client Validation** - **Severity**: LOW - **Status**: ⚠️ Open - Poor UX, unnecessary server load
8. **No Session Timeout** - **Severity**: LOW - **Status**: ⚠️ Open - Sessions never expire
9. **No Audit Logging** - **Severity**: LOW - **Status**: ❌ Open - No tracking of sensitive operations
10. **No Rate Limiting** - **Severity**: LOW - **Status**: ❌ Open - Brute force attacks possible

### Performance Metrics
- **Average Page Load**: ___ ms
- **Database Query Time**: ___ ms
- **Concurrent Users Supported**: ___
- **Memory Usage**: ___ MB

---

## 📋 9. Implementation Checklist (Based on Acceptance Criteria)

### 9.1 Sorting & Filtering ❌ **NOT IMPLEMENTED**
- [ ] Server-side whitelist for sort_by parameters
- [ ] Dynamic ORDER BY with SQL injection prevention
- [ ] Clickable column headers for sorting
- [ ] Sort direction toggle (ASC/DESC)
- [ ] Visual indicator of current sort
- [ ] Department filter dropdown
- [ ] Date range filter (appointments)
- [ ] Search by name functionality
- [ ] Status filter tabs

**Implementation Guide**:
```java
// Servlet example - WhitelistSortValidator.java
Set<String> allowedSort = Set.of("appointment_id", "appointment_date", "status", "doctor_name");
String sortBy = request.getParameter("sort_by");
if (!allowedSort.contains(sortBy)) sortBy = "appointment_id";
String sortDir = "desc".equalsIgnoreCase(request.getParameter("sort_dir")) ? "DESC" : "ASC";
String sql = "SELECT * FROM appointments ORDER BY " + sortBy + " " + sortDir;
```

### 9.2 Pagination ❌ **NOT IMPLEMENTED**
- [ ] Page size selector (10/25/50)
- [ ] Page navigation (First, Previous, Next, Last)
- [ ] Page number display (1, 2, 3...)
- [ ] Total count display ("Showing 1-10 of 45")
- [ ] SQL LIMIT/OFFSET implementation
- [ ] Preserve sort/filter on pagination

**Implementation Guide**:
```java
// Servlet pagination logic
int page = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
int pageSize = Integer.parseInt(request.getParameter("page_size") != null ? request.getParameter("page_size") : "10");
int offset = (page - 1) * pageSize;

String sql = "SELECT * FROM appointments LIMIT ? OFFSET ?";
pstmt.setInt(1, pageSize);
pstmt.setInt(2, offset);

// Get total count for pagination
String countSql = "SELECT COUNT(*) FROM appointments";
```

### 9.3 CSRF Protection ❌ **NOT IMPLEMENTED**
- [ ] CSRF token generation utility
- [ ] Token stored in session
- [ ] Hidden input field in all forms
- [ ] Server-side token validation
- [ ] Token refresh on form submission

**Implementation Guide**:
```java
// CSRFUtil.java
public static String generateToken() {
    return UUID.randomUUID().toString();
}

// In servlet doGet()
String csrfToken = CSRFUtil.generateToken();
session.setAttribute("csrfToken", csrfToken);
request.setAttribute("csrfToken", csrfToken);

// In JSP form
<input type="hidden" name="csrfToken" value="<%= request.getAttribute("csrfToken") %>">

// In servlet doPost()
String sessionToken = (String) session.getAttribute("csrfToken");
String formToken = request.getParameter("csrfToken");
if (!sessionToken.equals(formToken)) {
    response.sendError(403, "Invalid CSRF token");
    return;
}
```

### 9.4 Password Security Upgrade ⚠️ **NEEDS IMPROVEMENT**
- [ ] Replace SHA-256 with bcrypt (recommended work factor: 12)
- [ ] Password complexity validation (8+ chars, mixed case, digit, special)
- [ ] Client-side password strength indicator
- [ ] Server-side complexity enforcement

**Implementation Guide**:
```java
// Add to pom.xml
<dependency>
    <groupId>org.mindrot</groupId>
    <artifactId>jbcrypt</artifactId>
    <version>0.4</version>
</dependency>

// Replace PasswordUtil.java methods
import org.mindrot.jbcrypt.BCrypt;

public static String hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt(12));
}

public static boolean verifyPassword(String password, String hash) {
    return BCrypt.checkpw(password, hash);
}

public static boolean isValidComplexity(String password) {
    return password.length() >= 8 &&
           password.matches(".*[a-z].*") &&
           password.matches(".*[A-Z].*") &&
           password.matches(".*\\d.*") &&
           password.matches(".*[!@#$%^&*].*");
}
```

### 9.5 XSS Prevention ⚠️ **NEEDS AUDIT**
- [ ] Replace <%= %> with JSTL <c:out>
- [ ] HTML escape all user-generated content
- [ ] Validate and sanitize rich text inputs
- [ ] Use Content Security Policy headers

**Implementation Guide**:
```jsp
<%-- Replace this: --%>
<h1>Welcome <%= user.getFullName() %></h1>

<%-- With this: --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<h1>Welcome <c:out value="${user.fullName}"/></h1>
```

### 9.6 Session Management ⚠️ **NEEDS CONFIGURATION**
- [ ] Configure session timeout (20 minutes default)
- [ ] HttpOnly cookie flag
- [ ] Secure cookie flag (HTTPS only)
- [ ] Session regeneration after login
- [ ] Explicit session invalidation on logout

**Implementation Guide**:
```xml
<!-- web.xml -->
<session-config>
    <session-timeout>20</session-timeout>
    <cookie-config>
        <http-only>true</http-only>
        <secure>true</secure>
    </cookie-config>
</session-config>
```

```java
// After successful login
session.invalidate(); // Destroy old session
session = request.getSession(true); // Create new session
session.setAttribute("user", user);
```

### 9.7 Client-Side Validation ⚠️ **PARTIAL**
- [ ] Required field indicators (*)
- [ ] HTML5 input types (email, date, time, number)
- [ ] Pattern validation (phone, username)
- [ ] Real-time validation feedback
- [ ] Disable submit until valid

**Implementation Guide**:
```html
<input type="email" name="email" required 
       pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"
       title="Enter a valid email address">

<input type="password" name="password" required 
       minlength="8" 
       pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}"
       title="Min 8 chars with uppercase, lowercase, digit, and special char">

<script>
document.querySelector('form').addEventListener('submit', function(e) {
    if (!this.checkValidity()) {
        e.preventDefault();
        alert('Please fill all required fields correctly');
    }
});
</script>
```

### 9.8 Audit Logging ❌ **NOT IMPLEMENTED**
- [ ] Create audit_logs table
- [ ] Log user logins/logouts
- [ ] Log appointment status changes
- [ ] Log doctor/department CRUD operations
- [ ] Log medical record access
- [ ] Admin view for audit logs

**Database Schema**:
```sql
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    details TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_created ON audit_logs(created_at);
```

### 9.9 Export Functionality ❌ **NOT IMPLEMENTED**
- [ ] CSV export for appointments (admin)
- [ ] Export respects current filters/sort
- [ ] CSV headers included
- [ ] Proper content-type headers
- [ ] Filename with timestamp

**Implementation Guide**:
```java
// CsvExportUtil.java
public static void exportAppointments(List<Appointment> appointments, HttpServletResponse response) {
    response.setContentType("text/csv");
    response.setHeader("Content-Disposition", 
        "attachment; filename=appointments_" + 
        new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".csv");
    
    PrintWriter writer = response.getWriter();
    writer.println("ID,Patient,Doctor,Date,Time,Status,Reason");
    
    for (Appointment apt : appointments) {
        writer.println(String.format("%d,%s,%s,%s,%s,%s,\"%s\"",
            apt.getAppointmentId(),
            apt.getPatientName(),
            apt.getDoctorName(),
            apt.getAppointmentDate(),
            apt.getAppointmentTime(),
            apt.getStatus(),
            apt.getReason().replace("\"", "\"\"")));
    }
}
```

### 9.10 Accessibility (WCAG AA) ⚠️ **NEEDS TESTING**
- [ ] All images have alt text
- [ ] Form labels properly associated
- [ ] Keyboard navigation works
- [ ] Focus indicators visible
- [ ] Color contrast >= 4.5:1 (text)
- [ ] Color contrast >= 3:1 (UI components)
- [ ] Skip navigation link
- [ ] ARIA labels on interactive elements

**Testing Tools**:
- Chrome Lighthouse (Accessibility audit)
- WAVE browser extension
- axe DevTools
- Keyboard-only navigation test

---

## 🔄 9. Regression Testing Checklist

## 🔄 9. Regression Testing Checklist

Run after any code changes:

- [ ] All CRUD operations still work
- [ ] Authentication/authorization unchanged
- [ ] No broken links or 404 errors
- [ ] Database integrity maintained
- [ ] UI/UX consistency preserved
- [ ] No new security vulnerabilities

---

## 📝 10. Sign-Off

### Tested By
- **Name**: ___________________
- **Date**: ___________________
- **Signature**: ___________________

### Approved By
- **Name**: ___________________
- **Date**: ___________________
- **Signature**: ___________________

---

## 🚀 Next Steps

### Immediate Actions Required (Before Production)
1. ❌ **Implement CSRF Protection** - Critical security vulnerability
2. ⚠️ **Upgrade Password Hashing** - Replace SHA-256 with bcrypt
3. ⚠️ **Add XSS Prevention** - Replace <%= %> with <c:out>
4. ❌ **Implement Pagination** - Essential for scalability
5. ❌ **Implement Sorting** - Core requirement from specification

### Short-term Improvements (1-2 Weeks)
6. ⚠️ **Add Client Validation** - Improve UX
7. ⚠️ **Configure Session Timeout** - Security best practice
8. ⚠️ **Enforce Password Complexity** - Strengthen security
9. ❌ **Add Audit Logging** - Track sensitive operations
10. ⚠️ **Accessibility Audit** - WCAG AA compliance

### Medium-term Enhancements (2-4 Weeks)
11. ❌ **CSV Export** - Admin functionality
12. ❌ **Rate Limiting** - Prevent brute force
13. ❌ **Soft Delete** - Data safety
14. ❌ **Email Notifications** - User engagement
15. ⚠️ **Performance Optimization** - Database indexing, query optimization

### Deployment Path
1. ✅ Fix critical security issues (CSRF, password hashing, XSS)
2. ✅ Implement core missing features (pagination, sorting)
3. ✅ Deploy to staging environment
4. ✅ Perform comprehensive UAT with test scenarios
5. ✅ Fix any identified issues
6. ✅ Security audit & penetration testing
7. ✅ Performance testing under load
8. ✅ Deploy to production
9. ✅ Monitor system metrics (errors, performance, usage)
10. ✅ Collect user feedback & iterate

---

## 📚 Appendix: Reference Implementation Examples

### A. Sort Control JSP Include (sortcontrol.jspf)
```jsp
<%@ page import="java.util.Map" %>
<%
    String currentSort = request.getParameter("sort_by") != null ? request.getParameter("sort_by") : "id";
    String currentDir = request.getParameter("sort_dir") != null ? request.getParameter("sort_dir") : "asc";
    Map<String, String> sortOptions = (Map<String, String>) request.getAttribute("sortOptions");
%>
<div class="flex items-center gap-4 mb-4">
    <label class="font-semibold">Sort by:</label>
    <select id="sortBy" class="border rounded px-3 py-2" onchange="updateSort()">
        <% for (Map.Entry<String, String> option : sortOptions.entrySet()) { %>
            <option value="<%= option.getKey() %>" <%= currentSort.equals(option.getKey()) ? "selected" : "" %>>
                <%= option.getValue() %>
            </option>
        <% } %>
    </select>
    <button onclick="toggleSortDir()" class="border rounded px-3 py-2">
        <i class="fas fa-sort-<%= "asc".equals(currentDir) ? "up" : "down" %>"></i>
        <%= "asc".equals(currentDir) ? "Ascending" : "Descending" %>
    </button>
</div>
<script>
function updateSort() {
    const sortBy = document.getElementById('sortBy').value;
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.set('sort_by', sortBy);
    window.location.search = urlParams.toString();
}
function toggleSortDir() {
    const urlParams = new URLSearchParams(window.location.search);
    const currentDir = urlParams.get('sort_dir') || 'asc';
    urlParams.set('sort_dir', currentDir === 'asc' ? 'desc' : 'asc');
    window.location.search = urlParams.toString();
}
</script>
```

### B. Pagination JSP Include (pagination.jspf)
```jsp
<%
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int pageSize = (Integer) request.getAttribute("pageSize");
    long totalCount = (Long) request.getAttribute("totalCount");
    int startItem = (currentPage - 1) * pageSize + 1;
    int endItem = Math.min(currentPage * pageSize, (int) totalCount);
%>
<div class="flex justify-between items-center mt-6">
    <div class="text-sm text-gray-600">
        Showing <%= startItem %>-<%= endItem %> of <%= totalCount %>
    </div>
    <div class="flex gap-2">
        <select onchange="changePageSize(this.value)" class="border rounded px-3 py-1">
            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 per page</option>
            <option value="25" <%= pageSize == 25 ? "selected" : "" %>>25 per page</option>
            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 per page</option>
        </select>
    </div>
    <div class="flex gap-1">
        <% if (currentPage > 1) { %>
            <a href="?page=<%= currentPage - 1 %>&page_size=<%= pageSize %>" class="px-3 py-1 border rounded">Previous</a>
        <% } %>
        
        <% for (int i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) { %>
            <a href="?page=<%= i %>&page_size=<%= pageSize %>" 
               class="px-3 py-1 border rounded <%= i == currentPage ? "bg-blue-600 text-white" : "" %>">
                <%= i %>
            </a>
        <% } %>
        
        <% if (currentPage < totalPages) { %>
            <a href="?page=<%= currentPage + 1 %>&page_size=<%= pageSize %>" class="px-3 py-1 border rounded">Next</a>
        <% } %>
    </div>
</div>
```

### C. Database Schema Additions
```sql
-- Audit logging table
CREATE TABLE audit_logs (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Soft delete columns (add to existing tables)
ALTER TABLE doctors ADD COLUMN deleted_at TIMESTAMP NULL;
ALTER TABLE departments ADD COLUMN deleted_at TIMESTAMP NULL;
ALTER TABLE appointments ADD COLUMN deleted_at TIMESTAMP NULL;

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    token_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Session tracking
CREATE TABLE user_sessions (
    session_id VARCHAR(255) PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP
);

-- Performance indexes
CREATE INDEX idx_appointments_doctor_date ON appointments(doctor_id, appointment_date) WHERE deleted_at IS NULL;
CREATE INDEX idx_appointments_patient_status ON appointments(patient_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id, record_date DESC);
CREATE INDEX idx_audit_logs_user_action ON audit_logs(user_id, action, created_at DESC);
```

---

## ✅ Final Acceptance Checklist

Before declaring the system production-ready, verify ALL items:

### Security ✅
- [ ] CSRF protection on all forms
- [ ] bcrypt/Argon2 password hashing
- [ ] XSS prevention (JSTL <c:out>)
- [ ] SQL injection prevention (PreparedStatement)
- [ ] Session security (HttpOnly, Secure, timeout)
- [ ] Rate limiting on login
- [ ] Audit logging enabled

### Functionality ✅
- [ ] All CRUD operations working
- [ ] Role-based access control enforced
- [ ] Sorting on all list views
- [ ] Pagination on all list views
- [ ] Filters working (status, department, date)
- [ ] Search functionality
- [ ] CSV export (admin)

### Validation ✅
- [ ] Client-side validation (HTML5 + JS)
- [ ] Server-side validation (all inputs)
- [ ] Password complexity enforced
- [ ] Email format validation
- [ ] Date/time validation
- [ ] Business rules enforced (availability, overlaps)

### UI/UX ✅
- [ ] Responsive design tested
- [ ] Accessibility WCAG AA compliant
- [ ] Consistent styling (TailwindCSS)
- [ ] Error messages user-friendly
- [ ] Success notifications
- [ ] Loading indicators
- [ ] Empty states with CTAs

### Performance ✅
- [ ] Page load < 2s
- [ ] Database queries optimized
- [ ] Indexes created
- [ ] Connection pooling configured
- [ ] Concurrent users tested (20+)

### Operations ✅
- [ ] Database backup strategy
- [ ] Log retention policy
- [ ] Health check endpoint
- [ ] Error monitoring
- [ ] Deployment documentation
- [ ] Rollback procedure

---

**End of Quality Check Control Procedure**

**Document Status**: ⚠️ **Implementation Incomplete** - See Priority 1 items before production deployment
