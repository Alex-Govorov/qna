document.addEventListener("ajax:error", function(event) {	
	document.querySelector('.flash').innerText = event.detail[0]
})