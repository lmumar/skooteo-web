/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import { Turbo } from "@hotwired/turbo-rails"
import * as ActiveStorage from "activestorage"
import swal from "sweetalert"

ActiveStorage.start()

window.swal = swal
window.Turbo = Turbo

require("application")
