# All applications consolidated
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  btAudioProfile = pkgs.writeTextFile {
    name = "bt-audio-profile";
    executable = true;
    destination = "/bin/bt-audio-profile";
    text = ''
      #!${pkgs.python3}/bin/python3
      import re
      import subprocess
      import sys

      PW_CLI = "${pkgs.pipewire}/bin/pw-cli"
      WPCTL = "${pkgs.wireplumber}/bin/wpctl"

      def run(*args):
          return subprocess.check_output(args, text=True)

      def parse_ls(output):
          objects = []
          current = None

          for raw_line in output.splitlines():
              line = raw_line.strip()
              if not line:
                  continue

              match = re.match(r"id\s+(\d+),\s+type:\s+(.+)$", line)
              if match:
                  if current is not None:
                      objects.append(current)
                  current = {
                      "id": int(match.group(1)),
                      "type": match.group(2),
                      "props": {},
                  }
                  continue

              if current is None:
                  continue

              if line.startswith("*"):
                  line = line[1:].strip()

              prop = re.match(r"([A-Za-z0-9._:-]+)\s*=\s*\"(.*)\"$", line)
              if prop:
                  current["props"][prop.group(1)] = prop.group(2)
                  continue

              prop = re.match(r"([A-Za-z0-9._:-]+)\s*=\s*(.+)$", line)
              if prop:
                  current["props"][prop.group(1)] = prop.group(2)

          if current is not None:
              objects.append(current)

          return objects

      def parse_info_props(output):
          props = {}

          for raw_line in output.splitlines():
              line = raw_line.strip()
              if not line:
                  continue

              if line.startswith("*"):
                  line = line[1:].strip()

              prop = re.match(r"([A-Za-z0-9._:-]+)\s*=\s*\"(.*)\"$", line)
              if prop:
                  props[prop.group(1)] = prop.group(2)
                  continue

              prop = re.match(r"([A-Za-z0-9._:-]+)\s*=\s*(.+)$", line)
              if prop:
                  props[prop.group(1)] = prop.group(2)

          return props

      def inspect_props(target):
          return parse_info_props(run(WPCTL, "inspect", str(target)))

      def safe_inspect_props(target):
          try:
              return inspect_props(target)
          except subprocess.CalledProcessError:
              return {}

      def connected_devices():
          devices = []
          for raw_line in run(WPCTL, "status").splitlines():
              if "[bluez5]" not in raw_line:
                  continue

              match = re.search(r"(\d+)\.\s+.+\s+\[bluez5\]", raw_line)
              if not match:
                  continue

              device_id = int(match.group(1))
              props = parse_info_props(run(WPCTL, "inspect", str(device_id)))
              if props.get("device.api") != "bluez5":
                  continue
              if props.get("api.bluez5.connection") != "connected":
                  continue
              devices.append({"id": device_id, "type": "PipeWire:Interface:Device", "props": props})
          return devices

      def status_section_lines(section_name):
          in_audio = False
          in_section = False
          lines = []

          for raw_line in run(WPCTL, "status").splitlines():
              stripped = raw_line.strip()
              if stripped == "Audio":
                  in_audio = True
                  continue
              if in_audio and not raw_line.startswith(" ") and stripped and stripped != "Audio":
                  break
              if not in_audio:
                  continue

              if raw_line.startswith(f" ├─ {section_name}:") or raw_line.startswith(f" └─ {section_name}:"):
                  in_section = True
                  continue

              if in_section and (raw_line.startswith(" ├─ ") or raw_line.startswith(" └─ ")):
                  break

              if in_section:
                  lines.append(raw_line)

          return lines

      def section_node_ids(section_name):
          ids = []
          for raw_line in status_section_lines(section_name):
              match = re.search(r"(\d+)\.\s+", raw_line)
              if match:
                  ids.append(int(match.group(1)))
          return ids

      def select_device(pattern):
          devices = connected_devices()
          if not devices:
              raise SystemExit("No connected Bluetooth audio devices found.")

          if pattern:
              needle = pattern.lower()
              matches = [
                  device
                  for device in devices
                  if needle in device["props"].get("device.description", "").lower()
                  or needle in device["props"].get("device.name", "").lower()
                  or needle in device["props"].get("device.string", "").lower()
              ]
              if len(matches) == 1:
                  return matches[0]
              if len(matches) > 1:
                  lines = ["Multiple Bluetooth devices match:"]
                  for device in matches:
                      props = device["props"]
                      lines.append(f"- {props.get('device.description', props.get('device.name', device['id']))} ({props.get('device.string', 'unknown')})")
                  raise SystemExit("\n".join(lines))
              raise SystemExit(f"No connected Bluetooth device matched '{pattern}'.")

          if len(devices) == 1:
              return devices[0]

          lines = ["Multiple connected Bluetooth audio devices found. Pass a device name or MAC address:"]
          for device in devices:
              props = device["props"]
              lines.append(f"- {props.get('device.description', props.get('device.name', device['id']))} ({props.get('device.string', 'unknown')})")
          raise SystemExit("\n".join(lines))

      def profile_map(device_id):
          profiles = {}
          current_key = None
          current_profile = {}

          for raw_line in run(PW_CLI, "enum-params", str(device_id), "EnumProfile").splitlines():
              line = raw_line.strip()
              if "Param:Profile" in line and current_profile.get("name") and current_profile.get("index") is not None:
                  profiles[current_profile["name"]] = current_profile["index"]
                  current_profile = {}
                  current_key = None
                  continue

              if line.endswith(":index (1), flags 00000000"):
                  current_key = "index"
                  continue
              if line.endswith(":name (2), flags 00000000"):
                  current_key = "name"
                  continue

              if current_key == "index":
                  match = re.match(r"Int\s+(\d+)$", line)
                  if match:
                      current_profile["index"] = int(match.group(1))
                      current_key = None
                  continue

              if current_key == "name":
                  match = re.match(r'String\s+"([^"]+)"$', line)
                  if match:
                      current_profile["name"] = match.group(1)
                      current_key = None

          if current_profile.get("name") and current_profile.get("index") is not None:
              profiles[current_profile["name"]] = current_profile["index"]

          return profiles

      def section_nodes(section_name, device_id=None):
          nodes = []
          for node_id in section_node_ids(section_name):
              props = safe_inspect_props(node_id)
              if not props:
                  continue
              if device_id is not None and props.get("device.id") != str(device_id):
                  continue
              nodes.append({"id": node_id, "props": props})

          return nodes

      def node_priority(node):
          try:
              return int(node["props"].get("priority.session", "0"))
          except ValueError:
              return 0

      def preferred_sink_node(device_id):
          candidates = [
              node
              for node in section_nodes("Sinks", device_id)
              if node["props"].get("media.class") == "Audio/Sink"
              and node["props"].get("api.bluez5.profile")
          ]
          return max(candidates, key=node_priority) if candidates else None

      def preferred_source_node(device_id):
          candidates = [
              node
              for node in section_nodes("Sources", device_id)
              if node["props"].get("media.class") == "Audio/Source"
              and node["props"].get("api.bluez5.profile")
              and node["props"].get("bluez5.loopback") != "true"
          ]
          if not candidates:
              candidates = [
                  node
                  for node in section_nodes("Filters", device_id)
                  if node["props"].get("media.class") == "Audio/Source"
                  and node["props"].get("node.name", "").startswith("bluez_input.")
              ]
          return max(candidates, key=node_priority) if candidates else None

      def fallback_source_node(excluded_device_id):
          default_source = safe_inspect_props("@DEFAULT_AUDIO_SOURCE@")
          if (
              default_source
              and default_source.get("device.id") != str(excluded_device_id)
              and default_source.get("media.class", "").startswith("Audio/Source")
              and default_source.get("bluez5.loopback") != "true"
          ):
              return {"id": "@DEFAULT_AUDIO_SOURCE@", "props": default_source}

          candidates = []
          allowed_ids = set(section_node_ids("Sources"))
          for node_id in allowed_ids:
              props = safe_inspect_props(node_id)
              if not props:
                  continue
              if props.get("device.id") == str(excluded_device_id):
                  continue
              if not props.get("media.class", "").startswith("Audio/Source"):
                  continue
              if props.get("bluez5.loopback") == "true":
                  continue
              candidates.append({"id": node_id, "props": props})

          return max(candidates, key=node_priority) if candidates else None

      def refresh_default_nodes(mode, device_id):
          sink = None
          source = None

          for _ in range(10):
              sink = preferred_sink_node(device_id)
              source = preferred_source_node(device_id) if mode == "headset" else fallback_source_node(device_id)

              if mode == "headset":
                  if sink is not None and source is not None:
                      break
              elif sink is not None:
                  break

              subprocess.run(["${pkgs.coreutils}/bin/sleep", "0.2"], check=True)

          return sink, source

      def current_profile(device_id):
          for node in section_nodes("Sinks", device_id) + section_nodes("Sources", device_id) + section_nodes("Filters", device_id):
              profile = node["props"].get("api.bluez5.profile")
              if profile:
                  return profile
          return "unknown"

      def print_status(device):
          props = device["props"]
          print(f"{props.get('device.description', props.get('device.name', device['id']))}: {current_profile(device['id'])}")

      mode = sys.argv[1] if len(sys.argv) > 1 else "status"
      pattern = sys.argv[2] if len(sys.argv) > 2 else ""

      if mode not in {"status", "a2dp", "headset"}:
          raise SystemExit("Usage: bt-audio-profile [status|a2dp|headset] [device-name-or-mac]")

      device = select_device(pattern)
      props = device["props"]

      if mode == "status":
          print_status(device)
          raise SystemExit(0)

      profiles = profile_map(device["id"])
      preferred = {
          "a2dp": ["a2dp-sink", "a2dp-sink-sbc_xq", "a2dp-sink-sbc"],
          "headset": ["headset-head-unit", "headset-head-unit-cvsd"],
      }[mode]

      for profile_name in preferred:
          if profile_name in profiles:
              subprocess.check_call([WPCTL, "set-profile", str(device["id"]), str(profiles[profile_name])])
              sink, source = refresh_default_nodes(mode, device["id"])
              if sink is not None:
                  subprocess.check_call([WPCTL, "set-default", str(sink["id"])])

              if mode == "headset":
                  if source is not None:
                      subprocess.check_call([WPCTL, "set-default", str(source["id"])])
              else:
                  default_source = safe_inspect_props("@DEFAULT_AUDIO_SOURCE@")
                  if default_source.get("device.id") == str(device["id"]):
                      if source is not None:
                          subprocess.check_call([WPCTL, "set-default", str(source["id"])])

              print(f"Switched {props.get('device.description', props.get('device.name', device['id']))} to {profile_name}.")
              print_status(device)
              raise SystemExit(0)

      available = ", ".join(sorted(profiles)) or "none"
      raise SystemExit(f"No matching profile found for {mode}. Available profiles: {available}")
    '';
  };
