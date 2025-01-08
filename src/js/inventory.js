Inventory = {
    init: async () => {
        console.log('Inventory init')
        const accounts = await ethereum.request({method: 'eth_accounts'});
        console.log(accounts);
        Inventory.appendTokens(accounts[0])
    },

    appendTokens: (account) => {
        // get account and load tokens
        App.contracts.NumbersNFT.deployed().then((instance) => {
            // get balance of user
            return instance.balanceOf(account)
        }).then((o) => {
            return o.toNumber()
        }).then((balance) => {
            // get i'th NFT of the user
            let i = 0
            let getOwnedNFT = (i) => {
                console.log(`calling getOwnedNFT() with i = ${i}`)
                App.contracts.NumbersNFT.deployed().then((instance) => {
                    // get all NFT of user
                    return instance.tokenOfOwnerByIndex(account, i)
                }).then((o) => {
                    const number = o.toNumber()
                    console.log(`found number ${number}`)
                    // add thousands seperators
                    let formattedNumber = number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
                    // append number to dom
                    const accNumberRow = $('#accNumberRow')
                    const accNumberTemplate = $('#accNumberTemplate')
                    accNumberTemplate.find('.panel-body .number').text(formattedNumber)
                    accNumberTemplate.find('.panel-number .number').attr('data-token-id', number)
                    accNumberTemplate.find('.panel-number button').attr('data-token-id', number)
                    accNumberRow.append(accNumberTemplate.html())
                    i++
                    if (i < balance) {
                        getOwnedNFT(i)
                    }
                }).then((o) => {
                    // fit textsize of large numbers
                    fitty('#accNumberRow .number', {
                        minSize: 20,
                        maxSize: 60
                    })
                }).catch((e) => {
                    console.error(e.message)
                })
            }
            getOwnedNFT(i)
        })

        return Inventory.bindEvents()
    },
   bindEvents: () => {
    // add number to sell to model
    $(document).on('click', '#accNumberRow .init-sell', function(e) {
        const formattedNumber = $(this).parent().parent().find('.number').text()
        const number = $(this).attr('data-token-id')
        console.log(number)
        // add number to model
        $('#createAuctionModal .number').text(formattedNumber)
        $('#createAuctionModal .panel-body .number').attr('data-token-id', number)
        $('#submitAuction').attr('data-token-id', number)
        // reset step progress on modal
        $('#progress ol li > .step-completed').hide()
        $('#progress ol li').removeClass('step-completed')
        $('#submitAuction').text('Allow transfer of NFT')
        // https://getbootstrap.com/docs/4.1/components/modal/
        // when modal is ready
        $('#createAuctionModal').on('shown.bs.modal', (e) => {
            // fit textsize of large numbers in modal
            fitty('#createAuctionModal .number', {
                minSize: 20,
                maxSize: 60
            })
        })
    })
   },
}

$(() => {
    $(window).load(() => {
        Inventory.init()
    })
})