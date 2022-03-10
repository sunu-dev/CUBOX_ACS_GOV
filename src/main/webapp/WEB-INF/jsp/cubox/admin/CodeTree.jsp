<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/jsp/cubox/common/checkPasswd.jsp" flush="false"/>
<%-- <link rel="stylesheet" type="text/css" href="/css/bootstrap.min.css"> --%> 
<link rel="stylesheet" type="text/css" href="/css/bstreeview.css"> 
<link rel="stylesheet" type="text/css" href="/css/font-awesome.min.css" />
<script type="text/javascript" src="/js/bootstrap.min.js"></script>
<style>
.list-group-item {
    position: relative;
    display: block;
    padding: 10px 15px;
    margin-bottom: -1px;
    background-color: #fff;
    border: 1px solid #ddd;
}
.list-group-item:first-child {
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
}
</style>
<script type="text/javascript" src="/js/bstreeview.js"></script>
<script type="text/javascript">
$(function() {
	$(".title_tx").html("${menuNm}");
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getCdTree.do'/>",
		dataType: 'json',
		success: function(data) {
			if(data) {
				$('#tree').bstreeview({
					indent : 2,
					expandIcon : 'fa fa-angle-down',
					collapseIcon : 'fa fa-angle-right',
					data: JSON.stringify(data.tree),
					openNodeLinkOnNewTab : false
				});
				// 최초 화면 로딩시 트리를 접는다
				$("div[id^='tree-item-']").css("height", "0px");
			} else {
				alert("ERROR");
			}
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 조회 실패!');
			return;
		}
	});	

	$("#btnMenuAdd").on("click", function(event){
		fnClearMenu();
		$("#frmMenuDetail").find(".popupwindow_titlebar_text").html("메뉴 등록");
		$("#tdMenuCode").html("자동생성");
		$("#menuDetailPopup").PopupWindow("open");
	});
	
	$("#btnMenuClMng").on("click", function(event){
		fnPopupMenuClList();
		$("#menuClListPopup").PopupWindow("open");
	});
	
	$("#btnMenuPopupClose").click(function(){
		fnClearMenu();
		$("#menuDetailPopup").PopupWindow("close");
	});
	
	$("#btnMenuClAdd").on("click", function(event){
		fnClearMenuCl();
		$("#frmMenuCl").find(".popupwindow_titlebar_text").html("메뉴분류 등록");
		$("#tdMenuClCode").html("자동생성");
		$("#menuClPopup").PopupWindow("open");
	});	
	
	$("#btnMenuClPopupClose").click(function(){
		fnClearMenu();
		$("#menuClPopup").PopupWindow("close");
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
		$("#menu_cl_cd").val("");
		$("#menu_nm").val("");
		$("#use_yn").val("");
	});

	$("#menu_nm").keyup(function(e){if(e.keyCode == 13) pageSearch("1");});
	
	modalPopup("menuDetailPopup", "메뉴 등록", 650, 420);
	modalPopup("menuClListPopup", "메뉴분류 관리", 670, 450);	
	modalPopup("menuClPopup", "메뉴분류 등록", 550, 370);	
});

function fnGetCodeList(obj, cd) {
	/* gvObj = obj;
	console.log(obj);
	console.log(obj.id);  // cmn_cd
	console.log(gvObj.ariaExpanded);
	if(!gbObj.ariaExpanded) {
		$("div[id^='tree-item-']").css("height", "0px");
		$("div[id^='tree-item-']").addClass("collapsed");
		$("div[id^='tree-item-']").ariaExpanded = false;
	} */
	if(cd == "${params.upper_cd}") {
		return;
	} else {
		$("#upper_cd").val(cd);
		frmSearch.action = "${menuUrl}";
		//frmSearch.submit();
	}
}

