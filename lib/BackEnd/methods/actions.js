const User = require('../api/models/login.model');
const AdminUser = require('../api/models/admin.model');
const DocUser = require('../api/models/doctor.model');
const AddSchedule = require('../api/models/schedule.model');
const AddSlot = require('../api/models/slotbooking');
const jwt = require('jwt-simple');
const config = require('../config/dbconfig');
const moment = require('moment');


var functions = {


    // SLOT FOR EACH APPOINTMENT

    // slotBook: function (req, res, next) {
    //     var start = moment(req.body.start_time, "hh:mm a");
    //     var end = moment(req.body.end_time, "hh:mm a");

    //     start.minutes(Math.ceil(start.minutes() / 15) * 15);

    //     var result = [];

    //     var current = moment(start);

    //     while (current <= end) {
    //         result.push(current.format('hh:mm'));
    //         current.add(15, 'minutes');
    //     }
    //     console.log("Result is" + result);
    // },




    // SAVE DOCTOR SECHEDULE

    createSchedule: function (req, res, next) {
        //slotBook(req, res, next);
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
            var start = moment(req.body.start_time, "hh:mma");
            var end = moment(req.body.end_time, "hh:mma");

            start.minutes(Math.ceil(start.minutes() / 15) * 15);

            var result = [];
            var str = "";
            var current = moment(start);
            var current_next = moment(start);
            current_next.add(15, 'minutes');

            // var newSlot = AddSlot({
            //     doc_name: req.body.doc_name,
            //     doc_email: req.body.doc_email,
            //     doc_spec_in: req.body.doc_spec_in,
            //     date: req.body.date,
            //     slot: req.body.slot,
            //     start_time: current.format('hh:mm'),
            //     end_time: current_next.format('hh:mm'),
            //     app_booked: false,
            //     descreption: str,
            //     user_name: str,
            //     user_email: str,
            // });
            // newSlot.save(function (err, book) {
            //     if (err) {
            //         res.status(401).json({
            //             success: false,
            //             msg: "Failed to save slots bro",
            //             error: err,
            //         })
            //     }
            //     else {
            //         res.status(200).json({
            //             success: true,
            //             msg: "Succcessfully Saved Slots Bhiya ji",
            //             slots: book,

            //         })
            //     }
            // })

            while (current_next <= end) {



                var newSlot = AddSlot({
                    doc_name: req.body.doc_name,
                    doc_email: req.body.doc_email,
                    doc_spec_in: req.body.doc_spec_in,
                    date: req.body.date,
                    slot: req.body.slot,
                    start_time: current.format('hh:mma'),
                    end_time: current_next.format('hh:mma'),
                    app_booked: false,
                    descreption: str,
                    user_name: str,
                    user_email: str,
                });
                newSlot.save(function (err, book) {
                    if (err) {
                        res.status(401).json({
                            success: false,
                            msg: "Failed to save slots bro",
                            error: err,
                        })
                    }
                    // else {
                    //     res.status(200).json({
                    //         success: true,
                    //         msg: "Succcessfully Saved Slots Bhiya ji",
                    //         slots: book,

                    //     })
                    // }
                })

                //result.push(current.format('hh:mm'));
                current.add(15, 'minutes');
                current_next.add(15, 'minutes');
            }
            console.log("Result is" + result);
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

    searchSlot: function (req, res, next) {
        AddSlot.find({ date: req.body.date, slot: req.body.slot, doc_spec_in: req.body.doc_spec_in }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {

                return res.status(200).send({

                    user
                    // doc_name: user.doc_name,
                    // doc_email: user.doc_email,
                    // doc_spec_in: user.doc_spec_in,
                    // date: user.date,
                    // slot: user.slot,
                    // start_time: user.start_time,
                    // end_time: user.end_time,
                    // app_booked: user.app_booked,
                    // descreption: user.descreption,
                    // user_email: user.user_email,
                    // user_name: user.user_name

                })

                // return res.status(200).send({
                //     success: true,
                //     msg: "Congrats, User mil Gaya",
                //     name: user.name,
                //     type: user.type,
                //     branch: user.branch,
                //     rollno: user.rollno,
                //     email: user.email


                // })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, User Nahi mila",
                })
            }
        });
    },

    updateSlot: function (req, res, next) {
        if ((!req.body.date) || (!req.body.slot) || (!req.body.start_time) || (!req.body.end_time) || (!req.body.doc_name) || (!req.body.doc_email) || (!req.body.doc_spec_in) || (!req.body.app_booked) || (!req.body.user_name) || (!req.body.user_email)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {
            AddSlot.findOneAndUpdate({ _id: req.params.idfy }, {
                "date": req.body.date,
                "slot": req.body.slot,
                "start_time": req.body.start_time,
                "end_time": req.body.end_time,
                "doc_name": req.body.doc_name,
                "doc_email": req.body.doc_email,
                "doc_spec_in": req.body.doc_spec_in,
                "descreption": req.body.descreption,
                "app_booked": req.body.app_booked,
                "user_name": req.body.user_name,
                "user_email": req.body.user_email,
            })
                .then(result => {
                    res.status(200).json({
                        success: true,
                        msg: "Booking Updated Successfully",
                        result
                    })
                })
                .catch(err => {
                    res.status(500).json({
                        success: false,
                        msg: "Something Went Wrong Bhai",
                        err
                    })
                })
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