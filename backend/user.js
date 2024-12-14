const express = require('express')
const router = express.Router()
const bcrypt = require('bcrypt')
require('dotenv').config()
const jwt = require('jsonwebtoken')
const database = require('./database.js')
const { authenticateToken } = require('./middleware.js')

router.post('/signup', async (req,res) => {
    const {username, email, password, roles} = req.body

    if(!username || !email || !password) {
        return res.status(400).json({message: 'Data belum terisi seluruhnya'})
    }

    const userRole = roles === 'admin' ? 'admin' : 'user'

    const hashedPassword = await bcrypt.hash(password, 10)

    const sqlQuery = 'INSERT INTO users (username, email, password, roles) VALUES (?,?,?,?)'

    database.query(sqlQuery, [username, email, hashedPassword, userRole], function(err,data,fields) {
        if(err) {
            return res.status(500).json({message: err.message})
        } else {
            return res.status(201).json({message: 'Sign up berhasil'})
        }
    })
})

router.post('/signin', async (req,res) => {
    const {username, password} = req.body

    if(!username || !password) {
        return res.status(400).json({message: 'Data belum terisi seluruhnya'})
    }

    const sqlQuery = 'SELECT * FROM users WHERE username = ?'

    database.query(sqlQuery, [username], async (err, results) => {
        if(err) {
            return res.status(500).json({message : err.message})
        } 
        if(results.length === 0) {
            return res.status(404).json({message: 'User tidak ditemukan'})
        } 

        const user = results[0]
        const comparePassword =  await bcrypt.compare(password, user.password)

        if(!comparePassword) {
            return res.status(401).json({message: 'Password salah'})
        }
        
        delete user.password
        
        const token = jwt.sign({id: user.id, username: user.username, role: user.roles}, process.env.TOKEN, {expiresIn: '1h'})
        return res.status(200).json({token, role: user.roles, username: user.username})

    })
})

router.get('/protected', authenticateToken, (req,res) => {
    res.json({message : 'Ini adalah data yang dilindungi', user: req.user})
})

module.exports = router