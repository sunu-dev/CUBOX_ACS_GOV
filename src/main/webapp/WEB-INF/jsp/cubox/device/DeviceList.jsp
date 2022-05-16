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
	modalPopup("detailPopup", "단말기 관리", 610, 510);
	modalPopup("delDescPopup", "삭제 사유 입력", 400, 300);

	$('#srchDtFr').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});

	$('#srchDtTo').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	
	$("#btnActivePopup").click(function(){
		fnSave("A", 1);
	});
	
	$("#btnInactivePopup").click(function(){
		fnSave("I", 1);
	});
	
	$("#btnDeletePopup").click(function(){
		fnDelDescPopup("DETAIL");
	});
	
	$("#btnClosePopup").click(function(){
		fnClearDetail();
		$("#detailPopup").PopupWindow("close");
	});		

	$("#btnReset").click(function(){
		$("#srchDtFr").val("${initVal1}");
		$("#srchDtTo").val("${initVal2}");
		$("#srchType").val("");
		$("#srchManufacture").val("");
		$("#srchStatus").val("");
		$("#srchUuid").val("");
		$("#srchUserId").val("");
		$("#srchDeviceNm").val("");
		$("#srchGroupCd").val("");
	});

	$("#chkAll").click(function(){
		if($("#chkAll").prop("checked")) {
			$("input[name=chk]").prop("checked", true);
		} else {
			$("input[name=chk]").prop("checked", false);
		}
	});

	$("#btnApprove").click(function(){
		var chkStatus = true;
		$("input[name=chk]:checkbox").each(function(i){
			if($(this).is(":checked")) {
				if($("input[name='status']").eq(i).val() != "I") {
					alert("INACTIVE 자료만 활성화 처리가 가능합니다.");
					chkStatus = false;
					return false;
				}
			}
		});
	
		if(chkStatus) fnSave("A", 2);
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
		
		fnDelDescPopup("LIST");
	});
	
	$("#btnToDelete").click(function(){
		fnDelete();
	});
	
	$("#btnInvalid").click(function(){
		var chkStatus = true;
		$("input[name=chk]:checkbox").each(function(i){
			if($(this).is(":checked")) {
				if($("input[name='status']").eq(i).val() != "A") {
					alert("ACTIVE 자료만 무효 처리가 가능합니다.");
					chkStatus = false;
					return false;
				}
			}
		});		
		
		if(chkStatus) fnSave("I", 2);
	});	
	
	$("#btnCloseDescPopup").click(function(){
		$("#hidDelDiv").val("");
		$("#txtDesc").val("");
		$("#delDescPopup").PopupWindow("close");
	});

	$("#srchRecPerPage").change(function(){
		pageSearch();
	});
	
	$("#srchUserId").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});	
	$("#srchUuid").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});	
	$("#srchDeviceNm").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});	
	$("#srchGroupCd").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});	
});

