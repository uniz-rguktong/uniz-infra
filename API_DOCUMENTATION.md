# UniZ Backend API Documentation

Welcome to the comprehensive API reference for the UniZ Microservices Backend. All requests should be prefixed with the Gateway URL.

**Gateway URL:** `https://uniz-production-gateway.vercel.app/api/v1`

---

## Authentication Service (/auth)
Handles identity, sessions, and multi-factor authentication.

### Login
`POST /auth/login`
Authenticates a user and returns a JSON Web Token (JWT).
- **Body:**
  ```json
  {
    "username": "21BCE001",
    "password": "hashed_password"
  }
  ```
- **Returns:** `{ "success": true, "token": "...", "user": { ... } }`

### Signup / Add Student
`POST /auth/signup`
Creates a new student credential. Restricted to Admin or Student self-signup.
- **Body:**
  ```json
  {
    "username": "21BCE001",
    "password": "hashed_password",
    "role": "student"
  }
  ```

### Request OTP
`POST /auth/otp/request`
Generates and sends a 6-digit OTP to the user's registered contact.
- **Body:**
  ```json
  {
    "username": "21BCE001"
  }
  ```

### Verify OTP
`POST /auth/otp/verify`
Verifies the 6-digit code for password resets.
- **Body:**
  ```json
  {
    "username": "21BCE001",
    "otp": "123456"
  }
  ```

### Reset Password
`POST /auth/password/reset`
Updates the user's password if the OTP is valid.
- **Body:**
  ```json
  {
    "username": "21BCE001",
    "otp": "123456",
    "newPassword": "new_secure_password"
  }
  ```

### Logout
`POST /auth/logout`
Invalidates the current session.
- **Headers:** `Authorization: Bearer <token>`

---

## User Service (/profile)
Provides profile management and user lookup capabilities.

### Get My Student Profile
`GET /profile/student/me`
Fetches the detailed profile of the currently logged-in student.
- **Headers:** `Authorization: Bearer <token>`
- **Returns:**
  ```json
  {
    "success": true,
    "student": {
      "username": "...",
      "name": "...",
      "branch": "...",
      "is_in_campus": true
    }
  }
  ```

### Update Student Profile
`PUT /profile/student/update`
Allows students to update their personal information (phone, address, etc).
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "phone": "9876543210",
    "address": "..."
  }
  ```

### Search Students (Admin)
`POST /profile/student/search`
Filter and browse the student directory.
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "username": "21BCE",
    "branch": "CSE",
    "year": 3,
    "gender": "M",
    "page": 1,
    "limit": 20
  }
  ```

### Get My Faculty Profile
`GET /profile/faculty/me`
Retrieves specialized profile data for administrative staff.
- **Headers:** `Authorization: Bearer <token>`

### Create Faculty Profile (Admin)
`POST /profile/faculty/create`
Adds a new faculty profile into the system.
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "username": "F101",
    "name": "Prof. Smith",
    "email": "smith@uniz.edu",
    "department": "CSE",
    "designation": "Assistant Professor"
  }
  ```

### Get My Admin Profile
`GET /profile/admin/me`
Retrieves dashboard-specific data for webmasters/deans.
- **Headers:** `Authorization: Bearer <token>`

---

## Outpass Service (/requests)
Manages the workflow for student outpasses and local outings.

### Create Outpass (Long Stay)
`POST /requests/outpass`
Submit a request for residential leave (multi-day).
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "reason": "...",
    "fromDay": "ISO_DATE",
    "toDay": "ISO_DATE"
  }
  ```

### Create Outing (Local)
`POST /requests/outing`
Submit a request for local day-outing.
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "reason": "...",
    "fromTime": "ISO_TIME",
    "toTime": "ISO_TIME"
  }
  ```

### View My History
`GET /requests/history` | `GET /requests/history/:id`
Lists personal requests with status (pending, approved, rejected, expired).
- **Headers:** `Authorization: Bearer <token>`

### Approve Request (Admin/Faculty)
`POST /requests/:id/approve`
Finalize student outing/outpass requests.
- **Path Param:** `id` (The UUID of the request)
- **Body:**
  ```json
  {
    "comment": "Optional comment"
  }
  ```

### Reject Request (Admin/Faculty)
`POST /requests/:id/reject`
Reject student outing/outpass requests.
- **Path Param:** `id` (The UUID of the request)
- **Body:**
  ```json
  {
    "comment": "Reason for rejection"
  }
  ```

### List All Outing Requests (Admin)
`GET /requests/outing/all`
Master list of all local outing requests.
- **Headers:** `Authorization: Bearer <token>`

### List All Outpass Requests (Admin)
`GET /requests/outpass/all`
Master list of all long-stay outpass requests.
- **Headers:** `Authorization: Bearer <token>`

---

## Academics Service (/academics)
Manages subjects, grades, and attendance data.

### Get My Grades
`GET /academics/grades`
Fetches all grade records for the currently authenticated student.
- **Headers:** `Authorization: Bearer <token>`

### Add/Update Grades (Admin/Faculty)
`POST /academics/grades/add`
Bulk add or update subject grades for a student.
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "studentId": "21BCE001",
    "semesterId": "SEM_1",
    "grades": [
      { "subjectId": "SUB_UUID_1", "grade": 9.5 },
      { "subjectId": "SUB_UUID_2", "grade": 8.0 }
    ]
  }
  ```

### Get My Attendance
`GET /academics/attendance`
Retrieves subject-wise attendance percentages for the student.
- **Headers:** `Authorization: Bearer <token>`

### Add/Update Attendance (Admin/Faculty)
`POST /academics/attendance/add`
Update attendance records for a student/subject.
- **Headers:** `Authorization: Bearer <token>`
- **Body:**
  ```json
  {
    "subjectId": "SUB_UUID_1",
    "records": [
      { 
        "studentId": "21BCE001", 
        "semesterId": "SEM_1", 
        "attended": 28, 
        "total": 30 
      }
    ]
  }
  ```

### Get Subjects List
`GET /academics/subjects`
Fetch all subjects registered in the curriculum.
- **Headers:** `Authorization: Bearer <token>`

---

## Notification Service (/notifications)
Asynchronous notification delivery via email and worker queues.

### Health Check
`GET /notifications/health`
Check if the Redis worker and mail transporter are active.

---

## Cron Service (/cron)
System maintenance and background automation.

### Execute Maintenance Job
`GET /cron/api/cron`
Manually trigger the daily maintenance job (Expire old outpasses).
- **Requires:** Vercel Cron Secret

---

## Error Response Codes

| Code | Meaning |
| :--- | :--- |
| 200 | Success |
| 201 | Created |
| 400 | Validation Error (Invalid request body) |
| 401 | Unauthorized (Missing or invalid token) |
| 403 | Forbidden (Insufficient role permissions) |
| 404 | Resource Not Found |
| 409 | Conflict (Duplicate resource or state conflict) |
| 500 | Internal Server Error |

---
*Last Updated: January 30, 2026*
