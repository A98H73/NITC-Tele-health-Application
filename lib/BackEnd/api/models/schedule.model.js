const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const scheduleSchema = new mongoose.Schema({
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
    slot: {
        type: String,
        required: true,
    },
    date: {
        type: String,
        required: true,
    },
    start_time: {
        type: String,
        required: true,
    },
    end_time: {
        type: String,
        required: true,
    }

})


module.exports = mongoose.model('Schedule', scheduleSchema);