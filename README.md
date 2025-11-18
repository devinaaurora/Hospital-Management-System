# 🏥 Hospital Management System

A comprehensive hospital management platform built with JSP, Servlets, PostgreSQL, and TailwindCSS.

## � Security Update (v1.1.0 - November 14, 2025)

**Major security improvements implemented!** See [SECURITY_IMPROVEMENTS.md](SECURITY_IMPROVEMENTS.md) for details.

- ✅ **BCrypt Password Hashing** - Upgraded from SHA-256 to industry-standard BCrypt
- ✅ **CSRF Protection** - Framework implemented to prevent cross-site request forgery
- ✅ **Session Security** - HttpOnly cookies, 20-minute timeout, custom session management
- ✅ **JSTL Support** - Foundation for XSS prevention in JSP pages
- ⚠️ **Pending**: CSRF integration in all forms, JSTL migration, pagination, sorting

📊 **Security Score Improvement**: 71% increase (4.2/10 → 7.2/10)  
📖 **Full Analysis**: See [ANALYSIS_REPORT.md](ANALYSIS_REPORT.md)  
✅ **Quality Check**: See [qualitycheck.md](qualitycheck.md)

---

## �📋 Table of Contents
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Installation & Setup](#installation--setup)
- [Database Configuration](#database-configuration)
- [Building the Project](#building-the-project)
- [Deployment](#deployment)
- [Testing](#testing)
- [Default Credentials](#default-credentials)
- [Project Structure](#project-structure)

## ✨ Features

### Patient Features
- ✅ View doctor list & availability
- ✅ Book appointments online
- ✅ View appointment status
- ✅ Edit appointments (before approval)
- ✅ Cancel appointments
- ✅ View medical records

### Doctor Features
- ✅ View assigned appointments
- ✅ Approve/decline appointments
- ✅ Mark appointments as completed
- ✅ Add patient diagnosis and notes
- ✅ Manage patient medical records

### Admin Features
- ✅ Add/edit/delete doctors
- ✅ Manage departments
- ✅ View all appointments
- ✅ Monitor hospital operations

## 🛠 Technology Stack

- **Backend**: Java Servlets (Jakarta EE 5.0)
- **Frontend**: JSP, JSTL, TailwindCSS, Font Awesome
- **Database**: PostgreSQL
- **Build Tool**: Maven
- **Server**: Apache Tomcat 10+
- **Security**: BCrypt password hashing, CSRF protection, HttpOnly sessions

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Java JDK 11+** - [Download](https://www.oracle.com/java/technologies/downloads/)
- **Apache Tomcat 10+** - [Download](https://tomcat.apache.org/download-10.cgi)
- **PostgreSQL 12+** - [Download](https://www.postgresql.org/download/)
- **Maven 3.6+** - [Download](https://maven.apache.org/download.cgi)
- **IDE** (Optional): IntelliJ IDEA, Eclipse, or VS Code

## 🚀 Installation & Setup

### 1. Clone or Extract the Project

```bash
cd d:\ITS\Mata Kuliah\Pemrograman Web\hospital-management
```

### 2. Database Configuration

#### Create PostgreSQL Database

Open PostgreSQL command line (psql) or pgAdmin and run:

```sql
CREATE DATABASE hospital_db;
```

#### Run the Schema

Navigate to the database folder and run the schema:

```bash
psql -U postgres -d hospital_db -f database/schema.sql
```

Or using pgAdmin:
1. Open pgAdmin
2. Select `hospital_db` database
3. Open Query Tool
4. Copy contents of `database/schema.sql`
5. Execute the query

### 3. Configure Database Connection

Edit `src/main/resources/database.properties`:

```properties
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://localhost:5432/hospital_db
db.username=postgres
db.password=YOUR_POSTGRES_PASSWORD
```

**Important**: Replace `YOUR_POSTGRES_PASSWORD` with your actual PostgreSQL password.

## 🔨 Building the Project

### Using Maven

```bash
# Clean and compile
mvn clean compile

# Package as WAR file
mvn clean package
```

This will create `hospital-management.war` in the `target/` directory.

### Manual Build (Without Maven)

If you don't have Maven:

1. Create directory structure in Tomcat:
   ```
   TOMCAT_HOME/webapps/hospital-management/
   ```

2. Copy files:
   - Copy `src/main/webapp/*` to `TOMCAT_HOME/webapps/hospital-management/`
   - Compile Java files and place `.class` files in `WEB-INF/classes/com/hospital/...`
   - Copy PostgreSQL JDBC driver to `WEB-INF/lib/`

## 🌐 Deployment

### Local Deployment (Development)

#### Option 1: Using Maven Cargo Plugin (Recommended - Tomcat 10)

```bash
# Run embedded Tomcat 10 server
mvn clean package cargo:run
```

Access the application at: `http://localhost:8080/hospital/`

**Note**: Press `Ctrl+C` to stop the server.

#### Option 2: Manual Deployment to External Tomcat

1. Copy `target/hospital-management.war` to `TOMCAT_HOME/webapps/`
2. Start Tomcat:
   ```bash
   # Windows
   TOMCAT_HOME\bin\startup.bat
   
   # Linux/Mac
   TOMCAT_HOME/bin/startup.sh
   ```
3. Access the application:
   ```
   http://localhost:8080/hospital-management/
   ```

### Online Deployment

#### Deploy to Render, Railway, or similar PaaS:

1. Ensure your PostgreSQL database is accessible online
2. Update `database.properties` with online database credentials
3. Build WAR file: `mvn clean package`
4. Upload WAR file to your hosting service
5. Configure environment variables if needed

#### Deploy to Traditional Hosting (cPanel):

1. Build WAR file
2. Upload to cPanel File Manager
3. Extract in `public_html` or designated Java directory
4. Configure database connection in hosting control panel
5. Start Tomcat from cPanel

## 🧪 Testing

### 1. Verify Database Connection

Navigate to:
```
http://localhost:8080/hospital-management/
```

You should see the homepage without errors.

### 2. Test Login

Use the default credentials (see below) to test different user roles.

### 3. Test CRUD Operations

#### As Patient:
1. Login as patient
2. View doctors list
3. Book an appointment
4. View appointments
5. Cancel/edit appointment

#### As Doctor:
1. Login as doctor
2. View assigned appointments
3. Approve/reject appointments
4. Add medical records

#### As Admin:
1. Login as admin
2. Add a new doctor
3. Create a department
4. View all appointments

## 🔑 Default Credentials

### Admin
- **Username**: `admin`
- **Password**: `password123`

### Doctor
- **Username**: `dr.smith`
- **Password**: `password123`

### Patient
- **Username**: `patient1`
- **Password**: `password123`

**⚠️ Security Note**: Change these passwords in production!

## 📁 Project Structure

```
hospital-management/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── hospital/
│   │   │           ├── dao/           # Data Access Objects
│   │   │           ├── model/         # Entity classes
│   │   │           ├── servlet/       # Servlet controllers
│   │   │           └── util/          # Utility classes
│   │   ├── resources/
│   │   │   └── database.properties    # DB configuration
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml           # Servlet configuration
│   │       ├── META-INF/
│   │       │   └── context.xml       # Context configuration
│   │       ├── *.jsp                 # JSP pages
│   │       └── css/js/               # Static resources
├── database/
│   └── schema.sql                    # Database schema
├── pom.xml                           # Maven configuration
└── README.md                         # This file
```

## 🔧 Troubleshooting

### Issue: "Cannot connect to database"
**Solution**: 
- Verify PostgreSQL is running
- Check database credentials in `database.properties`
- Ensure PostgreSQL driver JAR is in `WEB-INF/lib/`

### Issue: "404 Not Found"
**Solution**:
- Verify WAR file is deployed in Tomcat webapps
- Check Tomcat logs: `TOMCAT_HOME/logs/catalina.out`
- Ensure correct URL: `http://localhost:8080/hospital-management/`

### Issue: "Servlet compilation errors"
**Solution**:
- Ensure using Tomcat 10+ (for Jakarta EE)
- For Tomcat 9 or below, change imports from `jakarta.*` to `javax.*`

## 📝 Development Notes

### Adding New Features

1. **Add new entity**: Create class in `model/` package
2. **Create DAO**: Add DAO class in `dao/` package
3. **Create servlet**: Add servlet in `servlet/` package
4. **Create JSP**: Add JSP page in `webapp/`
5. **Update web.xml** if needed

### Code Style
- Follow Java naming conventions
- Use meaningful variable names
- Comment complex logic
- Keep methods small and focused

## 📄 License

This project is created for educational purposes as part of the Web Programming course at ITS.

## 👨‍💻 Support

For issues and questions:
1. Check the troubleshooting section
2. Review Tomcat logs
3. Verify database connection
4. Check browser console for JavaScript errors

## 🎯 Next Steps

- [ ] Implement password hashing (BCrypt)
- [ ] Add email notifications
- [ ] Implement file upload for medical documents
- [ ] Add search and filtering features
- [ ] Implement pagination
- [ ] Add export to PDF functionality
- [ ] Implement real-time notifications
- [ ] Add patient registration form

---

**Built with ❤️ for ITS Web Programming Course**
