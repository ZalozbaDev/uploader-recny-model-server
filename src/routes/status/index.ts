import { Express, Request, Response } from 'express'
import { exec } from 'child_process'

export const addStatusRoute = (app: Express) =>
  app.get('/status', async (req: Request, res: Response) => {
    if (req.query.token === undefined) {
      res.status(400).send('Token is required')
      return
    }

    await exec(`cat uploads/${req.query.token}/progress.txt`, (error, stdout, stderr) => {
      if (error !== null) {
        console.log(`exec error: ${error}`)
        res.status(400).send('Error')
        return
      }

      const firstLine = stdout.split('\n')[0]
      const lastLine = stdout.split('\n')[stdout.split('\n').length - 2]
      const stdoutLinesCount = stdout.split('\n').length

      res.send({
        duration: stdoutLinesCount <= 2 ? -1 : firstLine, // in seconds
        done: lastLine.split('|')[0] === '100',
        status: lastLine.split('|')[0],
        message: lastLine.split('|')[1]
      })
    })
  })
