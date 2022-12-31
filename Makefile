sync-push: ## send data to compute server
	rsync -auvz --exclude-from rsyncignore.txt . "${TARGET_DIR}"

sync-pull: ## send data from compute server
	rsync -auvz --exclude-from rsyncignore.txt "${TARGET_DIR}" .

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'