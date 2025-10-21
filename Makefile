install:
	@echo ">>> Installing dependencies"
	pip install --upgrade pip
	pip install -r requirements.txt

format:
	@echo ">>> Formatting files using isort and Black"
	isort .
	black .

lint:
	@echo ">>> Linting Python files"
	ruff check .

test:
	@echo ">>> Running unit tests"
	python -m pytest -vv
