const languageModel = ['FHG', 'HF', 'FB', 'BOZA_MSA', 'DEVEL']
export type LanguageModel = (typeof languageModel)[number]
export const isLanguageModel = (x: any): x is LanguageModel => languageModel.includes(x)

const outputFormat = ['TXT', 'SRT']
export type OutputFormat = (typeof outputFormat)[number]
export const isOutputFormat = (x: any): x is OutputFormat => outputFormat.includes(x)
