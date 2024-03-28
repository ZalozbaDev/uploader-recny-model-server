const languageModel = ['FHG', 'HF', 'FB', 'BOZA_MSA', 'DEVEL']
export type LanguageModel = (typeof languageModel)[number]
export const isLanguageModel = (x: any): x is LanguageModel => languageModel.includes(x)

export enum OutputFormat {
  'TXT' = 'TXT',
  'SRT' = 'SRT'
}
export const isOutputFormat = (x: any): x is OutputFormat => x in OutputFormat

export enum LexFormat {
  'SAMPA' = 'SAMPA',
  'KALDI' = 'KALDI',
  'UASR' = 'UASR'
}

export const isLexFormat = (x: any): x is LexFormat => x in LexFormat

export type SERVER_MODE = 'FONETISIKI_SLOWNIK' | 'TRANSKRIPT'
