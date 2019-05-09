#!/usr/bin/env bash
/etc/init.d/nginx start

electrum setconfig requests_dir /var/www/html

if [ ! $MERCHANT_HOST ]
then
	echo "You must set a Merchant Host!"
	exit
fi

electrum setconfig url_rewrite "[ 'file:///var/www/html', 'http://$MERCHANT_HOST/' ]"

if [ $RPC_ENABLED ] && [ $RPC_ENABLED == 1 ]
then
	echo "init RPC ..."
	if [ $RPC_HOST ]; then electrum setconfig rpchost $RPC_HOST; fi
	if [ $RPC_PORT ]; then electrum setconfig rpcport $RPC_PORT; fi
	if [ $RPC_USER ]; then electrum setconfig rpcuser $RPC_USER; fi
	if [ $RPC_PASS ]; then electrum setconfig rpcpassword $RPC_PASS; fi

	echo "RPC-User:"
	electrum getconfig rpcuser
	echo "RPC-Password:"
	electrum getconfig rpcpassword
fi

if [ $WEB_SOCKET_ENABLED ] && [ $WEB_SOCKET_ENABLED == 1 ]
then
	echo "init websocket ..."
	if [ $MERCHANT_HOST ]; then electrum setconfig websocket_server $MERCHANT_HOST; fi
	if [ $WEB_SOCKET_PORT ]; then electrum setconfig websocket_port $WEB_SOCKET_PORT; fi
fi

python3.6 -m electrum-merchant

electrum create
electrum daemon stop
electrum daemon start
electrum daemon load_wallet
electrum daemon status
tail -f /dev/null
