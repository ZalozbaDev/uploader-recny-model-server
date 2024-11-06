import { Express, Request, Response } from 'express'
import { removeExtension, parseOutputFormat, parseLexFormat } from '../../helpers/parser.ts'
import { sanitize } from '../../helpers/sanitize.ts'
import { OutputFormat, isOutputFormat, LexFormat, isLexFormat } from '../../types/common.ts'

export const addDownloadRoute = (app: Express) =>
  app.get('/download', async (req: Request, res: Response) => {
    const { token, filename, outputFormat } = req.query as {
      token: string | undefined
      filename: string | undefined
      outputFormat: string | undefined
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
    } else if (isLexFormat(outputFormat)) {
      const file = `uploads/${token}/${removeExtension(sanitizedFilename)}.${parseLexFormat(
        outputFormat
      )}`

      return res.download(file)
    } else {
      return res.status(400).send('Invalid filepath')
    }
  })
