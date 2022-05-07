const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const slotBookingSchema = new mongoose.Schema({
    date: {
        type: String,
        required: true,
    },
    slot: {
        type: String,
        required: true
    },
    start_time: {
        type: String,
        required: true,
    },
    end_time: {
        type: String,
        required: true,
    },
    doc_name: {
        type: String,
        required: true,
    },
    doc_email: {
        type: String,
        required: true,
    },
    doc_spec_in: {
        type: String,
        required: true
    },
    app_booked: {
        type: Boolean,
        required: true,
    },
    descreption: {
        type: String,

    },
    user_name: {
        type: String,

    },
    user_email: {
        type: String,

    }


})



module.exports = mongoose.model('Slotbooking', slotBookingSchema);