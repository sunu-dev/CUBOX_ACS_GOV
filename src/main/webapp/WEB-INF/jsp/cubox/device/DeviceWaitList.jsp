<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/jsp/cubox/common/checkPasswd.jsp" flush="false"/>
<script type="text/javascript">
//$(window).bind("beforeunload", function (e){});
$(function(){ 
	$(".title_tx").html("${menuNm}");
	modalPopup("delDescPopup", "삭제 사유 입력", 400, 300);
	
	$('#srchDtFr').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	
	$('#srchDtTo').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});	
	
	$("#btnReset").click(function(){
		$("#srchDtFr").val("${initVal1}");
		$("#srchDtTo").val("${initVal2}");
		$("#srchType").val("");
		$("#srchManufacture").val("");
		$("#srchUuid").val("");
	});
	
	$("#chkAll").click(function(){
		if($("#chkAll").prop("checked")) {
			$("input[name=chk]").prop("checked", true);
		} else {
			$("input[name=chk]").prop("checked", false);
		} 
	});
	
	$("#btnDelete").click(function(){
		var arr = [];
		$("input[name=chk]:checkbox").each(function(i){
			if($(this).is(":checked")) {
				arr.push($(this).val());
			}
		});	
		if(arr.length == 0) {
			alert("삭제 처리할 자료를 선택하세요.");
			return;
		}
		
		$("#txtDesc").val("");
		$("#delDescPopup").PopupWindow("open");
	});
	
	$("#btnCloseDescPopup").click(function(){
		$("#hidDelDiv").val("");
		$("#txtDesc").val("");
		$("#delDescPopup").PopupWindow("close");
	});	
	
	$("#srchRecPerPage").change(function(){
		pageSearch();
	});	
	
	$("#srchUuid").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});
});

function fnSave() {
	var arr = [];
	$("input[name=chk]:checkbox").each(function(i){
		if($(this).is(":checked")) {
			arr.push($(this).val());
		}
	});	
	if(arr.length == 0) {
		alert("승인 처리할 자료를 선택하세요.");
		return;
	}
	
	if(confirm("승인 처리를 하시겠습니까?")) {
		$.ajax({
			url: "<c:url value='/device/save.do' />",
			type: "POST",
			data: {"id_list" : arr, "status" : "A"},
			dataType: "json",
			traditional: true,  //arr
			success: function(data, status){
				if(data.result == "success") {
					alert("승인 처리되었습니다.");
					location.reload();
				} else {
					if(fnIsEmpty(data.message)) {
						alert("승인 처리중 오류가 발생했습니다.");	
					} else {
						alert(data.message);
					}
				}
			}
		});		
	}
}

function fnDelete() {
	var str = $("#txtDesc").val();
	var delResn = str.replace(/\s/gi, "");	
	
	if(fnIsEmpty(delResn)) {
		alert("삭제 사유를 입력하세요.");
		$("#txtDesc").focus();
		return;
	} 
	
	if(delResn.length < 3) {
		alert("3자 이상 입력하세요.");
		$("#txtDesc").focus();
		return;
	}	
	
	var arr = [];
	$("input[name=chk]:checkbox").each(function(i){
		if($(this).is(":checked")) {
			arr.push($(this).val());
		}
	});	
	
	$.ajax({
		url: "<c:url value='/device/save.do' />",
		type: "POST",
		data: {"id_list" : arr, "status" : "D", "description" : str.trim()},
		dataType: "json",
		traditional: true,  //arr
		success: function(data, status){
			if(data.result == "success") {
				alert("삭제 처리되었습니다.");
				location.reload();
			} else {
				if(fnIsEmpty(data.message)) {
					alert("삭제 처리중 오류가 발생했습니다.");
				} else {
					alert(data.message);
				}
			}
		}
	});	
	
}

