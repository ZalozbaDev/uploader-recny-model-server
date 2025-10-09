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
    title: 'hornjoserbski KI model "Whisper" (doporučeny)',
    description: 'powšitkowne rozmołwy',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.HSB,
    source: 'https://...',
    forceAlign: false
  },
  {
    name: 'HFDSB',
    title: 'delnoserbski KI model "Whisper" (dokładny, pomały)',
    description: 'za rozmołwy wšědneho dnja',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.DSB,
    source: 'https://...',
    forceAlign: false
  },
  {
    name: 'BOZA_MSA',
    title: 'hornjoserbski klasiski model za bože mšě',
    description: 'm.d. tež bibliske teksty - Fraunhofer recIKTS',
    srt: true,
    diarization: false,
    vad: true,
    language: Language.HSB,
    source: 'Fraunhofer recIKTS',
    forceAlign: false
  },
  {
    name: 'GERMAN',
    title: 'rěčne spóznawanje němčiny',
    description: 'na př. za protokoly konferencow',
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
    description: 'za wuwiwarjow (ryzy spóznawanje)',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'xxx',
    forceAlign: false
  },
  {
    name: 'WAV2VEC2',
    title: 'powšitkowny hornjoserbski KI model "Wav2Vec2" (doporučeny)',
    description: 'na př. wobchadnorěčne rozmołwy',
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
