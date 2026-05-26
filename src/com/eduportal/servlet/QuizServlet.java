package com.eduportal.servlet;

import com.eduportal.dao.CourseDAO;
import com.eduportal.dao.QuizDAO;
import com.eduportal.model.*;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/quiz")
public class QuizServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) action = "list";

        QuizDAO quizDAO = new QuizDAO();

        switch (action) {

            case "list":
                List<Quiz> quizzes = quizDAO.getQuizzesForStudent(user.getId());
                request.setAttribute("quizzes", quizzes);
                request.getRequestDispatcher("/jsp/student/quizList.jsp")
                       .forward(request, response);
                break;

            case "take":
                int quizId = Integer.parseInt(request.getParameter("quizId"));
                Quiz quiz = quizDAO.getQuizById(quizId);
                List<Question> questions = quizDAO.getQuestionsByQuiz(quizId);
                request.setAttribute("quiz", quiz);
                request.setAttribute("questions", questions);
                request.getRequestDispatcher("/jsp/student/takeQuiz.jsp")
                       .forward(request, response);
                break;

            case "teacherQuizzes":
                List<Quiz> teacherQuizzes = quizDAO
                       .getQuizzesByTeacher(user.getId());
                request.setAttribute("quizzes", teacherQuizzes);
                CourseDAO courseDAO = new CourseDAO();
                List<Course> courses = courseDAO
                       .getCoursesByTeacher(user.getId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/jsp/teacher/manageQuizzes.jsp")
                       .forward(request, response);
                break;

            case "createForm":
                CourseDAO cDAO = new CourseDAO();
                List<Course> teacherCourses = cDAO
                       .getCoursesByTeacher(user.getId());
                request.setAttribute("courses", teacherCourses);
                request.getRequestDispatcher("/jsp/teacher/createQuiz.jsp")
                       .forward(request, response);
                break;

            case "results":
                List<QuizResult> results = quizDAO
                       .getResultsByStudent(user.getId());
                request.setAttribute("results", results);
                request.getRequestDispatcher("/jsp/student/quizResults.jsp")
                       .forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            // Create quiz
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            int duration = Integer.parseInt(request.getParameter("duration"));

            Quiz quiz = new Quiz();
            quiz.setCourseId(courseId);
            quiz.setTitle(title);
            quiz.setDurationMinutes(duration);

            QuizDAO quizDAO = new QuizDAO();
            int quizId = quizDAO.createQuizAndGetId(quiz);

            if (quizId > 0) {
                // Add questions
                String[] questionTexts = request.getParameterValues("questionText");
                String[] optionsA = request.getParameterValues("optionA");
                String[] optionsB = request.getParameterValues("optionB");
                String[] optionsC = request.getParameterValues("optionC");
                String[] optionsD = request.getParameterValues("optionD");
                String[] correctOptions = request.getParameterValues("correctOption");

                if (questionTexts != null) {
                    for (int i = 0; i < questionTexts.length; i++) {
                        Question question = new Question();
                        question.setQuizId(quizId);
                        question.setQuestionText(questionTexts[i]);
                        question.setOptionA(optionsA[i]);
                        question.setOptionB(optionsB[i]);
                        question.setOptionC(optionsC[i]);
                        question.setOptionD(optionsD[i]);
                        question.setCorrectOption(correctOptions[i]);
                        quizDAO.addQuestion(question);
                    }
                }
                response.sendRedirect(request.getContextPath() +
                       "/quiz?action=teacherQuizzes");
            } else {
                request.setAttribute("error", "Failed to create quiz!");
                request.getRequestDispatcher("/jsp/teacher/createQuiz.jsp")
                       .forward(request, response);
            }

        } else if ("submit".equals(action)) {
            // Submit quiz answers
            int quizId = Integer.parseInt(request.getParameter("quizId"));
            QuizDAO quizDAO = new QuizDAO();
            List<Question> questions = quizDAO.getQuestionsByQuiz(quizId);

            int score = 0;
            int total = questions.size();

            for (Question q : questions) {
                String answer = request.getParameter("answer_" + q.getId());
                if (answer != null && answer.equals(q.getCorrectOption())) {
                    score++;
                }
            }

            QuizResult result = new QuizResult();
            result.setStudentId(user.getId());
            result.setQuizId(quizId);
            result.setScore(score);
            result.setTotal(total);
            quizDAO.saveResult(result);

            request.setAttribute("score", score);
            request.setAttribute("total", total);
            request.setAttribute("percentage", total > 0 ? (score * 100) / total : 0);
            request.getRequestDispatcher("/jsp/student/quizResult.jsp")
                   .forward(request, response);
        }
    }
}