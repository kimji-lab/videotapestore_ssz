const express = require('express')
const mysql2 = require('mysql2')

const connection = mysql2.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'videotapestore_ssz'
})

connection.connect()
module.exports = connection