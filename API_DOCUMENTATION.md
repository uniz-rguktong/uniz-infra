# 📔 UniZ Backend API Documentation

Welcome to the comprehensive API reference for the UniZ Microservices Backend. All requests should be prefixed with the Gateway URL.

> **Gateway URL:** `https://uniz-production-gateway.vercel.app/api/v1`

---

## 🔐 Authentication Service (`/auth`)
Handles identity, sessions, and multi-factor authentication.

### **Login**
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

### **Request OTP**
`POST /auth/otp/request`
Generates and sends a 6-digit OTP to the user's registered contact.
- **Body:**
  ```json
  {
    "username": "21BCE001"
  }
  ```

### **Verify OTP**
`POST /auth/otp/verify`
Verifies the 6-digit code for password resets or highly sensitive actions.
- **Body:**
  ```json
  {
    "username": "21BCE001",
    "otp": "123456"
  }
  ```

### **Reset Password**
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

---

## 👤 User Service (`/profile`)
Provides profile management and user lookup capabilities.

### **Get My Profile**
`GET /profile/student/me`
Fetches the detailed profile of the currently logged-in student.
- **Headers:** `Authorization: Bearer <token>`
- **Returns:** 
  ```json
  {
    "success": true,
    "student": {
      "username": "...",
      "branch": "...",
      "is_in_campus": true,
      "phone_number": "..."
    }
  }
  ```

### **Update Profile**
`PUT /profile/student/update`
Allows students to update their personal information.
- **Headers:** `Authorization: Bearer <token>`
- **Body (JSON):**
  - `phone` (optional string)
  - `address` (optional string)
  - `name` (optional string)

### **Search Students (Admin)**
`POST /profile/student/search`
Filter and paginate through student records.
- **Headers:** `Authorization: Bearer <token>`
- **Body (JSON):**
  - `username`: Partial match for username or name
  - `branch`: "CSE", "ECE", etc.
  - `year`: 1, 2, 3, 4
  - `gender`: "M", "F"
  - `page`: Default 1
  - `limit`: Default 10

---

## 🎫 Outpass Service (`/requests`)
Manages the workflow for student outpasses and local outings.

### **Create Outpass (Long Stay)**
`POST /requests/outpass`
Submit a request for leave (usually multi-day).
- **Headers:** `Authorization: Bearer <token>`
- **Body (JSON):**
  ```json
  {
    "reason": "Family Function",
    "fromDay": "2024-02-01T10:00:00Z",
    "toDay": "2024-02-05T18:00:00Z"
  }
  ```

### **Create Outing (Local)**
`POST /requests/outing`
Submit a request for local day-outing.
- **Headers:** `Authorization: Bearer <token>`
- **Body (JSON):**
  ```json
  {
    "reason": "Shopping",
    "fromTime": "2024-02-01T14:00:00Z",
    "toTime": "2024-02-01T20:00:00Z"
  }
  ```

### **View My History**
`GET /requests/history`
Lists all personal requests with status (pending, approved, rejected).
- **Headers:** `Authorization: Bearer <token>`
- **Query Params:**
  - `page`: Page index (int)
  - `limit`: Items per page (int)

### **Approve/Reject (Faculty/Admin)**
`POST /requests/:id/approve` | `POST /requests/:id/reject`
Finalize or escalate a student request.
- **Path Param:** `id` (The UUID of the request)
- **Body (JSON):**
  ```json
  {
    "comment": "Approved based on parental confirmation."
  }
  ```

### **List All Requests (Admin)**
`GET /requests/outpass/all` | `GET /requests/outing/all`
Get a master list of all requests in the system.
- **Headers:** `Authorization: Bearer <token>`
- **Returns:** `{ "success": true, "outpasses": [...] }`

---

## ⏰ Cron Service (`/cron`)
System maintenance and background automation.

### **Trigger Maintenance**
`GET /cron/api/cron`
Manually trigger the daily maintenance job (Expire old outpasses, clear tokens).
- **Requires:** Vercel Cron Secret (Internal)

---

## 📧 Notification Service (`/notifications`)
Asynchronous notification delivery.

### **Health Check**
`GET /notifications/health`
Check if the Redis worker and mail transporter are active.

---

## 🛠 Status Codes & Errors

| Code | Meaning |
| :--- | :--- |
| `200` | Success |
| `400` | Validation Error (Check `errors` array) |
| `401` | Unauthorized (Invalid Token) |
| `403` | Forbidden (Insufficient Permissions) |
| `404` | Resource Not Found |
| `429` | Too Many Requests (Rate Limited) |
| `500` | Internal Server Error |

---
*Last Updated: January 2026*
