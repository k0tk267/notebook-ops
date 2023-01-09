run: ## run notebook for train
	poetry run python -B scripts/run.py \
		--input_file "${input_file}" \
		--output_file "${output_file}" \
		--batch_size "${batch_size}" \
		--epoch "${epoch}"

setup:
	sh scripts/setup.sh \
		"${project_name}" \
		"${your_name}" \
		"${your_email}" \
		"${package_name}" \

format: ## format python scripts
	poetry run black ./src/lib && \
	poetry run black ./scripts && \
	poetry run isort ./src/lib && \
	poetry run isort ./scripts

sync-push: ## send data to compute server
	rsync -auvz --exclude-from .rsyncignore . "${TARGET_DIR}"

sync-pull: ## send data from compute server
	rsync -auvz --exclude-from .rsyncignore "${TARGET_DIR}" .

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'