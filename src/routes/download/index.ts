import { Express, Request, Response } from 'express'
import { removeExtension, parseOutputFormat } from '../../helpers/parser.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { OutputFormat, isOutputFormat } from '../../types/common.ts'

export const addDownloadRoute = (app: Express) =>
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