function fnEdit(str) {
	$.ajax({
		type: "POST",
		url: "<c:url value='/device/get.do'/>",
		data: {"sn" : str},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$("#hidId").val(data.detail.sn);
				//$("#tdUserId").html(data.detail.user_id);
				$("#tdUuid").html(data.detail.device_id);
				$("#tdDeviceNm").html(data.detail.device_nm);
				$("#tdGroupCd").html(data.detail.group_cd);
				$("#tdType").html(data.detail.type_nm);
				$("#tdManufacture").html(data.detail.manufacture_nm);
				$("#tdOs").html(data.detail.os_nm);
				$("#tdIp").html(data.detail.ip);
				$("#tdMac").html(data.detail.mac);
				if(data.detail.status == "I") {
					$("#tdStatus").html("<font class='font-color_H'>"+data.detail.status_nm+"</font>");
				} else {
					$("#tdStatus").html(data.detail.status_nm);	
				}
				$("#tdResgitDt").html(data.detail.regist_dt);
				$("#tdUpdtDt").html(data.detail.updt_dt);
				
				if(data.detail.status == "I") {
					$("#btnActivePopup").show();
					$("#btnInactivePopup").hide();
				} else {
					$("#btnActivePopup").hide();
					$("#btnInactivePopup").show();
				}
				$("#detailPopup").PopupWindow("open");
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

function fnClearDetail() {
	$("#hidId").val("");
	//$("#tdUserId").html("");
	$("#tdUuid").html("");
	$("#tdDeviceNm").html("");
	$("#tdGroupCd").html("");
	$("#tdType").html("");
	$("#tdManufacture").html("");
	$("#tdOs").html("");
	$("#tdIp").html("");
	$("#tdMac").html("");
	$("#tdStatus").html("");
	$("#tdResgitDt").html("");
	$("#tdUpdtDt").html("");
		
}

function fnSave(div, multi) {
	var work = "활성화";
	if(div == "I") work = "무효";

	var arr = [];
	if(multi == 1) {  // 상세팝업에서 단건 처리
		arr.push($("#hidId").val());
	} else if(multi == 2) {  // 검색목록에서 다건 처리 
		$("input[name=chk]:checkbox").each(function(i){
			if($(this).is(":checked")) {
				arr.push($(this).val());
			}
		});	
	}

	if(arr.length == 0) {
		alert(work+" 처리할 자료를 선택하세요.");
		return;
	}	
	
	if(confirm(work+" 처리를 하시겠습니까?")) {
		$.ajax({
			url: "<c:url value='/device/save.do' />",
			type: "POST",
			data: {"id_list" : arr, "status" : div},
			dataType: "json",
			traditional: true,  //arr
			success: function(data, status){
				if(data.result == "success") {
					alert(work+" 처리되었습니다.");
					location.reload();
				} else {
					if(fnIsEmpty(data.message)) {
						alert(work+" 처리중 오류가 발생했습니다.");
					} else {
						alert(data.message);
					}
				}
			}
		});
	}		
	
}

function fnDelDescPopup(div) {
	$("#hidDelDiv").val(div); //DETAIL:상세팝업에서삭제, LIST:목록에서선택하여삭제
	$("#txtDesc").val("");
	$("#delDescPopup").PopupWindow("open");
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
	if($("#hidDelDiv").val() == "DETAIL") {  // 상세팝업에서 단건 처리
		arr.push($("#hidId").val());
	} else if($("#hidDelDiv").val() == "LIST") {  // 검색목록에서 다건 처리 
		$("input[name=chk]:checkbox").each(function(i){
			if($(this).is(":checked")) {
				arr.push($(this).val());
			}
		});	
	}
	
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
<%-- <input type="hidden" id="chkValueArray" name="chkValueArray" value="device_id,feature_yn,create_dt" />
<input type="hidden" id="chkTextArray" name="chkTextArray" value="단말기ID,이미지여부,등록일시"> --%>
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
		<div class="comm_search mr_20">
			<div class="title">단말기유형</div>
			<select name="srchType" id="srchType" size="1" class="w_130px input_com">
				<option value="">전체</option>
				<c:forEach items="${cboType}" var="type" varStatus="status">
				<option value='<c:out value="${type.cd}"/>' <c:if test="${type.cd eq params.srchType}">selected</c:if>><c:out value="${type.cd_nm}"/></option>
				</c:forEach>
			</select>
		</div>
		<div class="comm_search mr_20">
			<div class="title">제조사</div>
			<select name="srchManufacture" id="srchManufacture" size="1" class="w_110px input_com">
				<option value="">전체</option>
				<c:forEach items="${cboManu}" var="manu" varStatus="status">
				<option value='<c:out value="${manu.cd}"/>' <c:if test="${manu.cd eq params.srchManufacture}">selected</c:if>><c:out value="${manu.cd_nm}"/></option>
				</c:forEach>
			</select>
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
			<div class="title">단말기ID</div>
			<input type="text" id="srchUuid" name="srchUuid" class="w_200px input_com" placeholder="단말기ID" value='<c:out value="${params.srchUuid}"/>'>
		</div>
		<div class="comm_search mr_20">
			<div class="title">단말기명</div>
			<input type="text" id="srchDeviceNm" name="srchDeviceNm" class="w_142px input_com" placeholder="단말기명" value='<c:out value="${params.srchDeviceNm}"/>'>
		</div>
		<div class="comm_search mr_20">
			<div class="title">그룹코드</div>
			<input type="text" id="srchGroupCd" name="srchGroupCd" class="w_142px input_com" placeholder="그룹코드" value='<c:out value="${params.srchGroupCd}"/>'>
		</div>	
		<div class="comm_search mr_20">
			<div class="title">상태</div>
			<select name="srchStatus" id="srchStatus" size="1" class="w_110px input_com">
				<option value="">전체</option>
				<option value="A" <c:if test="${params.srchStatus eq 'A'}">selected</c:if>>ACTIVE</option>
				<option value="I" <c:if test="${params.srchStatus eq 'I'}">selected</c:if>>INACTIVE</option>
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
			<button type="button" class="btn_middle color_basic" id="btnApprove">활성화</button>
			<button type="button" class="btn_middle color_gray" id="btnInvalid">무효</button>
			<button type="button" class="btn_middle color_gray" id="btnDelete">삭제</button>
		</div>
	</div>
	<!--버튼 -->
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col width="3%">
				<col width="3%">
				<col width="10%"><%--단말기ID --%>
				<col width="7%"><%--단말기명 --%>
				<col width="7%"><%--그룹코드 --%>
				<col width="7%">
				<col width="7%">
				<%-- <col width="6%">
				<col width="10%">
				<col width="10%"> --%>
				<col width="5%">
				<col width="11%">
				<col width="11%">
				<col width="5%">
			</colgroup>
			<thead>
				<tr>
					<th><input type="checkbox" id="chkAll" name="chkAll" value="Y"></th>
					<th>순번</th>
					<th>단말기ID</th>
					<th>단말기명</th>
					<th>그룹코드</th>
					<th>단말기유형</th>
					<th>제조사</th>
					<%-- <th>운영체제</th>
					<th>IP</th>
					<th>MAC</th> --%>
					<th>상태</th>
					<th>등록일시</th>
					<th>수정일시</th>
					<th>상세</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="12">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<tr>
					<td><input type="checkbox" name="chk" value="<c:out value="${list.sn}"/>">
						<input type="hidden" name="status" value="<c:out value="${list.status}"/>"></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if>${(pagination.totRecord - (pagination.totRecord-status.index)+1) + ((pagination.curPage - 1) * pagination.recPerPage)}<c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.device_id}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.device_nm}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.group_cd}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.type_nm}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.manufacture_nm}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<%-- <td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.os_nm}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.ip}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.mac}"/><c:if test="${list.status eq 'I'}"></font></c:if></td> --%>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.status_nm}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.regist_dt}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><c:if test="${list.status eq 'I'}"><font class="font-color_H"></c:if><c:out value="${list.updt_dt}"/><c:if test="${list.status eq 'I'}"></font></c:if></td>
					<td><button type="button" class="btn_small color_basic" onclick="fnEdit('<c:out value="${list.sn}"/>');">상세</button></td>
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

