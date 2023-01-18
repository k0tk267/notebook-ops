build: ## make docker image
	docker build -t "${image_name}" .

# start: ## run notebook on Docker
# 	docker run -it --rm --gpus all \
# 		-v $(PWD):/app \
# 		-p 8000:8000 \
# 		"${image_name}" \
# 		/bin/bash -c "poetry run python scripts/run.py"

lab: ## start JupyterLab on Docker
	docker-compose up -d

run: ## run notebook for train
	poetry run python -B scripts/run.py \
		--input_file "${input_file}" \
		--output_file "${output_file}" \
		--batch_size "${batch_size}" \
		--epoch "${epoch}"

setup:  ## initial setup
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