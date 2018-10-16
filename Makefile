build:
	docker build -t quay.io/osevg/installcentos-validate .

release: build
	docker push quay.io/osevg/installcentos-validate