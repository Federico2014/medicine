const router = require('express').Router();

// import home controller
import Home from '../App/controllers/HomeController'

/* GET home page. */
router.get('/',Home.index)
      .get('/provider', Home.providerPage)
      .get('/approved', Home.approvedPage)
      .get('/manager',  Home.managerPage)
      .get('/license',  Home.licensePage)

export default router;
