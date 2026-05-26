package com.eduportal.model;

public class Quiz {

    private int id;
    private int courseId;
    private String courseTitle;
    private String title;
    private int durationMinutes;

    public Quiz() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public String getCourseTitle() { return courseTitle; }
    public void setCourseTitle(String courseTitle) { 
        this.courseTitle = courseTitle; 
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { 
        this.durationMinutes = durationMinutes; 
    }
}