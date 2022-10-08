# Changelog

All notable changes to this project will be documented in this file.

The format is mainly based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## 1.2.0

* Added: Set ansible module library path to `/ansible/library` by using the environment variable `ANSIBLE_LIBRARY`

## 1.1.0

* Added: Add the ssh keys on the container start with `ssh-add`
* Fixed: Ensure the .bash_history file exists for mounting

## 1.0.0

* Added: Initial release
