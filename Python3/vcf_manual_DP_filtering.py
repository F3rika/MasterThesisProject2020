#Variant calling results (VCF file fomat) were filtered for read depth (DP) by the means of a custom Python3 script, which functions as follows.
#Briefly, each VCF file is read line by line taking in account only the FORMAT and VALUE fields.
#The split function in Python is used to separate the values constituting these fields in their single elements and results are saved in two distinct
#list objects.
#The program then scans the list associated with the FORMAT field start to end, and stops when the index associated with the DP tag is identified.
#The corresponding value is extracted from the list of items contained in the VALUE field list. This is possible since tags in the FORMAT field and 
#corresponding values in the VALUE field have a one to one correspondence in a VCF file.
#All the variants with DP equal or higher than 10 are reported in the output VCF file.

#Note that the following python3 script was produced to be specifically performed on
#my samples and needs improvement to be applied in a more "general" way.

samples=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]
tools=['freebayes','varscan','gatk']

for s in samples:
     for t in tools:
         print('Processing Sample%i %s...'%(s,t))
         output=open('sample%i_all/sample%i_all_exome_intersect_%s_filtered.vcf'%(s,s,t),'w')
         header='#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\n'
         output.write(header)
         with open('sample%i_all/sample%i_all_exome_intersect_%s.vcf'%(s,s,t)) as vcf_file:
             for line in vcf_file:
                 l=line.split('\t')
                 format=l[8].split(':')
                 value=l[9].split(':')

                 for f in format:
                     if f=='DP':
                         idx=format.index(f)
                         v=int(value[idx])
                         if v>=10:
                             output.write(line)
         
         print('...Sample%i %s DONE!\n'%(s,t))
