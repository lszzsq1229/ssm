package com.gxuwz.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.gxuwz.crud.bean.Employee;
import com.gxuwz.crud.bean.Msg;
import com.gxuwz.crud.service.EmployeeService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /*
    删除员工
      批量和单个删除二合一
     */
    @RequestMapping(value = "/deleteEmp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable("ids")String ids){

        if(ids.contains("-")){
            List<Integer> del_ids=new ArrayList<Integer>();
            String[] str_ids = ids.split("-");
            for(String string :str_ids){
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deleteBatch(del_ids);


        }else {
            employeeService.deleteEmp(Integer.parseInt(ids));
        }

        return  Msg.success();

    }

    /* 修改员工信息

     */
    @RequestMapping(value = "/updateEmp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg updateEmp(Employee employee){
        System.out.println(employee);
        employeeService.updateEmp(employee);
        return  Msg.success();

    }

    /*
    根据id获取员工信息
     */
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("empId") Integer empId) {
        Employee employee = employeeService.getEmp(empId);
        return Msg.success().add("emp", employee);
    }


    @RequestMapping(value = "/empsforAjax")
    @ResponseBody
    public Msg getEmpsforAjax(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        //使用分页插件pagehelper(1.导入依赖2.mybatis.xml中配置PageInterceptor这个plugin，可以调用方法了）
        PageHelper.startPage(pn, 5);//5是1页的记录数，pn表示当前页
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo封装查询结果，封装了分页的详细信息，
        PageInfo pageInfo = new PageInfo(emps, 5);//5表示连续显示的页数

        return Msg.success().add("pageInfo", pageInfo);
    }

    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") @PathVariable Integer pn, Model model) {
        //使用分页插件pagehelper(1.导入依赖2.mybatis.xml中配置PageInterceptor这个plugin，可以调用方法了）
        PageHelper.startPage(pn, 5);//5是1页的记录数，pn表示当前页
        List<Employee> emps = employeeService.getAll();
        //使用pageInfo封装查询结果，封装了分页的详细信息，
        PageInfo pageInfo = new PageInfo(emps, 5);//5表示连续显示的页数

        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }




    @RequestMapping(value = "/addemp", method = RequestMethod.POST)
    @ResponseBody //封装成json数据返回
    public Msg addEmp(Employee employee) {

        employeeService.addEmp(employee);
        return Msg.success();
    }

    /*
       校验用户名是否可用
     */
    @RequestMapping(value = "checkuser", method = RequestMethod.POST)
    @ResponseBody
    public Msg checkuser(String empName) {

        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5}[0-9]{0,10})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("msg_va", "用户名是2-5位中文或6-16位英数组合(后)");
        }
        boolean b = employeeService.exitEmpName(empName);
        if (b) {
            return Msg.success();
        } else {
            return Msg.fail().add("msg_va", "用户名不可用");
        }


    }
}
