<cfoutput>
<cfsavecontent variable="js">
<script type="text/javascript">
$(document).ready(function() {
	$('.linkme,.ecounts:empty').css('cursor','pointer').click(function(){
		window.location = 'index.cfm?action=#url.action#&errorid=#url.errorid#&id='+$(this).parent().attr('id')+'&srch=#url.srch#&page=#url.page#'
	})
	
	$('###val(url.id)#').css('background-color','##FF9')
	$('.statbtn').click(function() {
		var id 		= $(this).parent().parent().attr('id')
		var stat	= $(this).attr('src').split("\/")
		stat		= stat[stat.length-1].split("_")
		stat		= Number(stat[0])
		if (stat == 3) {stat = 0} else {stat = stat+1}
		switch(stat) { 
		case 0:
			var title = "New"
			break;
		 case 1:
			var title = "Attending"
		   break;
		 case 2:
			var title = "Ignored"
		   break;
		 case 3:
			var title = "Fixed"
		   break;
		 }
		$(this).attr({'src':'images/'+stat+'_stat.png','original-title':title})
		$.ajax({url: "js/irongate.cfc?method=stat&returnformat=plain&id="+id+"&stat="+stat, dataType: "text", cache:false, success: function(data){ }})
	})
})
</script>
</cfsavecontent>
</cfoutput>
<cfhtmlhead text="#js#">