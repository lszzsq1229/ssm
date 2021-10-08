package com.gxuwz.crud.test;

import com.gxuwz.crud.bean.Department;
import com.gxuwz.crud.bean.DepartmentExample;
import com.gxuwz.crud.bean.Employee;
import com.gxuwz.crud.dao.DepartmentMapper;
import com.gxuwz.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Service;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;


/*
   测试mapper
    1.导入spring-test包
    2.@ContextConfiguration(locations = "classpath:applicationContext.xml")
    指定spring的配置文件位置
    @Autowired组件即可
 */
//@Runwith(SpringJUnit4ClassRunner.class)
//@ContextConfiguration(locations = "classpath:applicationContext.xml")
@Service
public class MapperTest {
    @Autowired
    EmployeeMapper employeeMapper;


@Test
    public void test02(){
        System.out.println(employeeMapper);
        employeeMapper.insertSelective(new Employee(null, "aaaa", "w", "@ADAA", 1));

    }


    @Test
    public void test01(){
        ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext.xml");
        DepartmentMapper departmentMapper = context.getBean(DepartmentMapper.class);
//        EmployeeMapper employeeMapper = context.getBean(EmployeeMapper.class);
        SqlSession sqlSession = (SqlSession) context.getBean("sqlSession");

        System.out.println(departmentMapper);
        //插入部门
//        departmentMapper.insertSelective(new Department(null, "测试部5"));
//        departmentMapper.insertSelective(new Department(null, "测试部6"));
        //删除部门
//        departmentMapper.deleteByPrimaryKey(3);
//        int i = employeeMapper.insertSelective(new Employee(null, "李四", "M", "李四@gxwuz.com", 1));
//        System.out.println(i);
//        批量插入
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i <2 ; i++) {
            String uuid = UUID.randomUUID().toString().substring(0, 5);
            mapper.insertSelective(new Employee(null, uuid, "M", uuid + "@gxuwz.com", 1));
        }


    }




}
