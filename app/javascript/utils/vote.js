// Vote Loader by Alex Govorov
//
// On turbolinks:load
//  It checks what user is logged in
//  It searches on the page for elemenets class endings with 'vote'
//  It extracts resource type and id from class
//  It loads vote status in JSON format through async XHR request on /vote_status/resource_type/id
//  It renders vote
// On ajax:success
//  It searching for vote element and renders vote
// On ajax:error
//  It renders errors

document.addEventListener("turbolinks:load", () => {
  if(logedIn() != true) return
  voteLoader()
  document.addEventListener("ajax:success", (event) => {
    if (typeof(event.detail[0]) != 'object') return
      var vote = event.detail[0]
    renderVote(vote, voteElement(vote))
  })
  document.addEventListener("ajax:error", (event) => {
    renderErrors(event)
  })
})

function logedIn(){
  var nav_elements = document.querySelector('.nav').getElementsByTagName('li')
  return nav_elements[nav_elements.length-1].innerText == 'Logout'
}

function renderErrors(event) {
  errors = event.detail[0]
  errors_text = ''
  errors.forEach(error => {
    errors_text += `${error} `
  })
  document.querySelector('.flash').innerText = errors_text
}

function voteElement(vote){
  resource_type = vote.resource_type
  resource_id = vote.resource_id
  return document.querySelector(`.${resource_type}-${resource_id}-vote`)
}

function voteLoader(){
  var vote_elements = document.querySelectorAll('div[class$="vote"]')
  if (vote_elements.length > 0) {
  vote_elements.forEach(element => {
    loadVote(element)
    })
  }
}

function voteParams(element){
  var resource_type = element.classList.item(element.classList.length-1).split('-')[0] + 's'
  var resource_id = element.classList.item(element.classList.length-1).split('-')[1]
  return `/${resource_type}/${resource_id}/vote`
}

function loadVote(element){
  fetch(voteParams(element))
  .then((response) => {
    return response.json()
  })
  .then((vote) => {
    renderVote(vote, element)
  })
}

function renderVote(vote, element){
  if (typeof(element) != 'object') return
  element.querySelectorAll('.vote-control').forEach(control => {
    if (vote.can_vote == true) {
      control.classList.replace('invisible','visible')
    } else {
      control.classList.replace('visible','invisible')
    }
  })

  if (vote.can_reset == true) {
    element.querySelector('.vote-reset').classList.replace('invisible','visible')
  } else {
    element.querySelector('.vote-reset').classList.replace('visible','invisible')
  }

  element.querySelector('.h5').innerText = vote.score
}
