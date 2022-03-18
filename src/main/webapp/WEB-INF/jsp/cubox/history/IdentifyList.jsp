<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<jsp:include page="/WEB-INF/jsp/cubox/common/checkPasswd.jsp" flush="false"/>
<%
String gvLogGb = System.getenv("FRS_IDENTIFICATION_LOG_GB");
if(gvLogGb == null) gvLogGb = "N";
pageContext.setAttribute("gvLogGb", gvLogGb);
%>
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
		$('.search_box input[type="checkbox"]').prop("checked",false).trigger('change');
	});
	
	$("#btnExcel").click(function(){
		frmSearch.action = "./idenListXls.do";
		frmSearch.submit();		
	})		
	
	$("#srchRecPerPage").change(function(){
		pageSearch();
	});	
});

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

<c:if test="${gvLogGb ne 'N'}">
function fnDetail(str) {
	var $form = $("<form></form>");
	$form.attr("method", "post");
	$form.attr("target", "winIdenDetailPopup");
	$form.attr("action", "./idenDetailPopup.do");
	$form.appendTo("body");
	
	var vid = $("<input type='hidden' id='srchSn' name='srchSn' value='"+str+"'>");
	$form.append(vid);
	
	openPopup('', 'winIdenDetailPopup', 874, 640);
	$form.submit();
}
</c:if>
</script>
<form id="frmSearch" name="frmSearch" method="post" onsubmit="return false;">
<input type="hidden" id="srchPage" name="srchPage" value="${pagination.curPage}">
<input type="hidden" id="chkValueArray" name="chkValueArray" value="request_dt,face_id,result_nm,score,threshold,device_id" /> 
<input type="hidden" id="chkTextArray" name="chkTextArray" value="인증요청일시,FaceID,인증결과,매칭점수,기준점수,단말기ID">
<input type="hidden" id="initYn" name="initYn" value="N">

<!--검색박스 -->
<div class="search_box mb_20">
	<div class="search_in_bline">
		<div class="comm_search mr_20">
			<label for="search-from-date" class="title">인증요청일자</label>
			<input type="text" id="srchDtFr" name="srchDtFr" class="input_datepicker w_150px  fl" name="search-from-date" placeholder="등록일자From" value='<c:out value="${params.srchDtFr}"/>' >
			<div class="sp_tx fl">~</div>
			<label for="search-to-date"></label> <input type="text" id="srchDtTo" name="srchDtTo" class="input_datepicker w_150px  fl" name="search-to-date" placeholder="등록일자To" value='<c:out value="${params.srchDtTo}"/>' >
		</div>
		<div class="comm_search mr_20">
			<div class="title">인증결과</div>
			<div class="ch_box ">
				<input type="checkbox" id="chkPass" name="chkPass" class="checkbox" value="Y" <c:if test="${params.chkPass eq 'Y'}">checked</c:if>>
				<label for="chkPass"> 성공</label>
				<input type="checkbox" id="chkFail" name="chkFail" class="checkbox" value="Y" <c:if test="${params.chkFail eq 'Y'}">checked</c:if>>
				<label for="chkFail" class="ml_10"> 실패</label>
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
			<b class="fl mr_10">전체 : <c:out value="${pagination.totRecord}"/>건</b>
			<select name="srchRecPerPage" id="srchRecPerPage" class="input_com w_80px">
			<c:forEach items="${cboCntPerPage}" var="cntPerPage" varStatus="status">
				<option value='<c:out value="${cntPerPage.cd_nm}"/>' <c:if test="${cntPerPage.cd_nm eq pagination.recPerPage}">selected</c:if>><c:out value="${cntPerPage.cd_nm}"/></option>
			</c:forEach>
			</select>
		</div>
		<div class="r_btnbox mb_5">
			<button type="button" class="btn_excel" data-toggle="modal" id="btnExcel">엑셀저장</button>
		</div>
	</div>
	<!--버튼 -->
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col width="5%">
				<col width="20%">
				<col width="15%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
				<col width="30%">
			</colgroup>		
			<thead>
				<tr>
					<th>순번</th>
					<th>인증요청일시</th>
					<th>Face ID</th>
					<th>인증결과</th>
					<th>매칭점수</th>
					<th>기준점수</th>
					<th>단말기ID</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="7">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<c:if test="${list.result_cd == 0}"><c:set var="vFontColor" value="font-color_H" /></c:if>
				<c:if test="${list.result_cd == 1}"><c:set var="vFontColor" value="font-color_E" /></c:if>				
				<tr>
					<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1)  + ( (pagination.curPage - 1)  *  pagination.recPerPage ) }</td>
					<c:if test="${gvLogGb ne 'N'}">
					<td><a style="cursor: pointer;" onclick="fnDetail('${list.sn}')"><c:out value="${list.request_dt}"/></a></td>
					</c:if><c:if test="${gvLogGb eq 'N'}">
					<td><c:out value="${list.request_dt}"/></td>
					</c:if>
					<td><c:out value="${list.face_id}"/></td>
					<td><c:out value="${list.result_nm}"/></td>
					<td><font class="${vFontColor}"><c:out value="${list.score}"/></font></td>
					<td><font class="font-color_V"><c:out value="${list.threshold}"/></font></td>
					<td><c:out value="${list.device_id}"/></td>
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