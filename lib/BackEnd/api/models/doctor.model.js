const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const docSchema = new mongoose.Schema({
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
    spec_in: {
        type: String,
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

docSchema.pre('save', function (next) {
    var docuser = this;
    if (this.isModified('password') || this.isNew) {
        bcrypt.genSalt(10, function (err, salt) {
            if (err) {
                return next(err);
            }
            bcrypt.hash(docuser.password, salt, function (err, hash) {
                if (err) {
                    return next(err);
                }
                docuser.password = hash;
                next();

            })


        })
    }
    else {
        return next();
    }
})


docSchema.methods.comparePassword = function (passwd, cb) {
    bcrypt.compare(passwd, this.password, function (err, isMatch) {
        if (err) {
            return cb(err);
        }
        cb(null, isMatch);
    })
}




module.exports = mongoose.model('Doctor', docSchema);