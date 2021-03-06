// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import 'bootstrap'
import 'vanilla-nested'
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

require('utils/ajax_errors')
require('utils/gist_loader')
require('utils/vannila_nested_ajax')
require('utils/vote')

Rails.start()
Turbolinks.start()
ActiveStorage.start()
