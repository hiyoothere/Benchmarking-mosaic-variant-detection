Benchmark for Mosaic Varaint Detection             
==========================================
![자산 6@3x](https://user-images.githubusercontent.com/77031715/144162216-072ccbe7-0c52-4423-8610-a55547480fe1.png)

<br/>

## Introduction

Here, we present our benchmark of nine feasible strategies for mosaic variant detection based on a systematically designed reference standard that mimics mosaic samples, with 390,153 control positive and 35,208,888 negative single-nucleotide variants and insertion–deletion mutations. We identified the condition-dependent strengths and weaknesses of the current strategies, instead of a single winner, regarding variant allele frequencies, variant sharing, and the usage of control samples. Moreover, ensemble approach and feature-level investigation direct the way for immediate to prolonged improvements in mosaic variant calling. Our results will guide researchers in selecting suitable calling algorithms and suggest future strategies for developers.  
[![DOI](https://zenodo.org/badge/395906637.svg)](https://zenodo.org/badge/latestdoi/395906637)
<br/>
<br/>

## 0. Controls
High confidence positive and negative control sets utilized in benchmark. Among the full sets of 39 cell line mixture-based ground truth in the [original reference material](https://www.nature.com/articles/s41597-022-01133-8), we only considered high-confident regions by excluding the simple repeats and segmental duplications supplied by UCSC. Thus, 92% of SNVs and 72% of INDELs from positive controls were adjustable. For negative controls, 94% of non-variant sites and 91% of germline variants were available per sample. The original ground truth is available in [Mosaic-Reference-Standards](https://github.com/hiyoothere/Mosaic-Reference-Standards). 
 
 **1. Positive control**:
  `controls/Positive_controls_hc.vcf`   
   * 345,552 SNVs and 8,706 INDELs
  
 **2. Negative control**:
   * Non-variant site: 
   `controls/Negative_controls_nonvariant.vcf.gz`   
     * 33,093,574 per sample
   * Germline variant: 
   `controls/Negative_controls_germline.vcf`  
     * 18,151 per sample
    
## 1. Running variant callers

 ### (A) Single sample analysis

 * **MosaicHunter** (v.1.0)  
     ```
     ./1.A.pipe_MosaicHunter_single.sh $Reference $Input_Bam $Output_Dir $Sample_ID $Input_DP
     ```
 * **MosaicForecast** (v.0.0.1)  
    * model for SNV: 250xRFmodel_addRMSK_Refine.rds
    * model for INDEL: deletions_250x.RF.rds and insertions_250x.RF.rds   
    
     ```
     ./1.A.pipe_MosaicForecast.sh $Reference #Input_Dir #$Output_Dir $Sample_ID $MosaicForecast_Path
     ```   
 * **DeepMosaic** (v.0.0)  
   * model: efficientnet-b4_epoch_6.pt   
   ```
   ./1.A.pipe_DeepMosaic/Running_DeepMosaic.sh #Input_Dir #$Output_Dir $DeepMosaic_Path
   ```
 * **Mutect2** (4.1.9.0)  
   * tumor only mode 
 * **HaplotypeCaller** (4.1.8.0)  
   * with ploidy option as 20 and 200 
    
  ### (B) Paired-sample analysis 
    
 * **MosaicHunter** (v.1.0)
   * paired naïve mode
   * Modification:  
      (i) Joint probability of two samples with “mosaic” variants was over 0.05   
      (ii) Joint probability larger than that of any other genotype combinations
 * **Mutect2** (4.1.9.0)
   * Altered filtration usage : tagged as "normal artifacts"
 * **M2S2MH** 
   * MosaicHunter (v.1.0, single mode)
   * Mutect2 (4.1.9.0, paired mode)
   * Strelka2 (v.2.9.10, somatic mode)
   * Manta (v.1.6.0)
    
    
## 2. Single sample analysis

  #### (A) Parsing the contorls from variant call sets
  #### (B) Sensitivity evaluation towards diverse VAFs
  #### (C) Variant call consistency across different sequencing depths
  #### (D) Variant call consistency between callers

   
## 3. Paired-sample analysis

  #### (A) Two single analysis for single sample callers
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
