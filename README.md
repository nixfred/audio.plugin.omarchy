<p align="center">
  <img src="docs/bar.png" alt="Audio Pulse on the Omarchy bar next to AirPods and Bluetooth" width="100%">
</p>

<p align="center">
  <a href="#install"><img alt="Omarchy plugin" src="https://img.shields.io/badge/Omarchy-bar%20widget-43f2a1?style=flat-square&labelColor=0b141d"></a>
  <a href="LICENSE"><img alt="MIT" src="https://img.shields.io/badge/license-MIT-efcc45?style=flat-square&labelColor=0b141d"></a>
  <a href="https://github.com/nixfred/ram.plugin.omarchy"><img alt="Sibling of RAM Pulse" src="https://img.shields.io/badge/sibling-RAM%20Pulse-63c89e?style=flat-square&labelColor=0b141d"></a>
</p>

# Audio Pulse

An animated, glowing audio chip for the Omarchy top bar. Same die, same colour language, same pins as [RAM Pulse](https://github.com/nixfred/ram.plugin.omarchy), [CPU Pulse](https://github.com/nixfred/omacpu) and [Net Pulse](https://github.com/nixfred/omanet.plugin.omarchy). Green at a whisper → yellow at half → dark red at concert-hall. Muted is grey, with a slash through the die.

<p align="center">
  <img src="docs/chip.png" alt="Compact Audio Pulse chip showing 95% VOL" width="280">
</p>

The inner mark follows the selected sink: speaker cone, headphone cups, HDMI display, or wireless arcs. Spectrum bars and a liquid fill track volume; pin packets run faster as the output peaks.

Left-click opens the mixer. Right-click mutes. Scroll changes volume. Everything else — output picker, input meter, per-app streams, keyboard cursor — is the stock audio panel, deliberately preserved.

<p align="center">
  <img src="docs/overview.png" alt="Audio Pulse mixer with hero chip, output picker and input meter" width="720">
</p>

## Install

This is a clone of `omarchy.audio`. On an Omarchy desktop:

```bash
omarchy plugin clone omarchy.audio
```

Then copy this plugin over `~/.config/omarchy/plugins/<user>.audio`, or:

```bash
omarchy plugin add https://github.com/nixfred/audio.plugin.omarchy --enable
```

Clone already replaces `omarchy.audio` in place. Disable the stock panel if both claim the bar slot.

## Files

- `AudioChip.qml` — compact bar die and the 148px hero chip
- `Panel.qml` — mixer, cloned from stock audio
- `Model.js` — sink kind, headroom ramp, volume readout
