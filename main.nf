#!/usr/bin/env nextflow

// Default params
params.merge_mafs = false
params.input_dir = ""
params.output_dir = "outputs"

// Parameter checking
if (!params.input_dir) {
  error("No input directory provided --input_dir")
  exit 1
}

// Process sudmodule
process annotateMaf {

  input:
    path maf_file

  output:
    publishDir "${params.output_dir}/annotated_mafs"
    path "${maf_file.baseName}.annotated.maf"
  
  stub:
    """
    touch "${maf_file.baseName}.annotated.maf"
    """

  script:
    """
    gnap --filename ${maf_file} --output-filename "${maf_file.baseName}.annotated.maf"
    """
}

// Process submodule
process annotateMergedMafs {
  input:
  path input // A directory containing all MAFs to merge OR a comma-delimited list of MAFs to merge

  output:
  path test // Output filename for merged MAF [REQUIRED]

  script:
    """
    gnap merge --input-mafs-directory ${input_maf} --output-maf ${output_filename}
    gnap merge --input-mafs-list ${input_maf} --output-maf ${output_filename}
    """

  stub:
    """
    """
}

// Named subworkflow
workflow annotate_mafs {
  take:
    mafs

  main:
    annotateMaf(mafs)
}

// Main implicit workflow
workflow {
  println "$params"
  mafs = Channel.fromPath("${params.input_dir}/*.txt", checkIfExists: true)
  annotate_mafs(mafs)
}

workflow.onComplete {
  println "Pipeline completed at: $workflow.complete"
  println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}

workflow.onError {
    println "Error: Pipeline execution stopped with the following message: ${workflow.errorMessage}"
}

// REQUIRES EDGE RELEASE: nextflow.preview.output 
// output {
//   directory 'outputs'
// }
