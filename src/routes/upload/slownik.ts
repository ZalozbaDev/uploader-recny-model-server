import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'
import { parseOutputFormat } from '../../helpers/parser.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { LanguageModel, OutputFormat } from '../../types/common.ts'

export const slownik = (app: Express) =>
  app.post(
    '/upload',
    upload.fields([{ name: 'korpus' }, { name: 'exceptions' }, { name: 'phonmap' }]),
    async (req: Request, res: Response) => {
      if (app.locals.currentSlowniktRuns > 5)
        return res
          .status(400)
          .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

      const {
        token,
        filename,
        languageModel,
        outputFormat,
        korpusname,
        phonmapname,
        exceptionsname
      } = req.body as {
        token: string | undefined
        filename: string | undefined
        languageModel: LanguageModel | undefined
        outputFormat: OutputFormat | undefined
        korpusname: string | undefined
        phonmapname: string | undefined
        exceptionsname: string | undefined
      }

      if (
        token === undefined ||
        filename === undefined ||
        languageModel === undefined ||
        outputFormat === undefined ||
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
        `script ${token} uploads/${token}/${sanitizedFilename} ${languageModel} uploads/${token}/phonmap/${phonmapname} uploads/${token}/exceptions/${exceptionsname} uploads/${token}/korpus/${korpusname} ${parseOutputFormat(
          outputFormat
        )} uploads/${token}/progress.txt`
      )

      exec(
        `src/scripts/create_dictionary.sh ${token} uploads/${token}/${sanitizedFilename} ${languageModel} uploads/${token}/phonmap/${phonmapname} uploads/${token}/exceptions/${exceptionsname} uploads/${token}/korpus/${korpusname} ${parseOutputFormat(
          outputFormat
        )} uploads/${token}/progress.txt`,
        (error, stdout, stderr) => {
          app.locals.currentSlowniktRuns -= 1
          if (error !== null) {
            console.log(`exec error: ${error}`)
            return res.status(400).send('Error')
          }
        }
      )
    }
  )
