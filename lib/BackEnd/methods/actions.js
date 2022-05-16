const User = require('../api/models/login.model');
const AdminUser = require('../api/models/admin.model');
const DocUser = require('../api/models/doctor.model');
const AddSchedule = require('../api/models/schedule.model');
const AddSlot = require('../api/models/slotbooking');
const Med = require('../api/models/MedicalLeave.model');
const jwt = require('jwt-simple');
const config = require('../config/dbconfig');
const moment = require('moment');
const bcrypt = require('bcrypt');


var functions = {




    // MEDICAL LEAVE REQUEST 

    addMedicalLeave: function (req, res, next) {
        if ((!req.body.doc_email) || (!req.body.doc_name) || (!req.body.doc_spec_in) || (!req.body.user_name) || (!req.body.user_email)) {
            res.json({
                success: false,
                msg: "Enter all fields buddy"
            })
        }
        else {
            var MedLeaveRequest = Med({
                "doc_name": req.body.doc_name,
                "doc_email": req.body.doc_email,
                "doc_spec_in": req.body.doc_spec_in,
                "user_name": req.body.user_name,
                "user_email": req.body.user_email,
                "user_branch": req.body.user_branch,
                "user_rollno": req.body.user_rollno,
                "doc_isaccepted": req.body.doc_isaccepted,
                "admin_isaccepted": req.body.admin_isaccepted,
            })

            MedLeaveRequest.save(function (err, medrequest) {
                if (err) {
                    res.status(401).json({
                        success: false,
                        msg: "Failed to save schedule ",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved Schedule ",
                        user_data: medrequest,
                    })
                }
            });
        }
    },

    searchMedLeave: function (req, res, next) {
        if ((!req.body.doc_email) || (!req.body.user_email)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {
            Med.find({ user_email: req.body.user_email, doc_email: req.body.doc_email }, function (err, user) {
                if (err) {
                    res.send('Something went wrong');
                    throw err;
                }

                if (user) {

                    return res.status(200).send({
                        success: true,
                        msg: "data found",
                        user
                    })
                }
                else {
                    return res.status(403).send({
                        success: false,
                        msg: "Authentication failed, User Not Found",
                    })
                }
            });
        }
    },

    updateMedRequest: function (req, res, next) {
        if ((!req.body.doc_name) || (!req.body.doc_email) || (!req.body.doc_spec_in) || (!req.body.user_name) || (!req.body.user_email) || ((!req.body.user_branch) || (!req.body.user_rollno))) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {
            Med.findOneAndUpdate({ _id: req.params.idfy }, {

                "doc_name": req.body.doc_name,
                "doc_email": req.body.doc_email,
                "doc_spec_in": req.body.doc_spec_in,
                "user_name": req.body.user_name,
                "user_email": req.body.user_email,
                "user_branch": req.body.user_branch,
                "user_rollno": req.body.user_rollno,
                "doc_isaccepted": req.body.doc_isaccepted,
                "admin_isaccepted": req.body.admin_isaccepted,
            })
                .then(result => {
                    res.status(200).json({
                        success: true,
                        msg: "Medical Request Accepted",
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


    removeMedRequest: function (req, res, next) {
        Med.deleteMany({ _id: req.params.idfy })
            .then(result => {
                console.log(result);
                if (result.deletedCount === 0) {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "No Such Request Exists",
                        dltAdmin: result,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "Leave Request Deleted Successfully",
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

    // SLOT BOOKING SERVICES


    fetchBookedSlot: function (req, res, next) {
        AddSlot.find({ user_email: req.body.user_email, app_booked: req.body.app_booked }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {

                return res.status(200).send({

                    user
                })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, User Not Found",
                })
            }
        });
    },

    cancelAppointment: function (req, res, next) {
        if ((!req.body.date) || (!req.body.slot) || (!req.body.start_time) || (!req.body.end_time) || (!req.body.doc_name) || (!req.body.doc_email) || (!req.body.doc_spec_in)) {
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
                        msg: "Booking Cancelled Successfully",
                        result
                    })
                })
                .catch(err => {
                    res.status(500).json({
                        success: false,
                        msg: "Something Went Wrong",
                        err
                    })
                })
        }
    },

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
                            msg: "Failed to save slots",
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
                        msg: "Failed to save schedule",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved Schedule ",
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
                    msg: "Authentication failed, User Not found",
                })
            }
        });
    },

    updateSlot: function (req, res, next) {
        if ((!req.body.date) || (!req.body.slot) || (!req.body.start_time) || (!req.body.end_time) || (!req.body.doc_name) || (!req.body.doc_email) || (!req.body.doc_spec_in) || (!req.body.user_name) || (!req.body.user_email)) {
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
                        msg: "Something Went Wrong ",
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
                        msg: "Failed to save",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved",
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
                        msg: "No Such User Exists",
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
                    msg: "Congrats, User Found",
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
                    msg: "Authentication failed, User Not Found",
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
                        msg: "Authentication failed, User Not Found",
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
                msg: "No Headers ",
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
                        msg: "Failed to save",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved",
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
                    res.send('Something went wrong');
                    throw err;
                }
                if (!user) {
                    res.status(403).send({
                        success: false,
                        msg: "Authentication failed, Admin Not Found",
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
                                msg: "Authentication failed, Admin wrong Password ",
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
                    msg: "Congrats, User Found",
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
                    msg: "Authentication failed, User Not Found",
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
                        msg: "Failed to save",
                        error: err,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        msg: "Succcessfully Saved ",
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
                    res.send('Something went wrong');
                    throw err;
                }
                if (!user) {
                    res.status(403).send({
                        success: false,
                        msg: "Authentication failed, Doctor Not Found",
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

    searchDoc: function (req, res, next) {
        DocUser.findOne({ email: req.body.email }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {
                return res.status(200).send({
                    success: true,
                    msg: "Congrats, Doctor Found",
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
                    msg: "Authentication failed, Doctor Not Found",
                })
            }
        })
    },

    searchDocSlots: function (req, res, next) {
        AddSlot.find({ date: req.body.date, doc_email: req.body.doc_email, doc_spec_in: req.body.doc_spec_in }, function (err, user) {
            if (err) {
                res.send('Something went wrong');
                throw err;
            }

            if (user) {
                return res.status(200).send({
                    user
                })
            }
            else {
                return res.status(403).send({
                    success: false,
                    msg: "Authentication failed, Doc Slot Not Found",
                })
            }
        })
    },

    cancelDocAppointment: function (req, res, next) {
        AddSlot.deleteMany({ _id: req.params.idfy })
            .then(result => {
                console.log(result);
                if (result.deletedCount === 0) {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "Something Went Wrong",
                        dltAdmin: result,
                    })
                }
                else {
                    res.status(200).json({
                        success: true,
                        deletecount: result.deletedCount,
                        msg: "Doctor Appointment is deleted successfully",
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

    //  UPDATE ALL USERS DATA

    updatePatient: function (req, res, next) {
        if ((!req.body.type) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {

            // bcrypt.genSalt(10, (err, salt) => {
            //     bcrypt.hash(req.body.password, salt, (err, hash) => {
            //         // Now we can store the password hash in db.
            //         req.body.password = hash;
            //     });
            // });
            User.findOne({ email: req.params.idfy }, function (err, user) {
                if (err) {
                    res.send('Something went wrong');
                    throw err;
                }

                if (user) {
                    user.email = req.body.email,
                        user.password = req.body.password;

                    user.save(function (err, newUser) {
                        if (err) {
                            res.status(401).json({
                                success: false,
                                msg: "Failed to save",
                                error: err,
                            })
                        }
                        else {
                            res.status(200).json({
                                success: true,
                                msg: "Succcessfully Saved",
                                newUser,
                            })
                        }
                    })

                }
                else {
                    return res.status(403).send({
                        success: false,
                        msg: "Authentication failed, User Not Found",
                    })
                }
            })

        }
    },

    updateAdmin: function (req, res, next) {
        if ((!req.body.type) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields"
            })
        }
        else {

            // bcrypt.genSalt(10, (err, salt) => {
            //     bcrypt.hash(req.body.password, salt, (err, hash) => {
            //         // Now we can store the password hash in db.
            //         req.body.password = hash;
            //     });
            // });
            AdminUser.findOne({ email: req.params.idfy }, function (err, user) {
                if (err) {
                    res.send('Something went wrong');
                    throw err;
                }

                if (user) {
                    user.type = req.body.type,
                        user.email = req.body.email,
                        user.password = req.body.password;

                    user.save(function (err, newUser) {
                        if (err) {
                            res.status(401).json({
                                success: false,
                                msg: "Failed to save ",
                                error: err,
                            })
                        }
                        else {
                            res.status(200).json({
                                success: true,
                                msg: "Succcessfully Saved ",
                                newUser,
                            })
                        }
                    })

                }
                else {
                    return res.status(403).send({
                        success: false,
                        msg: "Authentication failed, Admin Not Found",
                    })
                }
            })

        }
    },

    updateDoc: function (req, res, next) {
        if ((!req.body.type) || (!req.body.email) || (!req.body.password)) {
            res.json({
                success: false,
                msg: "Enter all fields "
            })
        }
        else {

            // bcrypt.genSalt(10, (err, salt) => {
            //     bcrypt.hash(req.body.password, salt, (err, hash) => {
            //         // Now we can store the password hash in db.
            //         req.body.password = hash;
            //     });
            // });
            DocUser.findOne({ email: req.params.idfy }, function (err, user) {
                if (err) {
                    res.send('Something went wrong');
                    throw err;
                }

                if (user) {
                    user.type = req.body.type,
                        user.email = req.body.email,
                        user.password = req.body.password;

                    user.save(function (err, newUser) {
                        if (err) {
                            res.status(401).json({
                                success: false,
                                msg: "Failed to save ",
                                error: err,
                            })
                        }
                        else {
                            res.status(200).json({
                                success: true,
                                msg: "Succcessfully Saved ",
                                newUser,
                            })
                        }
                    })

                }
                else {
                    return res.status(403).send({
                        success: false,
                        msg: "Authentication failed, Doctor Not Found",
                    })
                }
            })

        }
    }

}


module.exports = functions;