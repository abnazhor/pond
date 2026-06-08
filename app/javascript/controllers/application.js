import {Application} from "@hotwired/stimulus"
import AutoSubmit from '@stimulus-components/auto-submit'
import Dialog from '@stimulus-components/dialog'

const application = Application.start()

application.register('auto-submit', AutoSubmit)
application.register('dialog', Dialog)

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export {application}