function fnSaveMenu() {
	if(!fnFormValueCheck("frmMenuDetail")) return;
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/saveMenuInfo.do'/>",
		data: $("#frmMenuDetail").serialize(),
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

function fnEditMenu(str) {
	$("#frmMenuDetail").find(".popupwindow_titlebar_text").html("메뉴 편집");

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getMenuInfo.do'/>",
		data: {"menu_cd" : str},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$("#tdMenuCode").html(data.detail.menu_cd);
				$("#hidMenuCode").val(data.detail.menu_cd);
				$("#selMenuCl").val(data.detail.menu_cl_cd);
				$("#txtMenuNm").val(data.detail.menu_nm);
				$("#txtMenuUrl").val(data.detail.menu_url);
				$("#txtSortOrdr").val(data.detail.sort_ordr);
				$("#menuDetailPopup").PopupWindow("open");
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

function fnModUseYn(str, useYn, clUseYn) {
	console.log(fnIsEmpty(clUseYn)+"/"+clUseYn);
	
	if(!fnIsEmpty(clUseYn) && clUseYn == "N") {
		alert("해당 메뉴의 분류코드가 사용안함으로 변경할 수 없습니다.\n\n메뉴분류 코드를 사용으로 변경 후 처리하세요.");
		return;
	}
	
	if(!confirm("사용여부를 ["+(useYn=='Y'?'사용중':'사용안함')+"]으로 변경하시겠습니까?")) return;

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/modMenuUseYn.do'/>",
		data: {
			"menu_cd" : str,
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

function fnClearMenu() {
	$("#hidMenuCode").val("");
	$("#txtMenuNm").val("");
	$("#selMenuCl").val("");
	$("#txtMenuUrl").val("");
	$("#txtSortOrdr").val("");
}

function fnClearMenuCl() {
	$("#hidMenuClCode").val("");
	$("#txtMenuClNm").val("");
	$("#txtClSortOrdr").val("");
}

function fnPopupMenuClList() {
	//search
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getMenuClList.do'/>",
		data: {},
		dataType: 'json',
		success: function(data) {
			var totalList = "";
			if(!fnIsEmpty(data.list)) {
				if( data.list != null && data.list.length > 0 ) {
					for(var i = 0 ; i < data.list.length ; i++ ) {
						totalList += "<tr><td>" + data.list[i].menu_cl_cd + "</td><td>" 
						+ data.list[i].menu_cl_nm + "</td><td>" 
						+ data.list[i].icon_image + "</td><td>" 
						+ data.list[i].sort_ordr + "</td><td>" 
						+ (!fnIsEmpty(data.list[i].use_yn) && data.list[i].use_yn=="Y"?"<button type='button' class='btn_small color_basic' onclick='fnModClUseYn(\""+data.list[i].menu_cl_cd+"\", \"N\")'>사용중</button>":"<button type='button' class='btn_small color_gray' onclick='fnModClUseYn(\""+data.list[i].menu_cl_cd+"\", \"Y\")'>사용안함</button>")
						+"</td><td>"
						+ (!fnIsEmpty(data.list[i].use_yn) && data.list[i].use_yn=="Y"?"<button type='button' class='btn_small color_basic' onclick='fnEditMenuCl(\""+data.list[i].menu_cl_cd+"\")'>편집</button>":"&nbsp;")
						+"</td></tr>";
					}
				}	
				$("#tbMenuClList").html(totalList);
				$("#menuClListPopup").PopupWindow("open");
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

function fnSaveMenuCl() {
	if(!fnFormValueCheck("frmMenuCl")) return;
	
	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/saveMenuClInfo.do'/>",
		data: $("#frmMenuCl").serialize(),
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
			$("#menuClPopup").PopupWindow("close");
			document.location.reload();
			fnPopupMenuClList();
		},
		error: function(jqXHR){
			alert('[' + jqXHR.status + ' ' + jqXHR.statusText + '] 저장 실패!');
			return;
		}
	});
}

function fnEditMenuCl(str) {
	$("#frmMenuCl").find(".popupwindow_titlebar_text").html("메뉴분류 편집");

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/getMenuClInfo.do'/>",
		data: {"menu_cl_cd" : str},
		dataType: 'json',
		success: function(data) {
			if(!fnIsEmpty(data.detail)) {
				$("#tdMenuClCode").html(data.detail.menu_cl_cd);
				$("#hidMenuClCode").val(data.detail.menu_cl_cd);
				$("#txtMenuClNm").val(data.detail.menu_cl_nm);
				$("#txtIconImg").val(data.detail.icon_image);
				$("#txtClSortOrdr").val(data.detail.sort_ordr);
				$("#menuClPopup").PopupWindow("open");
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

function fnModClUseYn(str, useYn) {
	if(!confirm("해당 메뉴분류에 속하는 메뉴도 동시에 사용안함 처리합니다.\n\n사용여부를 ["+(useYn=='Y'?'사용중':'사용안함')+"]으로 변경하시겠습니까?")) return;

	$.ajax({
		type: "POST",
		url: "<c:url value='/admin/modMenuClUseYn.do'/>",
		data: {
			"menu_cl_cd" : str,
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
<input type="hidden" id="upper_cd" name="upper_cd">
<!--------- 목록--------->
<div class="com_box ">
	<!--테이블 시작 -->
	<div class="box_w2">
	<div class="box_w2_1d">
		<div class="totalbox">
			<div class="txbox">&nbsp;</div>
			<!--버튼 -->
			<div class="r_btnbox mb_10">
				<button type="button" class="btn_middle color_basic" onclick="fnPopupMenuClList()">상위코드관리</button>
			</div>
			<!--//버튼  -->	
		</div>	
		<div id="tree"></div>
	</div> 
	<div class="box_w2_2d">
		<div class="totalbox">
			<div class="txbox">&nbsp;</div>
			<!--버튼 -->
			<div class="r_btnbox mb_10">
				<button type="button" class="btn_middle color_basic" onclick="fnPopupMenuClList()">코드추가</button>
			</div>
			<!--//버튼  -->	
		</div>
		<div class="tb_outbox">
			<table class="tb_list">
				<colgroup>
					<col width="5%" />
					<col width="8%" />
					<col width="15%" />
					<col width="7%" />
					<col width="15%" />
					<col width="7%" />
					<col width="7%" />
					<col width="7%" />
				</colgroup>
				<thead>
					<tr>
						<th>순번</th>
						<th>상위코드</th>
						<th>상위코드명</th>
						<th>코드</th>
						<th>코드명</th>
						<th>정렬순번</th>						
						<th>사용여부</th>
						<th>편집</th>
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
						<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1)  + ( (pagination.curPage - 1)  *  pagination.recPerPage ) }</td>
						<td><c:out value="${list.upper_cd}"/></td>
						<td><c:out value="${list.upper_cd_nm}"/><c:if test="${list.upper_use_yn ne 'Y'}"><font class="font-color_H"> (사용안함)</font></c:if></td>
						<td><c:out value="${list.cd}"/></td>
						<td><c:out value="${list.cd_nm}"/><c:if test="${list.use_yn ne 'Y'}"><font class="font-color_H"> (사용안함)</font></c:if></td>
						<td><c:out value="${list.sort_ordr}"/></td>
						<td>
							<c:if test="${list.use_yn eq 'Y'}"><button type="button" class="btn_small color_basic" onclick="fnModUseYn('<c:out value="${list.menu_cd}"/>', 'N');">사용중</button></c:if>
							<c:if test="${list.use_yn eq 'N'}"><button type="button" class="btn_small color_gray" onclick="fnModUseYn('<c:out value="${list.menu_cd}"/>', 'Y', '<c:out value="${list.cl_use_yn}"/>');">사용안함</button></c:if>
						</td>
						<td><c:if test="${list.use_yn eq 'Y'}"><button type="button" class="btn_small color_basic" onclick="fnEditMenu('<c:out value="${list.menu_cd}"/>');">편집</button></c:if></td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	</div>
</div>
</form>

<!-- modal : 등록 -->
<div id="menuDetailPopup" class="example_content">
<form id="frmMenuDetail" name="frmMenuDetail" method="post">
<input type="hidden" name="hidMenuCode" id="hidMenuCode">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="25%" />
				<col width="75%" />
				<tbody>
					<tr>
						<th>메뉴코드 <span class="font-color_H">*</span></th>
						<td id="tdMenuCode"></td>
					</tr>
					<tr>
						<th>메뉴분류 <span class="font-color_H">*</span></th>
						<td>
							<select name="selMenuCl" id="selMenuCl" size="1" class="input_com w_190px" check="text" checkName="메뉴분류">
								<option value="" disabled selected>선택</option>
								<c:forEach items="${cboMenuCl}" var="menuCl" varStatus="status">
								<option value='<c:out value="${menuCl.menu_cl_cd}"/>'><c:out value="${menuCl.menu_cl_nm}"/></option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th>메뉴명 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtMenuNm" id="txtMenuNm" maxlength="30" class="w_100p input_com" check="text" checkName="메뉴명" />
						</td>
					</tr>
					<tr>
						<th>URL경로 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtMenuUrl" id="txtMenuUrl" maxlength="200" class="w_100p input_com" check="text" checkName="URL경로"/>
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
				<button type="button" class="comm_btn mr_5" onclick="fnSaveMenu();">저장</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnMenuPopupClose">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>

<div id="menuClListPopup" class="example_content">
	<div class="popup_box">
		<div class="search_box_popup mb_20 fl">
			<div class="search_in">
				<label style="font-size: 14px;" id="">메뉴분류 목록</label>
			</div>	
			<button type="button" class="comm_btn mr_5 mt_5" id="btnMenuClAdd">추가</button>
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
							<th>분류코드</th>
							<th>분류명</th>
							<th>아이콘</th>
							<th>순서</th>
							<th>사용여부</th>
							<th>편집</th>
						</tr>
					</thead>
					<tbody id="tbMenuClList"></tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<div id="menuClPopup" class="example_content">
<form id="frmMenuCl" name="frmMenuCl" method="post">
<input type="hidden" name="hidMenuClCode" id="hidMenuClCode">
	<div class="popup_box">
		<!--테이블 시작 -->
		<div class="tb_outbox mb_20">
			<table class="tb_write_02 tb_write_p1">
				<col width="25%" />
				<col width="75%" />
				<tbody>
					<tr>
						<th>메뉴분류코드 <span class="font-color_H">*</span></th>
						<td id="tdMenuClCode"></td>
					</tr>
					<tr>
						<th>메뉴분류명 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtMenuClNm" id="txtMenuClNm" maxlength="30" class="w_100p input_com" check="text" checkName="메뉴분류명" />
						</td>
					</tr>
					<tr>
						<th>아이콘파일명 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtIconImg" id="txtIconImg" maxlength="50" class="w_100p input_com" check="text" checkName="아이콘파일명" />
						</td>
					</tr>
					<tr>
						<th>정렬순서 <span class="font-color_H">*</span></th>
						<td>
							<input type="text" name="txtClSortOrdr" id="txtClSortOrdr" maxlength="3" class="w_100px input_com onlyNumber" check="text" checkName="정렬순서"/>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--버튼 -->
		<div class="r_btnbox">
			<div style="display: inline-block;">
				<button type="button" class="comm_btn mr_5" onclick="fnSaveMenuCl();">저장</button>
				<button type="button" class="bk_color comm_btn mr_5" id="btnMenuClPopupClose">취소</button>
			</div>
		</div>
		<!--//버튼  -->
	</div>
</form>	
</div>