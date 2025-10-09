import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel } from '../../types/common.ts'
import { models } from '../../constants/models.ts'

export const transcript = (app: Express) => {
  app.post(
    '/upload',
    upload.fields([
      { name: 'audioFile', maxCount: 1 },
      { name: 'textFile', maxCount: 1 }
    ]),
    async (req: Request, res: Response) => {
      console.log('🚀 UPLOAD REQUEST RECEIVED - lets start!')

      if (app.locals.currentTranscriptRuns >= 5)
        return res
          .status(400)
          .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

      const { model, translate, diarization, vad } = req.body as {
        model: LanguageModel | undefined
        translate: boolean | undefined
        diarization: number | undefined
        vad: boolean | undefined
      }

      // Get token from query parameters (required for multer) or body as fallback
      const token = (req.query.token as string) || req.body.token

      // Get uploaded files
      const files = req.files as { [fieldname: string]: Express.Multer.File[] }
      const audioFile = files?.audioFile?.[0]
      const textFile = files?.textFile?.[0]

      console.log(req.body)
      if (
        token === undefined ||
        !audioFile ||
        model === undefined ||
        translate === undefined ||
        diarization === undefined ||
        vad === undefined
      ) {
        return res
          .status(400)
          .send('token, audioFile, model, translate, diarization, vad is required')
        return
      }
      app.locals.currentTranscriptRuns += 1
      const sanitizedAudioFilename = sanitize(audioFile.originalname)
      let executionScript = `src/scripts/create_transcript.sh ${token} uploads/${token}/${sanitizedAudioFilename} ${model} uploads/${token}/progress.txt ${translate} ${diarization} ${vad}`
      if (textFile) {
        const sanitizedTextFilename = sanitize(textFile.originalname)
        executionScript = `src/scripts/create_forcealign.sh ${token} uploads/${token}/${sanitizedAudioFilename} uploads/${token}/${sanitizedTextFilename} ${model} uploads/${token}/progress.txt ${translate}`
      }
      console.log(executionScript)
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
    }
  )

  app.get('/models', async (req: Request, res: Response) => {
    res.status(200).send(models)
  })
}
