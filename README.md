# Automated Rsync with SSH

Requires the following packages:

- rsync
- openssh
- cron (or vixie-cron)

## Installation

- log into local(also referred to as source or SRC) machine (where push will come from)
- Unpack Synch to home folder, eg. /home/username/Synch

Make the follwoing files: error.log, access.log and task.log

    $ touch error.log access.log task.log config


## Config
change the defaults to your environment

    ORIGIN=/path/to/root/to/be/pushed/
    TARGET=/path/on/server/where/push/received/

    REMOTE=user@xxx.xxx.xxx.xxx
    SSHKEY=~/.ssh/my-rsync-key

## Make rsync keys

    $ ssh-keygen -t rsa -b 2048 -f /home/username/.ssh/username-rsync-key 
    Generating public/private rsa key pair. 
    Enter passphrase (empty for no passphrase): [press enter here] 
    Enter same passphrase again: [press enter here] 
    Your identification has been saved in /home/username/.ssh/username-rsync-key. 
    Your public key has been saved in /home/username/.ssh/username-rsync-key.pub. 
    The key fingerprint is: 
    2e:28:d9:ec:85:21:e7:ff:73:df:2e:07:78:f0:d0:a0 username@thishost 

NOTE: leave passphrase empty, just hit enter.

You now have two new files in ~/.ssh; username-rsync-key and username-rsync-key.pub

Now we need to get the pub file over to the remote server

    $ scp username-rsync-key.pub remoteuser@remotehost:/home/username/Synch/

## Remote Machine

ssh into your remote machine

    $ ssh remoteuser@remotehost

Now that you are on the remote machine, we need to add the key to to you authorized keys file.

    $ cd /home/username/Synch/
    $ cat username-rsync-key.pub >> ~/.ssh/authorized_keys

## Testing

On dev machine, cd to the Synch directory.

    $ cd /home/username/Synch

Run the following command to initiate a test push.

    $ bash synch.sh

If you are satisfied with the results, run the follwoing command to initate a production push.

    $ bash synch.sh prod

## Cron

Cron runs with a limited set of environmental variables, so you need to include a few when you create a new cron task. Open the cront task list for the current user.

    $ crontab -e

The task you will need to run is:

    $HOME/Tasks/Sync/sync.sh prod > $HOME/Tasks/Sync/task.log 2>&1

Need to add in the user's SSH_AUTH_SOCK variable:

    SSH_AUTH_SOCK="$(find /tmp/keyring*/ -perm 0755 -type s -user <USERNAME> -group <USERGROUP> -name '*ssh' | head -n 1)"

This will set the dynamic variable: SSH_AUTH_SOCK. Your task should look like the following:

    # m   h   dom  mon dow   command
      *   *    *    *   *    SSH_AUTH_SOCK="$(find /tmp/keyring*/ -perm 0755 -type s -user <USERNAME> -group <USERGROUP> -name '*ssh' | head -n 1)" $HOME/Tasks/Sync/sync.sh prod > $HOME/Tasks/Sync/task.log 2>&1

NOTE: replace USERNAME with your user name and USERGROUP with your user group.