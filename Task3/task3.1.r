# Factor Analysis (FA)
# Task 3: Multivariate Statistical Analysis
# Orthogonal factor model with 3 factors

# Load necessary libraries
library(MASS)
library(psych)
library(GPArotation)
library(corrplot)
library(ggplot2)

# Set seed for reproducibility
set.seed(2025)

# --- Data Generation ---
# Generate multivariate data with at least 7 dimensions
# Using a dataset with 8 variables (dimensions)

n <- 300  # Sample size

# Create factor structure
# Factor 1: Economic indicators (variables 1-3)
# Factor 2: Social indicators (variables 4-5)
# Factor 3: Environmental indicators (variables 6-7)
# Variable 8: Noise/unique factor

# Factor loadings matrix (8 variables x 3 factors)
# This defines the true factor structure
Lambda_true <- matrix(c(
  # Factor 1 (Economic)
  0.8, 0.0, 0.0,  # Var 1: GDP_Growth
  0.75, 0.0, 0.0, # Var 2: Industrial_Output
  0.7, 0.0, 0.0,  # Var 3: Trade_Balance
  # Factor 2 (Social)
  0.0, 0.8, 0.0,  # Var 4: Education_Level
  0.0, 0.75, 0.0, # Var 5: Healthcare_Index
  # Factor 3 (Environmental)
  0.0, 0.0, 0.8,  # Var 6: Air_Quality
  0.0, 0.0, 0.75, # Var 7: Water_Quality
  # Noise
  0.0, 0.0, 0.0   # Var 8: Random_Noise
), nrow = 8, byrow = TRUE)

# Unique variances (diagonal of Psi matrix)
Psi <- diag(c(0.36, 0.44, 0.51, 0.36, 0.44, 0.36, 0.44, 0.95))

# Generate correlation matrix from factor model
# Sigma = Lambda * Lambda' + Psi
Sigma <- Lambda_true %*% t(Lambda_true) + Psi

# Ensure positive definiteness
Sigma <- (Sigma + t(Sigma)) / 2
eigen_vals <- eigen(Sigma)$values
if (min(eigen_vals) < 0) {
  Sigma <- Sigma + diag(rep(abs(min(eigen_vals)) + 0.01, 8))
}

# Mean vector
mu_vec <- c(50, 60, 55, 30, 35, 40, 45, 20)

# Generate multivariate normal data
data <- mvrnorm(n = n, mu = mu_vec, Sigma = Sigma)

# Convert to data frame with meaningful names
colnames(data) <- c("GDP_Growth", "Industrial_Output", "Trade_Balance",
                    "Education_Level", "Healthcare_Index",
                    "Air_Quality", "Water_Quality", "Random_Noise")

data_df <- as.data.frame(data)

# --- Factor Analysis ---

cat("\n=== FACTOR ANALYSIS: 3-Factor Orthogonal Model ===\n\n")

# Case 1: Factor Analysis without rotation
cat("--- Case 1: FA without rotation ---\n\n")

fa_no_rotation <- fa(data_df, nfactors = 3, rotate = "none", 
                     fm = "ml",  # Maximum likelihood
                     scores = "regression")

cat("Factor Loadings (no rotation):\n")
print(round(fa_no_rotation$loadings, 4))

cat("\nCommunalities:\n")
print(round(fa_no_rotation$communality, 4))

cat("\nEigenvalues:\n")
print(round(fa_no_rotation$values, 4))

cat("\nProportion of variance explained:\n")
print(round(fa_no_rotation$Vaccounted, 4))

# Case 2: Factor Analysis with Varimax rotation
cat("\n\n--- Case 2: FA with Varimax rotation ---\n\n")

fa_varimax <- fa(data_df, nfactors = 3, rotate = "varimax",
                 fm = "ml",
                 scores = "regression")

cat("Factor Loadings (Varimax rotation):\n")
print(round(fa_varimax$loadings, 4))

cat("\nCommunalities:\n")
print(round(fa_varimax$communality, 4))

cat("\nEigenvalues:\n")
print(round(fa_varimax$values, 4))

cat("\nProportion of variance explained:\n")
print(round(fa_varimax$Vaccounted, 4))

cat("\nRotation matrix:\n")
print(round(fa_varimax$rot.mat, 4))

# --- Visualization ---

# Save plots to PDF
pdf("Task3/Task3_FactorLoadings.pdf", width = 14, height = 8)

par(mfrow = c(1, 2))

# Factor loadings without rotation
loadings_no_rot <- as.matrix(fa_no_rotation$loadings)
colnames(loadings_no_rot) <- paste0("Factor", 1:3)
rownames(loadings_no_rot) <- colnames(data_df)

# Create heatmap of loadings (no rotation)
corrplot(loadings_no_rot, method = "color", is.corr = FALSE,
         tl.cex = 0.8, tl.col = "black",
         title = "Factor Loadings (No Rotation)",
         mar = c(0, 0, 2, 0))

