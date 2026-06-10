import {Application} from "@hotwired/stimulus"
import AutoSubmit from '@stimulus-components/auto-submit'
import Timeago from '@stimulus-components/timeago'

const application = Application.start()

application.register('auto-submit', AutoSubmit)
application.register('timeago', Timeago)

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export {application}
