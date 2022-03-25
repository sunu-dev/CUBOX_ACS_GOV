<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="cubox.admin.cmmn.util.StringUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../frame/sub/head.jsp" />
<%
String gvGalleryDeleteYn = StringUtil.nvl(System.getenv("FRS_GALLERY_DELETE_YN"), "N");
pageContext.setAttribute("gvGalleryDeleteYn", gvGalleryDeleteYn);
%>
<script type="text/javascript">
$(document).ready(function() {
	$("#popupNm").html("갤러리 상세보기");
	
	//부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).on('beforeunload', function() {
		 window.close();
	});
	
	<c:if test="${gvGalleryDeleteYn eq 'Y'}">
	$("#btnDelete").click(function(){
		if(!confirm("정말 삭제하시겠습니까?")) return;
		
		$.ajax({
			url: "<c:url value='./delete.do'/>",
			type: "POST",
			data: {"faceId" : "${detail.face_id}"},
			dataType: "json",
			success: function(data){
				if(data.result == "success"){
					alert("삭제되었습니다.");
					opener.location.reload();
					window.close();
				} else {
					alert("삭제에 실패했습니다.");
				}
			},
			error: function (jqXHR){
				alert("삭제에 실패했습니다."+jqXHR.responseText);
			}
		});
	});
	</c:if>
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
		<div class="img_title" style="width:100%;">등록 갤러리</div>
	</div>
	<c:if test="${gvGalleryDeleteYn eq 'Y'}">
	<div class="r_btnbox mt_10 ">
		<button type="button" class="btn_middle color_gray" id="btnDelete">갤러리 삭제</button> 
	</div>
	</c:if>
</div>
<%-- <jsp:include page="../frame/sub/tail.jsp" /> --%>
</body>