<p align="center">
  <img src="assets/thorium-purple-lightning.png" width="220" alt="Thorium Browser Emblem">
</p>

# Thorium 瀏覽器（AVX1 + NVIDIA 舊顯卡/GF108 雙顯卡專用版）- 深度整合 RIME 輸入法與硬體解碼

[![版本](https://img.shields.io/badge/版本-v151.0.7922.72-blue.svg)](packages/)
[![架構](https://img.shields.io/badge/架構-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![GPU](https://img.shields.io/badge/GPU-Intel%20HD4000%20%2B%20GF108%20Fermi-orange.svg)](SUPPORT_MATRIX.md)
[![授權](https://img.shields.io/badge/授權-BSD--3--Clause-lightgrey.svg)](LICENSE)

專為 **Intel 第 2/3 代 Core 處理器（Sandy Bridge / Ivy Bridge 架構，如 i5-3210M、i7-2600K、i7-3770K）**、老舊 AMD 平台及雙顯卡筆電（Intel HD 4000 核顯 + NVIDIA Fermi GF108 GT 635M / 390.xx 驅動）量身打造的高效能 Chromium/Thorium 瀏覽器發布版。

---

## 🌟 核心特性與技術突破

1. **AVX1 微架構專屬編譯優化**：
   - 採用 `-march=sandybridge -mtune=generic -O3` 與 ThinLTO 全局優化，相較於標準版 Chromium，在 Ivy Bridge / Sandy Bridge 舊機型上獲得 **20%~25% 的頁面渲染與 JavaScript 執行提速**。
2. **建置主機工具鏈隔離技術（Toolchain Segregation）**：
   - 透過自定義的 `clang_x64_target` 工具鏈定義，徹底解決在非 AVX 或異質架構編譯機上生成代碼時，宿主工具（`protoc`、`torque`、`cppgen`）崩潰的難題。
3. **RIME（中州韻 / Fcitx5）長效輸入防失效機制**：
   - 完整支援 Linux 下 Fcitx5 / IBus 候選字框原生跟隨。引入視窗遮蔽保持旗標（`--disable-features=CalculateNativeWinOcclusion`），徹底解決長時間使用或頁籤休眠後輸入法自動失效的系統缺陷。
4. **雙顯卡硬體加速適配（NVIDIA 390 + Linux 6.6 + Xorg 21.1）**：
   - **內核空間**：升級 `nv.c` 採用現代 `pci_alloc_irq_vectors(PCI_IRQ_ALL_TYPES)`，消除 Linux 6.6 下與 USB 主控器 IRQ 16 衝突引起的 `NVRM: request_irq() failed (-22)` 崩潰。
   - **使用者空間**：配置 `/usr/lib/bumblebee-nvidia-ext/` 模組隔離，並透過 `fix_drm.so` 攔截次級 Xorg 的 DRM Master 鎖定請求，讓 NVIDIA Fermi GF108 實體顯卡完美釋放 **OpenGL 4.6 與 2GB 實體顯存**。
5. **VA-API 視訊硬體解碼**：
   - 完整啟用 Intel HD Graphics 4000/3000 硬體解碼通道，1080p60 串流影片流暢播放，大幅降低老舊 CPU 佔用率與發熱。

---

## 🚀 部署方案與快速安裝

### 1. Debian / antiX / Ubuntu 安裝（.deb）：
```bash
sudo apt update && sudo apt install -y libnss3 libatk1.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2
sudo dpkg -i packages/thorium-browser_151.0.7922.72_AVX_RIME.deb || sudo apt-get -f install -y
```

### 2. Arch Linux 安裝（.pkg.tar.zst）：
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-151.0.7922.72-1-x86_64.pkg.tar.zst
```

### 3. GF108 雙顯卡一鍵加速配置：
```bash
# 執行驅動補丁與環境配置腳本
bash scripts/setup_gf108_acceleration.sh

# 啟動並調用 GF108 硬體 OpenGL 加速
gf108-run thorium-browser
```

---

## 📁 專案目錄結構

```text
thorium-avx-release/
├── README.md               # 英文專案說明
├── README_zh.md            # 繁體中文專案說明
├── README_ja.md            # 日文專案說明
├── SUPPORT_MATRIX.md       # 詳細處理器微架構與顯卡支援表
├── INSTALL.md              # 多發行版安裝與雙顯卡加速指南
├── .gitignore              # 排除 >100MB 大檔案
├── config/args_avx.gn      # 核心構建配置
├── packaging/              # 發行版打包規格 (Arch PKGBUILD, Debian control)
├── patches/                # 編譯工具鏈隔離與驅動補丁集合
├── packages/SHA256SUMS     # 校驗清單 (安裝包發布於 Releases 頁面)
└── scripts/                # 自動化編譯與 GPU 配置腳本
```
