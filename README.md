# Ethereum NFT-Store with Dutch Auctions [POC]

![](https://imgur.com/N4mzAKX)

A POC of a NFT-Store where one can mint NFT's and then sell them by creating dutch auctions.
The app consists of three pages:

1. A main page where one can search for NFT's and mint them
2. An auctions page where all currently running auctions are listed
3. An inventory page where all numbers owned by the current user are listed

## Getting up and running

```bash
# install dependencies
$ npm install

# deploy contracts
# (make sure to first fire up ganache and to change the 'from' account in 'truffle.js')
$ truffle migrate --reset --network ganache

# start app
$ npm run dev
```

## Used packages

- [Truffle](https://truffleframework.com/truffle)
- [web3.js](https://github.com/ethereum/web3.js/)
- [Chart.js](https://github.com/chartjs/Chart.js)
- [Annotation plugin for Chart.js](https://github.com/chartjs/chartjs-plugin-annotation)
- [Fitty, Snugly text resizing](https://github.com/rikschennink/fitty)

## Used contracts

- [0xcert/ethereum-utils](https://github.com/0xcert/ethereum-utils)
- [0xcert/ethereum-erc721](https://github.com/0xcert/ethereum-erc721)

## Tools

- [MetaMask](https://metamask.io/)
- [Ganache](https://truffleframework.com/ganache)


## Screenshots
![](https://imgur.com/EP1F6ly)
![](https://imgur.com/BK73FMJ)
