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

    const { token, audioFile, model, translate, diarization, vad, textFile } = req.body as {
      token: string | undefined
      audioFile: string | undefined
      model: LanguageModel | undefined
      translate: boolean | undefined
      diarization: number | undefined
      vad: boolean | undefined
      textFile: string | null
    }

    if (
      token === undefined ||
      audioFile === undefined ||
      model === undefined ||
      translate === undefined ||
      diarization === undefined ||
      vad === undefined
    ) {
      return res
        .status(400)
        .send('token, audioFile, audioModel, translate, diarization, vad is required')
      return
    }
    app.locals.currentTranscriptRuns += 1
    const sanitizedAudioFilename = sanitize(audioFile)
    let executionScript = `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedAudioFilename} ${model} uploads/${token}/progress.txt ${translate} ${diarization} ${vad}`
    if (textFile) {
      const sanitizedTextFilename = sanitize(textFile)
      executionScript = `src/scripts/create_forcealign.sh ${token} uploads/${token}/${sanitizedAudioFilename} uploads/${token}/${sanitizedTextFilename} ${model} uploads/${token}/progress.txt ${translate}`
    }

    exec(
      executionScript,
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