function fnSearch() {
	if(fnIsEmpty($("#srchDtFr").val())) {
		alert("등록일자(From)을 선택하세요.");
		return;
	}
	if(fnIsEmpty($("#srchDtTo").val())) {
		alert("등록일자(To)을 선택하세요.");
		return;
	}

	$("#srchPage").val("1");
	
	frmSearch.action = "${menuUrl}";
	frmSearch.submit();	
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
<form id="frmSearch" name="frmSearch" method="post" onsubmit="return false;">
<input type="hidden" id="srchPage" name="srchPage" value="${pagination.curPage}">
<%-- <input type="hidden" id="chkValueArray" name="chkValueArray" value="uuid,feature_yn,create_dt" /> 
<input type="hidden" id="chkTextArray" name="chkTextArray" value="UUID,이미지여부,등록일시"> --%>
<input type="hidden" id="initYn" name="initYn" value="N">

<!--검색박스 -->
<div class="search_box mb_20">
	<div class="search_in_bline">
		<div class="comm_search mr_20">
			<label for="search-from-date" class="title">등록일자</label>
			<input type="text" id="srchDtFr" name="srchDtFr" class="input_datepicker w_150px  fl" name="search-from-date" placeholder="등록일자From" value='<c:out value="${params.srchDtFr}"/>' >
			<div class="sp_tx fl">~</div>
			<label for="search-to-date"></label> <input type="text" id="srchDtTo" name="srchDtTo" class="input_datepicker w_150px  fl" name="search-to-date" placeholder="등록일자To" value='<c:out value="${params.srchDtTo}"/>' >
		</div>
		<div class="comm_search ml_40">
			<div class="search_btn2" onclick="fnSearch();"></div>
		</div>
		<div class="comm_search ml_45">
			<button type="button" class="comm_btn" id="btnReset">초기화</button>
		</div>			
	</div>
	<div class="search_in_bline">
		<div class="comm_search mr_20">
			<div class="title">UUID</div>
			<input type="text" id="srchUuid" name="srchUuid" class="w_340px input_com" placeholder="UUID " value='<c:out value="${params.srchUuid}"/>'>
		</div>
		<div class="comm_search mr_20">
			<div class="title">단말기유형</div>
			<select name="srchType" id="srchType" size="1" class="w_142px input_com">
				<option value="">전체</option>
				<c:forEach items="${cboType}" var="type" varStatus="status">
				<option value='<c:out value="${type.cd}"/>' <c:if test="${type.cd eq params.srchType}">selected</c:if>><c:out value="${type.cd_nm}"/></option>
				</c:forEach>
			</select>
		</div>
		<div class="comm_search mr_10">
			<div class="title">제조사</div>
			<select name="srchManufacture" id="srchManufacture" size="1" class="w_110px input_com">
				<option value="">전체</option>
				<c:forEach items="${cboManu}" var="manu" varStatus="status">
				<option value='<c:out value="${manu.cd}"/>' <c:if test="${manu.cd eq params.srchManufacture}">selected</c:if>><c:out value="${manu.cd_nm}"/></option>
				</c:forEach>
			</select>
		</div>		
	</div>
</div>
<!--//검색박스 -->
<!--------- 목록--------->
<div class="com_box ">
	<div class="totalbox">
		<div class="txbox">
			<b class="fl mr_10">전체 : <fmt:formatNumber value="${pagination.totRecord}" type="number"/>건</b>
			<select name="srchRecPerPage" id="srchRecPerPage" class="input_com w_80px">
			<c:forEach items="${cboCntPerPage}" var="cntPerPage" varStatus="status">
				<option value='<c:out value="${cntPerPage.cd_nm}"/>' <c:if test="${cntPerPage.cd_nm eq pagination.recPerPage}">selected</c:if>><c:out value="${cntPerPage.cd_nm}"/></option>
			</c:forEach>
			</select>
		</div>
		<div class="r_btnbox mb_10">
			<b class="fl mr_10"></b>
			<button type="button" class="btn_middle color_basic" id="btnApprove" onclick="fnSave();">승인</button>
			<button type="button" class="btn_middle color_gray" id="btnDelete">삭제</button>
		</div>
	</div>
	<!--버튼 -->
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col width="5%">
				<col width="5%">
				<col width="13%">
				<col width="25%">
				<col width="10%">
				<col width="9%">
				<col width="9%">
				<col width="10%">
				<col width="14%">
			</colgroup>	
			<thead>
				<tr>
					<th><input type="checkbox" id="chkAll" name="chkAll" value="Y"></th>
					<th>순번</th>
					<th>등록일시</th>
					<th>UUID</th>					
					<th>단말기유형</th>
					<th>제조사</th>
					<th>운영체제</th>
					<th>IP</th>
					<th>MAC</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="9">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<tr>
					<td><input type="checkbox" name="chk" value="<c:out value="${list.sn}"/>"></td>
					<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1) + ((pagination.curPage - 1) * pagination.recPerPage)}</td>
					<td><c:out value="${list.regist_dt}"/></td>
					<td><c:out value="${list.device_id}"/></td>					
					<td><c:out value="${list.type_nm}"/></td>
					<td><c:out value="${list.manufacture_nm}"/></td>
					<td><c:out value="${list.os_nm}"/></td>
					<td><c:out value="${list.ip}"/></td>
					<td><c:out value="${list.mac}"/></td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>	
<!--------- //목록--------->
<!-- 페이징 -->
<jsp:include page="/WEB-INF/jsp/cubox/common/pagination.jsp" flush="false"/>
<!-- /페이징 -->
<!--//본문시작 -->
</form>

<!-- modal : 삭제사유 입력 -->
<div id="delDescPopup">
	<div class="popup_box">
		<div class="search_box_popup" style="border-bottom: 0px">
			<div class="search_in">
				<label style="font-size: 14px;">➠ 사유를 입력하여 주십시오.(3자 이상)</label>
			</div>
		</div>
		<div class="search_box_popup mb_20">
			<div class="search_in">
				<input type="text" id="txtDesc" name="txtDesc" class="w_300px input_com" maxlength="100" placeholder="" autocomplete="off">
			</div>
		</div>
		<div class="c_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" id="btnToDelete" onclick="fnDelete();">계속</button>
				<button type="button" class="bk_color comm_btn" id="btnCloseDescPopup">취소</button>
			</div>
		</div>
	</div>
</div>