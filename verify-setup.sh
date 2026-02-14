#!/bin/zsh
# ============================================================================
# Mac Studio + Samsung G81SF + Sterling H224 + Satechi Dock — Verification
# ============================================================================
# Run this script to verify your setup is configured correctly.
# Usage: zsh ~/Dev/mac-studio-setup/verify-setup.sh
# ============================================================================

PASS=0
FAIL=0
WARN=0

pass() { echo "  ✅ $1"; ((PASS++)); }
fail() { echo "  ❌ $1"; ((FAIL++)); }
warn() { echo "  ⚠️  $1"; ((WARN++)); }

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Mac Studio Setup Verification"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "═══════════════════════════════════════════════════════════════"

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 1. SATECHI THUNDERBOLT 4 DOCK"
echo ""

TB_INFO=$(system_profiler SPThunderboltDataType 2>/dev/null)

if echo "$TB_INFO" | grep -q "Satechi"; then
    pass "Satechi dock detected"

    # Check it's on a TB5 port (40 Gb/s upstream, not 10 Gb/s from front USB-C)
    SATECHI_SPEED=$(echo "$TB_INFO" | grep -A15 "Satechi" | grep "Port (Upstream)" -A3 | grep "Speed" | head -1 | grep -o '[0-9]*' | head -1)
    if [[ "$SATECHI_SPEED" == "40" ]]; then
        pass "Connected at 40 Gb/s (rear Thunderbolt port)"
    else
        fail "Connected at ${SATECHI_SPEED} Gb/s — should be 40 Gb/s (move to rear TB5 port)"
    fi
else
    fail "Satechi dock not detected — check cable and power adapter"
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 2. SAMSUNG ODYSSEY G81SF MONITOR"
echo ""

DISPLAY_ATTRS=$(ioreg -l -w 0 2>/dev/null | grep "DisplayAttributes")

if echo "$DISPLAY_ATTRS" | grep -q "Odyssey G81SF"; then
    pass "Samsung Odyssey G81SF detected"

    # Check max refresh rate
    MAX_REFRESH=$(echo "$DISPLAY_ATTRS" | grep -o '"MaximumRefreshRate"=[0-9]*' | head -1 | cut -d= -f2)
    if [[ "$MAX_REFRESH" == "240" ]]; then
        pass "Monitor reports 240Hz capability"
    else
        warn "Monitor reports ${MAX_REFRESH}Hz max — expected 240Hz"
    fi

    # Check HDMI connection (match exact key, not HDMI_HPD-Debounced)
    HDMI_HPD=$(ioreg -l -w 0 2>/dev/null | grep -A20 "Port-HDMI" | grep '"HDMI_HPD"' | head -1)
    if echo "$HDMI_HPD" | grep -q "Yes"; then
        pass "HDMI connection active"
    else
        fail "HDMI not connected — check cable"
    fi
else
    fail "Samsung G81SF not detected — check HDMI cable and monitor power"
fi

# Check display settings via displayplacer (if installed)
if command -v displayplacer &>/dev/null; then
    DP_OUTPUT=$(displayplacer list 2>/dev/null)
    if echo "$DP_OUTPUT" | grep -q "3840"; then
        pass "Running at 3840x2160 resolution"
    fi
    if echo "$DP_OUTPUT" | grep -q "240"; then
        pass "Running at 240Hz refresh rate"
    elif echo "$DP_OUTPUT" | grep -q "120"; then
        warn "Running at 120Hz — go to System Settings → Displays → set to 240Hz"
    fi
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 3. STERLING HARMONY H224 AUDIO INTERFACE"
echo ""

AUDIO_INFO=$(system_profiler SPAudioDataType 2>/dev/null)
USB_INFO=$(system_profiler SPUSBDataType 2>/dev/null)

if echo "$AUDIO_INFO" | grep -qi "Harmony\|H224\|Sterling"; then
    pass "Sterling H224 detected as audio device"
else
    if echo "$USB_INFO" | grep -qi "Harmony\|H224\|Sterling"; then
        warn "H224 detected on USB but not as audio device — try unplugging and replugging"
    else
        fail "H224 not detected — connect USB-C to USB-A cable from H224 to Mac Studio rear USB-A port"
    fi
fi

# Check if H224 is through a hub (should be direct)
if echo "$USB_INFO" | grep -B10 -i "Harmony\|H224" | grep -qi "Hub\|Satechi\|Samsung"; then
    fail "H224 appears to be connected through a hub — connect DIRECTLY to Mac Studio rear USB-A"
else
    if echo "$USB_INFO" | grep -qi "Harmony\|H224"; then
        pass "H224 connected directly (not through a hub)"
    fi
fi

