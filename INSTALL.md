# Thorium AVX Installation & Configuration Guide

This guide covers installing and configuring **Thorium Browser AVX Build (v151.0.7922.72)** with RIME input method integration and GPU hardware acceleration on Debian, Ubuntu, antiX, and Arch Linux.

---

## 1. Installation

### Debian / Ubuntu / antiX Linux (.deb)

Download `thorium-browser_151.0.7922.72_AVX_RIME.deb` from the `packages/` directory or GitHub Releases:

```bash
# 1. Install required dependencies
sudo apt update
sudo apt install -y libnss3 libatk1.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2

# 2. Install the package
sudo dpkg -i packages/thorium-browser_151.0.7922.72_AVX_RIME.deb || sudo apt-get -f install -y
```

### Arch Linux (.pkg.tar.zst / PKGBUILD)

```bash
# Option A: Direct install from prebuilt package
sudo pacman -U packages/thorium-browser-avx-rime-bin-151.0.7922.72-1-x86_64.pkg.tar.zst

# Option B: Build with PKGBUILD
cd packaging/arch
makepkg -si
```

---

## 2. RIME Input Method (Fcitx5 / IBus) Setup

Thorium AVX includes native IME support for Fcitx5, Fcitx4, and IBus. Ensure your desktop environment passes the required environment variables:

```bash
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
```

Start Thorium with native IME candidate window positioning:
```bash
thorium-browser --enable-features=UseOzonePlatform --ozone-platform=x11
```

---

## 3. NVIDIA Optimus & Hybrid GPU Acceleration (e.g. GF108 / GT 635M)

For laptops with hybrid Intel + NVIDIA GPUs running Linux 6.x kernels and Xorg 21.1+:

1. Run the included setup script:
   ```bash
   bash scripts/setup_gf108_acceleration.sh
   ```
2. Launch Thorium with full GF108 hardware OpenGL offloading:
   ```bash
   gf108-run thorium-browser
   ```

---

## 4. Verification

Open `chrome://gpu` in Thorium and verify:
- **Canvas**: Hardware accelerated
- **Direct Rendering**: Yes
- **Rasterization**: Hardware accelerated
- **Video Decode**: Hardware accelerated (via VA-API)
