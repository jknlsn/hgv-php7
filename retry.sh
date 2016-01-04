#!/bin/bash

echo "Trying again."
time sudo ansible-playbook -i hosts playbook.yml -c local