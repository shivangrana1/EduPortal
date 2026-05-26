<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 450px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo i {
            font-size: 50px;
            color: #667eea;
        }
        .logo h2 {
            color: #333;
            font-weight: 700;
            margin-top: 10px;
        }
        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 2px solid #eee;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: none;
        }
        .btn-register {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-size: 16px;
            font-weight: 600;
            width: 100%;
            color: white;
        }
        .btn-register:hover {
            opacity: 0.9;
            color: white;
        }
        .input-group-text {
            border-radius: 10px 0 0 10px;
            background: #f8f9fa;
            border: 2px solid #eee;
            border-right: none;
        }
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #888;
        }
        .login-link a {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="register-card">
    <div class="logo">
        <i class="fas fa-graduation-cap"></i>
        <h2>Join EduPortal</h2>
        <p>Create your account today</p>
    </div>

    <!-- Error Message -->
    <% if(request.getAttribute("error") != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>
            <%= request.getAttribute("error") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Register Form -->
    <form action="<%= request.getContextPath() %>/register" method="post">

        <div class="mb-3">
            <label class="form-label fw-semibold">Full Name</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-user text-muted"></i>
                </span>
                <input type="text" name="name" class="form-control"
                       placeholder="Enter your full name" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Email Address</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-envelope text-muted"></i>
                </span>
                <input type="email" name="email" class="form-control"
                       placeholder="Enter your email" required>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label fw-semibold">Password</label>
            <div class="input-group">
                <span class="input-group-text">
                    <i class="fas fa-lock text-muted"></i>
                </span>
                <input type="password" name="password" class="form-control"
                       placeholder="Create a password" required>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label fw-semibold">Register As</label>
            <select name="role" class="form-select" required>
                <option value="" disabled selected>Select your role</option>
                <option value="student">Student</option>
                <option value="teacher">Teacher</option>
            </select>
        </div>

        <button type="submit" class="btn btn-register">
            <i class="fas fa-user-plus me-2"></i> Create Account
        </button>

    </form>

    <div class="login-link">
        Already have an account?
        <a href="<%= request.getContextPath() %>/login">Login here</a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>