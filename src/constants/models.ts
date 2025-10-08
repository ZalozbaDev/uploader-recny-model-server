import { Language } from '../types/common.ts'

export type Model = {
  name: string
  title: string
  description: string
  srt: boolean
  diarization: boolean
  vad: boolean
  language: Language
  source: string
}
export const models: Model[] = [
  {
    name: 'HFHSB',
    title: 'powšitkowny KI model (doporučene)',
    description: 'za powsitkowne rozmołwy',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.HSB,
    source: 'https://...'
  },
  {
    name: 'HFDSB',
    title: 'powšitkowny KI model (dokladne, pomalu)',
    description: 'za powsitkowne rozmołwy',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.DSB,
    source: 'https://...'
  },
  {
    name: 'BOZA_MSA',
    title: 'klasiski model za bože mšě',
    description: 'wusměrjene na cyrkwinsku rěč - Fraunhofer recIKTS',
    srt: true,
    diarization: false,
    vad: true,
    language: Language.HSB,
    source: 'Fraunhofer recIKTS'
  },
  {
    name: 'DEVEL',
    title: 'simulator',
    description: 'jenož za wuwiwarjow',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'xxx'
  }
]