<!-- modal : 등록 -->
<div id="detailPopup">
<form id="frmDetail" name="frmDetail" method="post">
<input type="hidden" id="hidId" name="hidId">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="35%" />
				<tbody>
					<tr>
						<th>단말기ID</th>
						<td colspan="3" id="tdUuid"></td>
					</tr>
					<tr>
						<th>단말기명</th>
						<td id="tdDeviceNm"></td>
						<th>그룹코드</th>
						<td id="tdGroupCd"></td>
					</tr>
					<tr>
						<th>상태</th>
						<td id="tdStatus"></td>
						<th>단말기유형</th>
						<td id="tdType"></td>
					</tr>
					<tr>
						<th>제조사</th>
						<td id="tdManufacture"></td>
						<th>운영체제</th>
						<td id="tdOs"></td>
					</tr>
					<tr>
						<th>IP</th>
						<td id="tdIp"></td>
						<th>MAC</th>
						<td id="tdMac"></td>
					</tr>
					<tr>
						<th>등록일시</th>
						<td id="tdResgitDt"></td>
						<th>수정일시</th>
						<td id="tdUpdtDt"></td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--버튼 -->
		<div class="r_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" id="btnActivePopup">활성화처리</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnInactivePopup">무효처리</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnDeletePopup">삭제</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnClosePopup">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>

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
				<input type="hidden" id="hidDelDiv" name="hidDelDiv">
			</div>
		</div>
		<div class="c_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" id="btnToDelete">계속</button>
				<button type="button" class="bk_color comm_btn" id="btnCloseDescPopup">취소</button>
			</div>
		</div>
	</div>
</div>