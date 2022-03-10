<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/jsp/cubox/common/checkPasswd.jsp" flush="false"/>
<script type="text/javascript">
$(function() {
	$(".title_tx").html("${menuNm}");
	/* $("#TableID1").chromatable({
		width: "100%", // specify 100%, auto, or a fixed pixel amount
		height: "392px",
		scrolling: "yes"
	});	 */

	$("#btnCdAdd").on("click", function(event){
		fnClearCd();
		$("#frmCdDetail").find(".popupwindow_titlebar_text").html("코드 등록");
		$("#cdDetailPopup").PopupWindow("open");
	});
	
	$("#btnUpperCdManager").on("click", function(event){
		fnPopupUpperCdList();
		$("#upperCdListPopup").PopupWindow("open");
	});
	
	$("#btnCdPopupClose").click(function(){
		fnClearCd();
		$("#cdDetailPopup").PopupWindow("close");
	});
	
	$("#btnUpperCdAdd").on("click", function(event){
		fnClearUpperCd();
		$("#frmUpperCd").find(".popupwindow_titlebar_text").html("상위코드 등록");
		$("#tdUpperCd").html("자동생성");
		$("#upperCdPopup").PopupWindow("open");
	});	
	
	$("#btnUpperCdPopupClose").click(function(){
		fnClearCd();
		$("#upperCdPopup").PopupWindow("close");
	});	
	
	$(".onlyNumber").keyup(function(event){
		if (!(event.keyCode >=37 && event.keyCode<=40)) {
			var inputVal = $(this).val();
			$(this).val(inputVal.replace(/[^0-9]/gi,''));
		}
	});
	
	$("#srchRecPerPage").change(function(){
		pageSearch("1");
	});

	$("#btnReset").click(function(){
		$("#upper_cd").val("");
		$("#cd_nm").val("");
		$("#use_yn").val("");
	});

	$("#menu_nm").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});
	
	modalPopup("cdDetailPopup", "코드 등록", 650, 420);
	modalPopup("upperCdListPopup", "상위코드 관리", 690, 620);	
	modalPopup("upperCdPopup", "상위코드 등록", 550, 370);	
});

function fnSaveCd() {
	if(!fnFormValueCheck("frmCdDetail")) return;
	
	if(fnIsEmpty($("#hidUpperOfCd").val()) && fnIsEmpty($("#selUpperCd").val())) {
		alert("상위코드 은(는) 필수입력 항목입니다.");
		return;
	}
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/saveCdInfo.do'/>",
		data: $("#frmCdDetail").serialize(),
		dataType: 'json',
		success: function(data) {  //status:success
			if(data.result == "success") {
				alert("저장하였습니다.");
				$("#cdDetailPopup").PopupWindow("close");
				document.location.reload();
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert("저장 중 오류가 발생했습니다.");
				}	
			}
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + ']\n저장에 실패했습니다.');
			return;
		}
	});
}

function fnEditCd(upCd, cd) {
	$("#frmCdDetail").find(".popupwindow_titlebar_text").html("코드 편집");

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getCdInfo.do'/>",
		data: {"upper_cd" : upCd, "cd" : cd},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$("#selUpperCd").prop("disabled", true);
				$("#selUpperCd").val(data.detail.upper_cd);
				$("#hidUpperOfCd").val(data.detail.upper_cd);
				$("#txtCd").prop("readonly", true);				
				//$("#txtCd").addClass("input_readonly");				
				$("#txtCd").val(data.detail.cd);
				$("#hidCd").val(data.detail.cd);
				$("#txtCdNm").val(data.detail.cd_nm);
				$("#txtDesc").val(data.detail.cd_desc);
				$("#txtSortOrdr").val(data.detail.sort_ordr);
				$("#cdDetailPopup").PopupWindow("open");
			} else {
				alert("ERROR!");
			}
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 조회 오류입니다!');
			return;
		}
	});
}

function fnModUseYn(upCd, cd, useYn) {
	if(!confirm("사용여부를 ["+(useYn=='Y'?'사용중':'사용안함')+"]으로 변경하시겠습니까?")) return;

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/modCdUseYn.do'/>",
		data: {
			"upper_cd" : upCd,
			"cd" : cd,
			"use_yn" : useYn
		},
		dataType: 'json',
		success: function(data) {  //status:success
			if(data.result == "success") {
				alert("저장하였습니다.");
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert("저장 중 오류가 발생했습니다.");
				}
			}
			document.location.reload();
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 저장에 실패했습니다!');
			return;
		}
	});
}

