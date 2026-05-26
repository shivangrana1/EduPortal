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
    <title>EduPortal - Create Quiz</title>
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
        .form-card { background: white; border-radius: 15px; padding: 35px; box-shadow: 0 2px 15px rgba(0,0,0,0.08); margin-bottom: 25px; }
        .form-card h4 { font-weight: 700; color: #333; margin-bottom: 25px; }
        .form-control, .form-select { border-radius: 10px; padding: 12px 15px; border: 2px solid #eee; }
        .form-control:focus, .form-select:focus { border-color: #11998e; box-shadow: none; }
        .btn-create { background: linear-gradient(135deg, #11998e, #38ef7d); border: none; color: white; border-radius: 10px; padding: 12px 30px; font-weight: 600; }
        .btn-create:hover { opacity: 0.9; color: white; }
        .question-card { background: #f8f9fa; border-radius: 15px; padding: 25px; margin-bottom: 20px; border: 2px solid #eee; }
        .question-card h6 { font-weight: 700; color: #333; margin-bottom: 15px; }
        .btn-add-question { background: white; border: 2px dashed #11998e; color: #11998e; border-radius: 10px; padding: 12px 25px; font-weight: 600; width: 100%; }
        .btn-add-question:hover { background: #11998e; color: white; }
        .btn-remove { background: #fff0f0; border: none; color: #f5576c; border-radius: 8px; padding: 5px 12px; }
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
        <a href="<%= request.getContextPath() %>/course?action=createForm" class="nav-link">
            <i class="fas fa-plus-circle"></i> Create Course
        </a>
        <a href="<%= request.getContextPath() %>/quiz?action=teacherQuizzes" class="nav-link active">
            <i class="fas fa-question-circle"></i> Manage Quizzes
        </a>
        <a href="<%= request.getContextPath() %>/logout" class="nav-link mt-5">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<div class="main-content">
    <div class="form-card">
        <h4><i class="fas fa-question-circle me-2" style="color:#11998e;"></i>Create New Quiz</h4>

        <% if(request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/quiz" method="post">
            <input type="hidden" name="action" value="create">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label fw-semibold">Select Course</label>
                    <select name="courseId" class="form-select" required>
                        <option value="" disabled selected>Select a course</option>
                        <% if(courses != null) { for(Course c : courses) { %>
                            <option value="<%= c.getId() %>"><%= c.getTitle() %></option>
                        <% }} %>
                    </select>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label fw-semibold">Quiz Title</label>
                    <input type="text" name="title" class="form-control"
                           placeholder="Enter quiz title" required>
                </div>
                <div class="col-md-2 mb-3">
                    <label class="form-label fw-semibold">Duration (mins)</label>
                    <input type="number" name="duration" class="form-control"
                           value="10" min="1" max="120" required>
                </div>
            </div>

            <!-- Questions -->
            <h5 class="mt-3 mb-3 fw-bold">
                <i class="fas fa-list me-2" style="color:#11998e;"></i>Questions
            </h5>

            <div id="questionsContainer">
                <!-- Question 1 -->
                <div class="question-card" id="question_1">
                    <h6><i class="fas fa-circle me-2" style="color:#11998e;"></i>Question 1</h6>
                    <div class="mb-3">
                        <input type="text" name="questionText" class="form-control"
                               placeholder="Enter question" required>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-primary text-white">A</span>
                                <input type="text" name="optionA" class="form-control" placeholder="Option A" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-success text-white">B</span>
                                <input type="text" name="optionB" class="form-control" placeholder="Option B" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-warning text-white">C</span>
                                <input type="text" name="optionC" class="form-control" placeholder="Option C" required>
                            </div>
                        </div>
                        <div class="col-md-6 mb-2">
                            <div class="input-group">
                                <span class="input-group-text bg-danger text-white">D</span>
                                <input type="text" name="optionD" class="form-control" placeholder="Option D" required>
                            </div>
                        </div>
                    </div>
                    <div class="mt-2">
                        <label class="form-label fw-semibold">Correct Answer</label>
                        <select name="correctOption" class="form-select" required>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="C">C</option>
                            <option value="D">D</option>
                        </select>
                    </div>
                </div>
            </div>

            <button type="button" class="btn-add-question mb-4" onclick="addQuestion()">
                <i class="fas fa-plus me-2"></i>Add Another Question
            </button>

            <br>
            <button type="submit" class="btn btn-create">
                <i class="fas fa-save me-2"></i>Save Quiz
            </button>
            <a href="<%= request.getContextPath() %>/quiz?action=teacherQuizzes"
               class="btn btn-outline-secondary ms-2 rounded-pill px-4">
                Cancel
            </a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let questionCount = 1;

    function addQuestion() {
        questionCount++;
        const container = document.getElementById('questionsContainer');
        const div = document.createElement('div');
        div.className = 'question-card';
        div.id = 'question_' + questionCount;
        div.innerHTML = `
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h6><i class="fas fa-circle me-2" style="color:#11998e;"></i>Question ${questionCount}</h6>
                <button type="button" class="btn-remove" onclick="removeQuestion('question_${questionCount}')">
                    <i class="fas fa-times"></i> Remove
                </button>
            </div>
            <div class="mb-3">
                <input type="text" name="questionText" class="form-control"
                       placeholder="Enter question" required>
            </div>
            <div class="row">
                <div class="col-md-6 mb-2">
                    <div class="input-group">
                        <span class="input-group-text bg-primary text-white">A</span>
                        <input type="text" name="optionA" class="form-control" placeholder="Option A" required>
                    </div>
                </div>
                <div class="col-md-6 mb-2">
                    <div class="input-group">
                        <span class="input-group-text bg-success text-white">B</span>
                        <input type="text" name="optionB" class="form-control" placeholder="Option B" required>
                    </div>
                </div>
                <div class="col-md-6 mb-2">
                    <div class="input-group">
                        <span class="input-group-text bg-warning text-white">C</span>
                        <input type="text" name="optionC" class="form-control" placeholder="Option C" required>
                    </div>
                </div>
                <div class="col-md-6 mb-2">
                    <div class="input-group">
                        <span class="input-group-text bg-danger text-white">D</span>
                        <input type="text" name="optionD" class="form-control" placeholder="Option D" required>
                    </div>
                </div>
            </div>
            <div class="mt-2">
                <label class="form-label fw-semibold">Correct Answer</label>
                <select name="correctOption" class="form-select" required>
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                </select>
            </div>
        `;
        container.appendChild(div);
    }

    function removeQuestion(id) {
        document.getElementById(id).remove();
    }
</script>
</body>
</html>