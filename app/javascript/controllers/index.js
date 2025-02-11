// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ChatController from "./chat_controller"
application.register("chat", ChatController)

import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)

import CountdownController from "./countdown_controller"
application.register("countdown", CountdownController)

import DelayedRemovalController from "./delayed_removal_controller"
application.register("delayed-removal", DelayedRemovalController)

import DragDropController from "./drag_drop_controller"
application.register("drag-drop", DragDropController)

import FilterableController from "./filterable_controller"
application.register("filterable", FilterableController)

import FormRedirectController from "./form_redirect_controller"
application.register("form-redirect", FormRedirectController)

import InlineEditController from "./inline_edit_controller"
application.register("inline-edit", InlineEditController)

import ModalController from "./modal_controller"
application.register("modal", ModalController)
