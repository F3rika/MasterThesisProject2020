#CWL description of a typical Trimmomatic command line to perform trimming on PE reads.

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [java, -jar, trimmomatic-0.39.jar, PE]

inputs:
  Raw_fastq:
    type: File[]
    inputBinding:
      position: 0

  Trimmed_fastq_basename:
    type: string
    inputBinding:
      prefix: -baseout
      position: 1

  Leading_score:
    type: int
    inputBinding:
      prefix: "LEADING:"
      separate: false
      position: 2

  Trailing_score:
    type: int
    inputBinding:
      prefix: "TRAILING:"
      separate: false
      position: 3

  SlidingWindow_score:
    type: int[]
    inputBinding:
      prefix: "SLIDINGWINDOW:"
      separate: false
      itemSeparator: ":"
      position: 4

  Reads_minlen:
    type: int
    inputBinding:
      prefix: "MINLEN:"
      separate: false
      position: 5

outputs:
  Forward_trimmed_fastq:
    type: File
    outputBinding:
      glob: "*_1P*"

  Reverse_trimmed_fastq:
    type: File
    outputBinding:
      glob: "*_2P*"

  Unpaired_trimmed_fastq:
    type: File[]
    outputBinding:
      glob: "*_*U*"
