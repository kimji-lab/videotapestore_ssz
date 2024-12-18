const express = require('express')
const multer = require('multer')
const path = require('path')
const database = require('./database.js')
const router = express.Router()

console.log('Configuring videotape routes...');

const uploadDir = 'images_videotape';
if (!require('fs').existsSync(uploadDir)) {
  require('fs').mkdirSync(uploadDir, { recursive: true });
  console.log('Created upload directory:', uploadDir);
}

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir)
  },
  filename: function (req, file, cb) {
    const filename = Date.now() + path.extname(file.originalname);
    console.log(filename);
    cb(null, filename)
  }
})

const upload = multer({ storage: storage })

router.post('/videotapes/create', upload.single('image'), (req, res) => {
  console.log('Received create request');
  console.log('Request body:', req.body);
  console.log('File:', req.file);

  try {
    const { videoTapeId, title, price, description, genreId, tapeLevel } = req.body;
    const imagePath = req.file ? `${uploadDir}/${req.file.filename}` : '';

    const sqlQuery = 'INSERT INTO videotape (videoTapeId, title, price, description, genreId, tapeLevel, imagePath) VALUES (?,?,?,?,?,?,?)';
    
    database.query(sqlQuery, [videoTapeId, title, price, description, genreId, tapeLevel, imagePath], (err, result) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).json({ message: err.message });
      }
      
      console.log('Insert successful:', result);
      res.status(201).json({
        message: 'Videotape created successfully',
        data: {
          videoTapeId,
          title,
          imagePath
        }
      });
    });
  } catch (error) {
    console.error('Server error:', error);
    res.status(500).json({ message: error.message });
  }
});

//read
router.get('/videotapes/read', (req,res) => {
    const { videoTapeId } = req.params

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

// read all videotapes or filter by genre
router.get('/videotapes/readAll', (req, res) => {
  const { genreName } = req.query;  

  let sqlQuery = 'SELECT * FROM videotape';
  let params = [];

  if (genreName && genreName !== 'All') {
      sqlQuery = `
          SELECT vt.*, g.genreName
          FROM videotape vt
          LEFT JOIN genre g ON vt.genreId = g.genreId
      `;
      sqlQuery += ' WHERE g.genreName = ?';  
      params.push(genreName);
  }

  database.query(sqlQuery, params, (err, results) => {
      if (err) {
          return res.status(500).json({ message: err.message });
      }
      res.status(200).json(results);
  });
});



//update
router.put('/videotapes/update', (req,res) => {
    const {videoTapeId,title, price, description, genreId, tapeLevel, imagePath} = req.body

    const sqlQuery = 'UPDATE videotape SET title = ?, price = ?, description = ?, genreId = ?, tapeLevel = ?, imagePath = ? WHERE videoTapeId = ?'
    database.query(sqlQuery, [title, price, description, genreId, tapeLevel, imagePath, videoTapeId], (err, results) => {
        if(err) {
            return res.status(500).json({message: err.message})
        } 
        if(results.affectedRows === 0) {
            return res.status(404).json({message: 'Videotape tidak ditemukan'})
        }
        res.status(200).json({message: 'Videotape berhasil diupdate'})
    })
})

//delete
router.delete('/videotapes/delete', (req,res) => {
    const videoTapeId = req.body.videoTapeId

    const sqlQuery = 'DELETE FROM videotape WHERE videoTapeId = ?'
    database.query(sqlQuery, [videoTapeId], (err,results) => {
        if(err) {
            return res.status(500).json({message: err.message})
        }
        if(results.affectedRows === 0) {
            return res.status(404).json({message: 'Videotape tidak ditemukan'})
        }
        res.status(200).json({message: 'Videotape berhasil dihapus'})
    })
})

module.exports = router