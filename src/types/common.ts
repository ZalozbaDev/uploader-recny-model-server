const languageModel = ['FHG', 'HF', 'FB', 'BOZA_MSA', 'DEVEL']
export type LanguageModel = (typeof languageModel)[number]
export const isLanguageModel = (x: any): x is LanguageModel => languageModel.includes(x)

export enum OutputFormat {
  'TXT' = 'TXT',
  'SRT' = 'SRT'
}
export const isOutputFormat = (x: any): x is OutputFormat => x in OutputFormat
