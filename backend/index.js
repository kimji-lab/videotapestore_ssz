const express = require('express')
const app = express()
const path = require('path')
const cors = require('cors')

const userRouter = require('./user.js')
const videotapeRouter = require('./videotape.js')

app.use(express.json())
app.use(cors())
app.use('/images_videotape', express.static('images_videotape'))
app.use('/backend/images_videotape', express.static(path.join(__dirname, 'backend/images_videotape')));
app.use('/api/videotapes', videotapeRouter)

app.use('/', userRouter)

app.listen(3000, () => console.log('Your server is running on 3000'))