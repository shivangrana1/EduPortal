package com.eduportal.dao;

import com.eduportal.model.Quiz;
import com.eduportal.model.Question;
import com.eduportal.model.QuizResult;
import com.eduportal.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {

    public int createQuizAndGetId(Quiz quiz) {
        String sql = "INSERT INTO quizzes(course_id, title, duration_minutes) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, quiz.getCourseId());
            ps.setString(2, quiz.getTitle());
            ps.setInt(3, quiz.getDurationMinutes());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean addQuestion(Question question) {
        String sql = "INSERT INTO questions(quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES(?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, question.getQuizId());
            ps.setString(2, question.getQuestionText());
            ps.setString(3, question.getOptionA());
            ps.setString(4, question.getOptionB());
            ps.setString(5, question.getOptionC());
            ps.setString(6, question.getOptionD());
            ps.setString(7, question.getCorrectOption());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Quiz> getQuizzesByTeacher(int teacherId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, c.title as course_title FROM quizzes q JOIN courses c ON q.course_id = c.id WHERE c.teacher_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, teacherId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setCourseId(rs.getInt("course_id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDurationMinutes(rs.getInt("duration_minutes"));
                quiz.setCourseTitle(rs.getString("course_title"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return quizzes;
    }

    public List<Quiz> getQuizzesForStudent(int studentId) {
        List<Quiz> quizzes = new ArrayList<>();
        String sql = "SELECT q.*, c.title as course_title FROM quizzes q JOIN courses c ON q.course_id = c.id JOIN enrollments e ON c.id = e.course_id WHERE e.student_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setCourseId(rs.getInt("course_id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDurationMinutes(rs.getInt("duration_minutes"));
                quiz.setCourseTitle(rs.getString("course_title"));
                quizzes.add(quiz);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return quizzes;
    }

    public Quiz getQuizById(int id) {
        String sql = "SELECT q.*, c.title as course_title FROM quizzes q JOIN courses c ON q.course_id = c.id WHERE q.id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Quiz quiz = new Quiz();
                quiz.setId(rs.getInt("id"));
                quiz.setCourseId(rs.getInt("course_id"));
                quiz.setTitle(rs.getString("title"));
                quiz.setDurationMinutes(rs.getInt("duration_minutes"));
                quiz.setCourseTitle(rs.getString("course_title"));
                return quiz;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Question> getQuestionsByQuiz(int quizId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE quiz_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setQuizId(rs.getInt("quiz_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setOptionA(rs.getString("option_a"));
                q.setOptionB(rs.getString("option_b"));
                q.setOptionC(rs.getString("option_c"));
                q.setOptionD(rs.getString("option_d"));
                q.setCorrectOption(rs.getString("correct_option"));
                questions.add(q);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return questions;
    }

    public boolean saveResult(QuizResult result) {
        String sql = "INSERT INTO quiz_results(student_id, quiz_id, score, total) VALUES(?,?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, result.getStudentId());
            ps.setInt(2, result.getQuizId());
            ps.setInt(3, result.getScore());
            ps.setInt(4, result.getTotal());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<QuizResult> getResultsByStudent(int studentId) {
        List<QuizResult> results = new ArrayList<>();
        String sql = "SELECT qr.*, q.title as quiz_title, c.title as course_title FROM quiz_results qr JOIN quizzes q ON qr.quiz_id = q.id JOIN courses c ON q.course_id = c.id WHERE qr.student_id=? ORDER BY qr.attempted_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                QuizResult r = new QuizResult();
                r.setId(rs.getInt("id"));
                r.setStudentId(rs.getInt("student_id"));
                r.setQuizId(rs.getInt("quiz_id"));
                r.setQuizTitle(rs.getString("quiz_title"));
                r.setCourseTitle(rs.getString("course_title"));
                r.setScore(rs.getInt("score"));
                r.setTotal(rs.getInt("total"));
                r.setAttemptedAt(rs.getString("attempted_at"));
                results.add(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return results;
    }
}