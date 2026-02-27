import app from "ags/gtk3/app"
import Bar from "./bar/Bar"
import "./style.scss"

app.start({
  async main() {
    const Hyprland = (await import("gi://AstalHyprland")).default
    const hyprland = Hyprland.get_default()
    hyprland.get_monitors().forEach((m) => Bar(m.id))
  },
})
