ORIGIN=/path/to/production/files/
TARGET=/path/to/stage/files/
REMOTE="XXX@XX.XXX.XXX.XXX.XXX"	

default:
	@echo "you must specify an action: fakepush or push"; \
	exit 0; \

push:
	@echo "***************************************************\nAre you sure you want to push to PRODUCTION? yes/no\n***************************************************"; \
	read answer; \

	if [ "$$answer" != "yes" ]; then \
		exit 0; \
	else \
		echo "Pushing files to PRODUCTION..."; \
		rsync --exclude-from=rsync.exclude -rul -e ssh --delete $REMOTE:$ORIGIN $TARGET
 	fi \

fakepush:
	rsync --dry-run --exclude-from=rsync.exclude -rulvv -e ssh --delete ./ $(PROD)

