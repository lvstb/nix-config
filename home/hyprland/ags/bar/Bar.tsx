import app from "ags/gtk3/app"
import { Astal, Gtk, Gdk } from "ags/gtk3"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import { createBinding, createComputed } from "gnim"
import Hyprland from "gi://AstalHyprland"
import Wp from "gi://AstalWp"
import Network from "gi://AstalNetwork"
import Bluetooth from "gi://AstalBluetooth"

// ─── helpers ────────────────────────────────────────────────────────────────

function NixLogo() {
  return (
    <button
      class="nix-logo"
      tooltip_text="NixOS"
      onClicked={() => execAsync(["firefox", "https://search.nixos.org/packages"])}
    >
      <label label="" />
    </button>
  )
}

// ─── workspaces ─────────────────────────────────────────────────────────────

function Workspaces() {
  const hyprland = Hyprland.get_default()
  const workspaces = createBinding(hyprland, "workspaces")
  const focused = createBinding(hyprland, "focusedWorkspace")

  return (
    <box class="workspaces">
      {[1, 2, 3, 4, 5].map((id) => {
        const cls = createComputed(() => {
          const all = workspaces() ?? []
          if (focused()?.id === id) return "workspace active"
          if (!all.find((w) => w.id === id)) return "workspace empty"
          return "workspace"
        })

        return (
          <button
            class={cls}
            onClicked={() => hyprland.dispatch("workspace", `${id}`)}
          >
            <label label={`${id}`} />
          </button>
        )
      })}
    </box>
  )
}

// ─── media (MPRIS) ───────────────────────────────────────────────────────────

function Media() {
  const media = createPoll(
    { player: "", artist: "", title: "" },
    2000,
    async () => {
      try {
        const out = await execAsync([
          "playerctl",
          "metadata",
          "--format",
          "{{playerName}}\t{{artist}}\t{{title}}",
        ])

        const [player = "", artist = "", title = ""] = out
          .trim()
          .split("\t")
        return { player, artist, title }
      } catch {
        return { player: "", artist: "", title: "" }
      }
    },
  )

  const visible = media((m) => Boolean(m.player || m.artist || m.title))
  const icon = media((m) => {
    const player = m.player.toLowerCase()
    if (player.includes("spotify")) return "󰓇"
    if (player.includes("apple") || player.includes("music")) return "󰎆"
    return "󰎈"
  })
  const text = media((m) => {
    if (m.artist && m.title) return `${m.artist} - ${m.title}`
    return m.title || m.artist || m.player
  })
  const labelText = createComputed(() => {
    const textValue = text()
    return textValue ? `${icon()}  ${textValue}` : ""
  })

  return (
    <box class="media" visible={visible}>
      <button
        class="media-player"
        onClicked={() => execAsync(["playerctl", "play-pause"])}
        onScroll={(_, e) => {
          if (e.direction === Gdk.ScrollDirection.UP)
            execAsync(["playerctl", "next"])
          else if (e.direction === Gdk.ScrollDirection.DOWN)
            execAsync(["playerctl", "previous"])
        }}
      >
        <label label={labelText} maxWidthChars={40} truncate />
      </button>
    </box>
  )
}

// ─── bluetooth ───────────────────────────────────────────────────────────────

function BluetoothWidget() {
  const bt = Bluetooth.get_default()
  const isPowered = createBinding(bt, "isPowered")

  const icon = isPowered((powered) => {
    if (!powered) return "󰂲"
    const connected = bt.get_devices().some((d) => d.connected)
    return connected ? "󰂱" : "󰂯"
  })

  return (
    <button
      class="bluetooth pill"
      tooltip_text={isPowered((p) => (p ? "Bluetooth on" : "Bluetooth off"))}
      onClicked={() => execAsync(["blueman-manager"])}
    >
      <label label={icon} />
    </button>
  )
}

// ─── network ─────────────────────────────────────────────────────────────────

function NetworkWidget() {
  const network = Network.get_default()
  const primary = createBinding(network, "primary")

  const icon = primary((p) => {
    if (p === Network.Primary.WIFI) return "󰤨"
    if (p === Network.Primary.WIRED) return "󰈀"
    return "󰤭"
  })

  const tooltip = primary((p) => {
    if (p === Network.Primary.WIFI) {
      const ssid = network.wifi?.ssid ?? ""
      const strength = network.wifi?.strength ?? 0
      return ssid ? `${ssid} (${strength}%)` : "WiFi"
    }
    if (p === Network.Primary.WIRED) return "Ethernet"
    return "Disconnected"
  })

  const cls = primary((p) =>
    p === Network.Primary.UNKNOWN ? "network pill disconnected" : "network pill",
  )

  return (
    <button
      class={cls}
      tooltip_text={tooltip}
      onClicked={() => execAsync(["nm-connection-editor"])}
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
  const mute = createBinding(speaker, "mute")
  const volume = createBinding(speaker, "volume")

  const icon = createComputed(() => {
    if (mute()) return "󰝟"
    const vol = volume() ?? 0
    if (vol === 0) return "󰕿"
    if (vol < 0.5) return "󰖀"
    return "󰕾"
  })

  return (
    <button
      class={mute((m) => (m ? "volume pill muted" : "volume pill"))}
      tooltip_text={volume((v) => `${Math.round((v ?? 0) * 100)}% volume`)}
      onClicked={() => execAsync(["pavucontrol"])}
      onScroll={(_, e) => {
        if (e.direction === Gdk.ScrollDirection.UP)
          speaker.set_volume(Math.min(1, (speaker.volume ?? 0) + 0.05))
        else if (e.direction === Gdk.ScrollDirection.DOWN)
          speaker.set_volume(Math.max(0, (speaker.volume ?? 0) - 0.05))
      }}
    >
      <label label={icon} />
    </button>
  )
}

// ─── clock ───────────────────────────────────────────────────────────────────

function Clock() {
  const time = createPoll("", 60000, "date '+%H:%M'")
  const date = createPoll("", 60000, "date '+%A, %B %d, %Y'")

  return (
    <button class="clock pill" tooltip_text={date}>
      <label label={time} />
    </button>
  )
}

// ─── notifications ────────────────────────────────────────────────────────────

function Notifications() {
  return (
    <button
      class="notifications"
      tooltip_text="Notifications"
      onClicked={() => execAsync(["dunstctl", "history-pop"])}
    >
      <label label="󰂚" />
    </button>
  )
}

// ─── lock ────────────────────────────────────────────────────────────────────

function Lock() {
  return (
    <button
      class="lock"
      tooltip_text="Lock screen"
      onClicked={() => execAsync(["hyprlock"])}
    >
      <label label="󰌾" />
    </button>
  )
}

// ─── power ───────────────────────────────────────────────────────────────────

function Power() {
  return (
    <button
      class="power"
      tooltip_text="Power menu"
      onClicked={() => execAsync(["wlogout"])}
    >
      <label label="󰐥" />
    </button>
  )
}

// ─── bar ─────────────────────────────────────────────────────────────────────

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      name="bar"
      class="bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      layer={Astal.Layer.TOP}
      heightRequest={35}
      application={app}
    >
      <centerbox>
        <box $type="start" halign={Gtk.Align.START} class="modules-left">
          <NixLogo />
          <Workspaces />
        </box>
        <box $type="center" halign={Gtk.Align.CENTER} class="modules-center">
          <Media />
        </box>
        <box $type="end" halign={Gtk.Align.END} class="modules-right">
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
