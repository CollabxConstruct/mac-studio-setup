#!/bin/zsh
# ============================================================================
# Peripheral Software Installer
# ============================================================================
# Installs and organizes all peripheral software for your Mac Studio setup.
#
# Run from Terminal: zsh ~/Dev/mac-studio-setup/install-peripheral-software.sh
# (Will prompt for password when needed)
# ============================================================================

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Peripheral Software Installer"
echo "  $(date '+%Y-%m-%d %H:%M')"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# ── 1. Logi Options+ (Logitech Light Bar + Webcam) ────────────
echo "▸ 1/4 — Logi Options+ (Light Bar + Webcam)"
if mdfind "kMDItemDisplayName == 'Logi Options+*'" 2>/dev/null | grep -q "Logi"; then
    echo "  ✅ Already installed"
else
    echo "  Installing via Homebrew (will prompt for password)..."
    brew install --cask logi-options+ 2>&1 | tail -3
    if [[ $? -eq 0 ]]; then
        echo "  ✅ Logi Options+ installed"
    else
        echo "  ⚠️  Homebrew install failed — downloading directly..."
        echo "  Opening download page..."
        open "https://www.logitech.com/en-us/software/logi-options-plus.html"
        echo "  → Download and install manually from the page"
    fi
fi
echo ""

# ── 2. SteelSeries GG (Aerox 3 Wireless) ──────────────────────
echo "▸ 2/4 — SteelSeries GG (Aerox 3 Wireless mouse)"
if mdfind "kMDItemDisplayName == 'SteelSeries GG*'" 2>/dev/null | grep -q "SteelSeries"; then
    echo "  ✅ Already installed"
else
    echo "  Installing via Homebrew (will prompt for password)..."
    brew install --cask steelseries-gg 2>&1 | tail -3
    if [[ $? -eq 0 ]]; then
        echo "  ✅ SteelSeries GG installed"
    else
        echo "  ⚠️  Homebrew install failed — downloading directly..."
        echo "  Opening download page..."
        open "https://steelseries.com/gg"
        echo "  → Download and install manually from the page"
    fi
fi
echo ""

# ── 3. Razer Synapse (Seiren V3 Mini mic) ─────────────────────
echo "▸ 3/4 — Razer Synapse (Seiren V3 Mini mic)"
if mdfind "kMDItemDisplayName == 'Razer Synapse*'" 2>/dev/null | grep -q "Razer"; then
    echo "  ✅ Already installed"
else
    echo "  Not available via Homebrew — opening download page..."
    open "https://www.razer.com/synapse-3"
    echo "  → Download Razer Synapse 3 for macOS"
    echo "  → Install and sign in with your Razer ID (or create one)"
    echo "  → The Seiren V3 Mini will appear automatically once Synapse is running"
fi
echo ""

# ── 4. Glorious CORE (GMMK 75% keyboard) ──────────────────────
echo "▸ 4/4 — Glorious CORE (GMMK 75% keyboard)"
if mdfind "kMDItemDisplayName == 'Glorious CORE*'" 2>/dev/null | grep -q "Glorious"; then
    echo "  ✅ Already installed"
else
    echo "  Not available via Homebrew — opening download page..."
    open "https://www.gloriousgaming.com/pages/glorious-core"
    echo "  → Download Glorious CORE for macOS"
    echo "  → Install and the GMMK 75% will be detected automatically"
    echo "  → Use CORE to configure RGB, key mappings, and macros"
fi
echo ""

# ── Optional: Sterling H224 Control Panel ──────────────────────
echo "▸ Bonus — Sterling H224 Control Panel (optional)"
if mdfind "kMDItemDisplayName == '*H224*Control*'" 2>/dev/null | grep -q "H224"; then
    echo "  ✅ Already installed"
else
    echo "  Optional: provides GUI for routing, sample rate, and monitor mix"
    echo "  Opening download page..."
    open "https://sterlingaudio.net/harmony-h224-audio-interface-drivers/"
    echo "  → Download H224 Control Panel v1.3.0.0 for macOS"
fi

# ── Summary ────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  Software Installation Summary"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  ┌────────────────────────┬──────────────────────────────────┐"
echo "  │ Software               │ Controls                         │"
echo "  ├────────────────────────┼──────────────────────────────────┤"
echo "  │ Logi Options+          │ Logitech Light Bar + Webcam      │"
echo "  │ SteelSeries GG         │ Aerox 3 Wireless mouse           │"
echo "  │ Razer Synapse 3        │ Seiren V3 Mini microphone        │"
echo "  │ Glorious CORE          │ GMMK 75% keyboard (RGB/macros)   │"
echo "  │ H224 Control Panel     │ Sterling audio interface (opt.)  │"
echo "  │ Audio MIDI Setup       │ Sample rate / bit depth (built-in│"
echo "  └────────────────────────┴──────────────────────────────────┘"
echo ""
echo "  After installing, launch each app once to complete setup."
echo "  Most will add a menu bar icon for quick access."
echo ""
