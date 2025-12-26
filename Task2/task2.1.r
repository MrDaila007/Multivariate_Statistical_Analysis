# Principal Components Analysis (PCA)
# Task 2: Multivariate Statistical Analysis

# Load necessary libraries
library(MASS)
library(ggplot2)
library(corrplot)
library(factoextra)
library(FactoMineR)

# Set seed for reproducibility
set.seed(2025)

# --- Data Generation ---
# Generate multivariate data with at least 5 dimensions
# Using a dataset with 6 variables (dimensions)

n <- 200  # Sample size

# Create correlation structure
# Variables 1-3: correlated group (economic indicators)
# Variables 4-5: correlated group (social indicators)
# Variable 6: independent (random factor)

# Correlation matrix
cor_matrix <- matrix(c(
  1.0, 0.7, 0.6, 0.2, 0.1, 0.0,  # Var 1
  0.7, 1.0, 0.65, 0.15, 0.2, 0.0,  # Var 2
  0.6, 0.65, 1.0, 0.1, 0.15, 0.0,  # Var 3
  0.2, 0.15, 0.1, 1.0, 0.75, 0.0,  # Var 4
  0.1, 0.2, 0.15, 0.75, 1.0, 0.0,  # Var 5
  0.0, 0.0, 0.0, 0.0, 0.0, 1.0     # Var 6
), nrow = 6, byrow = TRUE)

# Standard deviations
sd_vec <- c(2.5, 3.0, 2.8, 1.8, 2.0, 1.5)

# Convert correlation to covariance matrix
cov_matrix <- diag(sd_vec) %*% cor_matrix %*% diag(sd_vec)

# Mean vector
mu_vec <- c(50, 60, 55, 30, 35, 20)

# Generate multivariate normal data
data <- mvrnorm(n = n, mu = mu_vec, Sigma = cov_matrix)

# Convert to data frame with meaningful names
colnames(data) <- c("GDP_Growth", "Industrial_Output", "Trade_Balance", 
                    "Education_Level", "Healthcare_Index", "Random_Factor")

data_df <- as.data.frame(data)

# --- Principal Components Analysis ---

# Case 1: PCA with 2 principal components
cat("\n=== CASE 1: PCA with 2 Principal Components ===\n\n")

pca_2 <- prcomp(data_df, center = TRUE, scale. = TRUE)

# Summary
cat("Summary of PCA (2 components):\n")
print(summary(pca_2))

# Eigenvalues and variance explained
eigenvalues_2 <- pca_2$sdev^2
prop_var_2 <- eigenvalues_2 / sum(eigenvalues_2)
cum_prop_var_2 <- cumsum(prop_var_2)

cat("\nEigenvalues:\n")
print(round(eigenvalues_2, 4))

cat("\nProportion of variance explained:\n")
print(round(prop_var_2 * 100, 2))

cat("\nCumulative proportion of variance:\n")
print(round(cum_prop_var_2 * 100, 2))

cat("\nLoadings (first 2 PCs):\n")
print(round(pca_2$rotation[, 1:2], 4))

# Case 2: PCA with 3 principal components
cat("\n\n=== CASE 2: PCA with 3 Principal Components ===\n\n")

pca_3 <- prcomp(data_df, center = TRUE, scale. = TRUE)

# Summary
cat("Summary of PCA (3 components):\n")
print(summary(pca_3))

# Eigenvalues and variance explained
eigenvalues_3 <- pca_3$sdev^2
prop_var_3 <- eigenvalues_3 / sum(eigenvalues_3)
cum_prop_var_3 <- cumsum(prop_var_3)

cat("\nEigenvalues:\n")
print(round(eigenvalues_3, 4))

cat("\nProportion of variance explained:\n")
print(round(prop_var_3 * 100, 2))

cat("\nCumulative proportion of variance:\n")
print(round(cum_prop_var_3 * 100, 2))

cat("\nLoadings (first 3 PCs):\n")
print(round(pca_3$rotation[, 1:3], 4))

# --- Visualization ---

# Save plots to PDF
pdf("Task2/Task2_Results.pdf", width = 12, height = 8)

# 1. Scree plot
par(mfrow = c(2, 2))

# Scree plot for 2 PCs
plot(1:6, eigenvalues_2, type = "b", 
     main = "Scree Plot (2 PCs Analysis)",
     xlab = "Principal Component", ylab = "Eigenvalue",
     pch = 19, col = "blue")
abline(h = 1, lty = 2, col = "red")
legend("topright", "Kaiser criterion (lambda=1)", lty = 2, col = "red")

