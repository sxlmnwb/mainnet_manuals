#
# // Copyright (C) 2022 Salman Wahib (sxlmnwb)
#

echo -e "\033[0;31m"  
echo "  ██████ ▒██   ██▒ ██▓     ███▄ ▄███▓ ███▄    █  █     █░▓█████▄ ";
echo "▒██    ▒ ▒▒ █ █ ▒░▓██▒    ▓██▒▀█▀ ██▒ ██ ▀█   █ ▓█░ █ ░█▒██▒ ▄██░";
echo "░ ▓██▄   ░░  █   ░▒██░    ▓██    ▓██░▓██  ▀█ ██▒▒█░ █ ░█ ▒██░█▀  ";
echo "  ▒   ██▒ ░ █ █ ▒ ▒██░    ▒██    ▒██ ▓██▒  ▐▌██▒░█░ █ ░█ ░▓█  ▀█▓";
echo "▒██████▒▒▒██▒ ▒██▒░██████▒▒██▒   ░██▒▒██░   ▓██░░░██▒██▓ ░▒▓███▀▒";
echo "▒ ▒▓▒ ▒ ░▒▒ ░ ░▓ ░░ ▒░▓  ░░ ▒░   ░  ░░ ▒░   ▒ ▒ ░ ▓░▒ ▒  ▒░▒   ░ ";
echo "░ ░▒  ░ ░░░   ░▒ ░░ ░ ▒  ░░  ░      ░░ ░░   ░ ▒░  ▒ ░ ░   ░    ░ ";
echo "░  ░  ░   ░    ░    ░ ░   ░      ░      ░   ░ ░   ░   ░ ░        ";
echo "      ░   ░    ░      ░  ░       ░            ░     ░          ░ ";
echo "     Auto Installer Quicksilver {cosmovisor} Mainnet v1.0.0      ";
echo -e "\e[0m"
sleep 1

# Query variable
QCK_WALLET=wallet
QCK=quicksilverd
BINARY=cosmovisor
QCK_ID=quicksilver-1
QCK_FOLDER=.quicksilverd
QCK_VER=v1.0.0
QCK_REPO=https://github.com/ingenuity-build/quicksilver
QCK_GENESIS=https://raw.githubusercontent.com/ingenuity-build/mainnet/main/genesis.json
#QCK_ADDRBOOK=
QCK_DENOM=uqck
QCK_PORT=11

# Query binary
DAEMON_NAME=quicksilverd
DAEMON_HOME=.quicksilverd
DAEMON_DATA_BACKUP_DIR=.quicksilverd/data_backup

# Add environment binary
echo "export DAEMON_NAME=${DAEMON_NAME}" >> $HOME/.bash_profile
echo "export DAEMON_HOME=${DAEMON_HOME}" >> $HOME/.bash_profile
echo "export DAEMON_DATA_BACKUP_DIR=${DAEMON_DATA_BACKUP_DIR}" >> $HOME/.bash_profile

# Add environment variable
echo "export QCK_WALLET=${QCK_WALLET}" >> $HOME/.bash_profile
echo "export QCK=${QCK}" >> $HOME/.bash_profile
echo "export BINARY=${BINARY}" >> $HOME/.bash_profile
echo "export QCK_ID=${QCK_ID}" >> $HOME/.bash_profile
echo "export QCK_FOLDER=${QCK_FOLDER}" >> $HOME/.bash_profile
echo "export QCK_VER=${QCK_VER}" >> $HOME/.bash_profile
echo "export QCK_REPO=${QCK_REPO}" >> $HOME/.bash_profile
echo "export QCK_GENESIS=${QCK_GENESIS}" >> $HOME/.bash_profile
#echo "export QCK_ADDRBOOK=${QCK_ADDRBOOK}" >> $HOME/.bash_profile
echo "export QCK_DENOM=${QCK_DENOM}" >> $HOME/.bash_profile
echo "export QCK_PORT=${QCK_PORT}" >> $HOME/.bash_profile
source $HOME/.bash_profile

# Set Vars
if [ ! $QCK_NODENAME ]; then
	read -p "sxlzptprjkt@w00t666w00t:~# [ENTER YOUR NODE] > " QCK_NODENAME
	echo 'export QCK_NODENAME='$QCK_NODENAME >> $HOME/.bash_profile
