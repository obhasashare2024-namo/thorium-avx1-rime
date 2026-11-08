<p align="center">
  <img src="assets/thorium-purple-lightning.png" width="220" alt="Thorium Browser Emblem">
</p>

# Thorium Browser（公式 Chromium ＋ Thorium ハイブリッド AVX1＆RIME IME 版）

[![リリース](https://img.shields.io/badge/リリース-最新版-blue.svg)](packages/)
[![ハイブリッドビルド](https://img.shields.io/badge/ハイブリッドビルド-公式%20Chromium%20%2B%20Thorium-blueviolet.svg)](#-ハイブリッドコンパイルアーキテクチャと系譜-hybrid-compilation-architecture)
[![アーキテクチャ](https://img.shields.io/badge/アーキテクチャ-x86__64%20(AVX1)-green.svg)](SUPPORT_MATRIX.md)
[![GPU](https://img.shields.io/badge/GPU-Intel%20HD4000%20%2B%20GF108%20Fermi-orange.svg)](SUPPORT_MATRIX.md)
[![ライセンス](https://img.shields.io/badge/ライセンス-BSD--3--Clause-lightgrey.svg)](LICENSE)

[English](README.md) | [繁體中文](README_zh.md) | [日本語](README_ja.md) | [Hardware Support Matrix](SUPPORT_MATRIX.md) | [技術設計書](HANDOFF_M159.md) | [インストール ガイド](INSTALL.md)

---

## 🧬 ハイブリッドコンパイルアーキテクチャと系譜 (Hybrid Compilation Architecture)

> [!IMPORTANT]
> **ハイブリッドソースコードの系譜**：本プロジェクトは、**公式 Chromium 最新版**（最新 Upstream ソースツリー）と **Thorium 最新版**（`Alex313031/Thorium` の SIMD 最適化および機能パッチ群）を融合し、さらに独自開発のビルドホスト分離ツールチェーン、Linux RIME / Fcitx5 IME 入力保持機構、および NVIDIA 390 デュアル GPU 加速ドライバパッチを統合した**デュアルトラック ハイブリッドビルド版**です。

```mermaid
graph TD
    A["公式 Chromium 上流ソースツリー (最新版)"] --> D["ハイブリッド ソースツリー (AVX1)"]
    B["Thorium 最新パッチ群 (AVX1 SIMD / ThinLTO / Codecs / 紫テーマ)"] --> D
    C["独自 C++ & カーネルパッチ (RIME 保持 / ホストツールチェーン分離 / GF108 加速)"] --> D
    D --> E["GN ベクトル構成 (args_avx.gn)"]
    E --> F["Clang + ThinLTO + 128/256ビット AVX1 コンパイルエンジン"]
    F --> G["ネイティブ バイナリおよびパッケージ (.deb / .pkg.tar.zst)"]
```

| 構成要素 | ソース / 上流 | 主な貢献と技術的実装詳細 |
| :--- | :--- | :--- |
| **ベース ブラウザ エンジン** | **公式 Chromium コア (最新版)** | 安定した Chromium レンダリングエンジン、V8 JavaScript エンジン、最新 Web 標準基盤。 |
| **ベクトル & マルチメディア群** | **Thorium 最新版** (`Alex313031/Thorium`) | AVX1 最適化フラグ（`-march=sandybridge`）、ThinLTO、全メディアコーデック、公式 API キー、紫太極ブランドアセット。 |
| **ホスト分離ツールチェーン** | **独自パッチ Patch 0001** | ホスト用生成ツールとターゲット用 AVX フラグ（`clang_x64_target`）を分離し、非 AVX ビルド機でのクラッシュを防止。 |
| **RIME IME 入力保持機構** | **独自パッチ** | Linux Fcitx5 / IBus 候補枠インライン追従に対応し、遮蔽追跡保持フラグ（`--disable-features=CalculateNativeWinOcclusion`）によりスリープ後の入力不能を防止。 |
| **NVIDIA 390 デュアル GPU 対応** | **独自カーネル/ユーザ空間パッチ** | `nv.c` を更新して `pci_alloc_irq_vectors` を適用し IRQ 競合を解消。`fix_drm.so` で DRM Master 競合を回避し、GF108 の 2GB VRAM と OpenGL 4.6 を解放。 |
| **VA-API ハードウェア動画デコード** | **専用構成** | Intel HD 4000/3000 内蔵グラフィックスでの 1080p60 再生に対応し、CPU 負荷を大幅に低減。 |

---

## 概要

**Thorium Browser（AVX1 互換版）** は、**AVX1 命令セット**（Sandy Bridge / Ivy Bridge）およびレガシーハードウェア向けに最適化された超高速 Chromium フォークです。公式 Chromium コアと Thorium のマルチメディアマイクロカーネル、AVX1 SIMD ルーチン、およびハードウェアアクセラレーションを緊密に統合しています。

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
sudo dpkg -i packages/thorium-browser_*_AVX.deb || sudo apt-get -f install -y
```

### 2. Arch Linux (.pkg.tar.zst)
```bash
sudo pacman -U packages/thorium-browser-avx-rime-bin-*-x86_64.pkg.tar.zst
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
├── .gitignore              # 大容量バイナリ隔離設定
├── config/args_avx.gn      # Chromium GN ビルド構成ファイル
├── packaging/              # 各種ディストリビューション向けパッケージ定義
├── patches/                # コンパイラ分離および Linux 6.6 ドライバパッチ群
├── packages/SHA256SUMS     # 暗号化チェックサムリスト
└── scripts/                # 自動ビルドおよび GPU 設定スクリプト
```
