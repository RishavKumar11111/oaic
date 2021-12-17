const JWT = require('jsonwebtoken')
const createError = require('http-errors')

module.exports = {
    signAccessToken: (userDetails) => {
        return new Promise((resolve, reject) => {
            const payload = userDetails
            const secret = process.env.ACCESS_TOKEN_SECRET
            const options = {
                expiresIn: '6h',
                issuer: 'odishaagro.nic.in',
                audience: userDetails.userId
            }
            JWT.sign(payload, secret, options, (err, token) => {
                if(err) {
                    console.error(err)
                    reject(createError.InternalServerError())
                }
                resolve(token)
            })
        })
    },
    verifyAccessToken: (req, res, next) => {
        const authHeaders = req.headers['authorization']
        if(!authHeaders) return next(createError.Unauthorized())
        const token = authHeaders.split(' ')[1]
        JWT.verify(token, process.env.ACCESS_TOKEN_SECRET, (err, payload) => {
            if(err) return next(createError.Unauthorized())
            req.payload = payload;
            next()
        })
    }
}