<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../frame/sub/head.jsp" />
<script type="text/javascript">
$(document).ready(function() {
	$("#popupNm").html("이미지상세보기");
	
	//부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).on('beforeunload', function() {
		 window.close();
	});		
});
</script>
<body>
<jsp:include page="../frame/sub/popup_top.jsp" />
<input type="hidden" value="${detail.sn}">
<div class="popup_box">
	<div class="search_box_popup mb_20">
		<div class="search_in_bline">
			<div class="comm_search">
				<div class="title">Face ID :</div>
				<div class="title_text">${detail.face_id}</div>
			</div>
			<div class="comm_search">
				<div class="title">등록일시 :</div>
				<div class="title_text">${detail.regist_dt}</div>
			</div>
		</div>
	</div>
	<div class="box_w2">
		<div class="com_box_img" align="center">
			<img id="image1" src='../history/getImage.do?gb=G&path=${detail.image_path}' alt="" onerror="this.src='/images/empty_photo.png'" style="width: 400px; height: 430px; object-fit: contain;">
		</div>
		<div class="img_title" style="width:100%;">등록이미지</div>
	</div>
</div>
<%-- <jsp:include page="../frame/sub/tail.jsp" /> --%>
</body>