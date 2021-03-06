<%@ page import="com.bean.RoomBean" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.bean.ScheduleBean" %>
<%@ page import="com.dao.*" %>
<%@ page import="com.core.SettingProp" %><%--
  Created by IntelliJ IDEA.
  User: recycle
  Date: 12/25 0025
  Time: 14:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>教室课表</title>
    <!-- Loading Bootstrap -->
    <link href="css/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet">
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="js/vendor/jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="js/flat-ui.min.js"></script>
    <script src="js/application.js"></script>
    <script src="js/layer/layer.js"></script>
    <script src="js/jquery.table2excel.js"></script>

    <script src="js/myJs.js"></script>
    <!-- icon -->
    <link rel = "icon" href = "img/favicon.ico" type = "image/x-icon">
    <link rel = "Shortcut Icon" href = "img/favicon.ico" type = "image/x-icon">

    <script>
        function autoFillRemain() {
//            alert("开始");
            $.ajax({
                type:"post",
                url:"schedule?page=fillAll",
                dataType:"json",
                success:function (data) {
                    if(data.state == "12")  {
                        layer.msg('操作成功！',{icon:1,time:1000},function () {
                            location.reload();
                        });
                    }
                    else  {
                        layer.msg('出现时间冲突',{icon:0,time:1000},function () {
                            location.reload();
                        });
                    }
                }
            })
        }
        function setting() {
            layer.prompt({title: '设置一天的课时', formType: 2}, function(text, index){
                layer.close(index);
                $.ajax({
                    type:"post",
                    url:"setting?num=" + encodeURI(text),dataType:"json",
                    success:function (data) {
                        layer.msg(data.state);
                    }
                });
            });
        }
    </script>
</head>
<body>
<%@include file="banner.jsp"%>
<!-- navbar -->
<%
    if(new UserDao().userType(loginName) == 1) {
%>
<style>
    .navbar-static-top {
        margin-bottom: 19px;
    }
</style>
<div class="navbar navbar-default navbar-static-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
            </button>
            <a class="navbar-brand" href="#">Welcome</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp"><span class="fui-home"></span></a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">基础信息 <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="groupInfo.jsp">班级</a></li>
                        <li><a href="roomInfo.jsp">教室</a></li>
                        <li><a href="courseInfo.jsp">课程</a></li>
                        <li><a href="teacherInfo.jsp">教师</a></li>
                        <li><a href="workInfo.jsp">任务</a></li>
                    </ul>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">排课 <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="fillTeacher.jsp">安排教师</a></li>
                        <li><a href="fillRoom.jsp">安排教室</a></li>
                        <li><a href="fillTime.jsp">安排时间</a></li>
                    </ul>
                </li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">课表 <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="groupSchedule.jsp">班级课表</a></li>
                        <li><a href="roomSchedule.jsp">教室课表</a></li>
                        <li><a href="teacherSchedule.jsp">教师课表</a></li>
                    </ul>
                </li>
                <li><a class="btn" onclick="autoFillRemain();">自动排课</a></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">

                <li><a onclick="setting();"><span class="fui-gear"></span></a></li>                 <li class="active"><a href="userCtrl?action=logout"><b>管理员</b> <%=loginName%></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</div>
<%
}
else {
    String URI = request.getRequestURI();
    String[] URIs = URI.split("/");
    String path = URIs[URIs.length-1];
    System.out.println(path.trim());
    if("errorPage.jsp".equals(path.trim()) || "main.jsp".equals(path.trim()) || "teacherSchedule.jsp".equals(path.trim()) ||
            "roomSchedule.jsp".equals(path.trim()) || "groupSchedule.jsp".equals(path.trim())) {
%>
<div class="navbar navbar-default navbar-static-top" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
            </button>
            <a class="navbar-brand" href="#">Welcome</a>
        </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp"><span class="fui-home"></span></a></li>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">课表 <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li><a href="groupSchedule.jsp">班级课表</a></li>
                        <li><a href="roomSchedule.jsp">教室课表</a></li>
                        <li><a href="teacherSchedule.jsp">教师课表</a></li>
                    </ul>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li class="active"><a href="userCtrl?action=logout"><b>用户</b> <%=loginName%></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</div>
<%
        }
        else {
            response.sendRedirect("main.jsp");
        }
    }
%>
<!-- /navbar -->
<%
    String idRoom = request.getParameter("idRoom");
    if(idRoom == null || "".equals(idRoom)) {
        idRoom = "0";
    }