function fnClearCd() {
	$("#hidCd").val("");
	$("#txtCd").val("");
	$("#txtCd").prop("readonly", false);
	$("#txtCdNm").val("");
	$("#hidUpperOfCd").val("");
	$("#selUpperCd").val("");
	$("#selUpperCd").prop("disabled", false);
	$("#txtDesc").val("");
	$("#txtSortOrdr").val("");
}

function fnClearUpperCd() {
	$("#hidUpperCd").val("");
	$("#tdUpperCd").html("");
	$("#txtUpperCdNm").val("");
	$("#txtUpperDesc").val("");
	$("#txtUpperSortOrdr").val("");
}

function fnPopupUpperCdList() {
	//search
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getUpperCdList.do'/>",
		data: {},
		dataType: 'json',
		success: function(data) {
			var totalList = "";
			if(!fnIsEmpty(data.list)) {
				if( data.list != null && data.list.length > 0 ) {
					for(var i = 0 ; i < data.list.length ; i++ ) {
						totalList += "<tr><td>" + data.list[i].cd + "</td><td>" 
						+ data.list[i].cd_nm + "</td><td>" 
						+ (!data.list[i].cd_desc?"-":data.list[i].cd_desc) + "</td><td>" 
						+ data.list[i].sort_ordr + "</td><td>" 
						+ (!fnIsEmpty(data.list[i].use_yn) && data.list[i].use_yn=="Y"?"<button type='button' class='btn_small color_basic' onclick='fnModUpperCdUseYn(\""+data.list[i].cd+"\", \"N\")'>사용중</button>":"<button type='button' class='btn_small color_gray' onclick='fnModUpperCdUseYn(\""+data.list[i].cd+"\", \"Y\")'>사용안함</button>")
						+"</td><td>"
						+ (!fnIsEmpty(data.list[i].use_yn) && data.list[i].use_yn=="Y"?"<button type='button' class='btn_small color_basic' onclick='fnEditUpperCd(\""+data.list[i].cd+"\")'>편집</button>":"&nbsp;")
						+"</td></tr>";
					}
				}	
				$("#tbUpperCdList").html(totalList);
				//$("#upperCdListPopup").PopupWindow("open");
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert('조회 중 오류가 발생했습니다.');	
				}
				return;
			}
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 조회 실패!');
			return;
		}
	});
}

function fnSaveUpperCd() {
	if(!fnFormValueCheck("frmUpperCd")) return;
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/saveUpperCdInfo.do'/>",
		data: $("#frmUpperCd").serialize(),
		dataType: 'json',
		success: function(data) {  //,status:success
			if(data.result == "success") {
				alert("저장하였습니다.");
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert("저장 중 오류가 발생했습니다.");
				}
			}
			$("#upperCdPopup").PopupWindow("close");
			fnPopupUpperCdList();
			document.location.reload();
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 저장 실패!');
			return;
		}
	});
}

function fnEditUpperCd(str) {
	$("#frmUpperCd").find(".popupwindow_titlebar_text").html("상위코드 편집");

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getCdInfo.do'/>",
		data: {"cd" : str, "upper_cd" : "00000"},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$("#hidUpperCd").val(data.detail.cd);
				$("#tdUpperCd").html(data.detail.cd);
				$("#txtUpperCdNm").val(data.detail.cd_nm);
				$("#txtUpperDesc").val(data.detail.cd_desc);
				$("#txtUpperSortOrdr").val(data.detail.sort_ordr);
				$("#upperCdPopup").PopupWindow("open");
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert("조회 중 오류가 발생했습니다.");
				}
			}
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 조회 실패!');
			return;
		}
	});
}

function fnModUpperCdUseYn(str, useYn) {
	if(!confirm("사용여부를 ["+(useYn=='Y'?'사용중':'사용안함')+"]으로 변경하시겠습니까?")) return;

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/modCdUseYn.do'/>",
		data: {
			"upper_cd" : "00000",
			"cd" : str,
			"use_yn" : useYn
		},
		dataType: 'json',
		success: function(data) {  //status:success
			if(data.result == "success") {
				alert("저장하였습니다.");
			} else {
				if(!fnIsEmpty(data.message)) {
					alert(data.message);
				} else {
					alert("저장 중 오류가 발생했습니다.");
				}
			}
			$("#upperCdPopup").PopupWindow("close");
			fnPopupUpperCdList();
			document.location.reload();
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 저장 실패!');
			return;
		}
	});
}

