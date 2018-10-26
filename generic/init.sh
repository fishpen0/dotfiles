#!/usr/bin/env bash

echo "Running Generic Tasks"
echo "Copying Generic Dotfiles"
cd ./dotfiles/
cp -vR . ~/

echo "Installing crontab"
crontab ~/.cron