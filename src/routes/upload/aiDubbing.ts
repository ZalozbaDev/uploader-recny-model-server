import { Express, Request, Response } from 'express'
import { exec } from 'child_process'
import { upload } from '../../helpers/multer.ts'

export const aiDubbing = (app: Express) =>
  app.post(
    '/upload',
    upload.fields([
      { name: 'audioFile', maxCount: 1 },
      { name: 'srtFile', maxCount: 1 }
    ]),
    async (req: Request, res: Response) => {
      if (app.locals.currentSlowniktRuns > 5)
        return res
          .status(400)
          .send('Wšitke servere su hižo wobsadźene. Prošu spytaj pozdźišo hišće raz.')

      const { audioFileName, srtFileName } = req.body as {
        audioFileName: string | undefined
        srtFileName: string | undefined
      }

      // Get token from query parameters (required for multer) or body as fallback
      const token = (req.query.token as string) || req.body.token

      if (token === undefined || audioFileName === undefined) {
        return res.status(400).send('token, audioFile is required')
      }

      app.locals.currentSlowniktRuns += 1

      res.status(200).send('File uploaded successfully')

      console.log(
        `will execute: script ${token} uploads/${token}/${audioFileName} uploads/${token}/progress.txt ${
          srtFileName !== undefined ? 'true' : 'false'
        } uploads/${token}/${srtFileName}`
      )

      exec(
        `src/scripts/create_dubbing.sh ${token} uploads/${token}/${audioFileName} uploads/${token}/progress.txt ${
          srtFileName !== undefined ? 'true' : 'false'
        } uploads/${token}/${srtFileName}`,
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
