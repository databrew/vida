
<!-- README.md is generated from README.Rmd. Please edit that file -->
vida: The R package of the VIDA-DataBrew collaboration
======================================================

Installation
------------

``` r
if(!require(devtools)) install.packages("devtools")
install_github('databrew/vida')
```

About
-----

`vida`, the R package of the VIDA-DataBrew collaboration, is a set of tools for transforming and combining verbal autopsy data from multiple sites and time periods.

Objectives
----------

The objectives of the R VIDA package are simple:

1.  Make data "translation" straightforward and user friendly

2.  Allow for translated data to be easily aggregated

3.  Allow for aggregated data to be easily analyzed

Set up
------

To use the `vida` package, you'll first need to install it. With a good internet connection, run the following from within R.

``` r
if(!require(devtools)) install.packages("devtools")
install_github('databrew/vida')
```

Once you've installed the package, you can use its functionality in any R script by simply including the following line:

``` r
library(vida)
```

Basic use
---------

### Format detection

The `vida` package can automatically detect the format of a dataset via the `detect_format` function. Here's an example of its use:

``` r
library(vida)
# Load some fake data
fake <- vida::fake
# Detect the format
format <- detect_format(df = fake)
#> The raw input data were run against 9 dictionaries. The best match was:
#>  who2010_2
#> which contained 79.19% of the variables in the raw data, and among those variables had a category matching percentage of approximately 69.95 %.
# Show the detected format
print(format)
#> [1] "who2010_2"
```

### Data translation

The workhorse function of the package is `translate`, which translates data from any format to "babel" (the term we use to describe the standardized format for aggregating all datasets). Here's an example of its use:

``` r
library(vida)
# Load some fake data
fake <- vida::fake
# Translate the data
translated <- translate(fake)
#> The raw input data were run against 9 dictionaries. The best match was:
#>  who2010_2
#> which contained 79.19% of the variables in the raw data, and among those variables had a category matching percentage of approximately 69.95 %.
#> Of 197 variables:
#>  156 were identified in the dictionary and underwent a name change;
#>  80 were categorical variables and underwent categorical changes.
```

In addition to translating the data, the function prints information about how many variables were translatable/translated, as well as how many response categories were translatable/translated

Developer details
-----------------

### Raw data

Download the raw data into the "data\_original" folder of this repo [here](https://drive.google.com/drive/u/0/folders/1u-hRKraveojMvO9KAhYj_UzfYxkGn8nq).

### Kenya mapping information

Read about the Kenya files and mapping process [here](https://docs.google.com/document/d/13-DOozvzSteWy9JE_z5zmwbgAiJD2UFZrcjUbvpktZY/edit?usp=sharing).

### Mali mapping information

Download the mali\_data folder into the main repository from [here](https://drive.google.com/drive/u/0/folders/1Nl6QrQhV3V_bYMWn7QK6jq96b-W3EJnp).
