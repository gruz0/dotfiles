install:
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | /usr/bin/ruby

provision:
	ansible-playbook playbook.yml -i local -vv
