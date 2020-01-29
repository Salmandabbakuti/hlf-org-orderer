echo 'Generating Certificates for Raft Setup Network..'

rm -rf channel-artifacts
mkdir channel-artifacts
export PATH=${PWD}/bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD
sleep 2
cryptogen generate --config=crypto-config.yaml
sleep 1
configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block -channelID byfn-sys-channel
sleep 2
configtxgen -profile Channel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID mychannel
configtxgen -profile Channel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
configtxgen -profile Channel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
echo 'all done..'
exit 1
