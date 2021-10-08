package com.gxuwz.crud.service;

import com.gxuwz.crud.bean.Employee;
import com.gxuwz.crud.bean.EmployeeExample;
import com.gxuwz.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class EmployeeService {
    @Autowired
    EmployeeMapper employeeMapper;

    public  void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);

    }

    public  void addEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }


    public List<Employee> getAll() {
        List<Employee> employees = employeeMapper.selectByExampleWithDept(null);

        return employees;

    }
     /*
     查看用户名是否存在，true为可用
      */
    public boolean exitEmpName(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
            //如果存在返回大于0，不存在返回0
        long count = employeeMapper.countByExample(employeeExample);
        return count==0;


    }

    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return  employee;
    }

    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    public void deleteBatch(List<Integer> del_ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpIdIn(del_ids);
        employeeMapper.deleteByExample(employeeExample);
    }
}
