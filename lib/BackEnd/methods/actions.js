const User = require('../api/models/login.model');
const AdminUser = require('../api/models/admin.model');
const DocUser = require('../api/models/doctor.model');
const AddSchedule = require('../api/models/schedule.model');
const jwt = require('jwt-simple');
const config = require('../config/dbconfig');


var functions = {


    // SAVE DOCTOR SECHEDULE

    createSchedule: function (req, res, next) {
        if ((!req.body.doc_email) || (!req.body.doc_name) || (!req.body.doc_spec_in) || (!req.body.slot) || (!req.body.date) || (!req.body.start_time) || (!req.body.end_time)) {
            res.json({
                success: false,
                msg: "Enter all fields",
            })
        }
        else {
            var newSchedule = AddSchedule({
                doc_email: req.body.doc_email,
                doc_name: req.body.doc_name,
                doc_spec_in: req.body.doc_spec_in,
                slot: req.body.slot,
                date: req.body.date,
                start_time: req.body.start_time,
                end_time: req.body.end_time,
            });
            newSchedule.save(function (err, schedule) {
                if (err) {
                    res.status(401).json({
                        success: false,
                        msg: "Failed to save schedule bro",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved Schedule Bhiya ji",
                        user_data: schedule,
                    })
                }
            });
        }
    },



    //  USER(PATIENT) PART

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

    deleteUser: function (req, res, next) {
        User.deleteMany({ email: req.params.idfy })
            .then(result => {
                console.log(result);
                if (result.deletedCount === 0) {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "NO Such User Exists",
                        dltAdmin: result,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "User Data is deleted successfully",
                        dltAdmin: result,
                    })
                }

            })

            .catch(err => {
                console.log(err);
                res.status(500).json({
                    msg: "Something went wrong...",
                    error: err,
                })
            })
    },


    searchUser: function (req, res, next) {
        User.findOne({ email: req.body.email }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {
                return res.status(200).send({
                    success: true,
                    msg: "Congrats, User mil Gaya",
                    name: user.name,
                    type: user.type,
                    branch: user.branch,
                    rollno: user.rollno,
                    email: user.email
                })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, User Nahi mila",
                })
            }
        })
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
    },

    //  ADMIN PART

    addNewAdmin: function (req, res, next) {
        if ((!req.body.name) || (!req.body.type) || (!req.body.college_id) || (!req.body.phone) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {

            var newAdminUser = AdminUser({
                name: req.body.name,
                type: req.body.type,
                college_id: req.body.college_id,
                phone: req.body.phone,
                email: req.body.email,
                password: req.body.password,

            })
            newAdminUser.save(function (err, newUser) {
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

    deleteAdmin: function (req, res, next) {
        AdminUser.deleteMany({ email: req.params.idfy })
            .then(result => {
                console.log(result);
                if (result.deletedCount === 0) {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "No Such Admin Exists",
                        dltAdmin: result,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "Admin Data is deleted successfully",
                        dltAdmin: result,
                    })
                }
            })

            .catch(err => {
                console.log(err);
                res.status(500).json({
                    msg: "Something went wrong...",
                    error: err,
                })
            })
    },


    authenticateAdmin: function (req, res, next) {
        AdminUser.findOne({ email: req.body.email },
            function (err, user) {
                if (err) {
                    res.send('Something went wrong admin');
                    throw err;
                }
                if (!user) {
                    res.status(403).send({
                        success: false,
                        msg: "Authentication failed, User Nahi mila admin",
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
                                msg: "Authentication failed, wrong Password admin",
                            })
                        }
                    })
                }
            })
    },


    searchAdmin: function (req, res, next) {
        AdminUser.findOne({ email: req.body.email }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {
                return res.status(200).send({
                    success: true,
                    msg: "Congrats, User mil Gaya",
                    name: user.name,
                    type: user.type,
                    college_id: user.college_id,
                    phone: user.phone,
                    email: user.email
                })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, User Nahi mila",
                })
            }
        })
    },

    // DOCTOR PART

    addNewDoc: function (req, res, next) {
        if ((!req.body.name) || (!req.body.type) || (!req.body.college_id) || (!req.body.spec_in) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {

            var newDocUser = DocUser({
                name: req.body.name,
                type: req.body.type,
                college_id: req.body.college_id,
                spec_in: req.body.spec_in,
                email: req.body.email,
                password: req.body.password,

            })
            newDocUser.save(function (err, newUser) {
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

    deleteDoc: function (req, res, next) {
        DocUser.deleteMany({ email: req.params.idfy })
            .then(result => {
                console.log(result);
                if (result.deletedCount === 0) {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "No such Doctor exist",
                        dltAdmin: result,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "Doctor Data is deleted successfully",
                        dltAdmin: result,
                    })
                }
            })

            .catch(err => {
                console.log(err);
                res.status(500).json({
                    msg: "Something went wrong...",
                    error: err,
                })
            })
    },


    authenticateDoc: function (req, res, next) {
        DocUser.findOne({ email: req.body.email },
            function (err, user) {
                if (err) {
                    res.send('Something went wrong doc');
                    throw err;
                }
                if (!user) {
                    res.status(403).send({
                        success: false,
                        msg: "Authentication failed, User Nahi mila doctor",
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
                                msg: "Authentication failed, wrong Password doctor",
                            })
                        }
                    })
                }
            })
    },

    searchDoc: function (req, res, next) {
        DocUser.findOne({ email: req.body.email }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {
                return res.status(200).send({
                    success: true,
                    msg: "Congrats, User mil Gaya",
                    name: user.name,
                    type: user.type,
                    college_id: user.college_id,
                    spec_in: user.spec_in,
                    email: user.email
                })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, User Nahi mila",
                })
            }
        })
    },
}


module.exports = functions;