import { OutputFormat } from '../types/common.ts'

export const parseOutputFormat = (outputFormat: OutputFormat): string => {
  switch (outputFormat) {
    case OutputFormat.SRT:
      return 'srt'
    case OutputFormat.TXT:
      return 'text'
  }
}

export const removeExtension = (input: string): string => input.split('.').slice(0, -1).join('')
