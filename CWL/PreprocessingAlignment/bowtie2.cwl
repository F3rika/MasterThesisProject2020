cwlVersion: v1.0
class: CommandLineTool
baseCommand: bowtie2

inputs:
  Bowtie_index:
    type: string
    inputBinding:
      prefix: -x
      position: 0

  Forward_reads_fastq:
    type: File
    inputBinding:
      prefix: "-1"
      position: 1

  Reverse_reads_fastq:
    type: File
    inputBinding:
      prefix: "-2"
      position: 2

  Unpaired_reads_fastq:
    type: File[]
    inputBinding:
      prefix: -U
      itemSeparator: ","
      position: 3

  Threads_number:
    type: int
    inputBinding:
      prefix: -p
      position: 4

  RG_id:
    type: string
    inputBinding:
      prefix: --rg-id
      position: 5

  RG_additional_fields:
    type: 
      type: array
      items: string
      label: "used to add the SM:text fields required by freebayes"
      inputBinding:
        prefix: --rg
    inputBinding:
      position: 6

  Output_name:
    type: string?
    inputBinding:
      prefix: -S
      position: 7

outputs:
  Aligned_SAM:
    type: stdout

stdout: $(inputs.Output_name)