%>
<div class="container">
    <div class="row page-header" style="margin-top: 10px;">
        <div class="col-md-6 col-md-offset-1">
            <div>
                <h5>教室课表</h5>
            </div>
        </div>
        <div style="margin-top: 2px" class="col-md-5">
            <div class="row">
                <div class="col-md-9">
                    <form style="margin:15px 0px 0px" name="group" id="groupSelect">
                        <div class="control-group">
                            <label for="selectRoom">教室： </label>
                            <select data-toggle="select" style="background-color: inherit;border: 2px" class="select select-default select-sm" id="selectRoom" name="idRoom" onchange="formsubmit(this);">
                                <%
                                    if(idRoom.equals("0")) {
                                %>
                                <option value="0" selected="true">全部</option>
                                <%
                                }
                                else {
                                %>
                                <option value="0">全部</option>
                                <%
                                    }
                                %>
                                <%
                                    ArrayList<RoomBean> roomBeanArrayList = new RoomDao().queryAll();
                                    for(RoomBean roomBean : roomBeanArrayList) {
                                        if(idRoom.equals(Integer.toString(roomBean.getIdRoom()))) {
                                %>
                                <option value="<%=roomBean.getIdRoom()%>" selected="true"><%=roomBean.getRoomName()%></option>
                                <%
                                }
                                else {
                                %>
                                <option value="<%=roomBean.getIdRoom()%>"><%=roomBean.getRoomName()%></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                        </div>
                    </form>
                </div>
                <div style="margin:15px 0px 0px" class="col-md-3">
                    <script>
                        function exportExcel() {
                            $("table").table2excel({
                                name:"<%=new RoomDao().roomName(Integer.parseInt(idRoom))%>",
                                filename:"<%=new RoomDao().roomName(Integer.parseInt(idRoom))%>"
                            });
                        }
                    </script>
                    <a href="#" onclick="exportExcel();">导出</a>
                </div>
            </div>
        </div>
    </div>
    <div class="jumbotron">
        <%
            ArrayList<ScheduleBean> scheduleBeanArrayList = new ArrayList<>();
            if("0".equals(idRoom)) {
                for(RoomBean roomBean : roomBeanArrayList) {
                    scheduleBeanArrayList = new ScheduleDao().queryByRoom(Integer.toString(roomBean.getIdRoom()));
        %>
        <div class="row table">
            <div class="row">
                <div class="col-md-12 text-center">
                    <p>教室：<%=new RoomDao().roomName(roomBean.getIdRoom())%>&nbsp;课程表</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 col-lg-8 col-md-offset-2">
                    <table style="width:100%" class="table-bordered text-center">
                        <thead><td>&nbsp;&nbsp;</td><td>Monday</td><td>Tuesday</td><td>Wednesday</td><td>Thirsday</td><td>Friday</td></thead>
                        <%
                            for (int i = 0; i < new SettingProp().getNum(); i++) {
                        %>
                        <tbody>
                        <td>第<%=i+1%>节</td>
                        <%
                            for (int j = 0; j < 5; j++) {
                        %>
                        <td>
                            <%
                                for (ScheduleBean scheduleBean : scheduleBeanArrayList) {
                                    if(scheduleBean.getTime() == 5*i+j+1) {
                                        out.print(new CourseDao().courseName(scheduleBean.getIdCourse()) + "<br>" + new TeacherDao().teacherName(scheduleBean.getIdTeacher()) +
                                                "<br>" + new GroupDao().groupName(scheduleBean.getIdGroup()));
                                    }
                                }
                            %>
                        </td>
                        <%
                            }
                        %>
                        </tbody>
                        <%
                            }
                        %>
                    </table>
                </div>
            </div>
        </div>
        <%
            }
        }
        else {
            scheduleBeanArrayList = new ScheduleDao().queryByRoom(idRoom);
        %>
        <div class="row table">
            <div class="row">
                <div class="col-md-12 text-center">
                    <p>教室：
                        <%=new RoomDao().roomName(Integer.parseInt(idRoom))%>&nbsp;课程表</p>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 col-lg-8 col-md-offset-2">
                    <table  style="width:100%" class="table-bordered text-center">
                        <thead><td>&nbsp;&nbsp;</td><td>Monday</td><td>Tuesday</td><td>Wednesday</td><td>Thirsday</td><td>Friday</td></thead>
                        <%
                            for (int i = 0; i < new SettingProp().getNum(); i++) {
                        %>
                        <thead>
                        <td>第<%=i+1%>节</td>
                        <%
                            for (int j = 0; j < 5; j++) {
                        %>
                        <td>
                            <%
                                for (ScheduleBean scheduleBean : scheduleBeanArrayList) {
                                    if(scheduleBean.getTime() == 5*i+j+1) {
                                        out.print(new CourseDao().courseName(scheduleBean.getIdCourse()) + "<br>" + new TeacherDao().teacherName(scheduleBean.getIdTeacher()) +
                                                "<br>" + new GroupDao().groupName(scheduleBean.getIdGroup()));
                                    }
                                }
                            %>
                        </td>
                        <%
                            }
                        %>
                        </thead>
                        <%
                            }
                        %>
                    </table>
                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
