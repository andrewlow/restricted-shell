# restricted-shell

This is a simple Docker container built on top of the Alpine base. It includes openssh to provide sshd and rsync. The motivation was to replace a [makejail(http://lowtek.ca/roo/2012/makejail-limited-ssh-account-on-ubuntu/) environment built on a classic Linux host with a container solution.

Before you use this, copy an ssh public key you want to use to the `./pub.key` file. You also need to modify the Dockerfile `ARG username=` to be the user that matches the public key.

The Makefile is used to control builds. The 1st time you run make, it will build the `./etc` directory with the results of a set of ssh-keygen commands. The `./etc` directory tree is used to configure the containers sshd. You should treat these files like secrets. By using this approach, the ssh host keys are static from build to build.

There are also make targets `start` and `stop` that help launch/teardown the container for testing.

To be useful for rsync stuff, you probably want to mount a filesystem when you run this - but that is left as an exercise for the user.
