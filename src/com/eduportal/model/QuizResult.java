package com.eduportal.model;

public class QuizResult {

    private int id;
    private int studentId;
    private int quizId;
    private String quizTitle;
    private String courseTitle;
    private int score;
    private int total;
    private String attemptedAt;

    public QuizResult() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { 
        this.courseTitle = courseTitle; 
    }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }

    public String getAttemptedAt() { return attemptedAt; }
    public void setAttemptedAt(String attemptedAt) { 
        this.attemptedAt = attemptedAt; 
    }

    public int getPercentage() {
        if (total == 0) return 0;
        return (score * 100) / total;
    }
}