#!/bin/bash
# cat $HOME/.bashrc
# ls -lah /usr/local/bin/asdf
#export ASDF_DIR=/root/.asdf
#. ${ASDF_DIR}/asdf.sh

ls -lah /root/.asdf

cat .tool-versions
asdf plugin list
asdf current

#asdf reshim elixir
#asdf reshim erlang
#asdf reshim nodejs

cat "*.log" || echo "No logs found"

# asdf install

# echo 'Running Script';
# # Compile and lint
# mix local.hex --force;
# mix local.rebar --force;
# mix deps.get
# mix deps.compile
# cd assets
# npm install
# # Build Release
# export LD_LIBRARY_PATH=/root/projects/wxWidgets/lib/;
# MIX_ENV=prod mix compile;
# # Build installer
# cd ..
# mix deps.update desktop
# mix deps.update desktop_deployment
# mix assets.deploy
# mix desktop.installer