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

router.delete('/deleteuser/:idfy', action.deleteUser);

router.delete('/deleteadmin/:idfy', action.deleteAdmin);

router.delete('/deletedoc/:idfy', action.deleteDoc);


// search any user

router.post('/fetchuser', action.searchUser);

router.post('/fetchadmin', action.searchAdmin);

router.post('/fetchdoc', action.searchDoc);


// CREATE SCHEDULE ROUTE

router.post('/addschedule', action.createSchedule);


// SEARCH SLOTS

router.post('/searchslot', action.searchSlot);


// UPDATE SLOT BOOKING 

router.put('/updateslot/:idfy', action.updateSlot);


module.exports = router;
