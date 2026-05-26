<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Create Course</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .sidebar {
            background: linear-gradient(180deg, #11998e 0%, #38ef7d 100%);
            min-height: 100vh; width: 250px;
            position: fixed; top: 0; left: 0;
            padding: 20px 0; z-index: 100;
        }
        .sidebar .logo { text-align: center; padding: 20px; border-bottom: 1px solid rgba(255,255,255,0.2); margin-bottom: 20px; }
        .sidebar .logo i { font-size: 40px; color: white; }
        .sidebar .logo h4 { color: white; margin-top: 10px; font-weight: 700; }
        .sidebar .nav-link { color: rgba(255,255,255,0.8); padding: 12px 25px; display: flex; align-items: center; gap: 12px; transition: all 0.3s; text-decoration: none; font-size: 15px; }
        .sidebar .nav-link:hover, .sidebar .nav-link.active { background: rgba(255,255,255,0.2); color: white; border-left: 4px solid white; }
        .sidebar .nav-link i { width: 20px; text-align: center; }
        .main-content { margin-left: 250px; padding: 30px; }
        .form-card { background: white; border-radius: 15px; padding: 35px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); }
        .form-card h4 { font-weight: 700; color: #333; margin-bottom: 25px; }
        .form-control, .form-select { border-radius: 10px; padding: 12px 15px; border: 2px solid #eee; }
        .form-control:focus, .form-select:focus { border-color: #11998e; box-shadow: none; }
        .btn-create { background: linear-gradient(135deg, #11998e, #38ef7d); border: none; color: white; border-radius: 10px; padding: 12px 30px; font-weight: 600; font-size: 16px; }
        .btn-create:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo">
        <i class="fas fa-chalkboard-teacher"></i>
        <h4>EduPortal</h4>
    </div>
    <nav>
        <a href="<%= request.getContextPath() %>/jsp/teacher/dashboard.jsp" class="nav-link">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/course?action=teacherCourses" class="nav-link">
            <i class="fas fa-book"></i> My Courses
        </a>
        <a href="<%= request.getContextPath() %>/course?action=createForm" class="nav-link active">
            <i class="fas fa-plus-circle"></i> Create Course
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-question-circle"></i> Manage Quizzes
        </a>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link mt-5">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="form-card">
        <h4><i class="fas fa-plus-circle me-2" style="color:#11998e;"></i>Create New Course</h4>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/course" method="post">
            <input type="hidden" name="action" value="create">

            <div class="mb-3">
                <label class="form-label fw-semibold">Course Title</label>
                <input type="text" name="title" class="form-control"
                       placeholder="Enter course title" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold">Description</label>
                <textarea name="description" class="form-control" rows="4"
                          placeholder="Describe what students will learn"></textarea>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold">Category</label>
                <select name="category" class="form-select" required>
                    <option value="" disabled selected>Select category</option>
                    <option value="Programming">Programming</option>
                    <option value="Web Development">Web Development</option>
                    <option value="Database">Database</option>
                    <option value="Data Science">Data Science</option>
                    <option value="Mobile Development">Mobile Development</option>
                    <option value="Design">Design</option>
                    <option value="Mathematics">Mathematics</option>
                    <option value="Science">Science</option>
                    <option value="Business">Business</option>
                    <option value="Other">Other</option>
                </select>
            </div>

            <button type="submit" class="btn btn-create">
                <i class="fas fa-plus me-2"></i>Create Course
            </button>
            <a href="<%= request.getContextPath() %>/course?action=teacherCourses"
               class="btn btn-outline-secondary ms-2 rounded-pill px-4">
                Cancel
            </a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>