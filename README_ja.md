<p align="center">
  <img src="assets/thorium-purple-lightning.png" width="220" alt="Thorium Browser Emblem">
</p>

# Thorium Browser（AVX1＋旧世代NVIDIA GPU/Fermi GF108対応版）- RIME IME統合＆ハードウェアアクセラレーション

[![リリース](https://img.shields.io/badge/リリース-v154.0.8023.0-blue.svg)](packages/)
[![アーキテクチャ](https://img.shields.io/badge/アーキテクチャ-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![GPU](https://img.shields.io/badge/GPU-Intel%20HD4000%20%2B%20GF108%20Fermi-orange.svg)](SUPPORT_MATRIX.md)
[![ライセンス](https://img.shields.io/badge/ライセンス-BSD--3--Clause-lightgrey.svg)](LICENSE)

**第2世代・第3世代 Intel Core プロセッサ（Sandy Bridge / Ivy Bridge、例: i5-3210M、i7-2600K、i7-3770K）**、旧世代 AMD CPU、およびハイブリッド デュアル GPU ノート PC（Intel HD Graphics 4000 ＋ NVIDIA Fermi GF108 GT 635M / 390.xx ドライバ）向けに高度に最適化された Chromium / Thorium ブラウザの公式リリースポジトリです。

---

## 🌟 主な特徴と技術革新

1. **AVX1 マイクロアーキテクチャ専用最適化**：
   - `-march=sandybridge -mtune=generic -O3` および ThinLTO を適用。Sandy Bridge / Ivy Bridge 搭載機において、標準 Chromium と比較して**レンダリングおよび JavaScript 実行速度が最大 20%〜25% 向上**。
2. **ビルドホスト分離ツールチェーン（Toolchain Segregation）**：
   - 独自の `clang_x64_target` ツールチェーン定義により、非 AVX ビルド機や異種アーキテクチャ上でもジェネレータツール（`protoc`、`torque`、`cppgen`）のクラッシュなしに AVX バイナリを確実にビルド。
3. **RIME（中州韻 / Fcitx5）IME 長時間安定動作（フォーカス喪失防止）**：
   - Linux 環境での Fcitx5 / IBus 候補ウィンドウのインライン追従にネイティブ対応。ウィンドウ遮蔽追跡保持フラグ（`--disable-features=CalculateNativeWinOcclusion`）を導入し、長時間使用やタブスリープ時の入力不能問題を根本解決。
4. **NVIDIA 390.157 ＋ Linux 6.6 ＋ Xorg 21.1 デュアル GPU 対応**：
   - カーネルパッチ：廃止された `pci_enable_msi` を `pci_alloc_irq_vectors(PCI_IRQ_ALL_TYPES)` に置換し、USB コントローラ IRQ 16 との競合による `NVRM: request_irq() failed (-22)` を完全解消。
   - ユーザ空間 Shim：`/usr/lib/bumblebee-nvidia-ext/` による GLX 隔離と `fix_drm.so` による DRM Master 競合回避を行い、GF108 Fermi GPU 上で **OpenGL 4.6 および 2GB VRAM アクセラレーション** を完全に復旧。
5. **VA-API ハードウェア動画デコード**：
   - Intel HD 4000/3000 内蔵グラフィックスでの 1080p60 再生に対応し、CPU 負荷と発熱を大幅に低減。

---

## 🚀 デプロイとインストール手順

### 1. Debian / Ubuntu / antiX Linux (.deb)
```bash
sudo apt update && sudo apt install -y libnss3 libatk1.0-0 libcups2 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libasound2
sudo dpkg -i packages/thorium-browser_154.0.8023.0_AVX.deb || sudo apt-get -f install -y
```

### 2. Arch Linux (.pkg.tar.zst)
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-154.0.8023.0-1-x86_64.pkg.tar.zst
```

### 3. GF108 デュアル GPU ワンクリック有効化
```bash
# ドライバパッチおよび環境設定スクリプトを実行
bash scripts/setup_gf108_acceleration.sh

# GF108 ハードウェア OpenGL アクセラレーションを有効化して起動
gf108-run thorium-browser
```

---

## 📁 リポジトリ構成

```text
thorium-avx-release/
├── README.md               # 英語ドキュメント
├── README_zh.md            # 繁体中国語ドキュメント
├── README_ja.md            # 日本語ドキュメント
├── SUPPORT_MATRIX.md       # 詳細な CPU / GPU 互換性表
├── INSTALL.md              # インストールおよび GPU 設定ガイド
├── .gitignore              # 大容量バイナリの除外設定
├── config/args_avx.gn      # ビルド構成ファイル
├── packaging/              # ディストリビューション用パッケージ定義
├── patches/                # ツールチェーン分離およびカーネルパッチ
├── packages/SHA256SUMS     # チェックサム一覧（Releases ページでバイナリ配布）
└── scripts/                # 自動ビルドおよび GPU 設定スクリプト
```