in {
  # Programs configuration
  # VSCode configuration moved to vscode.nix
  # Chromium replaced with Helium - see home.packages for helium installation

  # Shell based tools
  programs.home-manager.enable = true;
  programs.ripgrep.enable = true;
  programs.bat.enable = true;
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    options = ["--cmd" "cd"];
  };
  programs.jq.enable = true;
  programs.eza.enable = true;
  programs.btop.enable = true;
  programs.gh.enable = true;
  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open";
        }
        {
          title = "Needs My Review";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
      ];

      issuesSections = [
        {
          title = "My Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned";
          filters = "is:open assignee:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
      ];

      notificationsSections = [
        {
          title = "All";
          filters = "";
        }
        {
          title = "Created";
          filters = "reason:author";
        }
        {
          title = "Participating";
          filters = "reason:participating";
        }
        {
          title = "Mentioned";
          filters = "reason:mention";
        }
        {
          title = "Review Requested";
          filters = "reason:review-requested";
        }
        {
          title = "Assigned";
          filters = "reason:assign";
        }
        {
          title = "Subscribed";
          filters = "reason:subscribed";
        }
        {
          title = "Team Mentioned";
          filters = "reason:team-mention";
        }
      ];

      repo = {
        branchesRefetchIntervalSeconds = 30;
        prsRefetchIntervalSeconds = 60;
      };

      defaults = {
        preview = {
          open = false;
          width = 70;
        };
        prsLimit = 20;
        prApproveComment = "Approved";
        issuesLimit = 20;
        notificationsLimit = 20;
        view = "prs";
        layout = {
          prs = {
            updatedAt.width = 5;
            createdAt.width = 5;
            repo.width = 20;
            author.width = 15;
            authorIcon.hidden = false;
            assignees = {
              width = 20;
              hidden = true;
            };
            base = {
              width = 15;
              hidden = true;
            };
            lines.width = 15;
          };
          issues = {
            updatedAt.width = 5;
            createdAt.width = 5;
            repo.width = 15;
            creator.width = 10;
            creatorIcon.hidden = false;
            assignees = {
              width = 20;
              hidden = true;
            };
          };
        };
        refetchIntervalMinutes = 30;
      };

      keybindings = {
        universal = [
          {
            key = "g";
            name = "lazygit";
            command = "cd {{.RepoPath}}; lazygit";
          }
        ];
        prs = [
          {
            key = "C";
            name = "code review";
            command = "tmux new-window -n \"PR-{{.PrNumber}}\" 'wt switch pr:{{.PrNumber}} -x \"opencode --command review `review-pr-for-this-branch`\"'";
          }
        ];
      };

      theme = {
        ui = {
          sectionsShowCount = true;
          table = {
            showSeparator = true;
            compact = true;
          };
        };
      };

      pager.diff = "diffnav";
      confirmQuit = false;
      showAuthorIcons = true;
      smartFilteringAtLaunch = true;
    };
  };
  programs.yazi.enable = true;
  programs.yazi.shellWrapperName = "y";
  programs.fd.enable = true;

  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      "load_dotenv" = true;
    };
  };

  # Development languages and runtimes
  programs.go.enable = true;

  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };

  home.packages = with pkgs; [
    # Core applications
    ghostty
    nur.repos.Ev357.helium
    btAudioProfile

    # Communication apps
    telegram-desktop
    discord
    wasistlos
    slack
    nextcloud-client

    # Text editors and IDEs
    obsidian
    claude-code
    code-cursor
    kiro
    opencode
    saws
    github-copilot-cli

    # Development - Languages (use specific versions)
    python312
    python312Packages.pip
    python312Packages.pipx
    nodejs_24
    pnpm
    yarn
    bun
    rustc
    cargo
    gcc
    pre-commit
    uv

    # Development - Language servers (for nvim)
    gopls
    nixd
    yaml-language-server
    lua-language-server
    typescript-language-server
    terraform-ls
    marksman
    luajitPackages.luarocks
    jetbrains.idea

    # Development - Formatters and linters
    hadolint
    selene
    black
    prettier
    eslint
    alejandra
    stylua
    isort
    buf
    yamllint
    yamlfmt
    markdownlint-cli

    # Development - Tools
    # github-copilot-cli
    httpie-desktop
    sops
    act
    kubectl
    terraform
    awscli2
    azure-cli
    distrobox
    snyk
    just
    cloudsmith-cli
    github-cli
    dive
    lazydocker
    devenv
    nmap
    wireshark
    postgresql
    redis
    nosql-workbench
    google-cloud-sdk
    worktrunk
    diffnav

    # Office and productivity
    libreoffice-qt6-fresh
    bitwarden-desktop
    eid-mw

    # Audio and video
    spotify
    hypnotix
    pamixer

    # File management and archives
    ncdu
    file-roller
    unzip

    # Terminal utilities
    wget
    file
    killall
    tree
  ];

  # Development environment variables
  home.sessionVariables = {
    # JAVA_HOME will be set by the JDK package when needed
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.opencode/bin"
  ];
}
