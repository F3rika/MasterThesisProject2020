#CWL description of a typical SAMtools command line to sort alignment results (in BAM format).

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, sort]

inputs:
  BAM_file:
    type: File
    inputBinding:
      position: 0

  Sorted_BAM_name:
    type: string
    inputBinding:
      prefix: -o
      position: 1

outputs:
  Sorted_BAM_file:
    type: File
    outputBinding:
      glob: $(inputs.Sorted_BAM_name)
