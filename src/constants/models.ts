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
    title: 'powšitkowny KI model "Whisper" (doporučene)',
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
    title: 'powšitkowny KI model "Whisper" (dokladne, pomalu)',
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
    name: 'GERMAN',
    title: 'spoznawanje za Nemcinu',
    description: 'na priklad protokol zetkanja',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.DE,
    source: 'whisper large',
    forceAlign: false
  },
  {
    name: 'DEVEL',
    title: 'simulator',
    description: 'jenož za wuwiwarjow (spoznawanje)',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'xxx',
    forceAlign: false
  },
  {
    name: 'WAV2VEC2',
    title: 'powšitkowny KI model "Wav2Vec2" (doporučene)',
    description: 'za powsitkowne rozmołwy',
    srt: true,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'https://...',
    forceAlign: true
  },
  {
    name: 'DEVEL',
    title: 'simulator',
    description: 'jenož za wuwiwarjow (forcealign)',
    srt: true,
    diarization: false,
    vad: false,
    language: Language.DSB,
    source: 'xxx',
    forceAlign: true
  }
]
