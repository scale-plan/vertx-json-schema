.PHONY: test release

test:
	mvn verify

release:
	mvn -DskipDocs deploy