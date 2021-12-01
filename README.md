Benchmark for Mosaic Varaint Detection             
==========================================
<br/>


<br/>
<br/>
Introduction
------------  
<br/>

Here, we present our benchmark of nine feasible strategies for mosaic variant detection based on a systematically designed reference standard that mimics mosaic samples, with 390,153 control positive and 35,208,888 negative single-nucleotide variants and insertion–deletion mutations. We identified the condition-dependent strengths and weaknesses of the current strategies, instead of a single winner, regarding variant allele frequencies, variant sharing, and the usage of control samples. Moreover, ensemble approach and feature-level investigation direct the way for immediate to prolonged improvements in mosaic variant calling. Our results will guide researchers in selecting suitable calling algorithms and suggest future strategies for developers.  
   
 
<br/>

## 0. Controls
 * Positive control
 * Negative control
   * Non-variant site
   * Germline variant
    
## 1. Running variant callers

 ### (A) Single sample analysis
  
 * MosaicHunter 
 * MosaicForecast
 * DeepMosaic
 * Mutect2 
 * HaplotypeCaller ploidy 20 and 200
    
  ### (B) Paired-sample analysis 
    
  * MosaicHunter paired mode
   * Modification:    <br/>
   (i) 
   <br/>
   (ii)
  * Mutect2 with altered filtration usage
  * M2S2MH 
    
    
## 2. Single sample analysis

  #### (A) Parsing the contorls from variant call sets
  #### (B) Sensitivity evaluation towards diverse VAFs
  #### (C) Variant call consistency across different sequencing depths
  #### (D) Variant call consistency between callers

   
## 3. Paired-sample analysis

  #### (A) Two single analysis for single sample caller
  #### (B) Sensitivity evaluation on shared variant detection
  #### (C) Performance evaluation on grouped VAF range for shared variant detection 

## 4. Analysis of features and filters

  #### (A) Feature analysis
  #### (B) Filter analysis 
    
## 5. Additional strategies for mosaic variant calling

#### (A) call set- and feature-level recombination
#### (B) Rescue strategy
#### (C) Filtration with lineage distance

## 6. Visualization  

## 7. Others
  * Generation of in silico reference standards
  * Downsampling of the reference data
