const jwt = require('jsonwebtoken')
require('dotenv').config()

function authenticateToken(req, res, next) {
    const token = req.header('Authorization')?.split(' ')[1]

    if(!token) {
        return res.status(401).json({message: 'Token tidak ditemukan'})
    }

    jwt.verify(token, process.env.TOKEN, (err, user) => {
        if(err) {
            return res.status(403).json({message: 'Token tidak valid'})
        }
        req.user = user
        next()
    })
}

module.exports = { authenticateToken }