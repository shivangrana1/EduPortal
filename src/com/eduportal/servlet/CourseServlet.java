package com.eduportal.servlet;

import com.eduportal.dao.CourseDAO;
import com.eduportal.model.Course;
import com.eduportal.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.util.List;

@WebServlet("/course")
public class CourseServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) action = "browse";

        CourseDAO courseDAO = new CourseDAO();

        switch (action) {

            case "browse":
                List<Course> allCourses = courseDAO.getAllCourses();
                request.setAttribute("courses", allCourses);
                request.getRequestDispatcher("/jsp/student/courses.jsp")
                       .forward(request, response);
                break;

            case "myCourses":
                List<Course> myCourses = courseDAO
                       .getEnrolledCourses(user.getId());
                request.setAttribute("courses", myCourses);
                request.getRequestDispatcher("/jsp/student/myCourses.jsp")
                       .forward(request, response);
                break;

            case "teacherCourses":
                List<Course> teacherCourses = courseDAO
                       .getCoursesByTeacher(user.getId());
                request.setAttribute("courses", teacherCourses);
                request.getRequestDispatcher("/jsp/teacher/courses.jsp")
                       .forward(request, response);
                break;

            case "createForm":
                request.getRequestDispatcher("/jsp/teacher/createCourse.jsp")
                       .forward(request, response);
                break;

            case "enroll":
                int courseId = Integer.parseInt(
                       request.getParameter("courseId"));
                boolean isEnrolled = courseDAO.isEnrolled(
                       user.getId(), courseId);
                if (!isEnrolled) {
                    courseDAO.enrollStudent(user.getId(), courseId);
                }
                response.sendRedirect(request.getContextPath() + 
                       "/course?action=myCourses");
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
            String title       = request.getParameter("title");
            String description = request.getParameter("description");
            String category    = request.getParameter("category");

            Course course = new Course();
            course.setTitle(title);
            course.setDescription(description);
            course.setTeacherId(user.getId());
            course.setCategory(category);

            CourseDAO courseDAO = new CourseDAO();
            boolean success = courseDAO.createCourse(course);

            if (success) {
                response.sendRedirect(request.getContextPath() + 
                       "/course?action=teacherCourses");
            } else {
                request.setAttribute("error", "Failed to create course!");
                request.getRequestDispatcher("/jsp/teacher/createCourse.jsp")
                       .forward(request, response);
            }
        }
    }
}