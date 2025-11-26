package com.profile.studentstore.pojo;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document
public class Student {
    @Id
    private String sid;
    private String name;
    private int rNo;
    private String place;

    public Student(String sid, String name, int rNo, String place) {
        this.sid = sid;
        this.name = name;
        this.rNo = rNo;
        this.place = place;
    }

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getrNo() {
        return rNo;
    }

    public void setrNo(int rNo) {
        this.rNo = rNo;
    }

    public String getPlace() {
        return place;
    }

    public void setPlace(String place) {
        this.place = place;
    }
}
