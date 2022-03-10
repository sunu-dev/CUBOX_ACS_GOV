<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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
	});

	$("#btnExcel").click(function(){
		frmSearch.action = "./crttDayXls.do";
		frmSearch.submit();		
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


</script>
<form id="frmSearch" name="frmSearch" method="post" onsubmit="return false;">
<input type="hidden" id="chkValueArray" name="chkValueArray" value="stat_de,requst_cnt,succes_cnt,succes_rate,failr_cnt,failr_rate" /> 
<input type="hidden" id="chkTextArray" name="chkTextArray" value="요청일자,요청건수,성공건수,성공비율(%),실패건수,실패비율(%)">
<input type="hidden" id="initYn" name="initYn" value="N">

<!--검색박스 -->
<div class="search_box mb_20">
	<div class="search_in_bline">
		<div class="comm_search mr_20">
			<label for="search-from-date" class="title">요청일자</label>
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
</div>
<!--//검색박스 -->
<!--------- 목록--------->
<div class="com_box ">
	<!--버튼 -->
	<div class="totalbox">
		<div class="txbox"></div>
		<div class="r_btnbox mb_5">
			<button type="button" class="btn_excel" id="btnExcel">엑셀저장</button>
		</div>
	</div>
	<!--//버튼  -->
	<!--테이블 시작 -->
	<div class="tb_outbox">
		<table class="tb_list">
			<colgroup>
				<col style="width:15%" />
				<col style="width:15%" />
				<col style="width:15%" />
				<col style="width:15%" />			
				<col style="width:15%" />			
				<col style="width:15%" />			
			</colgroup>		
			<thead>
				<tr>
					<th>요청일자</th>
					<th>요청건수</th>
					<th>성공건수</th>
					<th>성공비율(%)</th>
					<th>실패건수</th>
					<th>실패비율(%)</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${list == null || fn:length(list) == 0}">
				<tr>
					<td class="h_35px" colspan="6">조회 목록이 없습니다.</td>
				</tr>
				</c:if>
				<c:forEach items="${list}" var="list" varStatus="status">
				<tr <c:if test="${list.stat_de eq '합계'}">class="total2"</c:if>>
					<td><c:out value="${list.stat_de}"/></td>
					<td class="td_right"><fmt:formatNumber value="${list.requst_cnt}" type="number"/></td>
					<td class="td_right"><fmt:formatNumber value="${list.succes_cnt}" type="number"/></td>
					<td><c:out value="${list.succes_rate}"/></td>
					<td class="td_right"><fmt:formatNumber value="${list.failr_cnt}" type="number"/></td>
					<td><c:out value="${list.failr_rate}"/></td>
				</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>	
<!--------- //목록--------->
<!--//본문시작 -->
</form>