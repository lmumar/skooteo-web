/* eslint no-console:0 */
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("auth", true, /.js$/)
application.load(definitionsFromContext(context))
