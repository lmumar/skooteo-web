// Usage:
//
// <form class="button_to" action="/fleet/videos/6" accept-charset="UTF-8" method="post"
//  data-controller="form-submit-confirmation"
//  data-form-submit-confirmation-message-value="Are you sure?"
//  data-action="submit->form-submit-confirmation#confirm"
// >
//   ...
// </form>
export default class extends ApplicationController {
  static values = { message: String };

  confirm(event) {
    if (!(window.confirm(this.messageValue))) {
      event.preventDefault()
      event.stopImmediatePropagation()
    };
  };
}
