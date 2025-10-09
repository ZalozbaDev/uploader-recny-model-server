import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel } from '../../types/common.ts'

export const slownik = (app: Express) =>
  app.post(
    '/upload',
    upload.fields([
      { name: 'korpus', maxCount: 1 },
      { name: 'exceptions', maxCount: 1 },
      { name: 'phonmap', maxCount: 1 }
    ]),
    async (req: Request, res: Response) => {
      if (app.locals.currentSlowniktRuns > 5)
        return res
          .status(400)
          .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

      const { filename, languageModel, korpusname, phonmapname, exceptionsname } = req.body as {
        filename: string | undefined
        languageModel: LanguageModel | undefined
        korpusname: string | undefined
        phonmapname: string | undefined
        exceptionsname: string | undefined
      }

      // Get token from query parameters (required for multer) or body as fallback
      const token = (req.query.token as string) || req.body.token

      if (
        token === undefined ||
        filename === undefined ||
        languageModel === undefined ||
        korpusname === undefined ||
        phonmapname === undefined ||
        exceptionsname === undefined
      ) {
        return res
          .status(400)
          .send(
            'token, filename, languageModel, outputFormat, korpusname, phonmapname, exceptionsname is required'
          )
      }

      app.locals.currentSlowniktRuns += 1
      const sanitizedFilename = sanitize(filename)

      res.status(200).send('File uploaded successfully')

      console.log(
        `will execute: script ${token} uploads/${token}/${sanitizedFilename} ${languageModel} uploads/${token}/phonmap/${phonmapname} uploads/${token}/exceptions/${exceptionsname} uploads/${token}/korpus/${korpusname} ${languageModel} uploads/${token}/progress.txt`
      )

      exec(
        `src/scripts/create_dictionary.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} uploads/${token}/phonmap/${phonmapname} uploads/${token}/exceptions/${exceptionsname} uploads/${token}/korpus/${korpusname} ${languageModel} uploads/${token}/progress.txt`,
        { maxBuffer: 1024 * 1024 * 20 }, // 20 MB statt 200 KB
        (error, stdout, stderr) => {
          app.locals.currentSlowniktRuns -= 1

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
