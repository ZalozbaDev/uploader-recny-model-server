import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import { SERVER_MODE } from './types/common.js'
import { addDownloadRoute } from './routes/download/index.ts'
import { addStatusRoute } from './routes/status/index.ts'
import { addUploadRoute } from './routes/upload/index.ts'

//For env File
dotenv.config()

const app = express()

app.use(cors())
app.use(express.json())
app.locals.currentTranscriptRuns = 0
app.locals.currentSlowniktRuns = 0

const port =
  (process.env.SERVER_MODE as SERVER_MODE) === 'FONETISIKI_SLOWNIK'
    ? process.env.PORT_SLOWNIK
    : process.env.PORT_TRANSCRIPT

addStatusRoute(app)
addDownloadRoute(app)
addUploadRoute(app)

app.listen(port, () => {
  console.log(`Server ${process.env.SERVER_MODE} is Fire at http://localhost:${port} 🚀`)
})
