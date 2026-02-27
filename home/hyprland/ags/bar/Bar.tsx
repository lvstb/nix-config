import { App, Astal, Gtk, Gdk } from "ags/gtk3"
import Hyprland from "gi://AstalHyprland"
import Mpris from "gi://AstalMpris"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"
import { Variable, bind, execAsync } from "ags"

// ─── helpers ────────────────────────────────────────────────────────────────

function NixLogo() {
  return (
    <button
      className="nix-logo"
      tooltip_text="NixOS"
      onClicked={() => execAsync(["firefox", "https://search.nixos.org/packages"])}
    >
      <label label="" />
    </button>
  )
}

// ─── workspaces ─────────────────────────────────────────────────────────────

function Workspaces() {
  const hyprland = Hyprland.get_default()

  return (
    <box className="workspaces">
      {bind(hyprland, "workspaces").as((wss) =>
        [1, 2, 3, 4, 5].map((id) => {
          const ws = wss.find((w) => w.id === id)
          const isActive = bind(hyprland, "focusedWorkspace").as(
            (fw) => fw?.id === id,
          )
          const isEmpty = bind(hyprland, "workspaces").as(
            (all) => !all.find((w) => w.id === id),
          )

          return (
            <button
              className={isActive.as((a) =>
                a ? "workspace active" : isEmpty.as((e) => (e ? "workspace empty" : "workspace")),
              )}
              onClicked={() => hyprland.dispatch("workspace", `${id}`)}
            >
              <label label={`${id}`} />
            </button>
          )
        }),
      )}
    </box>
  )
}

// ─── media (MPRIS) ───────────────────────────────────────────────────────────

function Media() {
  const mpris = Mpris.get_default()

  return (
    <box
      className="media"
      visible={bind(mpris, "players").as((p) => p.length > 0)}
    >
      {bind(mpris, "players").as((players) => {
        const player = players[0]
        if (!player) return <label label="" />

        const isSpotify = bind(player, "busName").as((n) =>
          n?.toLowerCase().includes("spotify"),
        )
        const icon = isSpotify.as((s) => (s ? "󰓇" : "󰎈"))
        const title = bind(player, "title").as((t) => t ?? "")
        const artist = bind(player, "artist").as((a) => a ?? "")
        const text = Variable.derive([title, artist], (t, a) =>
          a && t ? `${a} - ${t}` : t || a || "",
        )

        return (
          <button
            className="media-player"
            onClicked={() => player.play_pause()}
            onScrollUp={() => player.next()}
            onScrollDown={() => player.previous()}
          >
            <label
              label={Variable.derive([bind(icon), bind(text)], (i, s) =>
                s ? `${i}  ${s}` : "",
              )()}
              maxWidthChars={40}
              truncate
            />
          </button>
        )
      })}
    </box>
  )
}

// ─── bluetooth ───────────────────────────────────────────────────────────────

function BluetoothWidget() {
  const bt = Bluetooth.get_default()

  const icon = bind(bt, "isPowered").as((powered) => {
    if (!powered) return "󰂲"
    const connected = bt.get_devices().some((d) => d.connected)
    return connected ? "󰂱" : "󰂯"
  })

  return (
    <button
      className="bluetooth pill"
      tooltip_text={bind(bt, "isPowered").as((p) => (p ? "Bluetooth on" : "Bluetooth off"))}
      onClicked={() => execAsync(["blueman-manager"])}
    >
      <label label={icon} />
    </button>
  )
}

// ─── network ─────────────────────────────────────────────────────────────────

function NetworkWidget() {
  const network = Network.get_default()

  const icon = bind(network, "primary").as((primary) => {
    if (primary === Network.Primary.WIFI) return ""
    if (primary === Network.Primary.WIRED) return ""
    return ""
  })

  const tooltip = bind(network, "primary").as((primary) => {
    if (primary === Network.Primary.WIFI) {
      const ssid = network.wifi?.ssid ?? ""
      const strength = network.wifi?.strength ?? 0
      return ssid ? `${ssid} (${strength}%)` : "WiFi"
    }
    if (primary === Network.Primary.WIRED) return "Ethernet"
    return "Disconnected"
  })

  return (
    <button
      className={bind(network, "primary").as((p) =>
        p === Network.Primary.UNKNOWN ? "network pill disconnected" : "network pill",
      )}
      tooltip_text={tooltip}
      onClicked={() => execAsync(["ghostty", "--", "nmtui"])}
    >
      <label label={icon} />
    </button>
  )
}

