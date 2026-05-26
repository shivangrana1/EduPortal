<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eduportal.model.User"%>
<%@ page import="com.eduportal.model.Quiz"%>
<%@ page import="com.eduportal.model.Question"%>
<%@ page import="java.util.List"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    User user = (User) userSession.getAttribute("user");
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    List<Question> questions = (List<Question>) request.getAttribute("questions");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduPortal - Take Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Segoe UI', sans-serif; }
        .quiz-header { background: linear-gradient(135deg, #667eea, #764ba2); color: white; padding: 25px 30px; border-radius: 15px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .quiz-header h4 { margin: 0; font-weight: 700; }
        .timer { background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 10px; font-size: 20px; font-weight: 700; }
        .question-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); margin-bottom: 20px; }
        .question-card h5 { font-weight: 700; color: #333; margin-bottom: 20px; }
        .option-label { display: flex; align-items: center; gap: 12px; padding: 12px 20px; border-radius: 10px; border: 2px solid #eee; margin-bottom: 10px; cursor: pointer; transition: all 0.3s; }
        .option-label:hover { border-color: #667eea; background: #f0f2ff; }
        .option-label input { display: none; }
        .option-label.selected { border-color: #667eea; background: #f0f2ff; }
        .option-badge { width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; color: white; flex-shrink: 0; }
        .btn-submit { background: linear-gradient(135deg, #667eea, #764ba2); border: none; color: white; border-radius: 10px; padding: 15px 40px; font-size: 18px; font-weight: 600; width: 100%; }
        .btn-submit:hover { opacity: 0.9; color: white; }
        .main-content { max-width: 800px; margin: 30px auto; padding: 0 20px; }
    </style>
</head>
<body>

<div class="main-content">
    <!-- Quiz Header -->
    <div class="quiz-header">
        <div>
            <h4><i class="fas fa-question-circle me-2"></i><%= quiz.getTitle() %></h4>
            <small><i class="fas fa-book me-1"></i><%= quiz.getCourseTitle() %></small>
        </div>
        <div class="timer" id="timer">
            <i class="fas fa-clock me-2"></i>
            <span id="timeDisplay"><%= quiz.getDurationMinutes() %>:00</span>
        </div>
    </div>

    <!-- Questions Form -->
    <form action="<%= request.getContextPath() %>/quiz" method="post">
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="quizId" value="<%= quiz.getId() %>">

        <% int qNum = 1; for(Question q : questions) { %>
        <div class="question-card">
            <h5>Q<%= qNum++ %>. <%= q.getQuestionText() %></h5>

            <label class="option-label" onclick="selectOption(this)">
                <input type="radio" name="answer_<%= q.getId() %>" value="A">
                <span class="option-badge" style="background:#4361ee;">A</span>
                <span><%= q.getOptionA() %></span>
            </label>

            <label class="option-label" onclick="selectOption(this)">
                <input type="radio" name="answer_<%= q.getId() %>" value="B">
                <span class="option-badge" style="background:#2ecc71;">B</span>
                <span><%= q.getOptionB() %></span>
            </label>

            <label class="option-label" onclick="selectOption(this)">
                <input type="radio" name="answer_<%= q.getId() %>" value="C">
                <span class="option-badge" style="background:#f39c12;">C</span>
                <span><%= q.getOptionC() %></span>
            </label>

            <label class="option-label" onclick="selectOption(this)">
                <input type="radio" name="answer_<%= q.getId() %>" value="D">
                <span class="option-badge" style="background:#e74c3c;">D</span>
                <span><%= q.getOptionD() %></span>
            </label>
        </div>
        <% } %>

        <button type="submit" class="btn btn-submit mb-4"
                onclick="return confirm('Submit quiz? You cannot change answers after submission.')">
            <i class="fas fa-paper-plane me-2"></i>Submit Quiz
        </button>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Timer
    let totalSeconds = <%= quiz.getDurationMinutes() %> * 60;
    const timerDisplay = document.getElementById('timeDisplay');

    const countdown = setInterval(() => {
        totalSeconds--;
        const mins = Math.floor(totalSeconds / 60);
        const secs = totalSeconds % 60;
        timerDisplay.textContent = mins + ':' + (secs < 10 ? '0' : '') + secs;
        if (totalSeconds <= 0) {
            clearInterval(countdown);
            document.querySelector('form').submit();
        }
    }, 1000);

    // Option selection highlight
    function selectOption(label) {
        const name = label.querySelector('input').name;
        document.querySelectorAll(`input[name="${name}"]`).forEach(input => {
            input.closest('.option-label').classList.remove('selected');
        });
        label.classList.add('selected');
        label.querySelector('input').checked = true;
    }
</script>
</body>
</html>