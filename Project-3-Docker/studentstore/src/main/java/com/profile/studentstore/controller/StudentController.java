package com.profile.studentstore.controller;

import com.profile.studentstore.pojo.Student;
import com.profile.studentstore.repo.StudentRepo;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
public class StudentController {
    @Autowired
    private StudentRepo studentRepo;
    @PostMapping("/addStudent")
    public ResponseEntity<String> addStudent(@RequestBody Student student) {
        studentRepo.save(student);
        return ResponseEntity.ok("student successfully added.");
    }

    @GetMapping("/getStudents")
    public ResponseEntity<List<Student>> getAllStudents() {
        List<Student> students = studentRepo.findAll();
        return ResponseEntity.ok().body(students);
    }
}
