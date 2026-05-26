<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    int score = (Integer) request.getAttribute("score");
    int total = (Integer) request.getAttribute("total");
    int percentage = (Integer) request.getAttribute("percentage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Quiz Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .result-card { background: white; border-radius: 20px; padding: 50px; box-shadow: 0 20px 60px rgba(0,0,0,0.1); text-align: center; max-width: 500px; width: 100%; }
        .score-circle { width: 150px; height: 150px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 25px; font-size: 36px; font-weight: 700; color: white; }
        .score-excellent { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .score-good { background: linear-gradient(135deg, #4facfe, #00f2fe); }
        .score-poor { background: linear-gradient(135deg, #f093fb, #f5576c); }
        .result-card h3 { font-weight: 700; color: #333; margin-bottom: 10px; }
        .result-card p { color: #888; margin-bottom: 25px; }
        .stat-row { display: flex; justify-content: center; gap: 30px; margin-bottom: 30px; }
        .stat-item { text-align: center; }
        .stat-item h4 { font-weight: 700; color: #333; margin: 0; }
        .stat-item small { color: #888; }
        .btn-home { background: linear-gradient(135deg, #667eea, #764ba2); border: none; color: white; border-radius: 10px; padding: 12px 30px; font-weight: 600; text-decoration: none; display: inline-block; margin: 5px; }
        .btn-home:hover { opacity: 0.9; color: white; }
        .progress { height: 15px; border-radius: 10px; margin-bottom: 25px; }
    </style>
</head>
<body>

<div class="result-card">
    <% String scoreClass = percentage >= 80 ? "score-excellent" : percentage >= 50 ? "score-good" : "score-poor"; %>
    <% String emoji = percentage >= 80 ? "🎉" : percentage >= 50 ? "👍" : "📚"; %>

    <div class="score-circle <%= scoreClass %>">
        <%= percentage %>%
    </div>

    <h3><%= emoji %> Quiz Completed!</h3>
    <p>
        <% if(percentage >= 80) { %>Excellent work! You did amazing!
        <% } else if(percentage >= 50) { %>Good job! Keep practicing!
        <% } else { %>Keep studying! You can do better!<% } %>
    </p>

    <div class="progress">
        <div class="progress-bar <%= percentage >= 80 ? "bg-success" : percentage >= 50 ? "bg-info" : "bg-danger" %>"
             style="width:<%= percentage %>%"></div>
    </div>

    <div class="stat-row">
        <div class="stat-item">
            <h4 style="color:#11998e;"><%= score %></h4>
            <small>Correct</small>
        </div>
        <div class="stat-item">
            <h4 style="color:#f5576c;"><%= total - score %></h4>
            <small>Wrong</small>
        </div>
        <div class="stat-item">
            <h4 style="color:#667eea;"><%= total %></h4>
            <small>Total</small>
        </div>
    </div>

    <a href="<%= request.getContextPath() %>/quiz?action=list" class="btn-home btn">
        <i class="fas fa-tasks me-2"></i>Back to Quizzes
    </a>
    <a href="<%= request.getContextPath() %>/jsp/student/dashboard.jsp" class="btn-home btn">
        <i class="fas fa-home me-2"></i>Dashboard
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>