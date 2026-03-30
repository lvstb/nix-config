import app from "ags/gtk3/app"
import Bar from "./bar/Bar"
import style from "./style.scss"

app.start({
  css: style,
  main() {
    app.get_monitors().map(Bar)
  },
})
