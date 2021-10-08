<%--
  Created by IntelliJ IDEA.
  User: 小死懒
  Date: 2021/10/3
  Time: 11:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>查询所有员工</title>

    <%
      pageContext.setAttribute("ssm_Path",request.getContextPath());
    %>
  <script type="text/javascript" src="${ssm_Path}/static/js/jquery-3.5.1.min.js"> </script>
<%--    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>--%>


    <link href="${ssm_Path}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css"  rel="stylesheet" />
   <script src="${ssm_Path}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>


</head>
<script >


    $(function () {
        var currend_page=$(".page_num").attr("value");
        var total_page=$(".page_total").attr("value");



        $("#add_model_but").click(function () {
            //清除表单内容与样式
            $("#add_emp_model form")[0].reset();
            $("#add_emp_model").find("*").removeClass("has-success has-error")
            $("#add_emp_model").find(".help-block").text("");

            //显示添加框前先查询到部门信息
            getDepts("#add_emp_model select");
            $("#add_emp_model").modal({
                backdrop:"static"
            });
        })
        //添加员工
        $("#emp_add_btn").click(function () {

            //先校验数据
            if(!validate_add_form()){
                return false;
            }
            if($(this).attr("ajax-va")=="error"){
                return  false;
            }
            $.ajax({
                url:"${ssm_Path}/addemp",
                type:"POST",
                data:$("#add_emp_model form").serialize(),
                success:function (result) {
                    //关闭添加窗口
                    $("#add_emp_model ").modal('hide');
                    to_page(total_page)

                }
            })
        })

        //名字可用校验
        $("#empName_input").change(function () {

            $.ajax({
                url:"${ssm_Path}/checkuser",
                type:"POST",
                data:"empName="+$("#empName_input").val(),
                success:function (result) {
                    console.log(result.code)
                    console.log(this)

                    if(result.code==100){
                        $("#empName_input").parent().removeClass("has-error has-success ")
                        $("#empName_input").parent().addClass("has-success")
                        $("#empName_input").next().text("用户名可用")
                        $("#emp_add_btn").attr("ajax-va","success")
                    }else {
                        $("#empName_input").parent().removeClass("has-error has-success ")
                        $("#empName_input").parent().addClass("has-error")
                        $("#empName_input").next().text(result.extend.msg_va)
                        $("#emp_add_btn").attr("ajax-va","error")
                    }

                }
            })
        })
         //修改功能
         $(document).on("click",".edit_btn",function () {


                  //获取部门
                 getDepts("#update_emp_model select")
                 //根据id获取员工信息
                getEmp($(this).attr("value"))
             $("#emp_update_btn").attr("update_id",$(this).attr("value"))


             $("#update_emp_model").modal({
                 backdrop:"static"
             });
         })

        //修改提交
        $("#emp_update_btn").click(function () {
            $.ajax({
                url:"${ssm_Path}/updateEmp/"+$(this).attr("update_id"),
                type:"PUT",
                data:$("#update_emp_model form").serialize(),
                success:function (result) {
                    $("#update_emp_model ").modal('hide');
                    to_page(currend_page)

                }
            })
        })

        //删除员工
        $(document).on("click",".delete_btn",function () {
            var $empName=$(this).parents("tr").find("th:eq(2)").text();
            var empId=$(this).attr("value");

            if(confirm("确认删【"+$empName+"】吗")){
                $.ajax({
                  url:"${ssm_Path}/deleteEmp/"+empId,
                    type:"DELETE",
                    success:function (result) {
                        to_page(currend_page)

                    }
                })

            }
        })

        //全选
        $(document).on("click","#check_all",function () {
            $(".check_item").prop("checked", $(this).prop("checked"));
        })

        $(document).on("click",".check_item",function () {
            var flag=$(".check_item:checked").length==$(".check_item").length
            $("#check_all").prop("checked", flag);
        })
        //批量删除
        $("#delete_emp_all_btn").click(function () {
            var empNames = "";
            var del_idstr = "";
            $.each($(".check_item:checked"),function () {
                 empNames+=$(this).parents("tr").find("th:eq(2)").text()+",";
                del_idstr+=$(this).parents("tr").find("th:eq(1)").text()+"-";
            })
            //去除多余末尾符号
            var empNames= empNames.substring(0, empNames.length - 1);
            var del_idstr= del_idstr.substring(0, del_idstr.length - 1);
            if(confirm("确定要删除【"+empNames+"】吗？")){
                $.ajax({
                    url:"${ssm_Path}/deleteEmp/"+del_idstr,
                    type:"DELETE",
                    success:function (result) {
                        to_page(currend_page)
                    }
                })
            }
        })

        //表单校验
        function validate_add_form(){
            var empName=$("#empName_input").val()
            var regName=/(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;

            $("#empName_input").parent().removeClass("has-error has-success ")
            $("#empName_input").next().text("")
            $("#email_input").parent().removeClass("has-error has-success ")
            $("#email_input").next().text("")
            if(!regName.test(empName)){
                // alert("用户名是2-5位中文或6-16位英数组合");
                $("#empName_input").parent().addClass("has-error");
                $("#empName_input").next().text("户名是2-5位中文或6-16位英数组合")
                return false;
            }else {
                $("#empName_input").parent().addClass("has-success");
                $("#empName_input").next().text("")

            }
            var empemail=$("#email_input").val()
            var regemail=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/
            if(!regemail.test(empemail)){
                // alert("邮箱格式不正确");
                $("#email_input").parent().addClass("has-error");
                $("#email_input").next().text("邮箱格式不正确")
                return false;
            }else {
                $("#email_input").parent().addClass("has-success");
                $("#email_input").next().text("邮箱可用")
            }

            return true;

        }


    }) //加载







     //查询部门
    function getDepts(ele) {
        $(ele).empty();
        $.ajax({
            url:"${ssm_Path}/depts",
            type:"POST",
            success:function (result) {
                // console.log(result)
                $.each(result.extend.depts,function () {
                    var optionEle=$("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo(ele)
                })

            }
            // {"code":100,"msg":"处理成功","extend":{"depts":[{"deptId":1,"deptName":"设计部"},
            // {"deptId":2,"deptName":"测试部"}]}}

        })
    }
    //查询员工信息
    function  getEmp(id) {
        $.ajax({
            url:"${ssm_Path}/emp/"+id,
            type:"GET",
            success:function (result) {
                console.log(result)
                var empData=result.extend.emp;
                $("#empName").text(empData.empName);
                $("#email_update").val(empData.email);
                $("#update_emp_model input[name=gender]").val([empData.gender])
                $("#update_emp_model  select").val([empData.dId])


            }

        })

    }
    //返回当前页
      function to_page(pn) {
        $.ajax({
            url:"${ssm_Path}/emps",
            data:"pn="+pn,
            async:false,
            success:function () {

                window.location="index.jsp"+"?pn="+pn+""
            }

        })

      }


</script>

<body>
<%--员工修改--%>
<div class="modal fade" id="update_emp_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-7">
                            <p class="form-control-static" id="empName" ></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control" name="email" id="email_update" placeholder="email">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender3" value="M" > 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender4" value="W"> 女
                            </label>
                        </div>

                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
            </div>
        </div>
    </div>
</div>


<!-- 添加员工 -->
<div class="modal fade" id="add_emp_model" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-7">
                            <input type="text" class="form-control" name="empName" id="empName_input" placeholder="empName">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control" name="email" id="email_input" placeholder="email">
                            <span  class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2" value="W"> 女
                            </label>
                        </div>

                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="emp_add_btn">提交</button>
            </div>
        </div>
    </div>
</div>
    <div class="container">
        <%--标题--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-SRUD</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-success" id="add_model_but">新增</button>
                <button class="btn btn-danger" id="delete_emp_all_btn" >删除</button>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover " >
                    <tr>
                        <th><input type="checkbox"  name="check_all" id="check_all"/></th>
                        <th>#</th>
                        <th>员工名</th>
                        <th>性别</th>
                        <th>邮件</th>
                        <th>部门名</th>
                        <th>操作</th>
                    </tr>
                    <c:forEach items="${pageInfo.list}" var="emps">
                        <tr>
                            <th><input type="checkbox" name="check_item" class="check_item"/></th>
                            <th>${emps.empId}</th>
                            <th>${emps.empName}</th>
                            <th>${emps.gender=="M"?"男":"女"}</th>
                            <th>${emps.email}</th>
                            <th>${emps.dept.deptName}</th>
                            <th>
                                <button id="update_btn"  value="${emps.empId}" class="btn btn-success btn-sm edit_btn">
                                    <span class="glyphicon glyphicon-pencil" ></span>编辑
                                </button>
                                <button id="detelde_btn"  value="${emps.empId}" class="btn btn-success btn-sm delete_btn">
                                    <span class="glyphicon glyphicon-trash" ></span>删除
                                </button>
                            </th>

                        </tr>
                    </c:forEach>

                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6 page_num" value="${pageInfo.pageNum}">
                当前 ${pageInfo.pageNum}页,总页数${pageInfo.pages},总记录数${pageInfo.total}
            </div>
            <div class="col-md-6 page_total" value="${pageInfo.pages}">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li><a href="emps?pn=1">首页</a></li>
                        <c:if test="${pageInfo.hasPreviousPage}">
                            <li>
                                <a href="emps?pn=${pageInfo.pageNum-1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>

                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">

                            <c:if test="${page_Num==pageInfo.pageNum}">
                                <li class="active"><a href="#">${page_Num}</a></li>
                            </c:if>
                            <c:if test="${page_Num!=pageInfo.pageNum}">
                                <li ><a href="emps?pn=${page_Num}">${page_Num}</a></li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${pageInfo.hasNextPage}">
                            <li>
                                <a href="emps?pn=${pageInfo.pageNum+1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>


                        <li><a href="emps?pn=${pageInfo.pages}">尾页</a></li>
                    </ul>
                </nav>

            </div>
        </div>
    </div>

</body>
</html>
