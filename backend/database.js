const express = require('express')
var mysql2 = require('mysql2')

var connection = mysql2.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'videotapestore_ssz'
})

connection.connect(function(err){
    if(err) throw err
        console.log('Database connect')
})

module.exports = connection