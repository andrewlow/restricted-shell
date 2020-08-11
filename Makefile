#
#
include config.mk
#
all: etc key.pub
	docker build --build-arg username=$(USER) --tag restricted-shell .

# Run the container
#
start:
	docker run -d -p $(PORT):22 -v $(STORAGE):/home/$(USER)/external --name restricted-shell restricted-shell 

# Stop and remove the container
#
stop:
	docker stop restricted-shell
	docker rm restricted-shell

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

