import { Express } from 'express'
import { SERVER_MODE } from '../../types/common.ts'
import { transcript } from './transcript.ts'
import { slownik } from './slownik.ts'
import { aiDubbing } from './aiDubbing.ts'

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
