ViewAuctionM = {
    init: () => {
        console.log('ViewAuctionM init')
        return ViewAuctionM.bindEvents()
    },

    bindEvents: () => {
        $('#viewAuctionModal').on('click', '#buyButton', ViewAuctionM.getCurrentPrice)
    },

    getCurrentPrice: () => {
        web3.eth.getAccounts((e, accounts) => {
            if(e) {
                throw e
            }

            const account = accounts[0]
            const auctionId = parseInt($('#viewAuctionModal .panel-body').data('auction-id'))
            const tokenToBuy = parseInt($('#viewAuctionModal .number-template .number').data('token-id'))

            AudioParamMap.contracts.NFTAuction.deployed().then((instance) => {
                return instance.getCurrentPriceByAuctionId(auctionId, {from: account})
            }).then((currentPrice) => {
                console.log(`current price: ${currentPrice}`)
                return ViewAuctionM.bid(currentPrice, {from: account})
            }).catch((e) => {
                console.error(e.message)
            })
        })
    },

    bid: (price) => {
        // get values
        const tokenToBuy = $('#viewAuctionModal .number-template .number').attr('data-token-id')

        web3.eth.getAccounts((e,accounts) => {
            if(e){
                throw e.message
            }
            const account = accounts[0]

            AudioParamMap.contracts.NFTAuction.deployed().then((instance) => {
                console.log(`calling instance.bid() with price: ${price}`)
                // TODO: calculate fixed gas amount
                return instance.bid(tokenToBuy, {value: price, from: account, gas: 250000})
            }).then((result) => {
                return $('#viewAuctionModal').modal('hide')
            }).catch((e) => {
                console.error(e.message)
            })
        })
    },
}

$(() => {
    $(window).load(() => {
        ViewAuctionM.init()
    })
})