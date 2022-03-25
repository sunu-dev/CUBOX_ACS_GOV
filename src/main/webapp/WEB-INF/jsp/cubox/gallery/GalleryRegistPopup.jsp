<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<jsp:include page="../frame/sub/head.jsp" />
<script type="text/javascript">
$(document).ready(function() {
	$("#popupNm").html("갤러리 등록");
	
	//부모창의 새로고침/닫기/앞으로/뒤로
	$(opener).on('beforeunload', function() {
		 window.close();
	});

	$(".custom-file input").change(function(e) {
        for (var o = [], t = 0; t < $(this)[0].files.length; t++)
            o.push($(this)[0].files[t].name);
        $(".custom-file-label .custom-file-fileName").html(o.join(", "))
    });

	// img tag에서 미리보기
	$("#customFile").change(function(e) {
		$("#imageType").val("file");
		document.querySelector("#myCanvas").style.display = "none";
		document.querySelector("#imgView").style.display = "block";
		
		if(e.target.files && e.target.files[0]) {
			var fileName = e.target.files[0].name;
			var fileExt = fileName.slice(fileName.lastIndexOf(".")+1).toLowerCase();
			if($.inArray(fileExt, ['jpg','jpeg','bmp','wbmp','png','gif']) == -1) {
				alert("jpg, jpeg, bmp, wbmp, png, gif 포맷만 사용 가능합니다.");
				//location.reload();
				$("#customFile").val("");
			    $("#imageType").val("");
			    $("#imgView").attr("src", "/img/photo_01_back.jpg");
			} else {
				var reader = new FileReader();
				reader.onload = function(e) {
					$("#imgView").attr("src", e.target.result);
					//$("#imgView").animate({transform:"translateX(-100px)"});
				}
				reader.readAsDataURL(e.target.files[0]);
			}
		} else {
			$("#customFile").val("");
		    $("#imageType").val("");
			$("#imgView").attr("src", "/img/photo_01_back.jpg");
		}
	});
	
});

function fnSave() {
	if(fnIsEmpty($("#faceId").val())) {
		alert("Face ID를 입력하세요.");
		$("#faceId").focus();
		return;
	}
	
	var formData = new FormData($("#frmDetail")[0]);
	if($("#imageType").val() == "file") {
		//console.log('===> image : attach file!!');
		formData.append("fileObj", $("#customFile")[0].files[0]);
	} else {
		alert("사진 파일을 첨부하세요.");
		return;
	}
	
	formData.append("faceId", $("#faceId").val());
	
	$.ajax({
		url: "<c:url value='./regist.do'/>",
		type: "POST",
		enctype: "multipart/form-data",
		data: formData,
		dataType: "json",
		processData: false,
		contentType: false,
		success: function(data){
			if(data.result == "success"){
				alert("저장되었습니다.");
				opener.location.reload();
				window.close();
			} else {
				if(fnIsEmpty(data.message)) {
					alert("저장에 실패했습니다.");	
				} else {
					alert(data.message);
				}
			}
		},
		error: function (jqXHR){
			alert("저장에 실패했습니다."+jqXHR.responseText);
		}
	});	
}

</script>
<body>
<jsp:include page="../frame/sub/popup_top.jsp" />
<input type="hidden" id="imageType" name="imageType" >
<div class="popup_box">
	<div class="tb_outbox mb_10">
		<table class="tb_write_02 tb_write_p1">
			<tr>
				<th width="80px">Face ID <span class="font-color_H">*</span></th>
				<td><input type="text" id="faceId" name="faceId" class="w_100p input_com"></td>
			</tr>
		</table>
	</div>
	<div class="com_box" align="center">
		<div class="com_box"><!-- transform:scaleX(-1); -->
			<img src='/img/photo_01_back.jpg' alt="" style="width:400px; height:450px; object-fit:cover; " id="imgView">
			<canvas id="myCanvas" style="width:400px; height:430px; display:none;"></canvas>
		</div>
		<div class="totalbox2 mt_15" style="justify-content:center;">
			<div class="r_searhbox">
				<div class="custom-file comm_search mr_5">
					<input type="file" class="custom-file-input w_320px" id="customFile">
					<label class="custom-file-label" for="customFile">
						<div class="custom-file-fileName"></div>
					</label>
				</div>
				<div class="comm_search">
					<button type="button" class="btn_middle color_basic" onclick="fnSave()">저장</button>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
