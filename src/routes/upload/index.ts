import { Express } from 'express'
import { SERVER_MODE } from '../../types/common.js'
import { transcript } from './transcript.js'
import { slownik } from './slownik.js'
import { aiDubbing } from './aiDubbing.js'

export const addUploadRoute = (app: Express) => {
  switch (process.env.SERVER_MODE as SERVER_MODE) {
    case SERVER_MODE.TRANSCRIPT:
      transcript(app)
      break

    case SERVER_MODE.FONETISIKI_SLOWNIK:
      slownik(app)
      break

    case SERVER_MODE.DUBBING:
      aiDubbing(app)
      break

    default:
      break
  }
}
