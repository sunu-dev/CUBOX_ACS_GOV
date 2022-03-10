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
	modalPopup("detailPopup", "임계치 등록", 500, 320);
	
	$('#srchDtFr').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	
	$('#srchDtTo').datetimepicker({
		timepicker:false,
		format:'Y-m-d'
	});
	
	
	$("#btnAddPopup").click(function(){
		fnClearDetail();
		$(".popupwindow_titlebar_text").html("임계치 등록");
		$("#tdCd").html("자동생성");
		$("#detailPopup").PopupWindow("open");
	});
	
	$("#btnClosePopup").click(function(){
		fnClearDetail();
		$("#detailPopup").PopupWindow("close");
	});	
	
	$("#srchRecPerPage").change(function(){
		pageSearch();
	});	
});

function fnClearDetail() {
	$("#tdCd").html("");
	$("#hidCd").val("");
	$("#hidType").val("");
	$("#hidType2").val("");
	$("#txtNm").val("");
	$("#txtVal").val("");
}

function fnEdit(str) {
	$.ajax({
		type: "POST",
		url: "<c:url value='/threshold/get.do'/>",
		data: {"sn" : str},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$(".popupwindow_titlebar_text").html("임계치 편집");
				$("#tdCd").html(data.detail.sn);
				$("#hidCd").val(data.detail.sn);
				$("#hidType").val(data.detail.type);
				$("#hidType2").val(data.detail.type_2);
				$("#tdNm").html(data.detail.nm);
				$("#txtVal").val(data.detail.val);
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

function fnModify() {

	if(fnIsEmpty($("#txtVal").val())) {alert("임계치을 입력하세요."); return;}
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/threshold/modVal.do'/>",
		data: $("#frmDetail").serialize(),
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
			$("#menuDetailPopup").PopupWindow("close");
			document.location.reload();
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + ']\n저장에 실패했습니다.');
			return;
		}
	});
}

function fnSearch() {
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
<input type="hidden" id="initYn" name="initYn" value="N">

<!--검색박스 -->
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
		<div class="r_btnbox  mb_10">
			<%-- <button type="button" class="btn_middle color_basic" id="btnAddPopup">추가</button> --%>
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
				<col width="20%">
				<col width="20%">
				<col width="20%">
				<col width="15%">
			</colgroup>		
			<thead>
				<tr>
					<th>순번</th>
					<th>임계치명</th>
					<th>임계치</th>
					<th>등록일시</th>
					<th>수정일시</th>
					<th>편집</th>
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
					<td><c:out value="${list.nm}"/></td>
					<td><c:out value="${list.val}"/></td>
					<td><c:out value="${list.regist_dt}"/></td>
					<td><c:out value="${list.updt_dt}"/></td>
					<td><button type="button" class="btn_small color_basic" onclick="fnEdit('<c:out value="${list.sn}"/>');">임계치 수정</button></td>
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
<div id="detailPopup" class="example_content">
<form id="frmDetail" name="frmDetail" method="post">
<input type="hidden" id="hidCd" name="hidCd">
<input type="hidden" id="hidType" name="hidType">
<input type="hidden" id="hidType2" name="hidType2">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="30%" />
				<col width="70%" />
				<tbody>
					<tr>
						<th>임계치코드</th>
						<td id="tdCd"></td>
					</tr>
					<tr>
						<th>임계치명</th>
						<td id="tdNm"></td>
					</tr>
					<tr>
						<th>임계치</th>
						<td>
							<input type="text" id="txtVal" name="txtVal" maxlength="10" class="w_200px input_com" autocomplete="off"/>
						</td>
					</tr>					
				</tbody>
			</table>
		</div>
		<!--버튼 -->
		<div class="r_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" onclick="fnModify();">저장</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnClosePopup">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>
