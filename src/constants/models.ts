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
  forceAlign: boolean
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
    source: 'https://...',
    forceAlign: false
  },
  {
    name: 'HFDSB',
    title: 'powšitkowny KI model (dokladne, pomalu)',
    description: 'za powsitkowne rozmołwy',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.DSB,
    source: 'https://...',
    forceAlign: false
  },
  {
    name: 'BOZA_MSA',
    title: 'klasiski model za bože mšě',
    description: 'wusměrjene na cyrkwinsku rěč - Fraunhofer recIKTS',
    srt: true,
    diarization: false,
    vad: true,
    language: Language.HSB,
    source: 'Fraunhofer recIKTS',
    forceAlign: false
  },
  {
    name: 'DEVEL',
    title: 'simulator',
    description: 'jenož za wuwiwarjow',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'xxx',
    forceAlign: false
  }
]
