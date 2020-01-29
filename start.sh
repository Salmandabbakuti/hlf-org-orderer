echo 'Starting Network Setup..'

sudo docker-compose -f docker-compose-raft.yaml down
sudo docker volume prune
sudo docker network prune

sudo docker-compose -f docker-compose-raft.yaml up -d

echo 'Network Booting up.. Should take only 10 seconds..'
sleep 10
echo 'Im going out on vacation, bye..'

exit 1
