Benchmark for Mosaic Varaint Detection             
==========================================
![Figure1자산 39](https://user-images.githubusercontent.com/77031715/236405863-f4335050-3251-4f59-8ecd-481864c2965b.png)

<br/>

## Introduction!


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

 * [**MosaicHunter**](http://mosaichunter.cbi.pku.edu.cn) (v.1.0)  
     `1.A.pipe_MosaicHunter_single.sh, MH_Grab_Exome_Param.py`
 * [**MosaicForecast**](https://github.com/parklab/MosaicForecast) (v.0.0.1)  
    * model for SNV: 250xRFmodel_addRMSK_Refine.rds
    * model for INDEL: deletions_250x.RF.rds and insertions_250x.RF.rds   
     `1.A.pipe_MosaicForecast.sh`   
 * [**DeepMosaic**](https://github.com/Virginiaxu/DeepMosaic) (v.0.0)  
   * model: efficientnet-b4_epoch_6.pt   
   `1.A.pipe_DeepMosaic/Running_DeepMosaic.sh`
 * [**Mutect2**](https://gatk.broadinstitute.org/hc/en-us/articles/13832655155099--Tool-Documentation-Index) (4.1.9.0)  
   * tumor only mode  
   `1.A.pipe_Mutect2_single.sh`  
 * [**HaplotypeCaller**](https://gatk.broadinstitute.org/hc/en-us/articles/360037225632-HaplotypeCaller) (4.1.8.0)  
   * with ploidy option as 20 and 200   
   `1.A.pipe_HaplotypeCaller_ploidy.sh`
    
  ### (B) Paired-sample analysis 
    
 * [**MosaicHunter**](http://mosaichunter.cbi.pku.edu.cn) (v.1.0)
   * paired naïve mode
   * Modification:  
      (i) Joint probability of two samples with “mosaic” variants was over 0.05   
      (ii) Joint probability larger than that of any other genotype combinations  
      `1.B.pipe_MosaicHunter_paired.sh, MH_Collect_shared_MHPm.py, MH_Grab_Exome_Param.py`
 * [**Mutect2**](https://gatk.broadinstitute.org/hc/en-us/articles/13832655155099--Tool-Documentation-Index) (4.1.9.0)
   * Altered filtration usage : tagged as "normal artifacts"  
   `1.B.pipe_Mutect2_paired.sh`
 * [**M2S2MH**](https://www.nature.com/articles/s41591-019-0711-0#Sec8) 
   * MosaicHunter (v.1.0, single mode)
   * Mutect2 (4.1.9.0, paired mode)
   * Strelka2 (v.2.9.10, somatic mode)
   * Manta (v.1.6.0)   
   `1.B.pipe_M2S2MH`   
 * [**Strelka2**](https://github.com/Illumina/strelka) (v.2.9.10)
   * somatic calling mode  
   `pipe_Strelka2.sh`

    
## 2. Single sample analysis

  #### (A) Parsing the variant calls with control sets  
   `2.A.Parsing_variant.py`
  #### (B) Performance evaluation towards diverse VAF bins   
   * Calculation of sensitivity, precison, and F1-score  
    * precision recalibration applied based on the density of positive controls.  
     `2.B.Variant_snv_performance.py`    
   * AUPRC calculation   
    `2.B.Variant_snv_performance.2.auprc.py`  
   * Calculate upper limits of sensitivity
    `__Calulate_FN.py`
   * Visualization for Fig.2 b-d   
    `Fig2bcd.R` 
    
  #### (C) Variant call set consistency across different sequencing depths  
    
   `2.C.Depth_consistency.py, Fig2e.R`
  
  #### (D) Variant call set consistency between callers 
   `2.D.Caller_consistency.py, Fig2f.R`
   
## 3. Paired-sample analysis

  #### (A) Two single analysis for single sample callers
   * Single sample methods were applied for paired-sample analysis with intersection of the calls from two samples   
    `3.A.Two_single.py`
  #### (B) Sample-specific variant detection evaluation 
   `3.B.SampleSpecific_performance.py, 3.B.Variant_snv_performance_auprc.py, Fig3e.R`
  #### (C) Performance evaluation on grouped VAF range for shared variant detection 
   `3.C.SharedVariant_grouped_VAF.py, Fig3fg.R`
  #### (D) Sensitivity comparision in shared variant detection
   * balanced or unbalanced VAFs 
   * The unbalanced category includes variants whose differences in VAF of two samples was greater than 2-fold 
    `3.D.SharedVariant_sensitivity.py, Fig3h.R`
  #### (E) Misclassified shared variants
   * shared variants that were misclassified as sample-specific variants   
    `3.E.Misclassified.py`

## 4. Analysis of features and filters

  #### (A) Feature analysis  
   * Evaluation on 48 features used in detection methods  
   `4.A.Feature_analysis_1_data.py, 4.A.Feature_analysis_2_ROC.R, Fig4_a_ROC.R, Fig4_b.R`
  #### (B) Filter analysis 
   * Evaluation of post filters  
   `4.B.Filter_analysis.py, Fig4_c.R`
    
## 5. Additional strategies for mosaic variant calling

#### (A) call set- and feature-level recombination  
 * Feature-level recombination of muliple algorithms (Filtration of using features from different methods)   
  1. MT2-*to* call set + *alt softclip* (MF) > 0.05
  2. HC-*p200* call set + *MFRL alt* (MT2-*to*) <150
  3. HC-*p200* call set + *Het likelihood* (MF) > 0.25  
 `5.A.Call_Feature_Recombination`
#### (B) Rescue strategy  
 * Originally used by [M2S2MH](https://www.nature.com/articles/s41591-019-0711-0#Sec8)  
 * Improve sensitivity of high-precision mosaic category methods for shared variant detection  
 `5.B.Rescue`
#### (C) Filtration with lineage distance  
 * Filtration utilizing developmental lineage tree  
 * Two samples that are originated from more recently differentiated tissues are more proximal in a developmental lineage tree  
 * Improve precision in shared variant detection  
 `5.C.Lineage_Distance_Filter`

## 6. Others
  * Generation of in silico reference standards  
   `DS_TS_Downsample.sh` 
  * Downsampling of the reference data  
   `In_silico_ref_data`  
  * Benchmark summary (Fig. 6)  
   `Benchmark_summary.ipynb`
