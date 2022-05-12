const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const leaveSchema = new mongoose.Schema({
    doc_email: {
        type: String,
        required: true,
    },
    doc_name: {
        type: String,
        required: true,
    },
    doc_spec_in: {
        type: String,
        required: true,
    },
    user_name: {
        type: String,
        required: true,
    },
    user_email: {
        type: String,
        required: true,
    },
    user_branch: {
        type: String,

    },
    user_rollno: {
        type: String,

    },
    doc_isaccepted: {
        type: Boolean,

    },
    admin_isaccepted: {
        type: Boolean,
    }

});


module.exports = mongoose.model('LeaveRequest', leaveSchema);