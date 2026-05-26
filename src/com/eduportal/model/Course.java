package com.eduportal.model;

public class Course {

    private int id;
    private String title;
    private String description;
    private int teacherId;
    private String teacherName;
    private String category;
    private String createdAt;

    // Default Constructor
    public Course() {}

    // Parameterized Constructor
    public Course(int id, String title, String description, 
                  int teacherId, String category) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.teacherId = teacherId;
        this.category = category;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { 
        this.description = description; 
    }

    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }

    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { 
        this.teacherName = teacherName; 
    }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "Course{id=" + id + ", title=" + title + 
               ", category=" + category + "}";
    }
}