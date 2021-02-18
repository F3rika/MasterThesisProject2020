cwlVersion: v1.0
class: CommandLineTool
baseCommand: freebayes

inputs:
  Reference_FASTA:
    type: File
    secondaryFiles:
      - .fai
    inputBinding:
      prefix: -f
      position: 0

  Aligned_BAM:
    type: File
    inputBinding:
      position: 1

  Mapping_quality_threshold:
    type: int
    label: "Exclude alignments from analysis if they have a mapping quality less than Q. Default: 1. Recommended: 20"
    inputBinding:
      prefix: -m
      position: 2

  Base_quality_threashold:
    type: int
    label: "Exclude alleles from analysis if their supporting base quality is less than Q.  Default: 0. Recommended: 10"
    inputBinding:
      prefix: -q
      position: 3

  Min_observation_count:
    type: int
    label: "Require at least this count of observations. Recommended: 5."
    inputBinding:
      prefix: -C
      position: 4

  VCF_file_name:
    type: string


outputs:
  VCF_file:
    type: stdout

stdout: $(inputs.VCF_file_name)