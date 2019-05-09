electrum create
electrum daemon start
electrum daemon load_wallet

electrum setconfig requests_dir /var/www/html

# Commands
electrum restore [public key]
electrum addrequest 0.3 -m "test3"
electrum getrequest [bitcoin address]
