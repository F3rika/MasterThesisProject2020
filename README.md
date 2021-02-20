# MasterThesisProject2020
The present repository contains some of the Python3 scripts and CWL workflows I produced during my master thesis internship project.  
All the scripts/workflows were tested/applied and can be considered functioning, however they are still quite rough and there is still room for their improvement and polishing.  
For this reasons consider this repository as a personal archive.


## Brief summary of the project
The first part of my thesis project revolved around variant calling, which was performed using a custom re-implementation of the [CoVaCS](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5800023/) workflow. The latter is a consensus method based on the simultaneous application of three different and complementary algorithms for variant calling ([Freebayes](https://github.com/freebayes/freebayes), [VarScan](http://varscan.sourceforge.net/germline-calling.html) and [GATK](https://gatk.broadinstitute.org/hc/en-us/articles/360035894751)) and on the production of a final consensus call-set that collects all the variants common to at least two methods.  
All the workflows and scripts here reported, and briefly described below, were produced with this purpose in mind.


## Brief description of CWL workflows and Python3 scripts
The CWL specification was used to describe the tools useful to perform data pre-processing, alignment and variant calling (with Freebayes and VarScan) and to connect them into a workflow.  
Each of the tools constituting a step of a workflow MUST HAVE its own CWL description.  
The inputs to each workflow or tool description are outlined in a specific input file in YAML or JSON format.  
Further specification on how CWL workflows, tool descriptions and input files are written can be found [here](https://www.commonwl.org/user_guide/).  
Tools or workflows described the in CWL language can be executed using specific CWL runners. It is recommended to start with the reference implementation,
[cwltool](https://github.com/common-workflow-language/cwltool#install), which was used also in this project.

Regarding the Python3 scripts here collected, one was used to filter the variants obtained during previous steps and the other to produce the final consensus call-set.  
Both scripts accept VCF files as inputs and give back outputs in the same format.  
More in detail, variants were filtered according to their read depth (or DP) meaning the number of reads from the sequenced data that map in that specific position. In this project only variants with a DP>=10 were retained.  
The final consensus call-set was produced according to the CoVaCS guidelines meaning that only variants identified by at least two of the three different algorithms used are retained in the final results.

### More detailed descriptions of functioning and purpose of each script/workflow collected in this repository can be found on top of the corresponding file.
