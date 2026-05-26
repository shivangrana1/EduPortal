<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%@ page import="com.eduportal.dao.UserDAO"%>
<%@ page import="java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    if (!user.getRole().equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    UserDAO userDAO = new UserDAO();
    List<User> allUsers = userDAO.getAllUsers();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .sidebar {
            background: linear-gradient(180deg, #f093fb 0%, #f5576c 100%);
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
            background: linear-gradient(135deg, #f093fb, #f5576c);
            display: flex; align-items: center;
            justify-content: center;
            color: white; font-weight: 700;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            transition: transform 0.3s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        .stat-card .icon {
            width: 60px; height: 60px;
            border-radius: 15px;
            display: flex; align-items: center;
            justify-content: center;
            font-size: 24px; color: white;
            margin-bottom: 15px;
        }
        .stat-card h3 { font-size: 32px; font-weight: 700; margin: 0; color: #333; }
        .stat-card p { color: #888; margin: 5px 0 0; font-size: 14px; }
        .welcome-card {
            background: linear-gradient(135deg, #f093fb, #f5576c);
            border-radius: 15px;
            padding: 30px; color: white;
            margin-bottom: 25px;
            box-shadow: 0 2px 15px rgba(240,147,251,0.4);
        }
        .welcome-card h3 { font-weight: 700; margin-bottom: 5px; }
        .section-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }
        .section-card h5 {
            font-weight: 700; color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f2f5;
        }
        .badge-role {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-admin { background: #fde8f4; color: #f5576c; }
        .badge-teacher { background: #e8fdf0; color: #11998e; }
        .badge-student { background: #e8f4fd; color: #667eea; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <div class="logo">
        <i class="fas fa-user-shield"></i>
        <h4>EduPortal</h4>
    </div>
    <nav>
        <a href="dashboard.jsp" class="nav-link active">
            <i class="fas fa-home"></i> Dashboard
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-users"></i> Manage Users
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-book"></i> Manage Courses
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
        <a href="#" class="nav-link">
            <i class="fas fa-cog"></i> Settings
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
        <h5><i class="fas fa-home me-2"></i>Admin Dashboard</h5>
        <div class="d-flex align-items-center gap-2">
            <div class="user-avatar">
                <%= user.getName().charAt(0) %>
            </div>
            <div>
                <div class="fw-semibold"><%= user.getName() %></div>
                <small class="text-muted">Administrator</small>
            </div>
        </div>
    </div>

    <!-- Welcome Card -->
    <div class="welcome-card">
        <h3>Welcome, <%= user.getName() %>! 🛡️</h3>
        <p>Manage users, courses and monitor the platform.</p>
    </div>

    <!-- Stats Row -->
    <div class="row">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                    <i class="fas fa-users"></i>
                </div>
                <h3><%= allUsers.size() %></h3>
                <p>Total Users</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #11998e, #38ef7d);">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <h3>
                    <%
                        int teacherCount = 0;
                        for(User u : allUsers) {
                            if(u.getRole().equals("teacher")) teacherCount++;
                        }
                    %>
                    <%= teacherCount %>
                </h3>
                <p>Total Teachers</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card">
                <div class="icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <h3>
                    <%
                        int studentCount = 0;
                        for(User u : allUsers) {
                            if(u.getRole().equals("student")) studentCount++;
                        }
                    %>
                    <%= studentCount %>
                </h3>
                <p>Total Students</p>
            </div>
        </div>
    </div>

    <!-- Users Table -->
    <div class="section-card">
        <h5><i class="fas fa-users me-2"></i>All Users</h5>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(User u : allUsers) { %>
                    <tr>
                        <td><%= u.getId() %></td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <div class="user-avatar" style="width:35px;height:35px;font-size:14px;">
                                    <%= u.getName().charAt(0) %>
                                </div>
                                <%= u.getName() %>
                            </div>
                        </td>
                        <td><%= u.getEmail() %></td>
                        <td>
                            <span class="badge-role badge-<%= u.getRole() %>">
                                <%= u.getRole().toUpperCase() %>
                            </span>
                        </td>
                        <td>
                            <button class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-trash"></i>
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>