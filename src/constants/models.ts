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
    name: 'HF',
    title: 'powšitkowny KI model (doporučene)',
    description:
      'za powŝitkowne rozmołwy - HuggingFace Whisper "small" wusměrjene na Hornjoserbšćinu',
    srt: false,
    diarization: false,
    vad: false,
    language: Language.HSB,
    source: 'https://huggingface.co/models?search=whisper'
  },
  {
    name: 'FHG',
    title: 'powšitkowny klasiski model',
    description: 'hišće njeje přistupne - Fraunhofer recIKTS',
    srt: false,
    diarization: false,
    vad: false
  },
  {
    name: 'EURO',
    title: 'KI model Europeady 2022',
    description:
      'za transkript Europeady - HuggingFace Whisper "base" wusměrjene na hry Europeady 2022',
    srt: false,
    diarization: false,
    vad: false
  },
  {
    name: 'FB',
    title: 'wjacerěčny KI model',
    description: 'za powŝitkowne rozmołwy - Facebook MMS',
    srt: false,
    diarization: false,
    vad: false
  },
  {
    name: 'BOZA_MSA',
    title: 'klasiski model za bože mšě',
    description: 'wusměrjene na cyrkwinsku rěč - Fraunhofer recIKTS',
    srt: false,
    diarization: false,
    vad: false
  },
  {
    name: 'DEVEL',
    title: 'simulator',
    description: 'jenož za wuwiwarjow',
    srt: false,
    diarization: false,
    vad: false
  }
]
