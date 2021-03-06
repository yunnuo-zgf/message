﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<title>海文在线短信平台</title>
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/sms.css" />
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/alertify.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath }/scripts/jquery.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/scripts/alertify.js"></script>
<script type="text/javascript">
	/*${pageContext.request.contextPath}/msg.do?param=delete  */
    
	$(function() {
		showMessages(1, 3);//显示第一页三条数据
	})
	function del(id) {
		alertify.confirm('删除信息','是否确定删除?',function() {
				$.get(
					"${pageContext.request.contextPath}/msg/delete",
					{"id":id},	
					function(data){
						if(data=="success"){
							alertify.success('删除成功');
						showMessages(1, 3);
						}
					});
				}, function() {
						alertify.error('取消操作')
				}).set('modal', false);

	}


	/*分页函数  */
	function showMessages(pageNo, pageSize) {
		$.get("${pageContext.request.contextPath}/msg/querybyloginid", {
			"pageNo" : pageNo,
			"pageSize" : pageSize
		}, function(data) {
			var $ul =$(".messageList>ul");
			$ul.empty();//清空ul标签中所有的标签
			//循环
			for(var i = 0;i<data.msgList.length;i++){
				var $li="";
				if(data.msgList[i].state==1){
					$li=$("<li class='unReaded'></li>");//jQuery创建一个元素
				}else{
					$li=$("<li></li>");//jQuery创建一个元素
				}
				
				var $em1=$("<em>"+data.msgList[i].msg_create_date+"</em>");
				var $em2=$("<em><a href='${pageContext.request.contextPath}/user/queryallusers?sendid="+data.msgList[i].sendid +"'>回信</a></em>");
				var $em3=$("<em><a href='javascript:del("+data.msgList[i].id+")'>删除</a></em>");
				var $p=$("<p></p>");
				var $strong=$("<storng>"+data.msgList[i].title+"</strong>");
				var $a="";
				if(data.msgList[i].msgcontent.length>8){
					$a=$("<a href='${pageContext.request.contextPath}/msg/showmsgbyid?id="+data.msgList[i].id+"'>"+data.msgList[i].msgcontent.substring(0,8)+"</a>");
				}else{
					$a=$("<a href='${pageContext.request.contextPath}/msg/showmsgbyid?id="+data.msgList[i].id+"'>"+data.msgList[i].msgcontent+"</a>");
				}
				
				$p.append($strong).append("&nbsp;&nbsp;");
				$p.append($a);
				$li.append($em1);
				$li.append($em2);
				$li.append($em3);
				$li.append($p);
				$ul.append($li);
				
				var $as=$("#btns>a");
				$as.eq(0).attr("href","javascript:showMessages(1,"+pageSize+")");
				$as.eq(1).attr("href","javascript:showMessages("+data.prePage+","+pageSize+")");
				$as.eq(2).attr("href","javascript:showMessages("+data.nextPage+","+pageSize+")");
				$as.eq(3).attr("href","javascript:showMessages("+data.totalPages+","+pageSize+")");
				var $spans=$("#btns>span");
				$spans.eq(0).html(data.pageNo);
				$spans.eq(1).html(data.totalPages);
			}
		});
	}
</script>
</head>
<body>
	<div id="main">
		<div class="mainbox">
			<div class="title myMessage png"></div>
			<%@include file="menu.jsp"%>
			<!--错误信息  -->
			<div id="error"></div>
			<!--短消息列表  -->
			<div class="content messageList">
				<ul>
					<%-- <c:forEach items="${requestScope.data.msgList}" var="msg">

						<li class="${msg.state==1?'unReaded':''}"><em>${msg.msg_create_date }</em>
							<em><a
								href="${pageContext.request.contextPath}/user.do?param=queryallusers&sendid=${msg.sendid}">回信</a></em>
							<em><a href="javascript:del(${msg.id})">删除</a></em>

							<p>
								<strong>${msg.title }</strong> <a
									href="msg.do?param=showmsgbyid&id=${msg.id}"> <c:choose>
										<c:when test="${fn:length(msg.msgcontent)>8}">
			              ${fn:substring(msg.msgcontent,0,8) }...
			            </c:when>
										<c:otherwise>
			              ${msg.msgcontent}
			            </c:otherwise>
									</c:choose></a>
							</p></li>
					</c:forEach> --%>
				</ul>
			</div>
			<!--分页栏 -->
			<div align="center" style="margin-top: 10px" id="btns">
				<a href="#">首页</a>&nbsp;&nbsp;&nbsp; <a
					href="#">上一页</a>&nbsp;&nbsp; <a
					href="#">下一页</a>&nbsp;&nbsp;
				    <span></span>/<span></span>&nbsp;&nbsp; <a
					href="#">最后一页</a>
			</div>
			
			<%-- <div align="center" style="margin-top: 10px" id="btns">
				<a href="javascript:go('1')">首页</a>&nbsp;&nbsp;&nbsp; <a
					href="javascript:go(${data.prePage })">上一页</a>&nbsp;&nbsp; <a
					href="javascript:go(${data.nextPage })">下一页</a>&nbsp;&nbsp;
				${data.pageNo }/${data.totalPages }&nbsp;&nbsp; <a
					href="javascript:go(${data.totalPages })">最后一页</a>
			</div> --%>
		</div>
	</div>
</body>
</html>
