import Dialog from "@stimulus-components/dialog"

export default class extends Dialog {
  connect() {
    super.connect()

    this.element.addEventListener("dialog:close", () => {
      this.close()
    })
  }
}