// ─── volume ──────────────────────────────────────────────────────────────────

function Volume() {
  const wp = Wp.get_default()
  const audio = wp?.audio

  if (!audio) return <box />

  const speaker = audio.default_speaker

  const icon = bind(speaker, "mute").as((muted) => {
    if (muted) return ""
    const vol = speaker.volume ?? 0
    if (vol === 0) return "󰕿"
    if (vol < 0.5) return "󰖀"
    return "󰕾"
  })

  return (
    <button
      className={bind(speaker, "mute").as((m) => (m ? "volume pill muted" : "volume pill"))}
      tooltip_text={bind(speaker, "volume").as((v) => `${Math.round((v ?? 0) * 100)}% volume`)}
      onClicked={() => execAsync(["pavucontrol"])}
      onScrollUp={() => {
        const v = Math.min(1, (speaker.volume ?? 0) + 0.05)
        speaker.set_volume(v)
      }}
      onScrollDown={() => {
        const v = Math.max(0, (speaker.volume ?? 0) - 0.05)
        speaker.set_volume(v)
      }}
    >
      <label label={icon} />
    </button>
  )
}

// ─── clock ───────────────────────────────────────────────────────────────────

function Clock() {
  const time = Variable("").poll(60000, "date '+%H:%M'")
  const date = Variable("").poll(60000, "date '+%A, %B %d, %Y'")

  return (
    <button
      className="clock pill"
      tooltip_text={bind(date)}
    >
      <label label={bind(time)} />
    </button>
  )
}

// ─── swaync notification bell ────────────────────────────────────────────────

function Notifications() {
  // Poll swaync-client for notification count + DND state
  const state = Variable({ count: 0, dnd: false }).poll(2000, async () => {
    try {
      const out = await execAsync(["swaync-client", "--count"])
      const count = parseInt(out.trim(), 10) || 0
      const dndOut = await execAsync(["swaync-client", "--get-dnd"])
      const dnd = dndOut.trim() === "true"
      return { count, dnd }
    } catch {
      return { count: 0, dnd: false }
    }
  })

  const icon = bind(state).as(({ count, dnd }) => {
    if (dnd) return count > 0 ? " " : "󰂛"
    return count > 0 ? "󱅫" : ""
  })

  return (
    <button
      className="notifications"
      tooltip_text="Notifications"
      onClicked={() => execAsync(["swaync-client", "-t", "-sw"])}
      onSecondaryClick={() => execAsync(["swaync-client", "-d", "-sw"])}
    >
      <label label={icon} />
    </button>
  )
}

// ─── lock ────────────────────────────────────────────────────────────────────

function Lock() {
  return (
    <button
      className="lock"
      tooltip_text="Lock screen"
      onClicked={() => execAsync(["hyprlock"])}
    >
      <label label="" />
    </button>
  )
}

// ─── power ───────────────────────────────────────────────────────────────────

function Power() {
  return (
    <button
      className="power"
      tooltip_text="Power menu"
      onClicked={() => execAsync(["wlogout"])}
    >
      <label label="󰐥" />
    </button>
  )
}

// ─── bar ─────────────────────────────────────────────────────────────────────

export default function Bar(monitor: number) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      className="bar"
      gdkmonitor={Gdk.Display.get_default()?.get_monitor(monitor) ?? undefined}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      layer={Astal.Layer.TOP}
      heightRequest={35}
      application={App}
    >
      <centerbox>
        {/* left */}
        <box halign={Gtk.Align.START} className="modules-left">
          <NixLogo />
          <Workspaces />
        </box>

        {/* center */}
        <box halign={Gtk.Align.CENTER} className="modules-center">
          <Media />
        </box>

        {/* right */}
        <box halign={Gtk.Align.END} className="modules-right">
          <BluetoothWidget />
          <NetworkWidget />
          <Volume />
          <Clock />
          <Notifications />
          <Lock />
          <Power />
        </box>
      </centerbox>
    </window>
  )
}
