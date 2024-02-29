import express, { Request, Response } from 'express'
import cors from 'cors'
import { exec } from 'child_process'
import dotenv from 'dotenv'
import { parseOutputFormat } from './helpers/parser.js'
import { upload } from './multer.js'

//For env File
dotenv.config()

const app = express()
app.use(cors())
app.use(express.json())

const port = process.env.PORT || 8000

app.get('/status', async (req: Request, res: Response) => {
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

app.get('/download', async (req: Request, res: Response) => {
  if (req.query.filename === undefined) {
    return res.status(400).send('Filename is required')
  }
  if (req.query.token === undefined) {
    return res.status(400).send('Filename is required')
  }
  const file = `uploads/${req.query.token}/${req.query.filename}`

  return res.download(file)
})

app.post('/upload', upload.single('file'), async (req: Request, res: Response) => {
  const { token, fileName, languageModel, outputFormat } = req.body as {
    token: string | undefined
    fileName: string | undefined
    languageModel: LanguageModel | undefined
    outputFormat: OutputFormat | undefined
  }

  if (
    token === undefined ||
    fileName === undefined ||
    languageModel === undefined ||
    outputFormat === undefined
  ) {
    return res.status(400).send('token, fileName, languageModel, outputFormat is required')
  }

  // TODO: parseOutputFormat

  res.status(200).send('File uploaded successfully')

  exec(
    `src/scripts/create_transcript.sh ${token} uploads/${token}/${fileName} ${languageModel} ${parseOutputFormat(
      outputFormat
    )} uploads/${token}/progress.txt`,
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
