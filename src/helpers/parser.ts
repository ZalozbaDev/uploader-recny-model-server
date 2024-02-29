export const parseOutputFormat = (outputFormat: OutputFormat): string => {
  switch (outputFormat) {
    case 'SRT':
      return 'srt'
    case 'TXT':
      return 'text'
  }
}
