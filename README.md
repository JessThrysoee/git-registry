# Git Registry

> ... to collaborate with a couple of people on a private project, all you need is an SSH server and a bare repository.

— [Getting Git on a Server](https://git-scm.com/book/en/v2/Git-on-the-Server-Getting-Git-on-a-Server)

`git-registry` is a SSH server in a Docker container, managing a collection of bare git repositories, relying on SSH public key authentication.

# Getting started

Download [docker-compose.yml](https://github.com/JessThrysoee/git-registry/blob/main/docker-compose.yml), or clone this repository.

Generate SSH host keys (only once, before the very first start up)

      $ docker-compose run --rm git-registry ssh-keygen -A -f /git-registry

Start up `git-registry`

    $ docker-compose up -d

Add a SSH public key

    $ docker-compose exec git-registry /add-public-key.sh "$(cat ~/.ssh/id_rsa.pub)"

Test the connection

    $ ssh git@localhost -p 2222

In a local git repository, e.g. ~/example, init and add a remote

    $ ssh git@localhost -p 2222 add-repo example.git
    $ git remote add git-registry [git@localhost:2222]:src/example.git
    $ git push git-registry

# Git Shell Commands

    $ ssh git@localhost -p 2222
    Commands:
      help
      exit

      ls                     List repositories
      add-repo               Add new repository
      del-repo               Delete repository

      default-branch-repo    Change default branch name of an existing repository
      default-branch-global  Set the default branch name e.g. when initializing a new repository

      set-git-registry-host  Change the hostname printed in help and usage
      set-git-registry-port  Change the port printed in help and usage

    Examples:
      git> ls

      git> add-repo example.git
      git> add-repo github/githubproject.git
      git> add-repo private/privateproject.git

      git> del-repo example.git

      git> default-branch-global trunk
      git> default-branch-repo private/privateproject.git trunk

      git> set-git-registry-host example.com
      git> set-git-registry-port

      $ git clone [git@localhost:2222]:src/example.git
      $ git remote add git-registry [git@localhost:2222]:src/example.git

      $ ssh git@localhost -p 2222 ls

    git>

# Backup

See example scripts in `src/backup` for inspiration of how backup of the repositories might be handled.
