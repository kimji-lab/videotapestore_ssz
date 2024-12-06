const express = require('express')
const router = express.Router()
const bcrypt = require('bcrypt')
require('dotenv').config()
const jwt = require('jsonwebtoken')
var database = require('./database.js')
const { authenticateToken } = require('./middleware.js')

router.post('/signup', async (req,res) => {
    const {username, email, password} = req.body

    if(!username || !email || !password) {
        return res.status(400).json({message: 'Data belum terisi seluruhnya'})
    }

    const hashedPassword = await bcrypt.hash(password, 10)

    var sqlQuery = 'INSERT INTO users (username, email, password) VALUES (?,?,?)'

    database.query(sqlQuery, [username, email, hashedPassword], function(error,data,fields) {
        if(error) {
            return res.status(500).json({message: error.message})
        } else {
            return res.status(201).json({message: 'Sign up successful'})
        }
    })
})

router.post('/signin', async (req,res) => {
    const {username, password} = req.body

    if(!username || !password) {
        return res.status(400).json({message: 'Data belum terisi seluruhnya'})
    }

    var sqlQuery = 'SELECT * FROM users WHERE username = ?'

    database.query(sqlQuery, [username], async function(err, data, fields) {
        if(err) {
            return res.status(500).json({message : err.message})
        } if(data.length === 0) {
            return res.status(404).json({message: 'User tidak ditemukan'})
        } 

        const user = data[0]
        const comparePassword =  await bcrypt.compare(password, user.password)

        if(!comparePassword) {
            return res.status(401).json({message: 'Password salah'})
        }
        
        delete user.password

        const dataUser = {id: user.id, username: user.username, email: user.email}

        const token = jwt.sign(dataUser, process.env.TOKEN, {expiresIn: '1h'})
        return res.status(200).json({success: 'true', message: 'Sign in berhasil', token})

    })
})

router.get('/protected', authenticateToken, (req,res) => {
    res.json({message : 'Ini adalah data yang dilindungi', user: req.user})
})

module.exports = router