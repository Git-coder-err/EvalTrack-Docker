# EvalTrack Database Migration Guide
## Updated to Match EvalTrack_System Schema

### 🎯 **Overview**
The EvalTrack PHP project has been updated to use the same database schema as the EvalTrack_System Node.js project. This ensures compatibility between both systems and allows them to share the same database.

### 📊 **Database Schema Changes**

#### **New Tables Added:**
1. **programs** - Academic programs (BSIT, BSEMC)
2. **students** - Extended student information
3. **courses** - Course catalog with detailed information
4. **curricula** - Curriculum definitions
5. **curriculum_courses** - Course-to-curriculum mapping
6. **course_offerings** - Available course sections
7. **student_enrollments** - Enrollment records
8. **student_grades** - Detailed grade tracking

#### **Updated Tables:**
1. **users** - Added new columns and updated structure
2. **messages** - Kept for compatibility

### 🔧 **Files Modified**

#### **New Files:**
- `setup_db_system.php` - Complete database setup with new schema
- `DATABASE_MIGRATION_GUIDE.md` - This documentation

#### **Updated Files:**
- `login.php` - Updated to work with new user table structure
- `register.php` - Enhanced to handle new schema and create student records

### 🚀 **Setup Instructions**

#### **Step 1: Run Database Setup**
Visit: `http://localhost/EvalTrack/setup_db_system.php`

This will:
- ✅ Create all new tables with proper relationships
- ✅ Insert BSIT curriculum data
- ✅ Add default admin user
- ✅ Create performance indexes
- ✅ Maintain backward compatibility

#### **Step 2: Test Registration**
1. Go to `http://localhost/EvalTrack/login.html`
2. Click "Register Account"
3. Fill out the form
4. Should work with both old and new database structures

#### **Step 3: Test Login**
Use the default admin credentials:
- **Username**: `admin` or `ADMIN001`
- **Password**: `admin123`

### 🔄 **Compatibility Features**

#### **Dynamic Column Detection**
Both login and registration scripts automatically detect:
- Whether `must_change_password` column exists
- Whether `status` column exists
- Whether `students` table exists

#### **Backward Compatibility**
- Works with existing old database structure
- Works with new EvalTrack_System structure
- No breaking changes to existing functionality

### 📋 **New Database Structure**

#### **Users Table**
```sql
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'dean', 'registrar', 'instructor', 'student') NOT NULL,
    program VARCHAR(50),                    -- Added
    student_type ENUM('regular', 'irregular', 'transferee'), -- Added
    must_change_password BOOLEAN DEFAULT 0, -- Added
    status ENUM('Active', 'Inactive') DEFAULT 'Active', -- Added
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Added
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- Added
);
```

#### **Students Table** (New)
```sql
CREATE TABLE students (
    id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    program_code VARCHAR(50) NOT NULL,
    student_type ENUM('regular', 'irregular', 'transferee') NOT NULL,
    year_level INT DEFAULT 1,
    enrollment_status ENUM('active', 'inactive', 'graduated', 'dropped') DEFAULT 'active',
    date_admitted DATE,
    expected_graduation DATE,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    total_units_earned INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

#### **Courses Table** (New)
```sql
CREATE TABLE courses (
    code VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    units DECIMAL(3,1) NOT NULL,
    course_type ENUM('GE', 'IT', 'IT Elect', 'NSTP', 'PE', 'SF', 'CAP', 'SP', 'SWT', 'PRAC') NOT NULL,
    lec_hours INT DEFAULT 0,
    lab_hours INT DEFAULT 0,
    prerequisites TEXT,
    corequisites TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### 🎓 **Curriculum Data Included**

The setup includes the complete BSIT curriculum:
- **First Year**: 1st Semester, 2nd Semester
- **Second Year**: 1st Semester, 2nd Semester  
- **Third Year**: 1st Semester, 2nd Semester, Summer
- **Fourth Year**: 1st Semester, 2nd Semester

All courses from the curriculum evaluation document are included with proper prerequisites.

### 🔍 **Testing Checklist**

#### ✅ **Database Setup**
- [ ] Run `setup_db_system.php` without errors
- [ ] Verify all tables created
- [ ] Check default admin user exists

#### ✅ **Registration**
- [ ] Student registration works
- [ ] Instructor registration works
- [ ] Student records created in students table
- [ ] Email validation works (@jmc.edu.ph)

#### ✅ **Login**
- [ ] Admin login works
- [ ] Student login works
- [ ] Instructor login works
- [ ] Password change requirement works

#### ✅ **Compatibility**
- [ ] Works with EvalTrack_System Node.js backend
- [ ] Existing data preserved (if any)
- [ ] No breaking changes to existing features

### 🚨 **Important Notes**

1. **Backup First**: Always backup existing database before migration
2. **Clear Cache**: Clear browser cache after migration
3. **Test Thoroughly**: Test all user roles and features
4. **Check Permissions**: Ensure database user has proper permissions

### 📞 **Support**

If you encounter issues:
1. Check browser console for errors
2. Verify database connection in `config.php`
3. Ensure MySQL is running in XAMPP
4. Check PHP error logs

### 🎉 **Benefits of Migration**

- ✅ **Unified Database**: Both systems share the same data
- ✅ **Enhanced Features**: Access to curriculum evaluation features
- ✅ **Better Performance**: Optimized database structure
- ✅ **Future-Ready**: Ready for additional features
- ✅ **Data Integrity**: Proper foreign key constraints
