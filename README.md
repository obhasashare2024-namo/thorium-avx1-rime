<p align="center">
  <img src="assets/thorium-purple-lightning.png" width="220" alt="Thorium Browser Emblem">
</p>

# Thorium Browser (AVX1 + Legacy NVIDIA Fermi/GF108 Edition) with RIME IME & Dual-GPU Offloading

[![Release](https://img.shields.io/badge/Release-v151.0.7922.72-blue.svg)](packages/)
[![Arch](https://img.shields.io/badge/Arch-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![GPU](https://img.shields.io/badge/GPU-Intel%20HD4000%20%2B%20GF108%20Fermi-orange.svg)](SUPPORT_MATRIX.md)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-lightgrey.svg)](LICENSE)

A high-performance Chromium/Thorium binary optimized for **2nd and 3rd Generation Intel Core processors (Sandy Bridge / Ivy Bridge)**, legacy AMD CPUs, and hybrid dual-GPU laptops (Intel HD Graphics 3000/4000 + NVIDIA Fermi GF108 / GT 635M / 390.xx drivers).

---

## 🌟 Key Technical Highlights

1. **AVX1 Microarchitecture Optimization**:
   - Compiled with `-march=sandybridge -mtune=generic -O3` and ThinLTO, delivering up to 25% faster rendering and JavaScript execution on Sandy Bridge & Ivy Bridge processors.
2. **Host-Target Toolchain Segregation**:
   - Isolates host compilation tools from target flags (`clang_x64_target`), allowing non-AVX build hosts to compile AVX binaries without generator tool crashes.
3. **Native RIME IME Integration (Zero Dropping)**:
   - Full native inline candidate positioning for Fcitx5 and IBus. Includes occlusion keepalive flags (`--disable-features=CalculateNativeWinOcclusion`) preventing IME focus loss during long sessions.
4. **NVIDIA 390.157 + Linux 6.6 Kernel & Xorg 21.1 Dual-GPU Fixes**:
   - Kernel Patch: Replaces deprecated MSI allocation with `pci_alloc_irq_vectors(PCI_IRQ_ALL_TYPES)`, eliminating `request_irq (-22)` interrupt collisions on modern kernels.
   - User-space Shim: Isolates GLX modules in `/usr/lib/bumblebee-nvidia-ext/` and intercepts secondary DRM Master locks (`fix_drm.so`), restoring full hardware OpenGL 4.6 and 2GB VRAM offloading on GF108 Fermi GPUs.
5. **VA-API Hardware Video Decoding**:
   - Hardware-accelerated 1080p60 video playback via Intel HD 4000/3000 iGPUs, significantly reducing CPU load and thermal throttling.

---

## 🚀 Quick Deployment & Installation

### Debian / Ubuntu / antiX Linux (.deb)
```bash
# 1. Install dependencies
sudo apt update
sudo apt install -y libnss3 libatk1.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2

# 2. Install precompiled package
sudo dpkg -i packages/thorium-browser_151.0.7922.72_AVX_RIME.deb || sudo apt-get -f install -y
```

### Arch Linux (.pkg.tar.zst)
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-151.0.7922.72-1-x86_64.pkg.tar.zst
```

### GF108 / NVIDIA 390 Hybrid GPU One-Click Activation
```bash
# Deploy driver patches and launcher
bash scripts/setup_gf108_acceleration.sh

# Launch Thorium with full GF108 hardware OpenGL offloading
gf108-run thorium-browser
```

---

## 📁 Repository Structure

```text
thorium-avx-release/
├── README.md               # English documentation
├── README_zh.md            # Traditional Chinese documentation
├── README_ja.md            # Japanese documentation
├── SUPPORT_MATRIX.md       # Full CPU microarchitecture & GPU matrix
├── INSTALL.md              # Detailed installation & troubleshooting guide
├── .gitignore              # Large binary isolation (.deb/.pkg.tar.zst)
├── config/args_avx.gn      # Chromium GN build configuration
├── packaging/              # Distribution package specifications (Arch/Debian)
├── patches/                # Compiler segregation and Linux 6.6 driver patches
├── packages/SHA256SUMS     # Cryptographic checksums (Binaries on Releases)
└── scripts/                # Automated compilation and GPU setup scripts
```
