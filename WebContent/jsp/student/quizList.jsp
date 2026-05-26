<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%@ page import="com.eduportal.model.Quiz"%>
<%@ page import="java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - My Quizzes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .sidebar {
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
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
        .topbar { background: white; border-radius: 15px; padding: 15px 25px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); }
        .topbar h5 { margin: 0; color: #333; font-weight: 600; }
        .user-avatar { width: 40px; height: 40px; border-radius: 50%; background: linear-gradient(135deg, #667eea, #764ba2); display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; }
        .quiz-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; transition: transform 0.3s; }
        .quiz-card:hover { transform: translateY(-3px); }
        .quiz-info h5 { font-weight: 700; color: #333; margin: 0 0 8px; }
        .badge-course { background: #e8f4fd; color: #667eea; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .btn-take { background: linear-gradient(135deg, #667eea, #764ba2); border: none; color: white; border-radius: 10px; padding: 10px 25px; font-weight: 600; text-decoration: none; }
        .btn-take:hover { opacity: 0.9; color: white; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="logo">
        <i class="fas fa-graduation-cap"></i>
        <h4>EduPortal</h4>
    </div>
    <nav>
        <a href="<%= request.getContextPath() %>/jsp/student/dashboard.jsp" class="nav-link">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/course?action=myCourses" class="nav-link">
            <i class="fas fa-book"></i> My Courses
        </a>
        <a href="<%= request.getContextPath() %>/course?action=browse" class="nav-link">
            <i class="fas fa-search"></i> Browse Courses
        </a>
        <a href="<%= request.getContextPath() %>/quiz?action=list" class="nav-link active">
            <i class="fas fa-tasks"></i> My Quizzes
        </a>
        <a href="<%= request.getContextPath() %>/quiz?action=results" class="nav-link">
            <i class="fas fa-chart-line"></i> My Progress
        </a>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link mt-5">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="topbar">
        <h5><i class="fas fa-tasks me-2"></i>My Quizzes</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar"><%= user.getName().charAt(0) %></div>
            <div>
                <div class="fw-semibold"><%= user.getName() %></div>
                <small class="text-muted">Student</small>
            </div>
        </div>
    </div>

    <% if(quizzes == null || quizzes.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="fas fa-tasks fa-4x mb-3" style="color:#ddd;"></i>
            <h5 class="text-muted">No quizzes available yet</h5>
            <p class="text-muted">Enroll in courses to access quizzes!</p>
            <a href="<%= request.getContextPath() %>/course?action=browse"
               class="btn btn-primary rounded-pill px-4">
                <i class="fas fa-search me-2"></i>Browse Courses
            </a>
        </div>
    <% } else { %>
        <% for(Quiz quiz : quizzes) { %>
        <div class="quiz-card">
            <div class="quiz-info">
                <h5><%= quiz.getTitle() %></h5>
                <span class="badge-course">
                    <i class="fas fa-book me-1"></i><%= quiz.getCourseTitle() %>
                </span>
                <span class="ms-3 text-muted">
                    <i class="fas fa-clock me-1"></i><%= quiz.getDurationMinutes() %> mins
                </span>
            </div>
            <a href="<%= request.getContextPath() %>/quiz?action=take&quizId=<%= quiz.getId() %>"
               class="btn-take btn">
                <i class="fas fa-play me-2"></i>Start Quiz
            </a>
        </div>
        <% } %>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>