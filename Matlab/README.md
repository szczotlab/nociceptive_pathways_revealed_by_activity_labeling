# Instructions
- To run the matlab application on the published data, download the data from [here](https://zenodo.org/records/17392899).    [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17392899.svg)](https://doi.org/10.5281/zenodo.17392899)<br>
- Follow the instructions in [Quick Start](https://github.com/szczotlab/nociceptive_pathways_revealed_by_activity_labeling/blob/main/Matlab/QuickStart_SC_GeneBrowser.pdf) document to begin using SC_GeneBrowser.
- Extended information (system requirements, installation guide and demo): [ExtendedReadme.pdf] (https://github.com/szczotlab/nociceptive_pathways_revealed_by_activity_labeling/blob/main/Matlab/ExtendedReadme.pdf)

## Matlab variable description
The variable contains data to load into Matlab GUI for browsing.<br>
The fields within matlab variable contain data that can be accessed separately:<br>
- area - area in pixels of measured cells<br>
- cell_id - ordering number<br>
- gene_name - table of all gene names<br>
- green_intensity - background corrected value of green fluorescnece measured in Campari isolated cells.<br>
- louvain - number of cluster to which cells were assigned<br>
- normed_matrix - log normalized count matrix for all used cells<br>
- red_intesity - background corrected value of red fluorescnece measured in Campari isolated cells.<br>
- sparse_matrix - unnormalized count matrix<br>
- stimuli - identification of the stimuli for camapri cells<br>
- umap - umap coordinates for all cells<br>


