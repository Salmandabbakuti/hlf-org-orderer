echo 'Starting Network Setup..'

sudo docker-compose -f docker-compose-raft.yaml down
sudo docker volume prune
sudo docker network prune

sudo docker-compose -f docker-compose-raft.yaml up -d

echo 'Network Booting up.. Should take only 10 seconds..'
sleep 10
echo 'Channel creation and peers joining takes place now..'
sudo docker exec -it cli peer channel create -o orderer0.org1.example.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/orderer0.org1.example.com/msp/tlscacerts/tlsca.org1.example.com-cert.pem
sleep 2
echo 'org1 peers joining channel'
sudo docker exec -it cli peer channel join -b mychannel.block
sudo docker exec -e CORE_PEER_ADDRESS=peer1.org1.example.com:7051 -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer1.org1.example.com/tls/ca.crt cli peer channel join -b mychannel.block
sudo docker exec -it cli peer channel join -b mychannel.block
echo 'exporting mychannel.block to cli2 container and Org2 peers will be joining..'
sudo docker cp cli:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block .
sudo docker cp mychannel.block cli2:/opt/gopath/src/github.com/hyperledger/fabric/peer/mychannel.block
sudo docker exec -it cli peer channel join -b mychannel.block
docker exec -e CORE_PEER_ADDRESS=peer1.org2.example.com:7051 -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer1.org2.example.com/tls/ca.crt cli peer channel join -b mychannel.block
sudo docker exec -it cli peer channel join -b mychannel.block
sudo rm -rf mychannel.block
echo 'All Peers joined Channel and Ready to test.'

exit 1
