window.addEventListener('load', async () => {
    if(window.ethereum) {
        window.web3 = new Web3(ethereum)
        try {
            // request account access
            $('#overlay').show()
            $('#overlay .web3-not-unlocked').show()
            await ethereum.enable()
            // account now exposed
            $('#overlay').hide()

            // listen for account modifications
            let account = web3.eth.accounts[0]
            setInterval(() => {
                if(web3.eth.accounts[0] !== account) {
                    account = web3.eth.accounts[0]
                    //update interface
                    location.reload()
                }
            }, 1000)
        }
        catch (e) {
            console.log('user denied account access')
        }
    }

    else if(window.web3) {
        window.web3 = new Web3(web3.currentProvider)
        // account always exposed
    }
    // non d-app browser
    else {
        $('#overlay').show()
        $('#overlay .no-web3-browser').show()
        console.log('Non-Ethereum browser. You should consider trying Metamask!')
    }
})