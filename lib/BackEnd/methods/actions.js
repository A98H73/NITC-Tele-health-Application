const User = require('../api/models/login.model');
const jwt = require('jwt-simple');
const config = require('../config/dbconfig');


var functions = {
    addNew: function (req, res, next) {
        if ((!req.body.name) || (!req.body.type) || (!req.body.branch) || (!req.body.rollno) || (!req.body.email) || (!req.body.password)) {
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
                        success: true,
                        msg: "Succcessfully Saved Bhiya ji",
                        user_data: newUser,
                    })
                }
            })
        }
    },

    authenticate: function (req, res, next) {
        User.findOne({ email: req.body.email },
            function (err, user) {
                if (err) {
                    res.send('Something went wrong');
                    throw err;
                }
                if (!user) {
                    res.status(403).send({
                        success: false,
                        msg: "Authentication failed, User Nahi mila",
                    })
                }
                else {
                    user.comparePassword(req.body.password, function (err, isMatch) {
                        if (isMatch && !err) {
                            var token = jwt.encode(user, config.secret)
                            res.json({
                                success: true,
                                token: token,
                            })

                        }
                        else {
                            return res.status(403).send({
                                success: false,
                                msg: "Authentication failed, wrong Password",
                            })
                        }
                    })
                }
            })
    },


    getinfo: function (req, res) {
        if (req.headers.authorization && req.headers.authorization.split(" ")[0] === 'Bearer') {
            var token = req.headers.authorization.split(' ')[1];
            var decodedtoken = jwt.decode(token, config.secret);
            return res.status(200).json({
                success: true,
                msg: "hello Bro " + decodedtoken.name,
            })

        }
        else {
            return res.status(200).json({
                success: false,
                msg: "No Headers Bhaiya ji",
            })
        }
    }
}


module.exports = functions;