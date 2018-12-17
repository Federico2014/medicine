import mongoose from 'mongoose';

const MedicineSchema = mongoose.Schema({
  medicineId: Number,
  imgHash: String,
  name: String,
  ingredient: String,
  benefit: String,
  by: String,
  prices: String,
  detail: String,
  isAllowed: {
    type: Boolean,
    default: false
  },
  digitalId: String,



  createdAt:{
    type: Date,
    default: Date.now
  },
  updatedAt:{
    type: Date,
    default: Date.now
  },
});


const Medicine = mongoose.model('Medicines', MedicineSchema);

const MedicineFunctions = {
  getMedicines: (cb) => {
    Medicine.find().exec((err, medicines) => {
      if(err){
        cb({status: 400, medicines: []})
      }else{
        cb({status: 200, medicines: medicines})
      }
    });
  },

  createMedicine: (medicine, cb) => {
    Medicine.create(medicine, (err, data) => {
      if(err){
        cb({status: 400, medicine: []})
      }else{
        cb({status: 200, medicine: data})
      }
    })
  }
 
}

export default MedicineFunctions