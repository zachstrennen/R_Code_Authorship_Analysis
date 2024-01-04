# R Code Authorship Analysis

This reposotory was authored in collaboration with Gabriel Krotkov at Carnegie Mellon Univerity in the Fall of 2023.

## Overview
This reporitory contains code that uniquely tokenizes R script files as text. The text from each R file is specifically transformed in order to be tokenized. Each space in the file is represented by the token "space_placeholder" and each new line is represented by the token "new_line_placeholder". Additionally, several non-alphanumeric operators unique to R, as well as common, punctuation-based operators are replaced with placeholder tokens. While not all placeholders will be present in each text, it can be hypothesized that the proportionality of these placeholders, along with the use of namespaces, can be used to identify the author of an R code file.

Once all of the files are loaded in and tokenized, a weighted document feature matrix is created for the loaded tokens separated by each file along with the associated author id. Reminiscent of the classification done by Mosteller and Wallace, lasso regression is used to determine authorship. Initially using all collected tokens for each file as predictor variables, we determine the probability of authorship between two students in question.

To analyze the pairwise differences between groups of texts by two different authors we used LASSO regression to logistically predict the likelihood of the authorship of a given text being attributed to the first author as opposed to the second author. We selected LASSO instead of other methods to reduce the number of variables retained in the model and to maintain some simplicity. The resulting model has coefficients which can be interpreted to mean "the average expected increase in the log odds of the first author being the true author of the paper if the given token happened to increase in proportion from 0 to 1."

One key difference between the analysis of Mosteller & Wallance and our analysis is that the Mosteller & Wallace study was focused on the attribution of specfic texts, for which a specific two candidates were known. Our interest is in code authorship more generally, and so our analysis needs to account for differences between a variety of authors. In order to achieve this, we designed a "round robin" series of pairwise author comparisons and an analysis to compile the results of many different pairwise comparisons. First, for each author we conducted a pairwise comparison resulting in a model equation out of the LASSO with coefficients for each discriminator of significance. Principal Component Analysis is used to finally analyize the coefficients of each model as they relate to their respective author pairing.

## Loading and Accessing Data

In the `data` folder there is a folder named `authors` that currently contains eight groupings of ten .R files that have all been anonymized. However, each of the eight groupings are attributed to one author/author grouping. The `data` folder also contains `pca_info.rda` and `r_namespaces.rda`. `pca_info.rda` is needed for the file pca.R in order to complete the analysis. `r_namespaces.rda` contains thousands of namespaces unique to R which are used in wallace_pipeline.R.

### `extract_code.R`

The code in this file uses purl() to remove the the authorship lines at the top of r files and anonymize the file names. This was created to work with a mass amount of students' code if needed.

### `get_namespace.R`

This code is used to access the thousands of namespaces in r packages looked at. They are saved as `r_namespaces.rda`.

## Analysis

To replicate the analyis run the following code files in order.

### `rcode2txt`

This code first initializes the definitions of important placeholder tokens. The function reformat_text_R is defined after. This function takes in a .R file, replaces all R-specific tokens with placeholder tokens, and returns the resulting text.


## Installation

Describe packages.


1. Update credentials.py.
2. Run table_setup.py to create tables.
3. Use load-hhs.py and load-quality.py to populate tables with data.
4. Optional: Use table_teardown.py to remove tables.
