## clean
clean:
	@rm -rf .venv make-libs

## init
init: venv-create  install-pip-tools 

## init direnv
init-direnv:
	@echo "layout pipenv" >.envrc ; \
	direnv allow .

## lint
lint:
	source .venv/bin/activate && pylint src --disable=R,C,W  --output-format=colorized

## tests
test: lint
	@source .venv/bin/activate && cd src; python3 -m pytest -s


## run app locally
run:
	@source .venv/bin/activate && cd src; uvicorn main:app --reload

## single test
test-single:
	@source .venv/bin/activate && cd src; python3 -m pytest -s -k $(shell ls src/tests/ | grep ".py" |sed 's/\.py//g' |grep -v __ |fzf)

# pip check freeze
freeze-check:
	@source .venv/bin/activate && pip3 freeze |grep -vFxf requirements.txt -vFxf requirements-dev.txt


## pip install
install:
	@source .venv/bin/activate && pip install -r requirements.txt

## install-all w/dev
install-all: install install-dev

install-dev:
	@source .venv/bin/activate && pip install -r requirements-dev.txt


## freeze
freeze:
	@source .venv/bin/activate && pip-compile requirements.in > requirements.txt
	@source .venv/bin/activate && pip-compile requirements-dev.in > requirements-dev.txt

## pip-sync
pip-sync:
	@source .venv/bin/activate && pip-sync requirements.txt

## pip-sync-dev
pip-sync-dev:
	@source .venv/bin/activate && pip-sync requirements.txt requirements-dev.txt

## install-pip-tools
install-pip-tools:
	@source .venv/bin/activate && pip install pip-tools

venv-create:
	@test -f .venv || python3 -m venv .venv

## venv
venv: init install

## venv
venv-all: init install-all
	
	