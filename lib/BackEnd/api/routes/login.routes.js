const express = require('express');
const action = require('../../methods/actions');
const router = express.Router();

router.get('/', (req, res, next) => {
    // res.status(200).json({
    //     msg: "Hello world",
    // })
    res.send('Aab to khush ho');
})

router.post('/adduser', action.addNew);


module.exports = router;
