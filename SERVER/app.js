const express = require('express');
const app = express();
const path = require('path');
const bodyParser = require('body-parser');
// const session = require('express-session');
// const csrf = require('csurf');
// const csrfProtection = csrf({ session: true });
// const helmet = require('helmet');
const cors = require('cors');

const { verifyAccessToken } = require('./helpers/jwt.helper')
const { permission } = require('./permissions/permission')

const allowedMethods = ['GET', 'HEAD', 'POST', 'OPTIONS']

app.use((req, res, next) => {
    if (!allowedMethods.includes(req.method)) return res.status(405).send('Method Not Allowed');
    return next()
})
// app.use(helmet());
app.use(cors({
    origin: 'http://localhost:4200',
    methods: 'GET, POST',
    credentials: true
}));
// app.use(session({
//     secret: 'keyboard cat12321',
//     resave: false,
//     saveUninitialized: true
// }));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// app.use(express.json({
//     limit: '15mb'
// }));

// app.use(csrfProtection);
app.get('/test', async (req, res) => {
    res.json({message: 'pass!'})
  })
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'public')));
app.use('/user-login', express.static(path.join(__dirname, 'angular-app')));

app.use('/', require('./routes/public.route'));

app.use('/api', verifyAccessToken, require('./routes/api.route'));

app.use('/dm', verifyAccessToken, permission('DM'), require('./routes/dm.route'));

app.use('/dl', verifyAccessToken, permission('DEALER'), require('./routes/vendor.route'));

app.use('/accountant', verifyAccessToken, permission('ACCOUNTANT'), require('./routes/accountant.route'));

app.use('/jn', verifyAccessToken, require('./routes/jalanidhi.route'));

app.use('/admin', verifyAccessToken, permission('ADMIN'), require('./routes/admin.route'));

app.use('/bank', verifyAccessToken, permission('BANK'), require('./routes/bank.route'));

app.use('/report', verifyAccessToken, require('./routes/report.route'));

app.use('/accHead', verifyAccessToken, permission('ACC-HEAD'), require('./routes/accHead.route'));

app.use( (req, res, next) => {
    const error = new Error('not Found');
    error.status = 404;
    next(error);
} )

app.use( (err, req, res, next) => {
    console.error(err)
    res.status(err.status || 500)
    res.send({
        error: {
            status: err.status || 500,
            message: err.message
        }
    })
} )


// FIXME: Secret will generate from Crypto Module
process.env.ACCESS_TOKEN_SECRET = 'Hello world, Secret'



module.exports = app;







// const logUpdate = require('log-update')
// const char = 'I'
// const min = 0
// const max = 100
// const steps = 5
// let num = 1

// const mInterval = setInterval( () => {
//     let progres = ''
//     for(let i = 0; i < num; i++) {
//         progres += char
//     }
//     logUpdate(`Project Loading: [ ${progres} ${num * steps}% ]`)
//     num++
//     if(num > max / steps) {
//         logUpdate.done();
//         clearInterval(mInterval)
//     }
// }, 300)
