const express = require('express')
const app = express()

app.use(express.json())

const userRouter = require('./user.js')
app.use('/user', userRouter)

app.listen(3000, () => console.log('Your server is running on 3000'))