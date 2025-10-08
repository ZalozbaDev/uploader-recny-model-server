import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel } from '../../types/common.ts'
import { models } from '../../constants/models.ts'

export const transcript = (app: Express) => {
  app.post('/upload', upload.single('file'), async (req: Request, res: Response) => {
    if (app.locals.currentTranscriptRuns >= 5)
      return res
        .status(400)
        .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

    const { token, filename, languageModel, translate, diarization, vad } = req.body as {
      token: string | undefined
      filename: string | undefined
      languageModel: LanguageModel | undefined
      translate: boolean | undefined
      diarization: number | undefined
      vad: boolean | undefined
    }

    if (
      token === undefined ||
      filename === undefined ||
      languageModel === undefined ||
      translate === undefined ||
      diarization === undefined ||
      vad === undefined
    ) {
      return res
        .status(400)
        .send('token, filename, languageModel, translate, diarization, vad is required')
      return
    }
    app.locals.currentTranscriptRuns += 1
    const sanitizedFilename = sanitize(filename)

    res.status(200).send('File uploaded successfully')

    exec(
      `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} uploads/${token}/progress.txt ${translate} ${diarization} ${vad}`,
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

  app.get('/models', async (req: Request, res: Response) => {
    res.status(200).send(models)
  })
}
