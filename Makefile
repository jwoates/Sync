ORIGIN=/home/allibubba/Projects/cbai/public_html/
TARGET=/var/www/cbai/public_html/
REMOTE="allibubba@10.1.10.249"	

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

