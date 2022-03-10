<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<jsp:include page="/WEB-INF/jsp/cubox/common/checkPasswd.jsp" flush="false"/>
<spring:eval expression="@property['Globals.main.autoRefreshSecond']" var="gvAutoRefreshSecond"/>
<script type="text/javascript" src="/js/charts/loader.js"></script>
<script type="text/javascript" src="/js/charts/charts.min.js"></script>
<script type="text/javascript" src="/js/charts/chartjs-plugin-datalabels.min.js"></script>
<script type="text/javascript" src="/js/charts/chartjs-plugin-doughnutlabel.min.js"></script>
<script type="text/javascript" src="/js/charts/utils.js"></script>
<script type="text/javascript">
$(function() {
	<c:if test="${gvAutoRefreshSecond > 0}">
	setTimeout(function(){location.reload();}, <fmt:parseNumber value="${gvAutoRefreshSecond*1000}" integerOnly="true"/>);
	</c:if>
	
	//chartBar 일별얼굴인증현황
	$.ajax({
		type:"POST",
		url:"<c:url value='/main/chart01.do' />",
		dataType:"json",
		success:function(result) {
			if(result != null && result.list != null) {
				fnGetChartBar01(result.list);
			}
		}
	});	
	
	//chartPie 금일얼굴인증현황
	$.ajax({
		type:"POST",
		url:"<c:url value='/main/chart02.do' />",
		dataType:"json",
		success:function(result) {
			if(result != null && result.data != null) {
				fnGetChartPie02(result.data);
			}
		}
	});	
	
	
});

var arrChartColor = ['#213884', '#37A0FF', "#FF5952"];  //요청건수,성공건수,실패건수

function fnGetChartBar01(data) {
	var arrLabel = [];
	var arrData1 = [];
	var arrData2 = [];
	for(var i in data) {
		arrLabel.push(data[i].stat_de);
		arrData1.push(parseInt(data[i].requst_cnt));
		arrData2.push(parseInt(data[i].succes_cnt));
	}
	var color = Chart.helpers.color;
	var chartData = {
		labels: arrLabel,
		datasets: [{
			type: 'line',
			label: '요청건수',
			backgroundColor: arrChartColor[0],
			borderColor: arrChartColor[0],
			borderWidth: 2,
			fill: false,
			data: arrData1,
			datalabels: {
				align: 'end',
				anchor: 'end'
			}			
		}, {
			type: 'bar',
			label: '성공건수',
			backgroundColor: arrChartColor[1],
			borderColor: arrChartColor[1],
			borderWidth: 2,
			fill: false,
			data: arrData2,
			datalabels: {
				align: 'start',
				anchor: 'end'
			}			
		}]
	};
	
	var canvasOptionsBar = {
		responsive: true,				/*자동크기 조정*/
		maintainAspectRatio: false, 	/*가로세로 비율*/
		elements: {
			line: {
				tension: 0.000001	/*line 곡선 조절*/
			}
		},
		legend: {
			position: 'left',
			align: "end",
			labels: {
				fontSize : 12,
				padding : 5
			}
		},
		title: {
			display: false,
			text: '일별 입장객 현황'
		},
		tooltips: false,
		/* tooltips: {
			mode: 'index',
			intersect: true
		}, */
		layout: {
			padding: {
				left: 10,
				right: 0,
				top: 30,
				bottom: 10
			}
		},
		plugins: {
			datalabels: {
				backgroundColor: function(context) {
					return context.dataset.backgroundColor;
				},
				borderRadius: 4,
				color: 'white',
				font: {
					weight: 'bold',
					size: 13
				},
				formatter: Math.round
			}
		},
		scales: {
            x: {
                stacked: true
            },
            y: {
                stacked: true
            },			
			yAxes: [{
				ticks: {
					min: 0
					//stepSize: 1
				}
			}]
		}
	};

	new Chart(document.getElementById('canvasBar').getContext('2d'), {
		type: 'bar',
		data: chartData,
		options: canvasOptionsBar
	});
}

