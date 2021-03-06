const express = require('express');
const morgan = require('morgan');
const cors = require('cors');
const connectDB = require('./config/db');
const passport = require('passport');
const bodyParser = require('body-parser');
const loginRoutes = require('./api/routes/login.routes');



connectDB();

const app = express();

if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'));
}

app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(loginRoutes)

app.use(passport.initialize())
require('./config/passport')(passport)

const PORT = process.env.PORT || 3000

app.listen(PORT, console.log('server too running in ' + process.env.NODE_ENV + ' node on port ' + PORT));