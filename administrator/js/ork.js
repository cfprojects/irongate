$("document").ready(function() {
	// set tooltip
	$('.tip').tipsy({fade: true, gravity: 'nw'});
	$('.statbtn, .ecounts img').tipsy({fade: true, gravity: 'w'});
	// Tabs
	if ($('.tabline').length !== 0) {
		$('.tabline div').addClass('tab')
		$('.tabline div:first').css('margin-left','10px')
		$('.tabline div:last').css('margin-right','10px')
		$('.tabline').show()
		$('.tabline div').click(function() {
			$('.tabline .tabsel').removeClass('tabsel').addClass('tab')
			$(this).removeClass('tab').addClass('tabsel')
			$(this).parent().next().children('div:visible').hide()
			$(this).parent().next().children('div:nth-child('+ Number(Number($(this).index())+1) +')').show()
		})
		$('.tabline .tab:first').click()
	}
	
	$('td:contains("[Query]")').click(function(e) { $('#query_tab').click() }).css('cursor','pointer');
	$('#hidetable').click(function(e) {
		if ( $('.gridtable').is(':visible')) {
			$('.gridtable').fadeOut('slow', function(){ $('#hidetable').html('Expand') })
		} else {
			$('.gridtable').fadeIn('slow', function() { $('#hidetable').html('Fold') })
		}
	});
})

/////////////////////////////////////
// error message                  ///
/////////////////////////////////////
function showmsg(i) {
	$('.alertboxmsg').html( '<img src="images/success.png" align="absmiddle" /> ' + i)
	$('#alertbox').slideDown('slow', function() { setTimeout('hidealertbox()', 5000) });
}

function showerror(i) {
	$('.alertboxmsg').html( '<img src="images/critical.png" align="absmiddle" /> ' + i)
	$('#alertbox').slideDown('slow', function() {});
}

function hidealertbox() {
	$('#alertbox').slideUp('slow', function() { });
}