all:
	cp -r ~/dotfiles/template/ ./project
	ln -sf ~/database/ ./project/database/
	chmod +x ./project/*.sh
