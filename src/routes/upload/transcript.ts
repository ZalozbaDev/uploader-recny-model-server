import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel } from '../../types/common.ts'

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
      (error, stdout, stderr) => {
        app.locals.currentTranscriptRuns -= 1
        if (error !== null) {
          console.log(`exec error: ${error}`)
          return res.status(400).send('Error')
        }
      }
    )
  })

  app.get('/models', async (req: Request, res: Response) => {
    res.status(200).send([
      {
        name: 'HF',
        title: 'powšitkowny KI model (doporučene)',
        description:
          'za powŝitkowne rozmołwy - HuggingFace Whisper "small" wusměrjene na Hornjoserbšćinu',
        srt: false,
        diarization: false,
        vad: false
      },
      {
        name: 'FHG',
        title: 'powšitkowny klasiski model',
        description: 'hišće njeje přistupne - Fraunhofer recIKTS',
        srt: false,
        diarization: false,
        vad: false
      },
      {
        name: 'EURO',
        title: 'KI model Europeady 2022',
        description:
          'za transkript Europeady - HuggingFace Whisper "base" wusměrjene na hry Europeady 2022',
        srt: false,
        diarization: false,
        vad: false
      },
      {
        name: 'FB',
        title: 'wjacerěčny KI model',
        description: 'za powŝitkowne rozmołwy - Facebook MMS',
        srt: false,
        diarization: false,
        vad: false
      },
      {
        name: 'BOZA_MSA',
        title: 'klasiski model za bože mšě',
        description: 'wusměrjene na cyrkwinsku rěč - Fraunhofer recIKTS',
        srt: false,
        diarization: false,
        vad: false
      },
      {
        name: 'DEVEL',
        title: 'simulator',
        description: 'jenož za wuwiwarjow',
        srt: false,
        diarization: false,
        vad: false
      }
    ])
  })
}
