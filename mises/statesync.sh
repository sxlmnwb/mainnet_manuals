sudo systemctl stop misestmd

cp $HOME/.misestm/data/priv_validator_state.json $HOME/.misestm/priv_validator_state.json.backup

SNAP_RPC="https://e1.mises.site:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.misestm/config/config.toml

mv $HOME/.misestm/priv_validator_state.json.backup $HOME/.misestm/data/priv_validator_state.json

sudo systemctl restart misestmd
echo -e "\e[1m\e[32mINFO\e[0m \e[1m\e[31mLOADING FOR CONNECT STATE SYNC ...\e[0m"
sleep 10
sudo journalctl -u misestmd -f --no-hostname -o cat

