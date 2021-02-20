#CWL workflow describing the typical analysis process applied to prepare sequencing data for variant calling.
#Data are first trimmed to improve reads general quality and then aligned to the reference genome (in this case the human hg38 reference genome).
#Alignment results are compressed in BAM format, sorted and indexed.
#The tools used in this workflow are: Trimmomatic (trimming), Bowtie2 (alignment) and SAMtools (compression, sorting and indexing)

cwlVersion: v1.0
class: Workflow

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  raw_fastq_array:
    type:
      type: array
      items:
        type: array
        items: File
  trimmed_fastq_basename_array: string[]
  leading: int
  trailing: int
  slidingwindow: int[]
  reads_minlength: int
  bowtie_idx: string
  threads_num: int
  rg_id_array: string[]
  rg_additional_fields_array: 
    type: 
      type: array
      items:
        type: array
        items: string
  output_name_array: string[]
  bam_file_name_array: string[]
  sorted_bam_name_array: string[]
  bam_index_name_array: string[]


outputs:
  SORTED_BAM:
    type: File[]
    outputSource: Trimming_Alignment_BAM_file_and_index_production/sorted_bam_file
  INDEX_BAM:
    type: File[]
    outputSource: Trimming_Alignment_BAM_file_and_index_production/index_bam

steps:
  Trimming_Alignment_BAM_file_and_index_production:
    run:
      class: Workflow
      inputs:
        raw_fastq: File[]
        trimmed_fastq_basename: string
        leadin_score: int
        trailing_score: int
        slidingwindow_score: int[]
        reads_minlen: int
        bowtie_index: string
        threads_number: int
        rg_id: string
        rg_additional_fields: string[]
        output_name: string
        bam_file_name: string
        sorted_bam_name: string
        bam_index_name: string
      outputs:
        sorted_bam_file:
          type: File
          outputSource: Sort_BAM_by_coordinate/Sorted_BAM_file
        index_bam:
          type: File
          outputSource: Produce_BAM_index/Index_BAM
      steps:
        Trimming:
          run: trimmomatic.cwl
          in:
            Raw_fastq: raw_fastq
            Trimmed_fastq_basename: trimmed_fastq_basename
            Leading_score: leadin_score
            Trailing_score: trailing_score
            SlidingWindow_score: slidingwindow_score
            Reads_minlen: reads_minlen
          out: [Forward_trimmed_fastq, Reverse_trimmed_fastq, Unpaired_trimmed_fastq]

        Alignment:
          run: bowtie2.cwl
          in:
            Bowtie_index: bowtie_index
            Forward_reads_fastq: Trimming/Forward_trimmed_fastq
            Reverse_reads_fastq: Trimming/Reverse_trimmed_fastq
            Unpaired_reads_fastq: Trimming/Unpaired_trimmed_fastq
            Threads_number: threads_number
            RG_id: rg_id
            RG_additional_fields: rg_additional_fields
            Output_name: output_name
          out: [Aligned_SAM]

        Convert_SAM_to_BAM:
          run: samtools_view-b.cwl
          in:
            Aligned_SAM: Alignment/Aligned_SAM
            BAM_file_name: bam_file_name
          out: [BAM_file]

        Sort_BAM_by_coordinate:
          run: samtools_sort.cwl
          in:
            BAM_file: Convert_SAM_to_BAM/BAM_file
            Sorted_BAM_name: sorted_bam_name
          out: [Sorted_BAM_file]

        Produce_BAM_index:
          run: samtools_index.cwl
          in:
            Input_BAM: Sort_BAM_by_coordinate/Sorted_BAM_file
            BAM_index_name: bam_index_name
          out: [Index_BAM]
            

    scatter: [raw_fastq, trimmed_fastq_basename, rg_id, rg_additional_fields, output_name, bam_file_name, sorted_bam_name, bam_index_name]
    scatterMethod: dotproduct
    in:
      raw_fastq: raw_fastq_array
      trimmed_fastq_basename: trimmed_fastq_basename_array
      leadin_score: leading
      trailing_score: trailing
      slidingwindow_score: slidingwindow
      reads_minlen: reads_minlength
      bowtie_index: bowtie_idx
      threads_number: threads_num
      rg_id: rg_id_array
      rg_additional_fields: rg_additional_fields_array
      output_name: output_name_array
      bam_file_name: bam_file_name_array
      sorted_bam_name: sorted_bam_name_array
      bam_index_name: bam_index_name_array
    out: [sorted_bam_file, index_bam]
