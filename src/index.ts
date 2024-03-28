import express, { Request, Response } from 'express'
import cors from 'cors'
import { exec } from 'child_process'
import dotenv from 'dotenv'
import { parseOutputFormat, removeExtension } from './helpers/parser.js'
import { upload } from './helpers/multer.ts'
import { LanguageModel, OutputFormat, isOutputFormat } from './types/common.js'
import { sanitize } from './helpers/sanitize.js'

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
  const { token, filename, outputFormat } = req.query as {
    token: string | undefined
    filename: string | undefined
    outputFormat: OutputFormat | undefined
  }

  if (token === undefined || filename === undefined || outputFormat === undefined) {
    return res.status(400).send('token, filename, outputFormat is required')
  }
  const sanitizedFilename = sanitize(filename)
  if (isOutputFormat(outputFormat)) {
    const file = `uploads/${token}/${removeExtension(sanitizedFilename)}.${parseOutputFormat(
      outputFormat
    )}`

    return res.download(file)
  } else {
    return res.status(400).send('Invalid filepath')
  }
})

switch (process.env.SERVER_MODE) {
  case 'TRANSKRIPT':
    app.post('/upload', upload.single('file'), async (req: Request, res: Response) => {
      const { token, filename, languageModel, outputFormat } = req.body as {
        token: string | undefined
        filename: string | undefined
        languageModel: LanguageModel | undefined
        outputFormat: OutputFormat | undefined
      }

      if (
        token === undefined ||
        filename === undefined ||
        languageModel === undefined ||
        outputFormat === undefined
      ) {
        return res.status(400).send('token, filename, languageModel, outputFormat is required')
      }
      const sanitizedFilename = sanitize(filename)

      res.status(200).send('File uploaded successfully')

      exec(
        `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} ${parseOutputFormat(
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
    break

  case 'FONETISIKI_SLOWNIK':
    app.post(
      '/upload',
      upload.fields([{ name: 'korpus' }, { name: 'exceptions' }, { name: 'phonmap' }]),
      async (req: Request, res: Response) => {
        const { token, filename, languageModel, outputFormat } = req.body as {
          token: string | undefined
          filename: string | undefined
          languageModel: LanguageModel | undefined
          outputFormat: OutputFormat | undefined
        }

        if (
          token === undefined ||
          filename === undefined ||
          languageModel === undefined ||
          outputFormat === undefined
        ) {
          return res.status(400).send('token, filename, languageModel, outputFormat is required')
        }
        const sanitizedFilename = sanitize(filename)

        res.status(200).send('File uploaded successfully')

        // exec(
        //   `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} ${parseOutputFormat(
        //     outputFormat
        //   )} uploads/${token}/progress.txt`,
        //   (error, stdout, stderr) => {
        //     if (error !== null) {
        //       console.log(`exec error: ${error}`)
        //       return res.status(400).send('Error')
        //     }
        //   }
        // )
      }
    )
    break

  default:
    break
}

app.listen(port, () => {
  console.log(`Server ${process.env.SERVER_MODE} is Fire at http://localhost:${port} 🚀`)
})
