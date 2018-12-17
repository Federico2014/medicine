import path from 'path';
var medicineImagePath = path.join(__dirname, '../../public/images/medicines/')

module.exports = {
    uploadPath: medicineImagePath,
    host: "https://ropsten.infura.io/v3/2ea352f51b5a45819be9923cdfb58894",
    authorised: {
        address:'0x2a729274908041c8009699e8b37c8dff5bb0a012',
        abi: [{"constant":true,"inputs":[],"name":"getBalances","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"owners","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"}],"name":"rejectTransaction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_from","type":"address"}],"name":"getTransactionsConfirmedBy","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_identifier","type":"uint256"},{"name":"_from","type":"address"},{"name":"_value","type":"uint256"},{"name":"_type","type":"uint8"},{"name":"_author","type":"address"}],"name":"submitTransaction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"getAllProviderAdressOfTransactionsIDs","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"getIdsTransactionUnlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"getIdsTransactionBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTransactionsWaittingConfirm","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getTotalAuthoried","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorised","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_identifier","type":"uint256[]"}],"name":"getManyTransactionInformation","outputs":[{"components":[{"name":"identifier","type":"uint256"},{"name":"From","type":"address"},{"name":"value","type":"uint256"},{"name":"numberOfComfirmed","type":"uint8"},{"name":"numberReject","type":"uint8"},{"name":"Type","type":"uint8"},{"name":"time","type":"uint256"},{"name":"status","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_identifier","type":"uint256"}],"name":"confirmedTransaction","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"getTransactionStatus","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"isUnlocked","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_identifier","type":"uint256"}],"name":"isExecuted","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"blockAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_require","type":"uint8"},{"name":"_maxOwners","type":"uint8"}],"name":"setRequireAndMaxOwners","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_owner","type":"address"}],"name":"authorisedAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_owners","type":"address[]"}],"name":"authorisedManyAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_owners","type":"address[]"}],"name":"blockManyAccount","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_identifier","type":"uint256"}],"name":"getTransactionInformation","outputs":[{"components":[{"name":"identifier","type":"uint256"},{"name":"From","type":"address"},{"name":"value","type":"uint256"},{"name":"numberOfComfirmed","type":"uint8"},{"name":"numberReject","type":"uint8"},{"name":"Type","type":"uint8"},{"name":"time","type":"uint256"},{"name":"status","type":"bool"}],"name":"_trans","type":"tuple"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"listAuthorRejectTransactions","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"getTransactionsById","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_from","type":"address"}],"name":"getTransactionsRejectBy","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getListRefund","outputs":[{"name":"","type":"uint256[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"isBlocked","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"transactionCount","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_time","type":"uint256"}],"name":"changeTimeWaitting","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_identifier","type":"uint256"}],"name":"refundEth","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"},{"name":"_medecine","type":"address"},{"name":"_certificate","type":"address"},{"name":"_report","type":"address"},{"name":"_signature","type":"address"}],"name":"setProviderAndMedicineAndCertificateContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"listAuthorConfirmTransactions","outputs":[{"name":"","type":"address[]"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[{"name":"_owners","type":"address[]"},{"name":"_maxAuthoriseNumber","type":"uint8"},{"name":"_totalRequired","type":"uint8"}],"payable":true,"stateMutability":"payable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]
    },

    digital: {
        address:'0x2886f58d779372cd479266b70d22969dd3c8fa49',
        abi: [{"constant":false,"inputs":[{"name":"_author","type":"address"}],"name":"setAuthorContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"}],"name":"approveBlockAllDigitalCertificateOfProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getDigitalCertificateByProviderAddress","outputs":[{"components":[{"name":"idCertificate","type":"uint256"},{"name":"contents","type":"string"},{"name":"dateOf","type":"uint256"},{"name":"by","type":"string"},{"name":"addr","type":"address"},{"name":"medicineId","type":"uint256"},{"name":"isActive","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"getDigitalCertifiCateByMedicineId","outputs":[{"components":[{"name":"idCertificate","type":"uint256"},{"name":"contents","type":"string"},{"name":"dateOf","type":"uint256"},{"name":"by","type":"string"},{"name":"addr","type":"address"},{"name":"medicineId","type":"uint256"},{"name":"isActive","type":"bool"}],"name":"","type":"tuple"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"approveBlockDigitalCertificate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_id","type":"uint256"}],"name":"addDigitalCertificate","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"approveUnlockDigitalCertificate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"}],"name":"approveUnlockAllDigitalCertificatesOfProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]
    },

    medicine: {
        address: '0xc0fdd6ddad68b27460d97701e7271dc8e58ffa72',
        abi: [{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"approveUpdateMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approveUnlockAllMedicines","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_name","type":"string"},{"name":"_ingredient","type":"string"},{"name":"_benefit","type":"string"},{"name":"_by","type":"string"},{"name":"_detail","type":"string"},{"name":"_prices","type":"uint256"},{"name":"_imgHash","type":"bytes"},{"name":"_messageHash","type":"bytes32"},{"name":"_signHash","type":"bytes"}],"name":"addMedicine","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"}],"name":"approveUnlockMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"approveRejectUpdateMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"},{"name":"_id","type":"uint256"}],"name":"getHistoryUpdateMedicine","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"ingredient","type":"string"},{"name":"benefit","type":"string"},{"name":"by","type":"string"},{"name":"detail","type":"string"},{"name":"prices","type":"uint256"},{"name":"imgHash","type":"bytes"},{"name":"digitalId","type":"uint256"},{"name":"isAllowed","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_exchangeRate","type":"uint256"}],"name":"setexchangeRate","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"searchMedicineByID","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"ingredient","type":"string"},{"name":"benefit","type":"string"},{"name":"by","type":"string"},{"name":"detail","type":"string"},{"name":"prices","type":"uint256"},{"name":"imgHash","type":"bytes"},{"name":"digitalId","type":"uint256"},{"name":"isAllowed","type":"bool"}],"name":"","type":"tuple"},{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"}],"name":"approveBlockMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_author","type":"address"},{"name":"_provider","type":"address"},{"name":"_signature","type":"address"}],"name":"setAuthorAndProviderContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"}],"name":"approveBlockAllMedicineOfProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_hash","type":"bytes32"},{"name":"r","type":"bytes32"},{"name":"s","type":"bytes32"},{"name":"v","type":"uint8"}],"name":"verifyMedicine","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"pure","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"}],"name":"unlockMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"}],"name":"blockMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_id","type":"uint256"}],"name":"setDataWhenRefundEth","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_name","type":"string"},{"name":"_ingredient","type":"string"},{"name":"_benefit","type":"string"},{"name":"_by","type":"string"},{"name":"_detail","type":"string"},{"name":"_prices","type":"uint256"},{"name":"_imgHash","type":"bytes"},{"name":"_messageHash","type":"bytes32"},{"name":"_signHash","type":"bytes"}],"name":"updateMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"},{"name":"_digitalID","type":"uint256"}],"name":"approveAddMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getMedicinesUpdadingByProvider","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"ingredient","type":"string"},{"name":"benefit","type":"string"},{"name":"by","type":"string"},{"name":"detail","type":"string"},{"name":"prices","type":"uint256"},{"name":"imgHash","type":"bytes"},{"name":"digitalId","type":"uint256"},{"name":"isAllowed","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getMedicinesByProvider","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"ingredient","type":"string"},{"name":"benefit","type":"string"},{"name":"by","type":"string"},{"name":"detail","type":"string"},{"name":"prices","type":"uint256"},{"name":"imgHash","type":"bytes"},{"name":"digitalId","type":"uint256"},{"name":"isAllowed","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]
    },

    provider: {
        address: '0x800f6cb5efdac0edf8da6cd26d585ee5a3b63944',
        abi: [{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"}],"name":"blockProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approveUpdateProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isSignUpAndActiveCallByMedicine","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_name","type":"string"},{"name":"_street","type":"string"},{"name":"_phone","type":"string"},{"name":"_imgHash","type":"bytes"},{"name":"_messageHash","type":"bytes32"},{"name":"_signHash","type":"bytes"}],"name":"updateProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"},{"name":"","type":"uint256"}],"name":"providerUpdating","outputs":[{"name":"addr","type":"address"},{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"imgHash","type":"bytes"},{"name":"isActive","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approverBlockProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"searchProviderById","outputs":[{"components":[{"name":"addr","type":"address"},{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"imgHash","type":"bytes"},{"name":"isActive","type":"bool"}],"name":"","type":"tuple"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getUpdateProviderHistory","outputs":[{"components":[{"name":"addr","type":"address"},{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"imgHash","type":"bytes"},{"name":"isActive","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"setDataWhenRefundEth","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"}],"name":"unlockProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_author","type":"address"},{"name":"_medicine","type":"address"},{"name":"_signature","type":"address"}],"name":"setAuthorAndMedicneContractAddrees","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approveUnlockProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"approveSignUpProvider","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_name","type":"string"},{"name":"_street","type":"string"},{"name":"_phone","type":"string"},{"name":"_imgHash","type":"bytes"},{"name":"_messageHash","type":"bytes32"},{"name":"_signHash","type":"bytes"}],"name":"signUpProvider","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"getProviderInfor","outputs":[{"components":[{"name":"addr","type":"address"},{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"imgHash","type":"bytes"},{"name":"isActive","type":"bool"}],"name":"","type":"tuple"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"provider","outputs":[{"name":"addr","type":"address"},{"name":"id","type":"uint256"},{"name":"name","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"imgHash","type":"bytes"},{"name":"isActive","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]

    },

    report:{
        address:'0x55f82c147579c5e80e33c1fdbc7f37bba7c60a1b',
        abi:[{"constant":true,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"}],"name":"accIsReported","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_author","type":"address"}],"name":"setAuthorContract","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"viewReportDetail","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"_from","type":"address"},{"name":"_reportAddress","type":"address"},{"name":"email","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"content","type":"string"},{"name":"reply","type":"string"},{"name":"time","type":"uint256"},{"name":"status","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"}],"name":"viewReportInformation","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"_from","type":"address"},{"name":"_reportAddress","type":"address"},{"name":"email","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"content","type":"string"},{"name":"reply","type":"string"},{"name":"time","type":"uint256"},{"name":"status","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_from","type":"address"},{"name":"_reply","type":"string"}],"name":"approveReport","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"},{"name":"_email","type":"string"},{"name":"_street","type":"string"},{"name":"_phone","type":"string"},{"name":"_content","type":"string"}],"name":"reportMedicine","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_id","type":"uint256"},{"name":"_addr","type":"address"}],"name":"viewReportNotExcute","outputs":[{"components":[{"name":"id","type":"uint256"},{"name":"_from","type":"address"},{"name":"_reportAddress","type":"address"},{"name":"email","type":"string"},{"name":"street","type":"string"},{"name":"phone","type":"string"},{"name":"content","type":"string"},{"name":"reply","type":"string"},{"name":"time","type":"uint256"},{"name":"status","type":"bool"}],"name":"","type":"tuple[]"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]

    },

    signature:{
        address:'0x4f0b090fb6b087dc84c52fd016feab8d61153701',
        abi: [{"constant":true,"inputs":[{"name":"_imgHash","type":"bytes"},{"name":"_id","type":"uint256"}],"name":"imgNotExist","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_imgHash","type":"bytes"},{"name":"_id","type":"uint256"}],"name":"approveSetimageSignature","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_id","type":"uint256"}],"name":"imgRejected","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"newOwner","type":"address"}],"name":"transferOwnerShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"_imgHash","type":"bytes"}],"name":"getimgSignatureInfor","outputs":[{"components":[{"name":"messageHash","type":"bytes32"},{"name":"signHash","type":"bytes"},{"name":"isActive","type":"bool"},{"name":"id","type":"uint256"}],"name":"","type":"tuple"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_medicine","type":"address"},{"name":"_provider","type":"address"},{"name":"_author","type":"address"}],"name":"setMedicineAndProviderContractAddress","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"},{"name":"_imgHash","type":"bytes"},{"name":"_messageHash","type":"bytes32"},{"name":"_signHash","type":"bytes"},{"name":"_id","type":"uint256"}],"name":"setimageSignature","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"},{"name":"_imgHash","type":"bytes"}],"name":"isImgYourSelfSign","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"payable":true,"stateMutability":"payable","type":"fallback"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"}],"name":"TransferOwnerShip","type":"event"}]

    },

    isAddress: address => {
        return  (
                    address && 
                    typeof address == 'string' && 
                    address.length == 42 && 
                    address.indexOf('0x') == 0
                ) 
                    ? true
                    : false
    }
}