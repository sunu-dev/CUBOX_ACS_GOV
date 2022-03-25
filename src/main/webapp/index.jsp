<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="site.title"/></title>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<% 
String str = System.getProperty("spring.profiles.active");
System.out.println("   index.jsp : "+str);
if(!str.equals("local")) { %>
<meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests">
<% } %>
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1.0">
</head>
<frameset rows="*" cols="*" framespacing="0" frameborder="no" border="0">
<frame src="/login.do" name="index" scrolling="yes" noresize>
</frameset>
<noframes>
<body>[03/25/2022] CUBOX_FRS_MANAGEMENT_ADMIN_PAGE</body>
</noframes>
</html>