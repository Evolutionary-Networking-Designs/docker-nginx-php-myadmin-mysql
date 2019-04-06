build-421:
	docker build  --build-arg OPENEMR_VERSION=rel-421 -t meredithk/openemr:rel-421 -f Dockerfile.php5 .
run-421:
	docker run --rm -it meredithk/openemr:4.2.1 /bin/sh
build-422:
	docker build  --build-arg OPENEMR_VERSION=rel-422 -t meredithk/openemr:rel-422 -f Dockerfile.php5 .
run-422:
	docker run --rm -it meredithk/openemr:4.2.2 /bin/sh
build-500:
	docker build  --build-arg OPENEMR_VERSION=rel-500 -t meredithk/openemr:rel-500 -f Dockerfile.php7 .
run-500:
	docker run --rm -it meredithk/openemr:5.0.0 /bin/sh
build-501:
	docker build  --build-arg OPENEMR_VERSION=rel-501 -t meredithk/openemr:rel-501 -f Dockerfile.php7 .
run-501:
	docker run --rm -it meredithk/openemr:5.0.1 /bin/sh
build-all:
	@make build-421
	@make build-422
	@make build-500
	@make build-501