# Check default audio output via SwitchAudioSource (more reliable)
if command -v SwitchAudioSource &>/dev/null; then
    CURRENT_OUTPUT=$(SwitchAudioSource -c -t output 2>/dev/null)
    CURRENT_INPUT=$(SwitchAudioSource -c -t input 2>/dev/null)
    if [[ "$CURRENT_OUTPUT" == *"H224"* || "$CURRENT_OUTPUT" == *"Harmony"* ]]; then
        pass "H224 set as default output device"
    else
        warn "Default output is '${CURRENT_OUTPUT}' — should be Harmony H224 (run configure-audio.sh)"
    fi
    if [[ "$CURRENT_INPUT" == *"H224"* || "$CURRENT_INPUT" == *"Harmony"* ]]; then
        pass "H224 set as default input device"
    elif [[ "$CURRENT_INPUT" == *"Razer"* || "$CURRENT_INPUT" == *"Seiren"* ]]; then
        pass "Razer Seiren V3 Mini set as default input (dedicated mic — OK)"
    else
        warn "Default input is '${CURRENT_INPUT}' — expected H224 or Razer Seiren"
    fi
else
    # Fallback to system_profiler
    if echo "$AUDIO_INFO" | grep -B2 -A10 "Harmony\|H224" | grep -q "Default Output Device: Yes"; then
        pass "H224 set as default output device"
    else
        warn "H224 detected but may not be default output — check System Settings → Sound"
    fi
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 4. AUDIO MIDI SETUP (Sample Rate / Bit Depth)"
echo ""

# Check H224 sample rate specifically
H224_RATE=$(echo "$AUDIO_INFO" | grep -A8 "Harmony H224" | grep "SampleRate" | head -1 | grep -o '[0-9]*')
if [[ "$H224_RATE" == "48000" ]]; then
    pass "H224 sample rate: 48,000 Hz"
elif [[ "$H224_RATE" == "44100" ]]; then
    warn "H224 sample rate is 44,100 Hz — change to 48,000 Hz in Audio MIDI Setup"
elif [[ "$H224_RATE" == "96000" ]]; then
    pass "H224 sample rate: 96,000 Hz (high-res)"
elif [[ -n "$H224_RATE" ]]; then
    warn "H224 sample rate is ${H224_RATE} Hz — recommended: 48,000 Hz"
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 5. OLED PROTECTION SETTINGS"
echo ""

# Screen saver idle time
SS_TIME=$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null)
if [[ -n "$SS_TIME" && "$SS_TIME" -le 600 && "$SS_TIME" -gt 0 ]]; then
    pass "Screen saver activates after $((SS_TIME / 60)) minutes"
else
    fail "Screen saver idle time not set or too long — should be 5-10 min for OLED"
fi

# Display sleep
DISP_SLEEP=$(pmset -g | grep displaysleep | awk '{print $2}')
if [[ -n "$DISP_SLEEP" && "$DISP_SLEEP" -le 15 && "$DISP_SLEEP" -gt 0 ]]; then
    pass "Display sleep: ${DISP_SLEEP} minutes"
else
    fail "Display sleep is ${DISP_SLEEP} min — set to 10-15 min for OLED protection"
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 6. SYSTEM VOLUME"
echo ""

# Check volume — H224 uses hardware control, so "missing value" is expected
VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
if [[ "$VOL" == "missing value" ]]; then
    pass "Volume controlled by H224 hardware knob (correct — not software controlled)"
elif [[ -n "$VOL" && "$VOL" =~ ^[0-9]+$ ]]; then
    if [[ "$VOL" -ge 95 ]]; then
        pass "System volume at ${VOL}% (correct — control from H224 knob)"
    else
        warn "System volume at ${VOL}% — set to 100% for best 24-bit resolution"
    fi
fi

# ──────────────────────────────────────────────────────────────────
echo ""
echo "▸ 7. PORT ALLOCATION"
echo ""

# Count TB5 ports in use
TB_USED=$(echo "$TB_INFO" | grep "Device connected" | wc -l | tr -d ' ')
TB_FREE=$((4 - TB_USED))
echo "  Thunderbolt 5 ports: ${TB_USED} used, ${TB_FREE} free"

# Count USB devices
USB_DEVICES=$(echo "$USB_INFO" | grep "Product ID" | wc -l | tr -d ' ')
echo "  USB devices connected: ${USB_DEVICES}"

# ──────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Results: ${PASS} passed, ${FAIL} failed, ${WARN} warnings"
echo "═══════════════════════════════════════════════════════════════"

if [[ "$FAIL" -gt 0 ]]; then
    echo ""
    echo "  ⚡ Fix the failed checks above, then re-run this script."
fi

if [[ "$WARN" -gt 0 ]]; then
    echo ""
    echo "  💡 Review warnings — some may need manual action."
fi

if [[ "$FAIL" -eq 0 && "$WARN" -eq 0 ]]; then
    echo ""
    echo "  🎉 All checks passed — your setup is fully configured!"
fi

echo ""
