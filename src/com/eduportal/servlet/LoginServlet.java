package com.eduportal.servlet;

import com.eduportal.dao.UserDAO;
import com.eduportal.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Show login page
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
    }

    // Handle login form submission
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate empty fields
        if (email == null || email.isEmpty() || 
            password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(email, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userRole", user.getRole());

            // Redirect based on role
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect(request.getContextPath() + "/jsp/admin/dashboard.jsp");
                    break;
                case "teacher":
                    response.sendRedirect(request.getContextPath() + "/jsp/teacher/dashboard.jsp");
                    break;
                case "student":
                    response.sendRedirect(request.getContextPath() + "/jsp/student/dashboard.jsp");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            }

        } else {
            // Login failed
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        }
    }
}