# Variance explained plot
barplot(prop_var_2 * 100, names.arg = paste0("PC", 1:6),
        main = "Proportion of Variance Explained (2 PCs)",
        xlab = "Principal Component", ylab = "Variance (%)",
        col = "steelblue", ylim = c(0, max(prop_var_2 * 100) * 1.2))

# Scree plot for 3 PCs
plot(1:6, eigenvalues_3, type = "b", 
     main = "Scree Plot (3 PCs Analysis)",
     xlab = "Principal Component", ylab = "Eigenvalue",
     pch = 19, col = "darkgreen")
abline(h = 1, lty = 2, col = "red")
legend("topright", "Kaiser criterion (lambda=1)", lty = 2, col = "red")

# Cumulative variance plot
barplot(cum_prop_var_3 * 100, names.arg = paste0("PC", 1:6),
        main = "Cumulative Variance Explained (3 PCs)",
        xlab = "Principal Component", ylab = "Cumulative Variance (%)",
        col = "darkgreen", ylim = c(0, 100))

dev.off()

# 2. Biplot
pdf("Task2/Task2_Biplot.pdf", width = 10, height = 8)

par(mfrow = c(1, 2))

# Biplot for 2 PCs
biplot(pca_2, choices = c(1, 2), 
       main = "Biplot: PC1 vs PC2",
       cex = 0.7, scale = 0)

# Biplot for 3 PCs (PC1 vs PC2)
biplot(pca_3, choices = c(1, 2), 
       main = "Biplot: PC1 vs PC2 (3 PCs Analysis)",
       cex = 0.7, scale = 0)

dev.off()

# 3. Correlation plot
pdf("Task2/Task2_Correlation.pdf", width = 8, height = 8)
corrplot(cor(data_df), method = "circle", type = "upper",
         order = "hclust", tl.cex = 0.8, tl.col = "black",
         title = "Correlation Matrix of Original Variables")
dev.off()

# 4. Loadings plot
pdf("Task2/Task2_Loadings.pdf", width = 12, height = 6)

par(mfrow = c(1, 2))

# Loadings for PC1 and PC2
loadings_2 <- pca_2$rotation[, 1:2]
barplot(t(loadings_2), beside = TRUE, 
        main = "Loadings: PC1 and PC2",
        xlab = "Variable", ylab = "Loading",
        col = c("blue", "red"),
        legend = c("PC1", "PC2"),
        names.arg = substr(rownames(loadings_2), 1, 8),
        las = 2, cex.names = 0.7)

# Loadings for PC1, PC2, PC3
loadings_3 <- pca_3$rotation[, 1:3]
barplot(t(loadings_3), beside = TRUE, 
        main = "Loadings: PC1, PC2, and PC3",
        xlab = "Variable", ylab = "Loading",
        col = c("blue", "red", "green"),
        legend = c("PC1", "PC2", "PC3"),
        names.arg = substr(rownames(loadings_3), 1, 8),
        las = 2, cex.names = 0.7)

dev.off()

# --- Save results for LaTeX report ---
sink("Task2/Task2_analysis_results.txt")

cat("=== PRINCIPAL COMPONENTS ANALYSIS RESULTS ===\n\n")
cat("Dataset: Multivariate data with 6 variables\n")
cat("Sample size:", n, "\n\n")

cat("=== CASE 1: 2 Principal Components ===\n\n")
cat("Eigenvalues:\n")
print(round(eigenvalues_2, 4))
cat("\nProportion of variance:\n")
print(round(prop_var_2 * 100, 2))
cat("\nCumulative proportion:\n")
print(round(cum_prop_var_2 * 100, 2))
cat("\nLoadings (PC1, PC2):\n")
print(round(pca_2$rotation[, 1:2], 4))

cat("\n\n=== CASE 2: 3 Principal Components ===\n\n")
cat("Eigenvalues:\n")
print(round(eigenvalues_3, 4))
cat("\nProportion of variance:\n")
print(round(prop_var_3 * 100, 2))
cat("\nCumulative proportion:\n")
print(round(cum_prop_var_3 * 100, 2))
cat("\nLoadings (PC1, PC2, PC3):\n")
print(round(pca_3$rotation[, 1:3], 4))

sink()

cat("\n=== Analysis Complete ===\n")
cat("Results saved to:\n")
cat("  - Task2/Task2_Results.pdf (scree plots)\n")
cat("  - Task2/Task2_Biplot.pdf (biplots)\n")
cat("  - Task2/Task2_Correlation.pdf (correlation matrix)\n")
cat("  - Task2/Task2_Loadings.pdf (loadings plots)\n")
cat("  - Task2/Task2_analysis_results.txt (numerical results)\n")

