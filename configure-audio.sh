#!/bin/zsh
# ============================================================================
# Configure Sterling H224 Audio — Run after connecting the H224
# ============================================================================
# This script sets the H224 as default audio device, configures 48kHz/24-bit,
# and sets system volume to 100%.
#
# Usage: zsh ~/Dev/mac-studio-setup/configure-audio.sh
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Sterling H224 Audio Configuration"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Check if H224 is connected
AUDIO_DEVICES=$(system_profiler SPAudioDataType 2>/dev/null)

if ! echo "$AUDIO_DEVICES" | grep -qi "Harmony\|H224\|Sterling"; then
    echo "  ❌ Sterling H224 not detected!"
    echo ""
    echo "  Please:"
    echo "  1. Connect H224 rear USB-C port to Mac Studio rear USB-A port"
    echo "     (use the included USB-C to USB-A cable)"
    echo "  2. Wait 5 seconds for macOS to recognize it"
    echo "  3. Re-run this script"
    echo ""
    exit 1
fi

echo "  ✅ H224 detected"
echo ""

# ── Set H224 as default output device ──────────────────────────
echo "▸ Setting H224 as default output device..."

# Use SwitchAudioSource if available, otherwise guide user
if command -v SwitchAudioSource &>/dev/null; then
    # Try common device names
    for name in "Harmony H224" "H224" "Sterling H224" "Sterling Harmony H224"; do
        if SwitchAudioSource -t output -s "$name" 2>/dev/null; then
            echo "  ✅ Default output: $name"
            break
        fi
    done

    for name in "Harmony H224" "H224" "Sterling H224" "Sterling Harmony H224"; do
        if SwitchAudioSource -t input -s "$name" 2>/dev/null; then
            echo "  ✅ Default input: $name"
            break
        fi
    done
else
    echo "  ⚠️  SwitchAudioSource not installed — installing via Homebrew..."
    if brew install switchaudio-osx 2>/dev/null; then
        echo "  ✅ Installed SwitchAudioSource"

        # List available devices
        echo ""
        echo "  Available audio devices:"
        SwitchAudioSource -a | while read -r device; do
            echo "    - $device"
        done
        echo ""

        # Try to set H224
        for name in "Harmony H224" "H224" "Sterling H224" "Sterling Harmony H224"; do
            if SwitchAudioSource -t output -s "$name" 2>/dev/null; then
                echo "  ✅ Default output: $name"
                break
            fi
        done
        for name in "Harmony H224" "H224" "Sterling H224" "Sterling Harmony H224"; do
            if SwitchAudioSource -t input -s "$name" 2>/dev/null; then
                echo "  ✅ Default input: $name"
                break
            fi
        done
    else
        echo ""
        echo "  ⚠️  Could not install SwitchAudioSource."
        echo "  → Manually set in: System Settings → Sound → Output → Harmony H224"
        echo "  → Manually set in: System Settings → Sound → Input → Harmony H224"
    fi
fi

# ── Set system volume to 100% ─────────────────────────────────
echo ""
echo "▸ Setting system volume to 100%..."
osascript -e 'set volume output volume 100'
echo "  ✅ System volume: 100%"
echo "     (Control actual volume with the H224 hardware knob)"

# ── Configure sample rate ──────────────────────────────────────
echo ""
echo "▸ Sample rate configuration..."
echo "  Audio MIDI Setup must be used to set 48kHz / 24-bit."
echo ""
echo "  Opening Audio MIDI Setup..."
open "/Applications/Utilities/Audio MIDI Setup.app"
echo ""
echo "  In Audio MIDI Setup:"
echo "  1. Select 'Harmony H224' in the left sidebar"
echo "  2. Set Format: 48,000 Hz"
echo "  3. Set: 2ch-24bit Integer"
echo "  4. Verify Output tab shows Outputs 1+2 active"
echo "  5. Close Audio MIDI Setup"

# ── Summary ────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Audio Configuration Complete"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  H224 Physical Controls — Recommended Starting Settings:"
echo "  ┌─────────────────────┬───────────┐"
echo "  │ Main Volume knob    │ ~30-40%   │"
echo "  │ Direct Monitor      │ Off       │"
echo "  │ +48V Phantom Power  │ Off       │"
echo "  │ Pad buttons         │ Off       │"
echo "  │ HPF (High Pass)     │ Off       │"
echo "  └─────────────────────┴───────────┘"
echo ""
echo "  Test: Play music → H224 LEDs should show signal → sound from speakers"
echo ""
