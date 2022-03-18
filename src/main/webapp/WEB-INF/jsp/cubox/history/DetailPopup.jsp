<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../frame/sub/head.jsp" />
<%-- <script type="text/javascript" src="<c:url value='/js/faceComm.js?ver=<%=Math.random() %>'/>"></script> --%>
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
<div class="popup_box">
	<div class="search_box_popup mb_20">
		<div class="search_in_bline">
			<div class="comm_search">
				<div class="title">인증요청일시 :</div>
				<div class="title_text">${detail.request_dt}</div>
			</div>
			<div class="comm_search">
				<div class="title">매칭점수 :</div>
				<div class="title_text">${detail.score}</div>
				<div class="title_text"><c:if test="${detail.result_cd == 1}">인증${detail.result_nm}</c:if>
					<c:if test="${detail.result_cd == 0}"><span class="font-color_H">인증${detail.result_nm}</span></c:if>
					<c:if test="${detail.result_cd == 9}"><span class="font-color_H">갤러리없음</span></c:if>
				</div>
			</div>
		</div>
	</div>
	<div class="box_w2">
		<div class="box_w2_1a">
			<div class="com_box_img">
				<img id="image1" src='./getImage.do?gb=${gb}&path=${detail.image_1_path}' alt="" onerror="this.src='/images/empty_photo.png'" style="width: 400px; height: 430px; object-fit: contain;">
			</div>
			<div class="img_title" style="width:400px;">이미지 1</div>
		</div>
		<div class="box_w2_2a">
			<div class="com_box_img">
				<img id="image2" src='./getImage.do?gb=${gb}&path=${detail.image_2_path}' alt="" onerror="this.src='/images/empty_photo.png'" style="width: 400px; height: 430px; object-fit: contain;">
			</div>
			<div class="img_title" style="width:400px;">이미지 2</div>		
		</div>
	</div>
</div>
<%-- <jsp:include page="../frame/sub/tail.jsp" /> --%>
</body>