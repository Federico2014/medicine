// function checkMetaMask(){
//     if (typeof web3 !== 'undefined') {
//         console.log('MetaMask is installed')
//         web3.eth.getAccounts(function (err, accounts) {
//             if (accounts.length == 0) {
//                 alert('MetaMask is locked');
//                 window.location.href = "/";
//             }
//         });
//     } else {
//         alert('MetaMask is not installed');
//         window.location.href = "https://metamask.io/";
//     }
// }

// setInterval(() => {
//     checkMetaMask();
// }, 1000);


web3js = new Web3(web3.currentProvider);
MedicineContract = new web3js.eth.Contract(medicine.abi, medicine.address);
ProviderContract = new web3js.eth.Contract(provider.abi, provider.address);
AuthorContract = new web3js.eth.Contract(authorised.abi, authorised.address);
ReportContract = new web3js.eth.Contract(report.abi, report.address);
SignatureContract = new web3js.eth.Contract(signature.abi, signature.address);

async function getAccount() {
    var account;
    await web3js.eth.getAccounts().then(accounts => account = accounts[0]);
    return account;
}

async function checkIsProvider() {
    var account = await getAccount();
    return await ProviderContract.methods.provider(account).call({
        from: account
    });
}

async function checkIsManager() {
    var account = await getAccount();
    return await AuthorContract.methods.isAuthorised(account).call({
        from: account
    });
}

async function signUpProvider(name, street, phone, imgByte , messageHash, signHash) {
    var account = await getAccount();
    return await ProviderContract.methods.signUpProvider(name, street, phone, imgByte, messageHash, signHash).send({
        from: account,
        value: 10
    }).on('transactionHash', function (hash) {
        console.log(hash)
        showStatusPending('Sign Up: Pendding transaction', hash);
    });
}

async function updateProvider(id, name, street, phone, imgByte, messageHash, signHash) {
    var account = await getAccount();
    return await ProviderContract.methods.updateProvider(id, name, street, phone, imgByte,  messageHash, signHash).send({
        from: account
    }).on('transactionHash', function (hash) {
        console.log(hash);
        showStatusPending('Update Provider: Pendding transaction ', hash);
    });
}

async function addMedicine(name, ingredient, benefit, by, detail, prices, imgBytes32, messageHash, signHash) {
    var account = await getAccount();
    return await MedicineContract.methods.addMedicine(name, ingredient, benefit, by, detail, prices, imgBytes32, messageHash, signHash).send({
        from: account,
        value: 10
    }).on('transactionHash', function (hash) {
        showStatusPending('Register Medicine: Pendding transaction', hash);
    });
}

async function updateMedicine(id, name, ingredient, benefit, by, detail, prices, imgBytes32, messageHash, signHash) {
    var account = await getAccount();
    return await MedicineContract.methods.updateMedicine(id, name, ingredient, benefit, by, detail, prices, imgBytes32, messageHash, signHash).send({
        from: account
    }).on('transactionHash', function (hash) {
        showStatusPending('Update Medicine: Pendding transaction', hash);
    });
}

async function imgNotExist(imgByte, account, id) {
    var result = false
    await SignatureContract.methods.imgNotExist(imgByte, id).call({
        from: account 
    }).then( async (res)=>{
        if(res==true){
            await SignatureContract.methods.isImgYourSelfSign(account, imgByte).call({
                from: account 
            }).then(res2=>{
                if(res2==false){
                    result = true
                }
                else{
                    result = false
                }
            });
        }
        else{
            result = false
        }
    });
    return result
}

async function checkImgNotExist(imgByte, id) {
    return await SignatureContract.methods.imgNotExist(imgByte, id).call({
        from: account 
    })
}

async function confirmedTransaction(idTransaction) {
    account = await getAccount();
    return await AuthorContract.methods.confirmedTransaction(idTransaction)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            showStatusPending('Pendding transaction', hash);
        })
}

async function rejectedTransaction(idTransaction) {
    account = await getAccount();
    return await AuthorContract.methods.rejectTransaction(idTransaction)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            showStatusPending('Pendding transaction', hash);
        })
}

async function refundETH(id) {
    account = await getAccount();
    return await AuthorContract.methods.refundEth(id)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            showStatusPending('Pendding transaction', hash);
        })
}

async function checkReportMedicine(id, address) {
    account = await getAccount();
    return await ReportContract.methods.accIsReported(id, address).call({from: account})
}

async function reportMedicine(id, address, email, street, phone, content) {
    account = await getAccount();
    return await ReportContract.methods.reportMedicine(id, address, email, street, phone, content)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            
            showStatusPending('Pendding transaction', hash);
        })
}

async function blockMedicine(id) {
    account = await getAccount();
    return await MedicineContract.methods.blockMedicine(id)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            showStatusPending('Pendding transaction', hash);
        })
}

async function unlockMedicine(id) {
    account = await getAccount();
    return await MedicineContract.methods.unlockMedicine(id)
        .send({
            from: account,
        }).on('transactionHash', function (hash) {
            showStatusPending('Pendding transaction', hash);
        })
}

async function checkIsAccount() {
    account = await getAccount();
    return web3js.utils.isAddress(account);
}

function transactionTypes(type) {
    type = parseInt(type);
    var convertType = "";
    switch (type) {
        case 0:
            convertType = "Register Provider"
            break;
        case 1:
            convertType = "Update Provider"
            break;
        case 2:
            convertType = "Block Provider"
            break;
        case 3:
            convertType = "Register Medicine"
            break;
        case 4:
            convertType = "Update Medicine"
            break;
        case 5:
            convertType = "Block Medicine"
            break;
        case 6:
            convertType = "Unlock Provider"
            break;
        case 7:
            convertType = "Unlock Medicine"
            break;
        case 8:
            convertType = "Report Medicine"
            break;
        default:
            convertType = "NAN"
            break;
    }
    return convertType;
}