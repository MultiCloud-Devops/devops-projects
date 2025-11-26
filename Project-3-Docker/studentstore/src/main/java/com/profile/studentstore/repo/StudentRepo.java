package com.profile.studentstore.repo;

import com.profile.studentstore.pojo.Student;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentRepo extends MongoRepository<Student, String> {

}
