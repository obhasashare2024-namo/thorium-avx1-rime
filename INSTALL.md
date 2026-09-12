# Thorium AVX1 + Legacy GPU Installation & Configuration Guide

This guide covers installing and configuring **Thorium Browser AVX1 Edition (v154.0.8023.0)** with persistent RIME input method integration and hybrid GPU acceleration on Debian, Ubuntu, antiX, and Arch Linux.

---

## 1. Installation

### Debian / Ubuntu / antiX Linux (.deb)
```bash
sudo apt update
sudo apt install -y libnss3 libatk1.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2
sudo dpkg -i packages/thorium-browser_154.0.8023.0_AVX.deb || sudo apt-get -f install -y
```

### Arch Linux (.pkg.tar.zst)
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-154.0.8023.0-1-x86_64.pkg.tar.zst
```

---

## 2. Persistent RIME (Fcitx5 / IBus) Setup

To ensure RIME Chinese input never loses focus or drops out during long sessions or after tab discarding:

1. Add environment variables to `~/.bashrc` or `~/.xprofile`:
   ```bash
   export GTK_IM_MODULE=fcitx
   export QT_IM_MODULE=fcitx
   export XMODIFIERS=@im=fcitx
   export SDL_IM_MODULE=fcitx
   export GLFW_IM_MODULE=fcitx
   ```
2. Launch Thorium with persistent Gtk3 IM context and occlusion keepalive flags:
   ```bash
   thorium-browser \
     --gtk-version=3 \
     --ozone-platform=x11 \
     --enable-features=UseOzonePlatform \
     --disable-features=CalculateNativeWinOcclusion
   ```

---

## 3. NVIDIA Optimus & Hybrid GPU Acceleration (e.g. GF108 / GT 635M)

For laptops with hybrid Intel + NVIDIA GPUs running Linux 6.x kernels and Xorg 21.1+:

1. Execute the automated setup script:
   ```bash
   bash scripts/setup_gf108_acceleration.sh
   ```
2. Launch Thorium with full GF108 hardware OpenGL offloading:
   ```bash
   gf108-run thorium-browser
   ```

---

## 4. Hardware Acceleration Verification

Open `chrome://gpu` in Thorium and verify:
- **Canvas**: Hardware accelerated
- **Direct Rendering**: Yes
- **Rasterization**: Hardware accelerated
- **Video Decode**: Hardware accelerated (via VA-API)
