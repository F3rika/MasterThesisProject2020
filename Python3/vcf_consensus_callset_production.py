#According to the CoVaCS guidelines the final call-set is obtained by applying a simple consensus majority rule, and only variants that are identified
#by at least two out of three tools are retained. In the present work, this was implemented by using a custom Python3 script, which is briefly described below. 
#The script receives a collection of 3 VCF files, one from each different tool in input and all specified with the appropriate option (--freebayes, --varscan
#and --gatk respectively).
#Each file is processed, by reading it  line by line. From every line, characteristic features describing a genetic variant (chromosome,  position, reference
#and alternative allele) are extracted by  the means of the split function and used to compose the key of a Python3 dictionary. These keys are bound to be unique
#since in VCF files all the possible genetic variants associated with one genomic position are reported on the same line. In the dictionary the value associated
#with each key is the list of the tools that support a specific variant call.
#In this project only SNPs are taken in account during the process and, consequently, the script is optimized to process also haplotypes and multiple calls produced
#by some variant calling tools such as GATK and Freebayes. In these cases, the REF and ALT fields of the VCF file are broken down to single characters and the position
#of each single SNP reconstructed.
#Moreover, another critical issue considered is the presence of eventual duplicate calls among single tools files, which are removed to avoid false positive results.
#In the final step, a canonical  VCF call line is reconstructed for each identified variant supported by at least two tools and printed in the output file.
#Together with the consensus file, the script produces also three additional outputs containing the variants that are identified only by a single tool.

def idx_creation(inp):
     idx=[]
     freebayes_in=inp.freebayes_vcf
     varscan_in=inp.varscan_vcf
     gatk_in=inp.gatk_vcf
     inputs=[freebayes_in, varscan_in, gatk_in]
     
     for file in inputs:
         with open(file) as vcf_file:
             for line in vcf_file:
                 
                 if 'chr' in line and '#' not in line:
                     l=line.split('\t')
                     chrom=l[0]+'\t'
                     
                     if chrom not in idx:
                         idx.append(chrom)
     
     return idx

def SNP_analysis(inp):
     SNP_dictonary={}
     freebayes_in=inp.freebayes_vcf
     varscan_in=inp.varscan_vcf
     gatk_in=inp.gatk_vcf
     inputs=[freebayes_in, varscan_in, gatk_in]

     for file in inputs:
         with open(file) as vcf_file:
             for line in vcf_file:
                 
                 if 'chr' in line and '#' not in line:
                     l=line.split('\t')
                     chrom=l[0]
                     pos=l[1]
                     ref=l[3]
                     alt=l[4].split(',')
                     
                     for a in alt:
                         if file==freebayes_in:
                             source='freeBayes'
                             
                             if len(ref)==1 and len(a)==1 and a!='*':
                                 key=chrom+'\t'+pos+'\t'+'.'+'\t'+ref+'\t'+a+'\t'+'.'+'\t'+'.'+'\t'+'.'
                                 
                                 if key in SNP_dictonary and source not in SNP_dictonary[key]:
                                     SNP_dictonary[key].append(source)
                                 
                                 else:
                                     SNP_dictonary[key]=[source]
                                 
                             elif len(ref)==len(a):
                                 ref2=list(ref)
                                 alt2=list(a)
                                 
                                 for idx in range(0,len(ref2)):
                                     
                                     if ref2[idx]!=alt2[idx] and alt2[idx]!='*':
                                         key=chrom+'\t'+str(int(pos)+idx)+'\t'+'.'+'\t'+ref2[idx]+'\t'+alt2[idx]+'\t'+'.'+'\t'+'.'+'\t'+'.'
                                         
                                         if key in SNP_dictonary and source not in SNP_dictonary[key]:
                                             SNP_dictonary[key].append(source)
                                         
                                         else:
                                             SNP_dictonary[key]=[source]
                         
                         elif file==varscan_in:
                             source='VarScan'
                             
                             if len(ref)==1 and len(a)==1 and a!='*':
                                 key=chrom+'\t'+pos+'\t'+'.'+'\t'+ref+'\t'+a+'\t'+'.'+'\t'+'.'+'\t'+'.'
                                 
                                 if key in SNP_dictonary and source not in SNP_dictonary[key]:
                                     SNP_dictonary[key].append(source)
                                 
                                 else:
                                     SNP_dictonary[key]=[source]
                         
                         elif file==gatk_in:
                             source='GATK'
                             
                             if len(ref)==1 and len(a)==1 and a!='*':
                                 key=chrom+'\t'+pos+'\t'+'.'+'\t'+ref+'\t'+a+'\t'+'.'+'\t'+'.'+'\t'+'.'
                                 
                                 if key in SNP_dictonary and source not in SNP_dictonary[key]:
                                     SNP_dictonary[key].append(source)
                                 
                                 else:
                                     SNP_dictonary[key]=[source]

     return SNP_dictonary

def main():
     import argparse
     
     program=argparse.ArgumentParser(description='Identify common and unique SNPs from multilple VCF files generated with different tools')
     program.add_argument('--freebayes', help='VCF input file generated by freeBayes', dest='freebayes_vcf', type=str)
     program.add_argument('--varscan', help='VCF input file generated by VarScan', dest='varscan_vcf', type=str)
     program.add_argument('--gatk', help='VCF input file generated by GATK', dest='gatk_vcf', type=str)
     program.add_argument('--out', help='VCF output files base name', dest='output_name', type=str)
     program.set_defaults(func=idx_creation, func2=SNP_analysis)
     inp=program.parse_args()
     
     index=inp.func(inp)
     snp_dictionary=inp.func2(inp)
     output_basename=inp.output_name
     header='##fileformat=VCFv4.2\n#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n'
     
     common_out=open('%s_common_snp.vcf'%output_basename,'w')
     common_out.write(header)
     
     freebayes_out=open('%s_freebayes_snp.vcf'%output_basename,'w')
     freebayes_out.write(header)
     
     varscan_out=open('%s_varscan_snp.vcf'%output_basename,'w')
     varscan_out.write(header)
     
     gatk_out=open('%s_gatk_snp.vcf'%output_basename,'w')
     gatk_out.write(header)
     
     for chr in index:
         for snp in snp_dictionary.keys():
             if len(snp_dictionary[snp])>=2 and chr in snp:
                 common_out.write(snp+'\n')
             
             elif len(snp_dictionary[snp])==1 and 'freeBayes' in snp_dictionary[snp] and chr in snp:
                 freebayes_out.write(snp+'\n')
             
             elif len(snp_dictionary[snp])==1 and 'VarScan' in snp_dictionary[snp] and chr in snp:
                 varscan_out.write(snp+'\n')
             
             elif len(snp_dictionary[snp])==1 and 'GATK' in snp_dictionary[snp] and chr in snp:
                 gatk_out.write(snp+'\n')

if __name__=='__main__':
     main()
