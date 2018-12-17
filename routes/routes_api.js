import express from 'express';

//import controller file
import Api from '../App/controllers/ApiController'

// get an instance of express router
const router = express.Router();

// use multer 
import multer from "multer";
const multerConf = {
    storage: multer.diskStorage({
        destination: (req, file, cb) => {
            cb(null, './public/images/medicines')
        },
        filename: (req, file, cb) => {
            const ext = file.mimetype.split('/')[1];
            cb(null, file.fieldname + '-' + Date.now() + '.' + ext);
        }
    })
  }
      // Provider
router.get('/providerByCode',    Api.providerByCode) // Tìm kiếm thông tin provider bởi id
      .get('/providerByAddress',  Api.providerByAddress) // Tìm kiếm thông tin provider bởi address
      .get('/providerUpdatingByAddress',  Api.providerUpdatingByAddress) // Tìm kiếm thông tin update provider bởi address
      .get('/getDigitalCertificateByAddress',  Api.getDigitalCertificateByAddress) // Lấy danh sách giấy chứng nhận
      .get('/getDigitalCertifiCateByMedicineId',  Api.getDigitalCertifiCateByMedicineId) // Lấy thông tin giấy chứng nhận
      
      // Medicine
router.get('/medicineByCode', Api.medicineByCode) // tìm kiếm medicine bởi id
      .get('/allMedicines',    Api.allMedicines) // lấy tất cả danh sách thuốc đã có
      .get('/getMedicinesUpdadingByProvider',  Api.getMedicinesUpdadingByProvider) // Tìm kiếm thông tin update medicine bởi address

      // other
router.post('/uploadImage', multer(multerConf).single('image'), Api.uploadImage) // upload hình ảnh, trả về  hash + bytes32
      .get('/listWattingApproves',  Api.listWattingApproves) // manager lấy danh sách đợi approve
      .get('/listConfirmed',        Api.listConfirmed) // manager lấy danh đã approve
      .get('/hexToString',          Api.hexToString) // convert hex to string
      .get('/transactionById',      Api.transactionById) // Lấy lịch sử giao dịch theo id của provider or medicine
      .get('/allTransactionByAddress',  Api.allTransactionByAddress) // Lấy lịch sử giao dịch theo id của provider or medicine
      .get('/checkManager',        Api.checkManager) 
      .get('/listReport',        Api.listReport) 
     
export default router;