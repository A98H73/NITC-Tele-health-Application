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

// Adding an new User
// Post request /addNew

router.post('/adduser', action.addNew);

// Authenticating a User
// POST request /autheticate

router.post('/login', action.authenticate);

// GET info of a User
// GET request /getinfo

router.get('/getinfo', action.getinfo);

module.exports = router;
