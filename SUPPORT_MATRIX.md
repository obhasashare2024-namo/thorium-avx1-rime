# Thorium AVX (Sandy Bridge / Ivy Bridge) Hardware Support Matrix

This document provides detailed microarchitecture, instruction set, operating system, and GPU hardware acceleration compatibility specifications for **Thorium Browser AVX Build (v151.0.7922.72)**.

---

## 1. Supported CPU Microarchitectures

Thorium AVX is compiled with `-march=sandybridge -mtune=generic -O3` and specifically targets processors supporting **256-bit AVX1 (Advanced Vector Extensions)** instructions.

| Vendor | Microarchitecture / Family | Example Processors | Status | Instruction Sets Utilized |
| :--- | :--- | :--- | :--- | :--- |
| **Intel** | **Sandy Bridge (2nd Gen)** | Core i7-2600K, i5-2500K, i7-2720QM | **Fully Supported** | AVX, SSE4.2, SSE4.1, SSSE3, SSE2 |
| **Intel** | **Ivy Bridge (3rd Gen)** | Core i7-3770K, i5-3210M, i5-3320M | **Fully Supported** | AVX, F16C, SSE4.2, SSE4.1 |
| **Intel** | **Haswell / Broadwell (4th/5th Gen)** | Core i7-4790K, Xeon E5-2696 v4 | **Fully Supported** | AVX, AVX2, FMA3 (Fallback mode) |
| **Intel** | **Skylake to Alder/Raptor Lake** | Core i7-6700K, i9-12900K | **Supported** | (AVX-512 / AVX2 build recommended) |
| **AMD** | **Bulldozer / Piledriver** | FX-8150, FX-8350, A10-5800K | **Fully Supported** | AVX, F16C, SSE4a, SSE4.2 |
| **AMD** | **Zen 1 / Zen+ / Zen 2 / Zen 3** | Ryzen 5 1600, Ryzen 7 3700X, 5800X | **Fully Supported** | AVX, AVX2, FMA3 |

> [!NOTE]
> Processors lacking AVX support (such as Intel Core 2 Duo/Quad, Nehalem/Westmere 1st Gen Core, or older Celeron/Pentium) are **not supported** by this binary. For legacy processors without AVX, use the standard Thorium SSE4.2 build.

---

## 2. GPU Hardware Acceleration Support

| GPU Vendor | Architecture | Chipset / Model | Acceleration Method | Supported Features |
| :--- | :--- | :--- | :--- | :--- |
| **Intel** | **Gen 7 (Ivy Bridge GT2)** | HD Graphics 4000 / 2500 | `i965_drv_video` / VA-API | H.264 / MPEG-2 Hardware Decode, Glamor 2D |
| **Intel** | **Gen 6 (Sandy Bridge)** | HD Graphics 3000 / 2000 | `i965_drv_video` / VA-API | H.264 Video Decode |
| **NVIDIA** | **Fermi (GF108 / GF11x)** | GeForce GT 635M, GT 630M, GT 430 | `nvidia-390.157` + Primus | OpenGL 4.6, VDPAU, CUDA Compute, WebGL 2.0 |
| **NVIDIA** | **Kepler / Maxwell** | GT 730, GTX 750 Ti, GTX 860M | NVIDIA Legacy / Modern Driver | Full Hardware Rasterization, WebGL 2.0 |
| **AMD** | **Radeon HD 5000 / 6000 / 7000**| HD 6450, HD 7770, R7 240 | `radeonsi` / `r600` / VA-API | OpenGL 4.5, VA-API Video Decode |

---

## 3. Supported Operating Systems & Distributions

| Distribution | Version | Compatibility Level | Notes |
| :--- | :--- | :--- | :--- |
| **Debian** | 12 (Bookworm) / 13 (Trixie) / Sid | **Native (.deb)** | Fully tested on Debian 13 Trixie & antiX 26 |
| **Ubuntu** | 22.04 LTS / 24.04 LTS | **Native (.deb)** | Supported via apt or dpkg |
| **Arch Linux** | Current / Rolling | **Native (PKGBUILD)** | Supported via `makepkg` or `.pkg.tar.zst` |
| **antiX Linux** | 23 / 26 (SysVinit / Runit) | **Native (.deb)** | Zero-systemd compatible |
