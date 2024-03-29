import { Express } from 'express'
import { SERVER_MODE } from '../../types/common.ts'
import { transcript } from './transcript.ts'
import { slownik } from './slownik.ts'

export const addUploadRoute = (app: Express) => {
  switch (process.env.SERVER_MODE as SERVER_MODE) {
    case 'TRANSCRIPT':
      transcript(app)
      break

    case 'FONETISIKI_SLOWNIK':
      slownik(app)
      break

    default:
      break
  }
}
