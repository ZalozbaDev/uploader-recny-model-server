import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { parseOutputFormat } from '../../helpers/parser.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel, OutputFormat } from '../../types/common.ts'

export const transcript = (app: Express) =>
  app.post('/upload', upload.single('file'), async (req: Request, res: Response) => {
    if (app.locals.currentTranscriptRuns >= 5)
      return res
        .status(400)
        .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

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
    app.locals.currentTranscriptRuns += 1
    const sanitizedFilename = sanitize(filename)

    res.status(200).send('File uploaded successfully')

    console.log(`will execute: src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} ${parseOutputFormat(
        outputFormat
        )} uploads/${token}/progress.txt`)
    
    exec(
      `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} ${parseOutputFormat(
        outputFormat
      )} uploads/${token}/progress.txt`,
      { maxBuffer: 1024 * 1024 * 20 }, // 20 MB statt 200 KB
      (error, stdout, stderr) => {
        app.locals.currentTranscriptRuns -= 1

        console.log(`stdout: ${stdout}`)
        console.error(`stderr: ${stderr}`)

        if (error !== null) {
          console.log(`exec error: ${error}`)
          return res.status(400).send('Error')
        }
      }
    )
  })
