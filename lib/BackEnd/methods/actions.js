const User = require('../api/models/login.model');
const jwt = require('jwt-simple');
const config = require('../config/dbconfig');


var functions = {
    addNew: function (req, res, next) {
        if ((!req.body.name) || (req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {
            var newUser = User({
                name: req.body.name,
                type: req.body.type,
                branch: req.body.branch,
                rollno: req.body.rollno,
                email: req.body.email,
                password: req.body.password,

            })
            newUser.save(function (err, newUser) {
                if (err) {
                    res.status(401).json({
                        success: false,
                        msg: "Failed to save bro",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: false,
                        msg: "Succcessfully Saved Bhiya ji",
                        user_data: newUser,
                    })
                }
            })
        }
    }
}


module.exports = functions;