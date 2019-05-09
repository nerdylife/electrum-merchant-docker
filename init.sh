#!/usr/bin/env bash
/etc/init.d/nginx start

electrum create
electrum daemon start
electrum daemon load_wallet

electrum setconfig requests_dir /var/www/html
electrum setconfig url_rewrite "[ 'file:///var/www/html', 'http://$MERCHANT_HOST/' ]"

if [ $RPC_ENABLED ]
then
	echo "init RPC ..."
	electrum setconfig rpchost $RPC_HOST
	electrum setconfig rpcport $RPC_PORT
	echo "RPC-User:"
	electrum getconfig rpcuser
	echo "RPC-Password:"
	electrum getconfig rpcpassword
fi

if [ $WEB_SOCKET_ENABLED ]
then
	echo "init websocket ..."
	electrum setconfig websocket_server $MERCHANT_HOST
	electrum setconfig websocket_port 9999
fi

electrum daemon status

python3.6 -m electrum-merchant
tail -f /dev/null