fi
echo ""
echo -e "YOUR NODE NAME : \e[1m\e[31m$QCK_NODENAME\e[0m"
echo -e "NODE CHAIN ID  : \e[1m\e[31m$QCK_ID\e[0m"
echo -e "NODE PORT      : \e[1m\e[31m$QCK_PORT\e[0m"
echo ""

# Update
sudo apt update && sudo apt upgrade -y

# Package
sudo apt install curl git jq lz4 build-essential -y

# Install GO
ver="1.19.4"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

# Get mainnet version of quicksilver
cd $HOME
rm -rf quicksilver
git clone $QCK_REPO
cd quicksilver
git fetch origin --tags
git checkout $QCK_VER
make install
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@latest
sudo mv $HOME/go/bin/$BINARY /usr/bin/

# Init generation
$QCK config chain-id $QCK_ID
$QCK config node tcp://localhost:${QCK_PORT}657
$QCK init $QCK_NODENAME --chain-id $QCK_ID

# Set peers and seeds
SEEDS="20e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:11156,babc3f3f7804933265ec9c40ad94f4da8e9e0017@seed.rhinostake.com:11156,00f51227c4d5d977ad7174f1c0cea89082016ba2@seed-quick-mainnet.moonshot.army:26650"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/$QCK_FOLDER/config/config.toml

# Create target directory
cd $HOME
mkdir $HOME/$QCK_FOLDER/data_backup
mkdir $HOME/$QCK_FOLDER/cosmovisor
cd $HOME/$QCK_FOLDER/cosmovisor
mkdir genesis
mkdir upgrades
cd genesis
mkdir bin
cd $HOME

# Set the genesis binary
sudo cp $HOME/go/bin/$QCK $HOME/$QCK_FOLDER/cosmovisor/genesis/bin/
chmod +x $HOME/$QCK_FOLDER/cosmovisor/genesis/bin/$QCK

# Moving to initial location
sudo mv $HOME/go/bin/$QCK /usr/bin/

# Download genesis and addrbook
curl -Ls $QCK_GENESIS > $HOME/$QCK_FOLDER/config/genesis.json

# Set Port
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${QCK_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${QCK_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${QCK_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${QCK_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${QCK_PORT}660\"%" $HOME/$QCK_FOLDER/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${QCK_PORT}317\"%; s%^address = \":8080\"%address = \":${QCK_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${QCK_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${QCK_PORT}091\"%" $HOME/$QCK_FOLDER/config/app.toml

# Set Config Pruning
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/$QCK_FOLDER/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/$QCK_FOLDER/config/app.toml

# Set minimum gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0001$QCK_DENOM\"/" $HOME/$QCK_FOLDER/config/app.toml

# Create Service cosmovisor
sudo tee /etc/systemd/system/$BINARY.service > /dev/null <<EOF
[Unit]
Description=$BINARY
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $BINARY) run
Restart=always
RestartSec=3
LimitNOFILE=4096
Environment="DAEMON_NAME=$QCK"
Environment="DAEMON_HOME=$HOME/$QCK_FOLDER"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
# Set buffer size to handle:
# https://github.com/cosmos/cosmos-sdk/pull/8590
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_POLL_INTERVAL=300ms"
Environment="DAEMON_DATA_BACKUP_DIR=${HOME}/$QCK_FOLDER"
# Set to true if disk space is limited:
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="DAEMON_PREUPGRADE_MAX_RETRIES=0"

[Install]
WantedBy=multi-user.target
EOF

# Create Service quicksilver
sudo tee /etc/systemd/system/$QCK.service > /dev/null <<EOF
[Unit]
Description=$QCK
After=network-online.target
[Service]
User=$USER
ExecStart=$(which $QCK) start --home $HOME/$QCK_FOLDER
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

# Register And Start Service
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl start $BINARY
sudo systemctl enable $QCK
sudo systemctl start $QCK

echo -e "\e[1m\e[31mSETUP FINISHED\e[0m"
echo ""
echo -e "CHECK STATUS BINARY : \e[1m\e[31msystemctl status $BINARY\e[0m"
echo -e "CHECK RUNNING LOGS  : \e[1m\e[31mjournalctl -fu $QCK -o cat\e[0m"
echo -e "CHECK LOCAL STATUS  : \e[1m\e[31mcurl -s localhost:${QCK_PORT}657/status | jq .result.sync_info\e[0m"
echo ""
