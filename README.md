# Ethereum JSON RPC API Wrapper

### eth_sendTransaction

#### Usage: 
##### sh eth_sendTransaction.sh [-s|--server <arg>] [-f|--wallet_from <arg>] [-t|--wallet_to <arg>] [-v|--value <arg>] [-g|--gas <arg>] [-p|--gasprice <arg>] [-d|--data <arg>] [-h|--help]
##### -s, --server: optional argument (localhost:8545)
##### -f, --wallet_from: optional argument (0x0690786F0890F5DC6CF6f01772ECBdFc8E22f514)
##### -t, --wallet_to: optional argument (0x0690786F0890F5DC6CF6f01772ECBdFc8E22f514)
##### -v, --value: optional argument (0xde0b6b3a7640000)
##### -g, --gas: optional argument (0x76c0)
##### -p, --gasprice: optional argument (0x9184e72a000)
##### -d, --data: optional argument (0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675)
##### -h, --help: Prints help



### eth_getBalance

#### Usage: 
##### sh eth_getBalance.sh [-w|--wallet <arg>] [-t|--tag <arg>] [-s|--server <arg>] [-h|--help]
##### -w, --wallet: optional argument (0x0690786F0890F5DC6CF6f01772ECBdFc8E22f514)
##### -t, --tag: optional argument (latest)
##### -s, --server: optional argument (localhost:8545)
##### -h, --help: Prints help


##### wallet_value - address to check for balance.
##### tag_value - integer block number, or the string "latest", "earliest" or "pending", see the default block parameter

### Donate
#### 0x0690786F0890F5DC6CF6f01772ECBdFc8E22f514