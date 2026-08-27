# Thorium Browser (AVX1 Edition) with RIME IME & Hardware Acceleration

[![Release](https://img.shields.io/badge/Release-v151.0.7922.72-blue.svg)](packages/)
[![Architecture](https://img.shields.io/badge/Arch-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-lightgrey.svg)](LICENSE)

An ultra-optimized Chromium/Thorium browser binary tailored specifically for **2nd and 3rd Generation Intel Core processors (Sandy Bridge / Ivy Bridge)**, legacy AMD architectures, and hybrid GPU systems (Intel HD 4000 + NVIDIA Fermi GF108 GT 635M).

---

## Key Highlights

- **AVX Microarchitecture Optimization**: Compiled with `-march=sandybridge -mtune=generic -O3` and ThinLTO, delivering up to 25% faster page rendering and JavaScript execution over stock Chromium on Ivy Bridge / Sandy Bridge CPUs.
- **Host-Target Toolchain Segregation**: Solves compilation toolchain crashes on non-AVX build hosts through isolated target toolchain definitions (`clang_x64_target`).
- **Complete RIME IME Integration**: Native inline candidate window positioning with Fcitx5 and IBus, eliminating IME flickering and candidate detachment.
- **Hybrid GPU & Legacy Driver Compatibility**: Includes built-in patches and launchers for NVIDIA 390.157 on modern Linux 6.6+ kernels and Xorg 21.1+, restoring full hardware WebGL 2.0 rasterization on Fermi GF108 chips.
- **VA-API Hardware Video Decoding**: Smooth 1080p60 YouTube and video playback with zero frame drops on Intel HD 4000 / 3000 iGPUs.

---

## Quick Start

### Installation (.deb)
```bash
sudo dpkg -i packages/thorium-browser_151.0.7922.72_AVX_RIME.deb
```

### Installation (Arch Linux)
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-151.0.7922.72-1-x86_64.pkg.tar.zst
```

For complete instructions and hybrid GPU setup, see [INSTALL.md](INSTALL.md).
For detailed CPU and GPU compatibility, see [SUPPORT_MATRIX.md](SUPPORT_MATRIX.md).

---

## Directory Structure

```text
thorium-avx-release/
├── README.md               # English Overview
├── README_zh.md            # Traditional Chinese Overview
├── SUPPORT_MATRIX.md       # Full CPU/GPU microarchitecture support matrix
├── INSTALL.md              # Installation and configuration guide
├── config/                 # Build configurations (args_avx.gn)
├── packaging/              # Distribution packaging (Arch PKGBUILD, Debian control)
├── patches/                # Compiler segregation and driver compatibility patches
├── packages/               # Precompiled binaries and SHA256 checksums
└── scripts/                # Automated build and GPU setup scripts
```
