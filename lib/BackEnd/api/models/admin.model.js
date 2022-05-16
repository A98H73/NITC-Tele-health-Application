const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const adminSchema = new mongoose.Schema({
    name: {
        type: String,
        require: true,
    },
    type: {
        type: String,
        require: true,
    },
    college_id: {
        type: String,
        require: true,
    },
    phone: {
        type: Number,
        require: true,
    },
    email: {
        type: String,
        require: true,
        unique: true,
    },
    password: {
        type: String,
        require: true,
    }
})

adminSchema.pre('save', function (next) {
    var adminuser = this;
    if (this.isModified('password') || this.isNew) {
        bcrypt.genSalt(10, function (err, salt) {
            if (err) {
                return next(err);
            }
            bcrypt.hash(adminuser.password, salt, function (err, hash) {
                if (err) {
                    return next(err);
                }
                adminuser.password = hash;
                next();

            })


        })
    }
    else {
        return next();
    }
})


adminSchema.methods.comparePassword = function (passwd, cb) {
    bcrypt.compare(passwd, this.password, function (err, isMatch) {
        if (err) {
            return cb(err);
        }
        cb(null, isMatch);
    })
}




module.exports = mongoose.model('Admin', adminSchema);