cwlVersion: v1.0
class: CommandLineTool
baseCommand: [samtools, mpileup]
requirements:
  ShellCommandRequirement: {}

inputs:
  Reference_FASTA:
    type: File
    secondaryFiles:
      - .fai
    inputBinding:
      prefix: -f
      shellQuote: false
      position: 0

  BAM_file:
    type: File
    inputBinding:
      shellQuote: false
      position: 1

  Pipe:
    type: string
    default: "|"
    inputBinding:
      shellQuote: false
      position: 2

  VarScan:
    type: string
    default: java -jar VarScan.v2.4.4.jar mpileup2snp --output-vcf 1
    label: "The --output-vcf 1 argument allows to obtain a VCF 4.1 file as the output"
    inputBinding:
      shellQuote: false
      position: 3

  VCF_file_name:
    type: string

outputs:
  VCF_file:
    type: stdout

stdout: $(inputs.VCF_file_name)