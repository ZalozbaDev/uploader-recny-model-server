const languageModel = ['FHG', 'HF', 'GMEJ', 'EURO', 'HFBIG', 'FB', 'BOZA_MSA', 'DEVEL', 'HF_PAU', 'HFBIG_PAU', 'BOZA_MSA_PAU', 'GMEJ_PAU']
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

export enum SERVER_MODE {
  'FONETISIKI_SLOWNIK' = 'FONETISIKI_SLOWNIK',
  'TRANSCRIPT' = 'TRANSCRIPT'
}
