#
#
all: etc key.pub
	docker build --tag restricted-shell .

# Run the container
#
start:
	docker run -d -p 8080:22 --name restricted restricted-shell 

# Stop and remove the container
#
stop:
	docker stop restricted
	docker rm restricted

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
	@echo "\nYou need to copy your public key into the pub.key file\n" \
	&& exit 1
