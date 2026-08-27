#!/usr/bin/env bash
# Thorium AVX (Sandy Bridge / Ivy Bridge) Automated Compilation Pipeline
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_ROOT="${CHROMIUM_SRC:-/mnt/build_workspace/chromium/src}"
OUT_DIR="${SRC_ROOT}/out/thorium_avx"

echo "=== [1/4] 檢查構建環境與來源目錄 ==="
if [ ! -d "${SRC_ROOT}" ]; then
    echo "❌ 錯誤：未找到 Chromium 源碼目錄：${SRC_ROOT}"
    exit 1
fi

echo "=== [2/4] 套用 AVX 工具鏈隔離與 WebUI 補丁 ==="
cd "${SRC_ROOT}"
for patch_file in "${REPO_ROOT}"/patches/*.patch; do
    if [ -f "${patch_file}" ]; then
        echo "--> 應用補丁: $(basename "${patch_file}")"
        git apply --check "${patch_file}" 2>/dev/null && git apply "${patch_file}" || echo "    (補丁已套用或略過)"
    fi
done

echo "=== [3/4] 產生 GN 構建檔案 ==="
mkdir -p "${OUT_DIR}"
cp -f "${REPO_ROOT}/config/args_avx.gn" "${OUT_DIR}/args.gn"
gn gen "${OUT_DIR}"

echo "=== [4/4] 執行 Ninja 編譯 ==="
autoninja -C "${OUT_DIR}" thorium chrome_sandbox

echo "=== ✅ Thorium AVX 編譯完成！產物位於：${OUT_DIR}/thorium ==="
