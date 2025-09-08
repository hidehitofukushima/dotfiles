all:
	cp -r ~/dotfiles/template/ ./project
	ln -sf ~/database/ ./project/
	chmod +x ./project/*.sh