# Factor loadings with Varimax rotation
loadings_varimax <- as.matrix(fa_varimax$loadings)
colnames(loadings_varimax) <- paste0("Factor", 1:3)
rownames(loadings_varimax) <- colnames(data_df)

# Create heatmap of loadings (Varimax)
corrplot(loadings_varimax, method = "color", is.corr = FALSE,
         tl.cex = 0.8, tl.col = "black",
         title = "Factor Loadings (Varimax Rotation)",
         mar = c(0, 0, 2, 0))

dev.off()

# Scree plot
pdf("Task3/Task3_ScreePlot.pdf", width = 10, height = 6)

par(mfrow = c(1, 2))

# Scree plot for eigenvalues
eigenvalues <- fa_no_rotation$values
plot(1:8, eigenvalues, type = "b",
     main = "Scree Plot: Eigenvalues",
     xlab = "Factor Number", ylab = "Eigenvalue",
     pch = 19, col = "blue", ylim = c(0, max(eigenvalues) * 1.1))
abline(h = 1, lty = 2, col = "red")
legend("topright", "Kaiser criterion (lambda=1)", lty = 2, col = "red")

# Variance explained
variance_explained <- fa_no_rotation$Vaccounted[2, ] * 100
barplot(variance_explained, names.arg = paste0("Factor", 1:3),
        main = "Variance Explained by Each Factor",
        xlab = "Factor", ylab = "Variance (%)",
        col = "steelblue", ylim = c(0, max(variance_explained) * 1.2))

dev.off()

# Comparison plot: Loadings before and after rotation
pdf("Task3/Task3_LoadingsComparison.pdf", width = 14, height = 10)

par(mfrow = c(2, 3))

# Plot loadings for each factor (no rotation)
for (i in 1:3) {
  barplot(loadings_no_rot[, i], 
          main = paste("Factor", i, "(No Rotation)"),
          ylab = "Loading", xlab = "Variable",
          col = "lightblue", las = 2, cex.names = 0.7,
          ylim = c(-1, 1))
  abline(h = 0, col = "black", lwd = 1)
  abline(h = c(-0.3, 0.3), col = "gray", lty = 2)
}

# Plot loadings for each factor (Varimax rotation)
for (i in 1:3) {
  barplot(loadings_varimax[, i], 
          main = paste("Factor", i, "(Varimax Rotation)"),
          ylab = "Loading", xlab = "Variable",
          col = "lightgreen", las = 2, cex.names = 0.7,
          ylim = c(-1, 1))
  abline(h = 0, col = "black", lwd = 1)
  abline(h = c(-0.3, 0.3), col = "gray", lty = 2)
}

dev.off()

# Correlation matrix
pdf("Task3/Task3_Correlation.pdf", width = 8, height = 8)
corrplot(cor(data_df), method = "circle", type = "upper",
         order = "hclust", tl.cex = 0.8, tl.col = "black",
         title = "Correlation Matrix of Original Variables")
dev.off()

# --- Save results for LaTeX report ---
sink("Task3/Task3_analysis_results.txt")

cat("=== FACTOR ANALYSIS RESULTS ===\n\n")
cat("Dataset: Multivariate data with 8 variables\n")
cat("Sample size:", n, "\n")
cat("Number of factors: 3\n\n")

cat("=== CASE 1: No Rotation ===\n\n")
cat("Factor Loadings:\n")
print(round(fa_no_rotation$loadings, 4))
cat("\nCommunalities:\n")
print(round(fa_no_rotation$communality, 4))
cat("\nEigenvalues:\n")
print(round(fa_no_rotation$values, 4))
cat("\nVariance Accounted:\n")
print(round(fa_no_rotation$Vaccounted, 4))

cat("\n\n=== CASE 2: Varimax Rotation ===\n\n")
cat("Factor Loadings:\n")
print(round(fa_varimax$loadings, 4))
cat("\nCommunalities:\n")
print(round(fa_varimax$communality, 4))
cat("\nEigenvalues:\n")
print(round(fa_varimax$values, 4))
cat("\nVariance Accounted:\n")
print(round(fa_varimax$Vaccounted, 4))
cat("\nRotation Matrix:\n")
print(round(fa_varimax$rot.mat, 4))

sink()

cat("\n=== Analysis Complete ===\n")
cat("Results saved to:\n")
cat("  - Task3/Task3_FactorLoadings.pdf (loadings heatmaps)\n")
cat("  - Task3/Task3_ScreePlot.pdf (scree plots)\n")
cat("  - Task3/Task3_LoadingsComparison.pdf (comparison plots)\n")
cat("  - Task3/Task3_Correlation.pdf (correlation matrix)\n")
cat("  - Task3/Task3_analysis_results.txt (numerical results)\n")

