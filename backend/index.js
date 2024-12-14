const express = require('express')
const app = express()
const path = require('path')

app.use(express.json())

const userRouter = require('./user.js')
const videotapeRouter = require('./videotape.js')
app.use('/', userRouter)
app.use('/', videotapeRouter)
app.use('/backend/images_videotape', express.static(path.join(__dirname, 'backend/images_videotape')))

app.listen(3000, () => console.log('Your server is running on 3000'))