const express = require('express')
const mysql2 = require('mysql2')
const path = require('path')
const database = require('./database.js')
const { route } = require('./user.js')

const router = express.Router()

//create / insert
router.post('/videotapes/create', (req,res) => {
    const {videoTapeId, title, price, description, genreId, tapeLevel, imagePath} = req.body

    const sqlQuery = 'INSERT INTO videotape (videoTapeId, title, price, description, genreId, tapeLevel, imagePath) VALUES (?,?,?,?,?,?,?)'

    database.query(sqlQuery, [videoTapeId, title, price, description, genreId, tapeLevel, imagePath], (err,data,fields) => {
        if(err) {
            return res.status(500).json({message: err.message})
        } else {
            return res.status(201).json({message: 'Videotape berhasil dibuat'})
        }
    })
})

//read
router.get('/videotapes/read', (req,res) => {
    const videoTapeId = req.body.videoTapeId

    const sqlQuery = 'SELECT * FROM videotape WHERE videoTapeId = ?'
    database.query(sqlQuery, [videoTapeId], (err, results) => {
        if(err) {
            return res.status(500).json({message: err.message})
        }
        if(results.length === 0) {
            return res.status(404).json({ message: 'Videotape tidak ditemukan' });
          }
        res.status(200).json(results[0])
    })
    
})

//update
router.get('/videotapes/update', (req,res) => {
    const {videoTapeId,title, price, description, genreId, tapeLevel, imagePath} = req.body

    const sqlQuery = 'UPDATE videotape SET title = ?, price = ?, description = ?, genreId = ?, tapeLevel = ?, imagePath = ? WHERE videoTapeId = ?'
    database.query(sqlQuery, [title, price, description, genreId, tapeLevel, imagePath, videoTapeId], (err, results) => {
        if(err) {
            return res.status(500).json({message: err.message})
        } 
        if(results.length === 0) {
            return res.status(404).json({message: 'Videotape tidak ditemukan'})
        }
        res.status(200).json({message: 'Videotape berhasil diupdate'})
    })
})

//delete
router.get('/videotapes/delete', (req,res) => {
    const videoTapeId = req.body.videoTapeId

    const sqlQuery = 'DELETE FROM videotape WHERE videoTapeId = ?'
    database.query(sqlQuery, [videoTapeId], (err,results) => {
        if(err) {
            return res.status(500).json({message: err.message})
        }
        if(results.length === 0) {
            return res.status(404).json({message: 'Videotape tidak ditemukan'})
        }
        res.status(200).json({message: 'Videotape berhasil dihapus'})
    })
})

module.exports = router