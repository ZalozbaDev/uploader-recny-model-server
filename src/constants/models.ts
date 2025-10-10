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
    source: 'https://huggingface.co/spaces/Korla/hsb_stt_demo',
    forceAlign: false
  },
  {
    name: 'HFHSBBIG',
    title: 'hornjoserbski KI model "Whisper" (dokładny, pomały)',
    description: 'za rozmołwy wšědneho dnja',
    srt: true,
    diarization: true,
    vad: true,
    language: Language.HSB,
    source: 'https://huggingface.co/Korla/whisper-large-v3-turbo-hsb',
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
    source: 'https://huggingface.co/Korla/whisper-large-v3-turbo-dsb',
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
    source: 'https://www.ikts.fraunhofer.de/de/abteilungen/elektronik_mikrosystem_biomedizintechnik/pruef_analysesysteme/kognitive_materialdiagnostik.html',
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
    source: 'https://huggingface.co/openai/whisper-large-v2',
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
    source: 'jenoz za wuwice',
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
    source: 'https://huggingface.co/Korla/Wav2Vec2BertForCTC-hsb',
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
    source: 'jenoz za wuwice',
    forceAlign: true
  }
]
