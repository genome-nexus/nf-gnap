# nf-gnap

A NextFlow pipeline to annotate Mutation Annotation Format (MAF) files via the
genome-nexus-annotation-pipeline and [genomenexus.org](genomenexus.org).

Genome nexus aggregates variant information from multiple sources

For more information please see: 
[annotation sources](https://docs.genomenexus.org/annotation-sources)

Example Usage:
```
nextflow run main.nf --input_dir $(pwd)/<directory_of_mafs> --output_dir $(pwd)/outputs
```


