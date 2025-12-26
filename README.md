# Multivariate Statistical Analysis

A comprehensive R-based project exploring multivariate statistical analysis techniques through three distinct tasks covering normal distribution visualization, principal component analysis, and factor analysis.

## Project Overview

This repository contains implementations and analyses for three key multivariate statistical methods:

1. **Task 1**: Multivariate Normal Distribution Visualization and Covariance Matrix Analysis
2. **Task 2**: Principal Component Analysis (PCA)
3. **Task 3**: Factor Analysis with Orthogonal Models

## Project Structure

```
Multivariate_Statistical_Analysis/
│
├── README.md                 # This file
├── LICENSE                   # License file
│
├── Task1/                    # Multivariate Normal Distribution Analysis
│   ├── task1.md             # Task description
│   ├── task1.1.r            # Main R script
│   ├── compile_report.R     # LaTeX report compilation script
│   ├── README_report.md     # Report documentation
│   ├── report.tex           # LaTeX source
│   ├── report.pdf           # Compiled report
│   ├── Task1_Results.pdf   # Generated results PDF
│   └── Task1_3D_with_ellipsoids.png  # 3D visualization
│
├── Task2/                    # Principal Component Analysis
│   ├── task2.md             # Task description
│   ├── task2.1.r            # Main R script
│   ├── compile_report.R     # LaTeX report compilation script
│   ├── README_report.md     # Report documentation
│   ├── report.tex           # LaTeX source
│   ├── report.pdf           # Compiled report
│   ├── Task2_Results.pdf    # Scree plots and variance analysis
│   ├── Task2_Biplot.pdf     # Biplot visualizations
│   ├── Task2_Correlation.pdf # Correlation matrix
│   ├── Task2_Loadings.pdf   # Loadings plots
│   └── Task2_analysis_results.txt  # Numerical results
│
└── Task3/                    # Factor Analysis
    ├── Task3.md             # Task description
    ├── task3.1.r            # Main R script
    ├── compile_report.R     # LaTeX report compilation script
    ├── README_report.md     # Report documentation
    ├── report.tex           # LaTeX source
    ├── report.pdf           # Compiled report
    ├── Task3_FactorLoadings.pdf      # Factor loadings heatmaps
    ├── Task3_ScreePlot.pdf           # Scree plots
    ├── Task3_LoadingsComparison.pdf  # Before/after rotation comparison
    ├── Task3_Correlation.pdf         # Correlation matrix
    └── Task3_analysis_results.txt    # Numerical results
```

## Tasks Description

### Task 1: Multivariate Normal Distribution Analysis

**Objective**: Generate and visualize multiple sub-samples from 3-dimensional Normal (Gaussian) distributions with different covariance structures.

**Key Features**:
- Generates three sub-samples with different covariance matrices:
  - Spherical (uncorrelated, equal variance)
  - Axis-aligned ellipsoid (uncorrelated, unequal variance)
  - Rotated ellipsoid (correlated variables)
- 3D scatter plot visualization with different colors for each sub-sample
- Spectral decomposition analysis
- 95% confidence ellipsoids visualization
- Analysis of how covariance structure influences scatter cloud forms

**Dependencies**: `MASS`, `plotly`, `scatterplot3d`, `rgl`, `ellipse`

### Task 2: Principal Component Analysis (PCA)

**Objective**: Construct and interpret principal components for multivariate data with at least 5 dimensions.

**Key Features**:
- PCA analysis with 2 and 3 principal components
- Scree plots and variance explained visualizations
- Biplots for component interpretation
- Correlation matrix analysis
- Loadings analysis and interpretation
- Detailed interpretation of first and second principal components

**Dependencies**: `MASS`, `ggplot2`, `corrplot`, `factoextra`, `FactoMineR`

### Task 3: Factor Analysis

**Objective**: Construct a 3-factor orthogonal model and apply varimax rotation for interpretation.

**Key Features**:
- 3-factor orthogonal factor model
- Factor analysis without rotation
- Varimax rotation implementation
- Comparison of loadings before and after rotation
- Scree plots and variance explained analysis
- Detailed interpretation of factor structure

**Dependencies**: `MASS`, `psych`, `GPArotation`, `corrplot`, `ggplot2`

## Installation and Setup

### Prerequisites

- **R** (version 4.0 or higher recommended)
- **RStudio** (optional, but recommended for better experience)
- **LaTeX distribution** (required for PDF report compilation)

### Installing R Packages

Run the following commands in R to install all required packages:

```r
# Install packages for Task 1
install.packages(c("MASS", "plotly", "scatterplot3d", "rgl", "ellipse"))

# Install packages for Task 2
install.packages(c("ggplot2", "corrplot", "factoextra", "FactoMineR"))

# Install packages for Task 3
install.packages(c("psych", "GPArotation"))

# Or install all at once
install.packages(c("MASS", "plotly", "scatterplot3d", "rgl", "ellipse",
                   "ggplot2", "corrplot", "factoextra", "FactoMineR",
                   "psych", "GPArotation"))
```

## Usage

### Running Individual Tasks

Each task can be run independently by executing the corresponding R script:

#### Task 1
```r
# Navigate to Task1 directory or set working directory
setwd("Task1")
source("task1.1.r")
```

#### Task 2
```r
# Navigate to Task2 directory or set working directory
setwd("Task2")
source("task2.1.r")
```

#### Task 3
```r
# Navigate to Task3 directory or set working directory
setwd("Task3")
source("task3.1.r")
```

### Compiling Reports

Each task includes a LaTeX report that can be compiled using the provided R script:

```r
# For any task, navigate to its directory and run:
source("compile_report.R")
```

This will generate a PDF report from the LaTeX source files.

## Output Files

Each task generates several output files:

- **PDF files**: Visualizations and plots
- **Text files**: Numerical analysis results
- **PNG files**: Static images (Task 1)
- **PDF reports**: Comprehensive LaTeX-compiled reports

## Key Concepts Covered

- **Multivariate Normal Distribution**: Generation, visualization, and covariance structure analysis
- **Spectral Decomposition**: Eigenvalue decomposition of covariance matrices
- **Principal Component Analysis**: Dimensionality reduction and variance explanation
- **Factor Analysis**: Latent factor modeling and rotation techniques
- **Varimax Rotation**: Orthogonal rotation for factor interpretability
- **Statistical Visualization**: 3D plots, biplots, scree plots, and correlation matrices

## Notes

- All scripts use `set.seed()` for reproducibility
- Sample sizes and parameters can be adjusted in each script
- Output files are saved in the respective task directories
- Interactive plots (Task 1) can be saved as HTML if needed

## License

See the [LICENSE](LICENSE) file for details.

## Author

Multivariate Statistical Analysis Project

---

For detailed information about each task, refer to the individual task directories and their respective README files.
