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
    if (!fs.existsSync(path)) {
      fs.mkdirSync(path)
      cb(null, path)
    }
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
  await exec(`cat uploads/${req.query.token}/progress.txt`, (error, stdout, stderr) => {
    if (error !== null) {
      console.log(`exec error: ${error}`)
      res.status(400).send('Error')
    }

    const firstLine = stdout.split('\n')[0]
    const lastLine = stdout.split('\n')[stdout.split('\n').length - 2]
    const stdoutLinesCount = stdout.split('\n').length

    res.send({
      duration: stdoutLinesCount <= 2 ? -1 : firstLine, // in seconds
      done: lastLine.split('|')[0] === '100',
      status: lastLine.split('|')[0],
      message: lastLine.split('|')[1]
    })
  })
})

app.get('/download', async (req, res) => {
  if (req.query.filename === undefined) {
    return res.status(400).send('Filename is required')
  }
  if (req.query.token === undefined) {
    return res.status(400).send('Filename is required')
  }
  const file = `uploads/${req.query.token}/${req.query.filename}`

  return res.download(file) // Set disposition and send it.
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

  res.status(200).send('File uploaded successfully')

  exec(
    `src/scripts/create_transcript.sh ${token} uploads/${token}/${fileName} ${languageModel} ${outputFormat} uploads/${token}/progress.txt`,
    (error, stdout, stderr) => {
      if (error !== null) {
        console.log(`exec error: ${error}`)
        return res.status(400).send('Error')
      }
    }
  )
})

app.listen(port, () => {
  console.log(`Server is Fire at http://localhost:${port}`)
})
