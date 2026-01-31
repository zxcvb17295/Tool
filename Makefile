# 將 'tmux' 宣告為偽目標，因為它是一個動作，而非一個檔案。
.PHONY: tmux

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
