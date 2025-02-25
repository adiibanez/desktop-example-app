cat $HOME/.bashrc
ls -lah /usr/local/bin/asdf
cat .tool-versions
asdf plugin list
asdf current

echo 'Running Script';
# Compile and lint
asdf install
mix local.hex --force;
mix local.rebar --force;
mix deps.get
mix deps.compile
cd assets
npm install
# Build Release
export LD_LIBRARY_PATH=/root/projects/wxWidgets/lib/;
MIX_ENV=prod mix compile;
# Build installer
cd ..
mix deps.update desktop
mix deps.update desktop_deployment
mix assets.deploy
mix desktop.installer