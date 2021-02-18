cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, index, -b]

inputs:
  Input_BAM:
    type: File
    inputBinding:
      position: 0

  BAM_index_name:
    type: string
    label: "MUST be input-BAM-name.bam.bai"
    inputBinding:
      position: 1

outputs:
  Index_BAM:
    type: File
    outputBinding:
      glob: $(inputs.BAM_index_name)