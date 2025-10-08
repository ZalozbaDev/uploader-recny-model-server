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

let port = 0
switch (process.env.SERVER_MODE) {
  case 'FONETISIKI_SLOWNIK':
    port = Number(process.env.PORT_SLOWNIK)
    break
  case 'TRANSCRIPT':
    port = Number(process.env.PORT_TRANSCRIPT)
    break
  case 'AI_DUBBING':
    port = Number(process.env.PORT_AI_DUBBING)
    break
  default:
    console.error('SERVER_MODE is not set correctly in .env file')
    process.exit(1)
}

addStatusRoute(app)
addDownloadRoute(app)
addUploadRoute(app)

app.listen(port, () => {
  console.log(`Server ${process.env.SERVER_MODE} is Fire at http://localhost:${port} 🚀`)
})
