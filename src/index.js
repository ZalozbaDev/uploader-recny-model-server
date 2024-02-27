import express from 'express'
import dotenv from 'dotenv'
import cors from 'cors'
import { exec } from 'child_process'
import multer from 'multer'
import * as fs from 'fs'
//For env File
dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

const port = process.env.PORT || 8000

// setup multer for file upload
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    let token = req.body.token
    let path = `./uploads/${token}`
    fs.mkdirSync(path)
    cb(null, path)
  },
  filename: function (req, file, cb) {
    cb(null, `/${file.originalname}`)
  }
})

const upload = multer({ storage: storage })

app.get('/status', async (req, res) => {
  if (req.query.token === undefined) {
    res.status(400).send('Token is required')
  }
  await exec(`cat uploads/${req.query.token}/progress.txt | tail -1`, (error, stdout, stderr) => {
    if (error !== null) {
      console.log(`exec error: ${error}`)
      res.status(400).send('Error')
    }

    res.send(stdout)
  })
})

app.post('/upload', upload.single('file'), async (req, res) => {
  const { token, fileName, languageModel, outputFormat } = req.body

  if (
    token === undefined ||
    fileName === undefined ||
    languageModel === undefined ||
    outputFormat === undefined
  ) {
    return res.status(400).send('token, fileName, languageModel, outputFormat is required')
  }

  exec(
    `src/scripts/create_transcript.sh ${token} uploads/${token}/${fileName} ${languageModel} ${outputFormat} uploads/${token}/progress.txt`,
    (error, stdout, stderr) => {
      console.log(stdout)
      console.log(stderr)
      if (error !== null) {
        console.log(`exec error: ${error}`)
        return res.status(400).send('Error')
      }
    }
  )

  return res.send('Start')
})

app.listen(port, () => {
  console.log(`Server is Fire at http://localhost:${port}`)
})
