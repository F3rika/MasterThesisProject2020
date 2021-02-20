#CWL description of a typical SAMtools command line to convert SAM format alignment results in the compressed BAM format.

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, view, -b]

inputs:
  Aligned_SAM:
    type: File
    inputBinding:
      position: 0

  BAM_file_name:
    type: string
    inputBinding:
      prefix: -o
      position: 1

outputs:
  BAM_file:
    type: stdout

stdout: $(inputs.BAM_file_name)
