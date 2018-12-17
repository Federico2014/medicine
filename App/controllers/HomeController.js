// this is home controller
module.exports = {
    index: (req, res) => {
        res.render('index', {
            title: 'Medicine'
        });
    },
    managerPage: (req, res) => {
        res.render('managers/index', {
            title: "Medicine - Manager"
        });
    },

    providerPage: (req, res) => {
        res.render('provider/index', {
            title: "Medicine - Provider"
        });
    },

    approvedPage: (req, res) => {
        res.render('managers/approved', {
            title: "Medicine - Approved"
        });
    },

    licensePage: (req, res) => {
        res.render('managers/license', {
            title: "Medicine - License"
        });
    },

    registerProvider: (req, res) => {
        res.render('layout/register_provider', {
            title: "Register Provider"
        });
    }
}