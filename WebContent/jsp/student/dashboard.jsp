<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    if (!user.getRole().equals("student")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Student Dashboard</title>
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
        .sidebar .logo {
            text-align: center; padding: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 20px;
        }
        .sidebar .logo i { font-size: 40px; color: white; }
        .sidebar .logo h4 { color: white; margin-top: 10px; font-weight: 700; }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 25px;
            display: flex; align-items: center;
            gap: 12px; transition: all 0.3s;
            text-decoration: none; font-size: 15px;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white; border-left: 4px solid white;
        }
        .sidebar .nav-link i { width: 20px; text-align: center; }
        .main-content { margin-left: 250px; padding: 30px; }
        .topbar {
            background: white; border-radius: 15px;
            padding: 15px 25px;
            display: flex; justify-content: space-between;
            align-items: center; margin-bottom: 30px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
        }
        .topbar h5 { margin: 0; color: #333; font-weight: 600; }
        .user-avatar {
            width: 40px; height: 40px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; align-items: center;
            justify-content: center; color: white; font-weight: 700;
        }
        .stat-card {
            background: white; border-radius: 15px;
            padding: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px; transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card .icon {
            width: 60px; height: 60px; border-radius: 15px;
            display: flex; align-items: center;
            justify-content: center; font-size: 24px;
            color: white; margin-bottom: 15px;
        }
        .stat-card h3 { font-size: 32px; font-weight: 700; margin: 0; color: #333; }
        .stat-card p { color: #888; margin: 5px 0 0; font-size: 14px; }
        .welcome-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 15px; padding: 30px; color: white;
            margin-bottom: 25px;
            box-shadow: 0 2px 15px rgba(102,126,234,0.4);
        }
        .welcome-card h3 { font-weight: 700; margin-bottom: 5px; }
        .section-card {
            background: white; border-radius: 15px;
            padding: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }
        .section-card h5 {
            font-weight: 700; color: #333;
            margin-bottom: 20px; padding-bottom: 10px;
            border-bottom: 2px solid #f0f2f5;
        }
        .quick-link {
            display: flex; align-items: center;
            gap: 15px; padding: 15px; border-radius: 10px;
            background: #f8f9fa; margin-bottom: 10px;
            text-decoration: none; color: #333; transition: all 0.3s;
        }
        .quick-link:hover { background: #667eea; color: white; }
        .quick-link .icon {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center;
            justify-content: center; font-size: 18px;
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
        <a href="<%= request.getContextPath() %>/jsp/student/dashboard.jsp" class="nav-link active">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/course?action=myCourses" class="nav-link">
            <i class="fas fa-book"></i> My Courses
        </a>
        <a href="<%= request.getContextPath() %>/course?action=browse" class="nav-link">
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
        <h5><i class="fas fa-home me-2"></i>Student Dashboard</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar"><%= user.getName().charAt(0) %></div>
            <div>
                <div class="fw-semibold"><%= user.getName() %></div>
                <small class="text-muted">Student</small>
            </div>
        </div>
    </div>

    <!-- Welcome Card -->
    <div class="welcome-card">
        <h3>Welcome back, <%= user.getName() %>! 👋</h3>
        <p>Continue your learning journey today.</p>
    </div>

    <!-- Stats Row -->
    <div class="row">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #667eea, #764ba2);">
                    <i class="fas fa-book"></i>
                </div>
                <h3>0</h3>
                <p>Enrolled Courses</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                    <i class="fas fa-tasks"></i>
                </div>
                <h3>0</h3>
                <p>Quizzes Taken</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                    <i class="fas fa-trophy"></i>
                </div>
                <h3>0%</h3>
                <p>Average Score</p>
            </div>
        </div>
    </div>

    <!-- Quick Links -->
    <div class="row">
        <div class="col-md-6">
            <div class="section-card">
                <h5><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                <a href="<%= request.getContextPath() %>/course?action=browse" class="quick-link">
                    <div class="icon" style="background:#e8f4fd;">
                        <i class="fas fa-search" style="color:#667eea;"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Browse Courses</div>
                        <small>Find new courses to enroll</small>
                    </div>
                </a>
                <a href="<%= request.getContextPath() %>/course?action=myCourses" class="quick-link">
                    <div class="icon" style="background:#fde8f4;">
                        <i class="fas fa-play" style="color:#f5576c;"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">My Courses</div>
                        <small>Resume your enrolled courses</small>
                    </div>
                </a>
                <a href="#" class="quick-link">
                    <div class="icon" style="background:#e8fdf0;">
                        <i class="fas fa-pen" style="color:#2ecc71;"></i>
                    </div>
                    <div>
                        <div class="fw-semibold">Take a Quiz</div>
                        <small>Test your knowledge</small>
                    </div>
                </a>
            </div>
        </div>
        <div class="col-md-6">
            <div class="section-card">
                <h5><i class="fas fa-clock me-2"></i>Recent Activity</h5>
                <div class="text-center text-muted py-4">
                    <i class="fas fa-history fa-3x mb-3" style="color:#ddd;"></i>
                    <p>No recent activity yet.<br>Start learning today!</p>
                </div>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>