function pageSearch(page){
	if(!fnIsEmpty(page)) {
		$("#srchPage").val(page);
	} else {
		$("#srchPage").val("1");
	}
	
	frmSearch.action = "${menuUrl}";
	frmSearch.submit();	
}

</script>
<form id="frmSearch" name="frmSearch" method="post">
<input type="hidden" id="srchPage" name="srchPage" value="${pagination.curPage}"/>
<!--//검색박스 -->
<div class="search_box mb_20">
	<div class="search_in">
		<div class="comm_search mr_20">
			<div class="title">상위코드</div>
			<select name="upper_cd" id="upper_cd" size="1" class="w_190px input_com">
				<option value="">상위코드를 선택하세요.</option>
				<c:forEach items="${cboUpperCd}" var="upperCd" varStatus="status">
				<option value='<c:out value="${upperCd.upper_cd}"/>' <c:if test="${params.upper_cd eq upperCd.upper_cd}">selected</c:if>><c:out value="${upperCd.upper_cd_nm}"/></option>
				</c:forEach>
			</select>
		</div>
		<div class="comm_search mr_20">
			<div class="title">코드명</div>
			<input type="text" id="cd_nm" name="cd_nm" class="w_150px input_com" value="<c:out value='${params.cd_nm}'/>" placeholder="코드명을 입력하세요.">
		</div>
		<div class="comm_search mr_10">
			<div class="title">사용여부</div>
			<select name="use_yn" id="use_yn" size="1" class="w_100px input_com">
				<option value="">전체</option>
				<option value="Y" <c:if test="${params.use_yn eq 'Y'}">selected</c:if>>사용중</option>
				<option value="N" <c:if test="${params.use_yn eq 'N'}">selected</c:if>>사용안함</option>
			</select>
		</div>
		<div class="comm_search ml_40">
			<div class="search_btn2" onclick="pageSearch('1')"></div>
		</div>
		<div class="comm_search ml_45">
			<button type="button" class="comm_btn" id="btnReset">초기화</button>
		</div>
	</div>
</div>
<!--------- 목록--------->
<div class="com_box ">
	<div class="totalbox">
		<div class="txbox">
			<b class="fl mr_10">전체 : <fmt:formatNumber value="${pagination.totRecord}" type="number"/>건</b>
			<!-- 건수 -->
			<select name="srchRecPerPage" id="srchRecPerPage" class="input_com w_80px">
				<c:forEach items="${cboCntPerPage}" var="cntPerPage" varStatus="status">
				<option value='<c:out value="${cntPerPage.cd_nm}"/>' <c:if test="${cntPerPage.cd_nm eq pagination.recPerPage}">selected</c:if>><c:out value="${cntPerPage.cd_nm}"/></option>
				</c:forEach>
			</select>
		</div>
		<!--버튼 -->
		<div class="r_btnbox mb_10">
			<button type="button" class="btn_middle color_basic" id="btnCdAdd">코드추가</button>
			<button type="button" class="btn_middle color_basic" id="btnUpperCdManager">상위코드관리</button>
		</div>
		<!--//버튼  -->	
	</div>
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col width="5%" />
				<col width="12%" />
				<col width="20%" />
				<col width="10%" />
				<col width="20%" />
				<col width="8%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th>순번</th>
					<th>상위코드</th>
					<th>상위코드명</th>
					<th>코드</th>
					<th>코드명</th>
					<th>정렬순서</th>
					<th>사용여부</th>
					<th>편집</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="8">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<tr>
					<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1)  + ( (pagination.curPage - 1)  *  pagination.recPerPage ) }</td>
					<td><c:out value="${list.upper_cd}"/></td>
					<td><c:out value="${list.upper_cd_nm}"/><c:if test="${list.upper_use_yn ne 'Y'}"><font class="font-color_H"> (사용안함)</font></c:if></td>
					<td><c:out value="${list.cd}"/></td>
					<td><c:out value="${list.cd_nm}"/></td>
					<td><c:out value="${list.sort_ordr}"/></td>
					<td>
						<c:if test="${list.use_yn eq 'Y'}"><button type="button" class="btn_small color_basic" onclick="fnModUseYn('<c:out value="${list.upper_cd}"/>', '<c:out value="${list.cd}"/>', 'N');">사용중</button></c:if>
						<c:if test="${list.use_yn eq 'N'}"><button type="button" class="btn_small color_gray" onclick="fnModUseYn('<c:out value="${list.upper_cd}"/>', '<c:out value="${list.cd}"/>', 'Y');">사용안함</button></c:if>
					</td>
					<td><c:if test="${list.use_yn eq 'Y'}"><button type="button" class="btn_small color_basic" onclick="fnEditCd('<c:out value="${list.upper_cd}"/>', '<c:out value="${list.cd}"/>');">편집</button></c:if></td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
	<!--------- //목록--------->
	<!-- 페이징 -->
	<jsp:include page="/WEB-INF/jsp/cubox/common/pagination.jsp" flush="false"/>
	<!-- /페이징 -->
