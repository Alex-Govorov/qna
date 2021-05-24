document.addEventListener("ajax:success", (event) => {
    document.querySelectorAll('.vanilla-nested-add').forEach(element => {
	element.addEventListener('click', addVanillaNestedFields, true
		)})
	document.querySelectorAll('.vanilla-nested-remove').forEach(element => {
	element.addEventListener('click', removeVanillaNestedFields, true
		)})
  })