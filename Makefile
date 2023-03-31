#
#
include config.mk
#
NAME=restricted-shell
#
all: etc key.pub
	docker build --build-arg username=$(USER) --tag $(NAME) .

# Run the container
#
start:
	docker run -d -p $(PORT):22 -v $(STORAGE):/home/$(USER)/external --name $(NAME) --restart unless-stopped $(NAME)

# Stop and remove the container
#
stop:
	docker stop $(NAME)
	docker rm $(NAME)

# Generate secrets if not found
#
etc:
	mkdir -p etc/ssh
	ssh-keygen -f etc/ssh/ssh_host_dsa_key -N '' -t dsa
	ssh-keygen -f etc/ssh/ssh_host_rsa_key -N '' -t rsa
	ssh-keygen -f etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
	ssh-keygen -f etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# Warn if key.pub file isn't present
#
key.pub:
	@echo "\nYou need to copy your public key into the key.pub file\n" \
	&& exit 1

# update to a new base image
#
update:
	docker pull alpine:latest
	- docker rm $(NAME)-old
	docker rename $(NAME) $(NAME)-old
	make all
	docker stop $(NAME)-old
	make start