function fnGetChartPie02(data) {
	$("#spanText").html(data.cf_pass_rate+"%");

	var canvasOptionsPie = {
		//responsive: true,				/*자동크기 조정*/
		maintainAspectRatio: false, 	/*가로세로 비율*/
		cutoutPercentage: 40,
		legend: {
			position: 'left',
			align: "end",
			labels: {
				fontSize : 12,
				padding : 5,
			}
		},
		title: {
			display: false,
			text: '금일 얼굴인식 성공률'
		},
		tooltips: false,
		hover: {
			mode: null
		},
		layout: {
			padding: {
				left: 10,
				right: 0,
				top: 10,
				bottom: 20
			}
		},
		elements: {
	        arc: {
	            borderWidth: 0
	        }
	    },		
		plugins: {
			datalabels: {
				backgroundColor: function(context) {
					return context.dataset.backgroundColor;
				},
				//borderColor: 'white',
				//borderRadius: 25,
				//borderWidth: 2,
				color: 'white',
				display: function(context) {
					/* var dataset = context.dataset;
					var count = dataset.data.length;
					var value = dataset.data[context.dataIndex];
					return value > count * 1.5; */
					return context.dataset.data[context.dataIndex] > 0;
				},
				font: {
					weight: 'bold',
					size: 18
				},
				formatter: Math.round
			},
			doughnutlabel: {
				labels: [{
					text: data.cf_tot,
					font: {
						weight: 'bold',
						size: 18
					}
				}]
			}			
		}
	};
	
	//canvasOptionsPie.plugins.doughnutlabel.labels[0].text = data.cf_tot;
	var configPie = {
		type: 'doughnut', //'doughnut',
		data: {
			labels: ['성공건수', '실패건수'],
			datasets: [{
				data: [data.cf_pass, data.cf_fail],
				backgroundColor: [arrChartColor[1], arrChartColor[2]],
				borderColor: [arrChartColor[1], arrChartColor[2]],
			}]
		},
		options: canvasOptionsPie
	};
	configPie.data.datasets.forEach(dataset => {
		if (dataset.data.every(el => el === 0)) {
			dataset.backgroundColor.push('#E8E8E8');
			dataset.data.push(1);
			canvasOptionsPie.plugins.datalabels.color = "#E8E8E8";
		}
	});
	var chartPie = new Chart(document.getElementById('canvasPie').getContext('2d'), configPie);
}

function fnGoToPage(page){
	gotoForm.action = page;
	gotoForm.submit();
}
</script>
<form id="gotoForm" name="gotoForm" method="post" target="_self">
</form>
<div class="main_b">
	<div class="inbox1">
		<div class="title">일별 얼굴인증현황</div>
		<div class="gr">
			<div style="height: 320px; margin-left: 10px;">
				<canvas id="canvasBar"></canvas>
			</div>
		</div>
	</div>
	<div class="inbox1">
		<div class="title">금일 얼굴인증현황
			<br><font color="#0082F5"><span id="spanText"></span></font>
		</div>
		<div class="gr">
			<div style="height: 320px; margin-left: 10px;">
				<canvas id="canvasPie"></canvas>
			</div>
		</div>
	</div>
	<div class="inbox3">
		<div class="title">얼굴인증이력 (최근 <c:out value="${limitCnt}" />건)
			<div class="more">
				<img src="/img/main/icon_more.png" alt="" onclick="fnGoToPage('/gallery/history.do');"/>
			</div>
		</div>
		<div class="tb_outbox">
			<table class="tb_list_main">
				<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="12%">
					<col width="9%">
					<col width="9%">
					<col width="9%">
					<col width="14%">
					<col width="13%">
					<col width="14%">
				</colgroup>		
				<thead>
					<tr>
						<th>순번</th>
						<th>인증요청일시</th>
						<th>UUID</th>
						<th>인증결과</th>
						<th>매칭점수</th>
						<th>기준점수</th>
						<th>(a)특징점추출시간(ms)</th>
						<th>(b)매칭시간(ms)</th>
						<th>(a+b+α)전체시간(ms)</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${list == null || fn:length(list) == 0}">
					<tr>
						<td class="h_35px" colspan="9">조회 목록이 없습니다.</td>
					</tr>
					</c:if>
					<c:forEach items="${list}" var="list" varStatus="status">
					<c:if test="${list.result_cd == 0}"><c:set var="vFontColor" value="font-color_H" /></c:if>
					<c:if test="${list.result_cd == 1}"><c:set var="vFontColor" value="font-color_E" /></c:if>				
					<tr>
						<td>${(pagination.totRecord - (pagination.totRecord-status.index)+1)  + ( (pagination.curPage - 1)  *  pagination.recPerPage ) }</td>
						<td><c:out value="${list.request_dt}"/></td>
						<td><c:out value="${list.uuid}"/></td>
						<td><c:out value="${list.result_nm}"/></td>
						<td><font class="${vFontColor}"><c:out value="${list.score}"/></font></td>
						<td><font class="font-color_V"><c:out value="${list.threshold}"/></font></td>
						<td><c:out value="${list.inference_time}"/></td>
						<td><c:out value="${list.match_time}"/></td>
						<td><c:out value="${list.total_time}"/></td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<c:if test="${gvAutoRefreshSecond > 0}">
	<div style="width: 100%; margin-top: 10px; text-align: right;">
		<span style="font-size: 13px;">※ <fmt:parseNumber value="${gvAutoRefreshSecond/60}" integerOnly="true"/>분마다 새로고침 실행</span> 
	</div>
	</c:if>
</div>	

