package com.gxuwz.crud.controller;

import com.gxuwz.crud.bean.Department;
import com.gxuwz.crud.bean.Msg;
import com.gxuwz.crud.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DepartmentController {
        @Autowired
        private DepartmentService departmentService;

        @ResponseBody
        @RequestMapping("/depts")
        public Msg getDepts(){
            List<Department> depts = departmentService.getDepts();
            return new Msg().success().add("depts",depts);

        }

}
