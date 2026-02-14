#!/bin/zsh
# ============================================================================
# Configure Samsung G81SF Display Settings
# ============================================================================
# Verifies and guides display configuration for 4K 240Hz HDR.
#
# Usage: zsh ~/Dev/mac-studio-setup/configure-display.sh
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Samsung Odyssey G81SF Display Configuration"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ── Check monitor is connected ─────────────────────────────────
DISPLAY_ATTRS=$(ioreg -l -w 0 2>/dev/null | grep "DisplayAttributes")

if echo "$DISPLAY_ATTRS" | grep -q "Odyssey G81SF"; then
    echo "  ✅ Samsung Odyssey G81SF detected"

    MAX_REFRESH=$(echo "$DISPLAY_ATTRS" | grep -o '"MaximumRefreshRate"=[0-9]*' | head -1 | cut -d= -f2)
    echo "  Max refresh rate: ${MAX_REFRESH}Hz"

    VRR=$(echo "$DISPLAY_ATTRS" | grep -o '"SupportsVariableRefreshRate"=[A-Za-z]*' | head -1 | cut -d= -f2)
    echo "  VRR support: ${VRR}"

    HDR=$(echo "$DISPLAY_ATTRS" | grep -o '"SupportsPQEOTF"=[A-Za-z]*' | head -1 | cut -d= -f2)
    echo "  HDR (PQ EOTF): ${HDR}"

    HDR10PLUS=$(echo "$DISPLAY_ATTRS" | grep -o '"SupportsHDR10PlusApplicationVersion"=[0-9]*' | head -1 | cut -d= -f2)
    [[ -n "$HDR10PLUS" ]] && echo "  HDR10+: Supported (v${HDR10PLUS})"
else
    echo "  ❌ Samsung G81SF not detected!"
    echo "  Check HDMI cable connection and monitor power."
    exit 1
fi

# ── Check current display mode ─────────────────────────────────
echo ""
echo "▸ Current Display Configuration"
echo ""

if command -v displayplacer &>/dev/null; then
    displayplacer list 2>/dev/null
else
    echo "  (Install displayplacer for detailed info: brew install displayplacer)"
fi

# ── Guide for manual settings ──────────────────────────────────
echo ""
echo "▸ macOS Display Settings"
echo ""
echo "  Open: System Settings → Displays"
echo ""
echo "  1. Resolution:    3840 x 2160 (native)"
echo "  2. Refresh Rate:  240 Hz"
echo "  3. HDR:           On"
echo "  4. Color Profile: HDR (if available)"
echo ""
echo "  Scaling recommendation for 27\" 4K:"
echo "  • 'Default for display' = Retina 2x (1920×1080 logical) — clean/readable"
echo "  • 'More Space' = more workspace, smaller UI — good for productivity"
echo ""

# Open System Settings to Displays
echo "  Opening System Settings → Displays..."
open "x-apple.systempreferences:com.apple.Displays-Settings.extension"

echo ""
echo "▸ If 240Hz doesn't appear:"
echo ""
echo "  1. Check HDMI cable is Ultra High Speed (48Gbps certified)"
echo "  2. Monitor OSD → HDMI Mode must be '2.1' (not 1.4)"
echo "  3. Try the other HDMI port on the monitor"
echo "  4. Hold Option key while clicking resolution options"
echo ""

# ── Monitor OSD Checklist ──────────────────────────────────────
echo ""
echo "▸ Monitor OSD Settings (use joystick on back of monitor)"
echo ""
echo "  ┌────────────────────────┬───────────────────────────────────┐"
echo "  │ HDMI Mode              │ HDMI 2.1 (required for 4K 240Hz) │"
echo "  │ Response Time          │ Standard or Fast                  │"
echo "  │ Brightness (SDR)       │ 40-60%                            │"
echo "  │ Picture Mode           │ Custom or Standard                │"
echo "  │ Color Temperature      │ Warm 2 or Custom R50/G50/B50      │"
echo "  │ Gamma                  │ Mode 1 (2.2)                      │"
echo "  │ Color Space            │ sRGB (design) / Native (widest)   │"
echo "  │ HDR                    │ On                                │"
echo "  │ HDR Tone Mapping       │ On                                │"
echo "  │ Pixel Refresh          │ Auto                              │"
echo "  │ Screen Saver           │ Enable                            │"
echo "  │ Logo Detection Dimming │ On                                │"
echo "  └────────────────────────┴───────────────────────────────────┘"
echo ""
