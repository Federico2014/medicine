import Helper from '../helpers/Helper'

import Web3 from 'web3'
var web3 = new Web3(Helper.host);
var Medicine = new web3.eth.Contract(Helper.medicine.abi, Helper.medicine.address); // init contract
var Provider = new web3.eth.Contract(Helper.provider.abi, Helper.provider.address); // init contract
var Authorised = new web3.eth.Contract(Helper.authorised.abi, Helper.authorised.address); // init contract
var Digital = new web3.eth.Contract(Helper.digital.abi, Helper.digital.address); // init contract
var Report = new web3.eth.Contract(Helper.report.abi, Helper.report.address); // init contract

module.exports = {
    // Lấy thông tin nhà cung cấp theo id
    providerByCode: async (req, res) => {
        let code = req.query.code;
        
        if (!code || code == '') return res.json({
            status: 400
        });

        let data = await Provider.methods.searchProviderById(code)
            .call()
            .then(data => data)
            .catch(err => [])

        if (!data || data.length == 0) return res.json({
            status: 400
        });

        data[5] = web3.utils.hexToString(data[5]);
        return res.json({
            status: 200,
            provider: data
        })
    },

    // Lấy thông tin nhà cung cấp theo địa chỉ
    providerByAddress: async (req, res) => {
        let address = req.query.address;
        if (!Helper.isAddress(address)) return res.json({
            status: 400
        });

        let data = await Provider.methods.getProviderInfor(address)
            .call({ from: address })
            .then(data => data)
            .catch(err => [])

        if (!data || data.length == 0) return res.json({
            status: 400
        });

        data[5] = web3.utils.hexToString(data[5]);
        return res.json({
            status: 200,
            provider: data
        })
    },

    // Tìm kiếm thông tin update provider bởi address
    providerUpdatingByAddress: async (req, res) => {
        let address = req.query.address;
        if (!Helper.isAddress(address)) return res.json({
            status: 400
        });
        let data = await Provider.methods.getUpdateProviderHistory(address)
            .call({ from: address })
            .then(data => data)
            .catch(err => [])

        if (!data || data.length == 0) return res.json({
            status: 400
        });
        data = data.find(x => x[6] == true)
        data[5] = web3.utils.hexToString(data[5])
        return res.json({
            status: 200,
            provider: data
        })
    },

    // Lấy thông tin thuốc theo id
    medicineByCode: async (req, res) => { 
        let code = req.query.code;
        if (!code || code == '') return res.json({
            status: 400
        });

        let medicine = await Medicine.methods.searchMedicineByID(code)
            .call()
            .then(data => data)
            .catch(err => console.log(err))

        if (!medicine) return res.json({
            status: 400
        });

        let provider = await Provider.methods.getProviderInfor(medicine[1])
            .call()
            .then(data => data)
            .catch(err => console.log(err))

        medicine[0][7] = web3.utils.hexToString(medicine[0][7]);

        if (provider && provider.length > 0) {
            provider[5] = web3.utils.hexToString(provider[5]);
        }

        return res.json({
            status: 200,
            medicine: medicine,
            provider: provider
        })
    },

    // Lấy tất cả thuốc đã có
    allMedicines: async (req, res) => {
        let provider = req.query.provider;

        if (!Helper.isAddress(provider)) return res.json({
            status: 400
        });

        let medicines = await Medicine.methods.getMedicinesByProvider(provider)
            .call()
            .then(medicine => medicine)
            .catch(err => [])

        let approved = [], //  ds thuốc đã được xác nhận
            watting = [], //  ds thuốc chưa được xác nhận
            license = []; // ds thuốc đã được cấp chứng chỉ điện tử

        if (!medicines || medicines.length == 0) return res.json({
            status: 200,
            approved: [],
            watting: [],
            license: [],
            medicines: []
        });

        medicines.forEach(e => {
            e[7] = web3.utils.hexToString(e[7]);
            if (e["isAllowed"]) {
                approved.push(e);
                if (e["digitalId"] != "0") license.push(e);
            } else {
                watting.push(e)
            }
            return e;
        })

        return res.json({
            status: 200,
            approved: approved,
            watting: watting,
            license: license,
            medicines: medicines,
        })
    },

    // Tìm kiếm thông tin update medicine bởi address
    getMedicinesUpdadingByProvider: async (req, res) => {
        let address = req.query.address;
        let id = req.query.id;

        if (!Helper.isAddress(address)) return res.json({
            status: 400
        });

        let medicines = await Medicine.methods.getMedicinesUpdadingByProvider(address)
            .call({ from: address })
            .then(data => data)
            .catch(err => [])

        if (!medicines || medicines.length == 0) return res.json({
            status: 400
        });

        let medicine = medicines.find(x => (x[0] == id && x[9] == true));

        let provider = await Provider.methods.getProviderInfor(address)
            .call()
            .then(data => data)
            .catch(err => console.log(err))

        return res.json({
            status: 200,
            medicine: medicine,
            provider: provider
        })
    },

    // upload image
    uploadImage: (req, res) => {
        let filename = req.file.filename;

        let ipfsAPI = require('ipfs-api');
        let fs = require('fs');
        let ipfs = ipfsAPI('ipfs.infura.io', '5001', {
            protocol: 'https'
        });

        if (!filename) return res.json({
            status: 400
        });

        let medicineImage = Helper.uploadPath + filename;
        let medicineFile = fs.readFileSync(medicineImage);
        let medicineBuffer = Buffer.from(medicineFile);

        ipfs.files.add(medicineBuffer, function (err, file) {

            if (err || !file || (file && file.length == 0)) return res.json({
                status: 400
            });

            fs.unlinkSync(medicineImage); // remove file uploaded

            return res.json({
                status: 200,
                hash: file[0].hash,
                byte32: web3.utils.toHex(file[0].hash)
            })
        })
    },

    // danh sách đang đợi approve
    listWattingApproves: async (req, res) => {
        let account = req.query.addressManager;
        console.log(account)
        let transactionIds = await Authorised.methods.getTransactionsWaittingConfirm()
            .call({ from: account })
            .then(ids => ids)
            .catch(err => []);
        if (!transactionIds || transactionIds.length == 0) return res.json({
            status: 400
        });

        let transactions = await Authorised.methods.getManyTransactionInformation(transactionIds)
            .call()
            .then(data => data)
            .catch(err => [])

        if (transactions && transactions.length > 0) {
            transactions.forEach((t, i) => {
                t.push(transactionIds[i])
            })
        }
        console.log(transactions);
        return res.json({
            status: 200,
            transactions: transactions
        })
    },

    // lấy danh sách đã được approved
    listApproved: async (req, res) => {
        let transactionCount = await Authorised.methods.transactionCount().call();

        let transactionIds = await Authorised.methods.getTransactionIds(0, transactionCount, 0, 1)
            .call()
            .then(ids => ids)
            .catch(err => []);

        if (!transactionIds || transactionIds.length == 0) return res.json({
            status: 400
        });

        let transactions = await Authorised.methods.getManyTransactionInformation(transactionIds)
            .call()
            .then(data => data)
            .catch(err => [])

        return res.json({
            status: 200,
            transactions: transactions
        })
    },

    //  ds đã được approved
    listConfirmed: async (req, res) => {
        let address = req.query.address;
        console.log('address: ', address);

        if (!Helper.isAddress(address)) return res.json({
            status: 400
        });

        let transactionIds = await Authorised.methods.getTransactionsConfirmedBy(address)
            .call({ from: address })
            .then(ids => ids)
            .catch(err => console.log(err));

        if (!transactionIds || transactionIds.length == 0) return res.json({
            status: 400
        });

        let transactions = await Authorised.methods.getManyTransactionInformation(transactionIds)
            .call({ from: address })
            .then(data => data)
            .catch(err => []);

        return res.json({
            status: 200,
            transactions: transactions
        })

    },

    // danh sách report đang đợi approve
    listReport: async (req, res) => {
        let id = req.query.id;
        let address = req.query.address;
        Report.methods.viewReportNotExcute(id, address).call({ from: address }).then(list => {
            if (list.length == 0) {
                res.json({
                    status: 400
                })
            }
            res.json({
                status: 200,
                list: list
            })
        }).catch(err => {
            res.json({
                status: 400
            })
        });

    },

    // convert hex code to string
    hexToString: (req, res) => {
        return res.json({
            string: web3.utils.hexToString(req.query.hex)
        })
    },

    // Hiển thị danh sách giao dịch theo id của provider or medicine
    transactionById: async (req, res) => {
        let id = req.query.id;

        if (!id || id == "") return res.json({
            status: 400
        });

        let transactionIds = await Authorised.methods.getTransactionsById(id)
            .call()
            .then(ids => ids)
            .catch(err => []);

        if (!transactionIds || transactionIds.length == 0) return res.json({
            status: 400
        });
        let transactions = await Authorised.methods.getManyTransactionInformation(transactionIds)
            .call()
            .then(data => data)
            .catch(err => []);

        return res.json({
            status: 200,
            transactions: transactions
        })
    },

    allTransactionByAddress: (req, res) => {
        let providerAddress = req.query.providerAddress;
        if (!Helper.isAddress(providerAddress)) return res.json({
            status: 400
        });
        Authorised.methods.getAllProviderAdressOfTransactionsIDs().call({ from: providerAddress }).then(listId => {
            if (listId.length != 0)
                Authorised.methods.getManyTransactionInformation(listId).call({ from: providerAddress }).then(listInfo => {
                    return res.json({
                        status: 200,
                        listInfo: listInfo
                    })
                })
        }).catch(err => {
            console.log(err)
            return res.json({
                status: 400
            })
        })
    },

    // provider lấy danh sách digital
    getDigitalCertificateByAddress: (req, res) => {
        let providerAddress = req.query.providerAddress;

        if (!Helper.isAddress(providerAddress)) return res.json({
            status: 400
        });
        Digital.methods.getDigitalCertificateByProviderAddress(providerAddress)
            .call()
            .then(r => {
                return res.json({
                    status: 200,
                    digital: r
                })
            })
            .catch(err => console.log('err', err))
    },

    // provider lấy thông tin giấy chứng nhận
    getDigitalCertifiCateByMedicineId: async (req, res) => {
        let medicineId = req.query.medicineId,
            providerAddress = req.query.providerAddress;

        if (
            !Helper.isAddress(providerAddress) ||
            !medicineId ||
            medicineId == ""
        ) return res.json({
            status: 400
        });

        let digital = await Digital.methods.getDigitalCertifiCateByMedicineId(medicineId, providerAddress)
            .call()
            .then(data => data)
            .catch(err => [])

        if (!digital || digital.length == 0) return res.json({
            status: 400
        });

        return res.json({
            status: 200,
            data: digital
        })

    },

    // check manager
    checkManager: async (req, res) => {
        let address = req.query.address;

        if (!Helper.isAddress) return res.send(false);

        let totalAuthoried = await Authorised.methods.getTotalAuthoried().call();

        let author = [];
        if (totalAuthoried && totalAuthoried.length > 0) {
            totalAuthoried.forEach(e => author.push(e.toLowerCase()))
        }

        if (author.length == 0 || !author.includes(address.toLowerCase())) return res.send(false);
        res.send(true)

    }



}