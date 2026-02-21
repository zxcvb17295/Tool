.PHONY: tmux install-focus uninstall-focus help

# --- 預設目標 ---
help:
	@echo "Makefile 用法:"
	@echo "  make tmux            - 設定 Tmux 環境。"
	@echo "  make install-focus   - 安裝或更新 'focus' 腳本。"
	@echo "  make uninstall-focus - 移除 'focus' 腳本。"


# ==============================================================================
# => Tmux
# ==============================================================================

# --- 變數 ---
TPM_DIR    := $(HOME)/.tmux/plugins/tpm
TMUX_CONF  := $(HOME)/.tmux.conf
LOCAL_CONF := $(PWD)/tmux.conf

# --- 目標 ---
tmux:
	@echo "==> 🚀 正在啟動 tmux 設定..."

	@# 1. 如果 Tmux 插件管理器 (TPM) 不存在，則安裝它。
	@if [ ! -d "$(TPM_DIR)" ]; then \
		echo "未找到 TPM。正在從 GitHub 安裝..."; \
		git clone https://github.com/tmux-plugins/tpm $(TPM_DIR); \
	else \
		echo "TPM 已存在。跳過安裝。"; \
	fi

	@# 2. 從您的本地設定檔創建一個符號連結到主目錄。
	@# -sf 標誌將強制覆蓋任何現有的連結，無需詢問。
	@echo "正在為 .tmux.conf 創建符號連結：$(TMUX_CONF) -> $(LOCAL_CONF)"
	@ln -sf $(LOCAL_CONF) $(TMUX_CONF)

	@# 3. 載入設定檔以應用正在運行的 tmux 會話中的更改。
	@echo "正在應用設定..."
	@tmux source-file $(TMUX_CONF) > /dev/null 2>&1 || echo "ⓘ 注意：tmux 伺服器未運行。請啟動 tmux 以使更改生效。"

	@echo "==> ✅ Tmux 設定完成！"


# ==============================================================================
# => Focus Tool
# ==============================================================================

# --- 變數 ---
FOCUS_SCRIPT_NAME := focus
FOCUS_INSTALL_PATH := /usr/local/bin/$(FOCUS_SCRIPT_NAME)
FOCUS_LOCAL_SCRIPT := $(FOCUS_SCRIPT_NAME)

# --- 目標 ---
install-focus:
	@echo "==> 🚀 正在安裝/更新 'focus' 腳本到 $(FOCUS_INSTALL_PATH)..."
	@sudo cp $(FOCUS_LOCAL_SCRIPT) $(FOCUS_INSTALL_PATH)
	@sudo chmod +x $(FOCUS_INSTALL_PATH)
	@echo "==> ✅ 'focus' 腳本安裝/更新完成！"

uninstall-focus:
	@echo "==> 🗑️ 正在從 $(FOCUS_INSTALL_PATH) 移除 'focus' 腳本..."
	@sudo rm -f $(FOCUS_INSTALL_PATH)
	@echo "==> ✅ 'focus' 腳本已移除。"
