// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChatController from "./chat_controller"
application.register("chat", ChatController)

import CountdownController from "./countdown_controller"
application.register("countdown", CountdownController)

import DelayedRemovalController from "./delayed_removal_controller"
application.register("delayed-removal", DelayedRemovalController)

import DraftController from "./draft_controller"
application.register("draft", DraftController)

import FilterableController from "./filterable_controller"
application.register("filterable", FilterableController)

import FormRedirectController from "./form_redirect_controller"
application.register("form-redirect", FormRedirectController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)
