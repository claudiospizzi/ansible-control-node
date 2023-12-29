# Changelog

All notable changes to this project will be documented in this file.

The format is mainly based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 6.2.0.0

* Changed: Align the control node version with the Ansible version

## 1.4.1

* Fixed: Set `ANSIBLE_CONFIG` to `/ansible/ansible.cfg` to prevent world-readable errors

## 1.4.0

* Changed: Update Ansible to 6.2.0
* Changed: Update PowerShell to 7.3.0
* Fixed: Entrypoint script and bash prompt (remove username)

## 1.3.0

* Changed: Update prompt with colors and fixed hostname as `ansible-control-node`

## 1.2.0

* Added: Set ansible module library path to `/ansible/library` by using the environment variable `ANSIBLE_LIBRARY`

## 1.1.0

* Added: Add the ssh keys on the container start with `ssh-add`
* Fixed: Ensure the .bash_history file exists for mounting

## 1.0.0

* Added: Initial release