</div>
</form>

<!-- modal : 등록 -->
<div id="cdDetailPopup" class="example_content">
<form id="frmCdDetail" name="frmCdDetail" method="post">
<input type="hidden" name="hidUpperOfCd" id="hidUpperOfCd">
<input type="hidden" name="hidCd" id="hidCd">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="25%" />
				<col width="75%" />
				<tbody>
					<tr>
						<th>상위코드 <span class="font-color_H">*</span></th>
						<td>
							<select name="selUpperCd" id="selUpperCd" size="1" class="input_com w_60p">
								<option value="" disabled selected>선택</option>
								<c:forEach items="${cboUpperCd}" var="upperCd" varStatus="status">
								<option value='<c:out value="${upperCd.upper_cd}"/>' <c:if test="${upperCd.use_yn eq 'N'}">disabled</c:if>><c:out value="${upperCd.upper_cd_nm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>코드 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtCd" id="txtCd" maxlength="5" class="w_60p input_com" check="text" checkName="코드" />
						</td>
					</tr>
					<tr>
						<th>코드명 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtCdNm" id="txtCdNm" maxlength="50" class="w_100p input_com" check="text" checkName="코드명" />
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td>
							<input type="text" name="txtDesc" id="txtDesc" maxlength="100" class="w_100p input_com" />
						</td>
					</tr>
					<tr>
						<th>정렬순서 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtSortOrdr" id="txtSortOrdr" maxlength="3" class="w_100px input_com onlyNumber" check="text" checkName="정렬순서"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--버튼 -->
		<div class="r_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" onclick="fnSaveCd();">저장</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnCdPopupClose">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>

<div id="upperCdListPopup" class="example_content">
	<div class="popup_box">
		<div class="search_box_popup mb_20 fl">
			<div class="search_in">
				<label style="font-size: 14px;" id="">상위코드 목록</label>
			</div>	
			<button type="button" class="comm_btn mr_5 mt_5" id="btnUpperCdAdd">추가</button>
		</div>
		<div class="com_box">
			<div class="tb_outbox">
				<table class="tb_list2" id="TableID1">
					<col width="15%" />
					<col width="25%" />
					<col width="24%" />
					<col width="10%" />
					<col width="13%" />
					<col width="13%" />
					<thead>
						<tr>
							<th>상위코드</th>
							<th>상위코드명</th>
							<th>비고</th>
							<th>순서</th>
							<th>사용여부</th>
							<th>편집</th>
						</tr>
					</thead>
					<tbody id="tbUpperCdList"></tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<div id="upperCdPopup" class="example_content">
<form id="frmUpperCd" name="frmUpperCd" method="post">
<input type="hidden" name="hidUpperCd" id="hidUpperCd">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="25%" />
				<col width="75%" />
				<tbody>
					<tr>
						<th>상위코드 <span class="font-color_H">*</span></th>
						<td id="tdUpperCd"></td>
					</tr>
					<tr>
						<th>상위코드명 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtUpperCdNm" id="txtUpperCdNm" maxlength="50" class="w_100p input_com" check="text" checkName="상위코드명" />
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td>
							<input type="text" name="txtUpperDesc" id="txtUpperDesc" maxlength="100" class="w_100p input_com"/>
						</td>
					</tr>
					<tr>
						<th>정렬순서 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtUpperSortOrdr" id="txtUpperSortOrdr" maxlength="3" class="w_100px input_com onlyNumber" check="text" checkName="정렬순서"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--버튼 -->
		<div class="r_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" onclick="fnSaveUpperCd();">저장</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnUpperCdPopupClose">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>