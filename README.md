# Mac Studio Setup — Complete Reference

## Hardware

| Device | Connection | Port |
|--------|-----------|------|
| Samsung Odyssey G81SF (27" 4K OLED) | HDMI 2.1 cable (48Gbps) | Mac Studio rear HDMI |
| Sterling Harmony H224 | USB-C to USB-A (included) | Mac Studio rear USB-A #1 |
| Satechi TB4 Slim Hub Pro | TB4/USB-C cable (included) | Mac Studio rear TB5 #3 |
| Samsung monitor USB hub | USB-B to USB-A | Mac Studio rear USB-A #2 |

### Peripherals via Satechi Dock
| Device | Port | Why Here |
|--------|------|----------|
| Razer Seiren V3 Mini | Satechi USB-A | Low-bandwidth mic, dock is fine |
| Logitech Light Bar | Satechi USB-A | Control-only, minimal bandwidth |
| Logitech HD 1080p Webcam | Satechi USB-A | 1080p video works fine via TB4 |

### Peripherals via Monitor USB Hub
| Device | Port | Why Here |
|--------|------|----------|
| Glorious GMMK 75% Keyboard | Monitor USB-A | Keyboard is fine through any hub |
| SteelSeries Aerox 3 Wireless | Monitor USB-A | Receiver near mouse = best signal |

## Port Map

```
MAC STUDIO REAR:
┌───────────────────────────────────────────────────────────────┐
│  [TB5#1]  [TB5#2]  [TB5#3]  [TB5#4]  [USB-A#1]  [USB-A#2]   │
│   free     free     Satechi   free     H224        Monitor    │
│                     Dock               (audio)     USB Hub    │
│                                                               │
│  [HDMI 2.1]   [Ethernet]   [3.5mm]   [Power]                 │
│   Monitor                                                     │
└───────────────────────────────────────────────────────────────┘

SATECHI DOCK:
┌───────────────────────────────────────────────────────────────┐
│  REAR: [TB4] [TB4] [TB4]  [USB-A]    [USB-A]     [USB-A]     │
│         free  free  free   Razer mic  Logi Light  Logi Webcam │
│  FRONT: [Host→Mac]  [USB-A]  [SD]  [3.5mm]                   │
│                       free                                    │
└───────────────────────────────────────────────────────────────┘

MONITOR USB HUB:
┌───────────────────────────────────────────────────────────────┐
│  [USB-A]       [USB-A]                                        │
│  GMMK 75%      Aerox 3 receiver                              │
└───────────────────────────────────────────────────────────────┘

FRONT USB-C (keep free for temporary devices):
┌───────────────────────────────────────────────────────────────┐
│  [USB-C]  [USB-C]  [SD card]                                  │
│  iPhone, flash drives, temporary connections                  │
└───────────────────────────────────────────────────────────────┘
```

## Software

| Software | Controls | Install Method |
|----------|----------|---------------|
| Logi Options+ | Light Bar + Webcam | `brew install --cask logi-options+` |
| SteelSeries GG | Aerox 3 Wireless mouse | `brew install --cask steelseries-gg` |
| Razer Synapse 3 | Seiren V3 Mini mic | [razer.com/synapse-3](https://www.razer.com/synapse-3) |
| Glorious CORE | GMMK 75% keyboard | [gloriousgaming.com/glorious-core](https://www.gloriousgaming.com/pages/glorious-core) |
| H224 Control Panel | Audio interface (optional) | [sterlingaudio.net](https://sterlingaudio.net/harmony-h224-audio-interface-drivers/) |
| Audio MIDI Setup | Sample rate / bit depth | Built-in: `/System/Applications/Utilities/` |

## Display Settings

- **Resolution**: 2560x1440 (Retina 2x scaled, renders at 5120x2880 → native 3840x2160)
- **Refresh Rate**: 240 Hz
- **Color Depth**: 8-bit (max at 4K 240Hz via HDMI 2.1)
- **HDR**: Enable in System Settings → Displays when viewing HDR content

### Monitor OSD (Samsung joystick)
| Setting | Value |
|---------|-------|
| HDMI Mode | 2.1 |
| Response Time | Standard or Fast |
| Brightness (SDR) | 40-60% |
| Picture Mode | Custom or Standard |
| Color Temp | Warm 2 |
| Gamma | Mode 1 (2.2) |
| Color Space | sRGB (design) / Native (widest) |
| HDR | On |
| HDR Tone Mapping | On |
| Pixel Refresh | Auto |
| Screen Saver | Enable |
| Logo Detection Dimming | On |

## Audio Settings

- **Default Output**: Harmony H224 → speakers
- **Default Input**: Razer Seiren V3 Mini (dedicated mic)
- **H224 Sample Rate**: 48,000 Hz / 24-bit (set in Audio MIDI Setup)
- **System Volume**: 100% — control actual volume with H224 hardware knob

### H224 Physical Controls
| Control | Setting |
|---------|---------|
| Main Volume | Start ~30-40% |
| Direct Monitor | Off |
| +48V Phantom | Off |
| Pad | Off |
| HPF | Off |

## OLED Protection

- Screen saver: 5 minutes
- Display sleep: 10 minutes
- Monitor pixel refresh: Auto
- Monitor screen saver: Enabled
- Logo detection dimming: On

## Scripts

| Script | Purpose | Run |
|--------|---------|-----|
| `verify-setup.sh` | Check all settings | `zsh ~/Dev/mac-studio-setup/verify-setup.sh` |
| `configure-audio.sh` | Set up H224 audio | `zsh ~/Dev/mac-studio-setup/configure-audio.sh` |
| `configure-display.sh` | Display settings guide | `zsh ~/Dev/mac-studio-setup/configure-display.sh` |
| `install-peripheral-software.sh` | Install all software | `zsh ~/Dev/mac-studio-setup/install-peripheral-software.sh` |

## Key Rules

1. **H224 must connect DIRECTLY to Mac Studio** — never through dock or monitor hub
2. **Satechi dock on rear TB5 port** — never front USB-C (only 10Gbps)
3. **System volume at 100%** — use H224 knob for volume (preserves 24-bit audio)
4. **Screen saver on** — protects OLED from burn-in
5. **Don't unplug monitor during pixel refresh** — let it complete when monitor sleeps
