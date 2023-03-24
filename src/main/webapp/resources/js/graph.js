function showAdminGraph(dmndNo) {
   console.log("graph dmndNo : " + dmndNo);
   $.ajax({
      url : "/progress/chart?dmndNo=" + dmndNo,
      type : "GET",
      success : function(res) {
         var gname = res.srNo;
         console.log("ㅁㅁ");
         if (!res.dateList) {
            console.log("ㅁㅁ");
            console.log("차트 실패");
            const chart = Highcharts.chart('adGraph', {
               title : {
                  text : '진척계획이 수립되지 않았습니다.'
               },
               xAxis : {
                  
               },
               yAxis : {
                  title : {
                     text : '진척률'
                  }
               },
               series : [ {
                  type : 'line',
                  name : '계획'
                  
               }, {
                  type : 'column',
                  name : '현재'
                  
               } ]
            });
         } else {
            const chart = Highcharts.chart('adGraph', {
               title : {
                  text : res.srNo + ' 진척계획 및 현황'
               },
               xAxis : {
                  categories : res.dateList
               },
               yAxis : {
                  title : {
                     text : '진척률'
                  }
               },
               series : [ {
                  type : 'line',
                  name : '계획',
                  data : res.prgrsList
               }, {
                  type : 'column',
                  name : '현재',
                  data : res.nowArr
               } ]
            });
         }
      }
   });
}