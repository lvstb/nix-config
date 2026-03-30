import app from "ags/gtk3/app"
import Bar from "./bar/Bar"
import style from "./style.scss"

app.start({
  instanceName: "bar",
  requestHandler(_argv: string[], respond: (response: string) => void) {
    respond("ok")
  },
  css: style,
  main() {
    return app.get_monitors().map(Bar)
  },
})
