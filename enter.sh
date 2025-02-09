#!/bin/bash

ssh-keygen -f '/root/.ssh/known_hosts' -R '[localhost]:10022' >/dev/null
ssh -i bookworm.id_rsa -p 10022 -o "StrictHostKeyChecking no" root@localhost
