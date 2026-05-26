<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%@ page import="com.eduportal.model.Course"%>
<%@ page import="java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Browse Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .sidebar {
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            width: 250px;
            position: fixed;
            top: 0; left: 0;
            padding: 20px 0;
            z-index: 100;
        }
        .sidebar .logo {
            text-align: center;
            padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 20px;
        }
        .sidebar .logo i { font-size: 40px; color: white; }
        .sidebar .logo h4 { color: white; margin-top: 10px; font-weight: 700; }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 15px;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
            border-left: 4px solid white;
        }
        .sidebar .nav-link i { width: 20px; text-align: center; }
        .main-content { margin-left: 250px; padding: 30px; }
        .topbar {
            background: white;
            border-radius: 15px;
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
        }
        .topbar h5 { margin: 0; color: #333; font-weight: 600; }
        .user-avatar {
            width: 40px; height: 40px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; align-items: center;
            justify-content: center;
            color: white; font-weight: 700;
        }
        .course-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            transition: transform 0.3s;
        }
        .course-card:hover { transform: translateY(-5px); }
        .course-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            padding: 25px;
            color: white;
        }
        .course-header h5 { font-weight: 700; margin: 0; }
        .course-body { padding: 20px; }
        .course-body p { color: #666; font-size: 14px; }
        .badge-category {
            background: #e8f4fd;
            color: #667eea;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .btn-enroll {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 10px;
            padding: 8px 20px;
            font-weight: 600;
            width: 100%;
        }
        .btn-enroll:hover { opacity: 0.9; color: white; }
        .search-box {
            background: white;
            border-radius: 15px;
            padding: 20px 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>

<!-- Sidebar -->
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
        <a href="<%= request.getContextPath() %>/course?action=browse" class="nav-link active">
            <i class="fas fa-search"></i> Browse Courses
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-tasks"></i> My Quizzes
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-chart-line"></i> My Progress
        </a>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link mt-5">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<!-- Main Content -->
<div class="main-content">

    <!-- Topbar -->
    <div class="topbar">
        <h5><i class="fas fa-search me-2"></i>Browse Courses</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar"><%= user.getName().charAt(0) %></div>
            <div>
                <div class="fw-semibold"><%= user.getName() %></div>
                <small class="text-muted">Student</small>
            </div>
        </div>
    </div>

    <!-- Search Box -->
    <div class="search-box">
        <div class="input-group">
            <span class="input-group-text bg-white border-end-0">
                <i class="fas fa-search text-muted"></i>
            </span>
            <input type="text" id="searchInput" class="form-control border-start-0"
                   placeholder="Search courses...">
        </div>
    </div>

    <!-- Courses Grid -->
    <% if (courses == null || courses.isEmpty()) { %>
        <div class="text-center py-5">
            <i class="fas fa-book-open fa-4x mb-3" style="color:#ddd;"></i>
            <h5 class="text-muted">No courses available yet</h5>
            <p class="text-muted">Check back later for new courses!</p>
        </div>
    <% } else { %>
        <div class="row" id="courseGrid">
            <% for (Course course : courses) { %>
            <div class="col-md-4 course-item">
                <div class="course-card">
                    <div class="course-header">
                        <h5><%= course.getTitle() %></h5>
                        <small><i class="fas fa-user me-1"></i><%= course.getTeacherName() %></small>
                    </div>
                    <div class="course-body">
                        <p><%= course.getDescription() != null ? 
                            (course.getDescription().length() > 100 ? 
                            course.getDescription().substring(0, 100) + "..." : 
                            course.getDescription()) : "No description" %></p>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="badge-category">
                                <i class="fas fa-tag me-1"></i><%= course.getCategory() %>
                            </span>
                        </div>
                        <a href="<%= request.getContextPath() %>/course?action=enroll&courseId=<%= course.getId() %>"
                           class="btn btn-enroll"
                           onclick="return confirm('Enroll in <%= course.getTitle() %>?')">
                            <i class="fas fa-plus me-2"></i>Enroll Now
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Search functionality
    document.getElementById('searchInput').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let items = document.querySelectorAll('.course-item');
        items.forEach(item => {
            let text = item.innerText.toLowerCase();
            item.style.display = text.includes(filter) ? '' : 'none';
        });
    });
</script>
</body>
</html>