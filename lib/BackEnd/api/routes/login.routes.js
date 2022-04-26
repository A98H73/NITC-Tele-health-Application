const express = require('express');
const { addNew } = require('../../methods/actions');
const action = require('../../methods/actions');
const router = express.Router();

router.get('/', (req, res, next) => {
    // res.status(200).json({
    //     msg: "Hello world",
    // })
    res.send('Aab to khush ho');
})

// Adding an new User, Admin, Doctor
// Post request /addNew, /addadmin, /adddoc

router.post('/adduser', action.addNew);
router.post('/addadmin', action.addNewAdmin);
router.post('/adddoc', action.addNewDoc);

// Authenticating a User, Admin, Doctor
// POST request /authenticate, /authenticateAdmin, /authenticateDoc

router.post('/login', action.authenticate);
router.post('/loginadmin', action.authenticateAdmin);
router.post('/logindoc', action.authenticateDoc);

// GET info of a User
// GET request /getinfo

router.get('/getinfo', action.getinfo);


//Remove Users(All 3) From Database Route

router.delete('/deleteuser', action.deleteUser);

router.delete('/deleteadmin', action.deleteAdmin);

router.delete('/deletedoc', action.deleteDoc);


module.exports = router;
