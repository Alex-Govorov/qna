// Async Gist Loader by Alex Govorov
// 
// It searches on the page for elemenets with class="gist" on page load or ajax:success events
// It gets gist id from href in nested <a> element
// It loads gist in JSON format through gist API
// It renders element with gist filenames and content
// It changes element class to "gist-loaded"

document.addEventListener("turbolinks:load", () => {  
  gistLoader()
  document.addEventListener("ajax:success", (event) => {
    gistLoader()
  })
})

function gistLoader(){
  var gist_elements = document.querySelectorAll('.gist')  
  if (gist_elements.length > 0) {
    gist_elements.forEach(element => {
      loadGist(element)
    })
  }
}

function gistId(element){
  return element.getElementsByTagName('a')[0].href.split('/').slice(-1).toString()
}

function loadGist(element) {
  fetch('https://api.github.com/gists/' + gistId(element))
    .then((response) => {
      return response.json()
    })
    .then((gist) => {          
      return Promise.all([listGistFiles(gist), gist])
    })
    .then(([files, gist]) => {
      renderGist(files, gist, element)
    })    
  }

 function listGistFiles(gist) {
    var files = []
    for(var file in gist.files) {
      files.push(file)      
    }
    return files
  }  

  function renderGist(files, gist, element){
    var html = ''
    files.forEach(file => {
      html += `<small class="text-muted">${file}</small>`
      html += `<pre>${gist.files[file].content}</pre>`
    })
    element.innerHTML = html
    element.classList.replace('gist','gist-loaded')
}
