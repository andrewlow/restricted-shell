# restricted-shell

This is a simple Docker container built on top of the Alpine base. It includes openssh to provide sshd and rsync. The motivation was to replace a [makejail](http://lowtek.ca/roo/2012/makejail-limited-ssh-account-on-ubuntu/) environment built on a classic Linux host with a container solution.

Before you use this, copy a ssh public key you want to use to the `./key.pub` file. You also need to create a config.mk file, base it on the config.mk.template file. This file will specify the user (that will match the key), port and file path to mount.

The Makefile is used to control builds. The 1st time you run make, it will build the `./etc` directory with the results of a set of ssh-keygen commands. The `./etc` directory tree is used to configure the containers sshd. You should treat these files like secrets. By using this approach, the ssh host keys are static from build to build.

There are also make targets `start` and `stop` that help launch/teardown the container for testing.

## Example usage

```
$ make
$ make start
$ ssh -p 8080 localhost
$ make stop
```

Above assumes you are logged into a machine as the user declared in the config.mk file and have the matching private key to the `./pub.key`

When the alpine:latest base image is updated, you can easily update your image with
```
$ make update
```

There is a companion 'sending' container for managing [encrypted backups](https://github.com/andrewlow/encrypted-backup)
