#!/usr/bin/env bash
# GF108 / NVIDIA 390.157 + Linux 6.6 + Xorg 21.1 Hybrid Graphics Acceleration Setup
set -euo pipefail

echo "=== [1/4] 配置 Xorg 21.1 GLX 模組隔離目錄 ==="
sudo mkdir -p /usr/lib/bumblebee-nvidia-ext
sudo ln -sf /usr/lib/xorg/modules/extensions/libglx.so.390.157 /usr/lib/bumblebee-nvidia-ext/libglx.so

echo "=== [2/4] 編譯 DRM Master 攔截 Shim (fix_drm.so) ==="
cat << 'CCODE' | sudo gcc -O2 -fPIC -shared -x c - -o /usr/lib/bumblebee-nvidia-ext/fix_drm.so -ldl
#define _GNU_SOURCE
#include <dlfcn.h>
#include <errno.h>

int drmSetMaster(int fd) {
    return 0; // Return success to allow secondary X server initialization without DRM master lock
}

int drmDropMaster(int fd) {
    return 0;
}
CCODE

echo "=== [3/4] 配置 Secondary Xorg Wrapper ==="
cat << 'WRAP' | sudo tee /usr/lib/bumblebee-nvidia-ext/Xorg-bumblebee
#!/bin/bash
export LD_PRELOAD=/usr/lib/bumblebee-nvidia-ext/fix_drm.so
exec /usr/lib/xorg/Xorg "$@" -novtswitch -sharevts -ac
WRAP
sudo chmod +x /usr/lib/bumblebee-nvidia-ext/Xorg-bumblebee

echo "=== [4/4] 部署一鍵加速啟動器 (gf108-run) ==="
cat << 'RUNNER' | sudo tee /usr/local/bin/gf108-run
#!/bin/bash
if ! ps aux | grep -v grep | grep -q "Xorg :8"; then
    export LD_PRELOAD=/usr/lib/bumblebee-nvidia-ext/fix_drm.so
    sudo LD_PRELOAD=/usr/lib/bumblebee-nvidia-ext/fix_drm.so /usr/lib/xorg/Xorg :8 -config /etc/bumblebee/xorg.conf.nvidia -configdir /etc/bumblebee/xorg.conf.d -sharevts -nolisten tcp -noreset -verbose 3 -isolateDevice PCI:001:00:0 -modulepath /usr/lib/bumblebee-nvidia-ext,/usr/lib/xorg/modules -ac >/tmp/xorg8.stdout.log 2>&1 &
    sleep 1
fi

export DISPLAY=${DISPLAY:-:0}
export PRIMUS_DISPLAY=:8
export PRIMUS_libGLa=/usr/lib/x86_64-linux-gnu/libGLX_nvidia.so.390.157
export PRIMUS_libGLd=/usr/lib/x86_64-linux-gnu/libGLX_mesa.so.0
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/primus:${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

exec "$@"
RUNNER
sudo chmod +x /usr/local/bin/gf108-run

echo "=== ✅ GF108 加速環境部署完成！可使用 gf108-run thorium-browser 啟動 ==="
