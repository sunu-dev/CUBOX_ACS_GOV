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
		$("#srchUserId").val("");
		$("#srchUuid").val("");
	});

	$("#srchRecPerPage").change(function(){
		pageSearch();
	});
});


function fnSearch() {
	if(fnIsEmpty($("#srchDtFr").val())) {
		alert("작업일자(From)을 선택하세요.");
		return;
	}
	if(fnIsEmpty($("#srchDtTo").val())) {
		alert("작업일자(To)을 선택하세요.");
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
			<label for="search-from-date" class="title">작업일자</label>
			<input type="text" id="srchDtFr" name="srchDtFr" class="input_datepicker w_150px  fl" name="search-from-date" placeholder="작업일자From" value='<c:out value="${params.srchDtFr}"/>' >
			<div class="sp_tx fl">~</div>
			<label for="search-to-date"></label> <input type="text" id="srchDtTo" name="srchDtTo" class="input_datepicker w_150px  fl" name="search-to-date" placeholder="작업일자To" value='<c:out value="${params.srchDtTo}"/>' >
		</div>
		<div class="comm_search mr_20">
			<div class="title">UUID</div>
			<div class="comm_search">
				<input type="text" id="srchUuid" name="srchUuid" class="w_340px input_com" placeholder="UUID " value='<c:out value="${params.srchUuid}"/>'>
			</div>
		</div>		
		<div class="comm_search ml_40">
			<div class="search_btn2" onclick="fnSearch();"></div>
		</div>
		<div class="comm_search ml_45">
			<button type="button" class="comm_btn" id="btnReset">초기화</button>
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
			<%-- <button type="button" class="btn_middle color_basic" id="btnApprove">활성화</button>
			<button type="button" class="btn_middle color_gray" id="btnInvalid">무효</button>
			<button type="button" class="btn_middle color_gray" id="btnDelete">삭제</button> --%>
		</div>
	</div>
	<!--버튼 -->
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col width="5%">
				<col width="25%">
				<col width="13%">
				<col width="13%">
				<col width="15%">
				<col width="19%">
			</colgroup>
			<thead>
				<tr>
					<th>순번</th>
					<th>UUID</th>
					<th>단말기상태</th>
					<th>작업자</th>
					<th>작업일시</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="6">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<tr>
					<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1) + ((pagination.curPage - 1) * pagination.recPerPage)}</td>
					<td><c:out value="${list.device_id}"/></td>
					<td><c:out value="${list.status_nm}"/></td>
					<td><c:out value="${list.regist_nm}"/></td>
					<td><c:out value="${list.regist_dt}"/></td>
					<td><c:out value="${list.description}"/></td>
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
