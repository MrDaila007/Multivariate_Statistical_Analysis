# Load necessary libraries
# If you don't have these installed, run: install.packages(c("MASS", "plotly", "scatterplot3d", "rgl", "ellipse"))
library(MASS)
library(plotly)
library(scatterplot3d)
library(rgl)
library(ellipse)

# Set seed for reproducibility
set.seed(123)

# --- Configuration & Parameters ---

# Define Sample Volumes (Sample Sizes)
n1 <- 100
n2 <- 100
n3 <- 100

# Define Parameters for Sub-sample 1: Standard Spherical
# Centered at (0,0,0), Uncorrelated, Equal Variance
mu1 <- c(0, 0, 0)
sigma1 <- matrix(c(1, 0, 0,
                   0, 1, 0,
                   0, 0, 1), nrow=3)

# Define Parameters for Sub-sample 2: Axis-Aligned Ellipsoid
# Centered at (5,5,5), Uncorrelated, Unequal Variance (Stretched on Z-axis)
mu2 <- c(5, 5, 5)
sigma2 <- matrix(c(1, 0, 0,
                   0, 1, 0,
                   0, 0, 5), nrow=3) # Variance of Z is 5

# Define Parameters for Sub-sample 3: Rotated Ellipsoid (Correlated)
# Centered at (10,0,0), Correlated variables (Non-diagonal covariance)
mu3 <- c(10, 0, 0)
sigma3 <- matrix(c(1, 0.8, 0.8,
                   0.8, 1, 0.8,
                   0.8, 0.8, 1), nrow=3)

# --- Data Generation ---

# Generate the sub-samples using mvrnorm (multivariate normal distribution)
data1 <- mvrnorm(n = n1, mu = mu1, Sigma = sigma1)
data2 <- mvrnorm(n = n2, mu = mu2, Sigma = sigma2)
data3 <- mvrnorm(n = n3, mu = mu3, Sigma = sigma3)

# Convert to data frames with group labels
g1 <- data.frame(
  x = data1[,1],
  y = data1[,2],
  z = data1[,3],
  group = "Sub-sample 1 (Spherical)"
)

g2 <- data.frame(
  x = data2[,1],
  y = data2[,2],
  z = data2[,3],
  group = "Sub-sample 2 (Stretched Z)"
)

g3 <- data.frame(
  x = data3[,1],
  y = data3[,2],
  z = data3[,3],
  group = "Sub-sample 3 (Correlated)"
)

# Combine into a single dataframe
df <- rbind(g1, g2, g3)

# --- Visualization ---

# Create interactive 3D scatter plot using plotly
p <- plot_ly(data = df, 
        x = ~x, 
        y = ~y, 
        z = ~z, 
        color = ~group, 
        colors = c("red", "blue", "green"),
        type = 'scatter3d', 
        mode = 'markers',
        marker = list(size = 3)) %>%
  layout(title = "3D Scatter Plot of Multivariate Normal Sub-samples",
         scene = list(
           xaxis = list(title = 'X Axis'),
           yaxis = list(title = 'Y Axis'),
           zaxis = list(title = 'Z Axis')
         ))

# Display interactive plot
print(p)

# Save as HTML for interactive viewing (optional)
# Uncomment the next line if you want to save interactive HTML plot
# if (requireNamespace("htmlwidgets", quietly = TRUE)) {
#   htmlwidgets::saveWidget(p, "Task1_Interactive.html")
# }

# Generate PDF using static plot
# Note: plotly doesn't work well with pdf(), so we'll use scatterplot3d for PDF

pdf("Task1_Results.pdf", width = 8, height = 6)

all_data <- rbind(data1, data2, data3)
colors <- c(rep("red", n1), rep("blue", n2), rep("green", n3))
shapes <- c(rep(16, n1), rep(17, n2), rep(18, n3))

s3d <- scatterplot3d(all_data, 
                     color = colors, 
                     pch = shapes,
                     main = "3D Scatter Plot of Multivariate Normal Sub-samples",
                     xlab = "X Axis", ylab = "Y Axis", zlab = "Z Axis",
                     grid = TRUE, box = FALSE)

# Add a legend
legend(s3d$xyz.convert(12, 0, 10), legend = c("Sub-sample 1 (Spherical)", 
                                             "Sub-sample 2 (Stretched Z)", 
                                             "Sub-sample 3 (Correlated)"),
       col =  c("red", "blue", "green"), pch = c(16, 17, 18))

# Close the PDF device to save the file
dev.off()

# --- Spectral Decomposition and PCA Analysis ---

# Function to compute spectral decomposition and save results
analyze_covariance <- function(sigma, mu, name) {
  # Spectral decomposition: Sigma = U * diag(lambda) * U^T
  eigen_result <- eigen(sigma)
  eigenvalues <- eigen_result$values
  eigenvectors <- eigen_result$vectors
  
  # 95% confidence ellipsoid: c^2 = chi^2(3, 0.95) ≈ 7.815
  c_value <- sqrt(qchisq(0.95, df = 3))
  
  # Semi-axes lengths
  semi_axes <- c_value * sqrt(eigenvalues)
  
  # Proportion of variance explained by each PC
  prop_var <- eigenvalues / sum(eigenvalues)
  cum_prop_var <- cumsum(prop_var)
  
  # Create ellipsoid
  ellipsoid <- ellipse3d(sigma, centre = mu, level = 0.95)
  
  return(list(
    name = name,
    eigenvalues = eigenvalues,
    eigenvectors = eigenvectors,
    semi_axes = semi_axes,
    prop_var = prop_var,
    cum_prop_var = cum_prop_var,
    ellipsoid = ellipsoid,
    c_value = c_value
  ))
}

# Analyze all three sub-samples
analysis1 <- analyze_covariance(sigma1, mu1, "Sub-sample 1")
analysis2 <- analyze_covariance(sigma2, mu2, "Sub-sample 2")
analysis3 <- analyze_covariance(sigma3, mu3, "Sub-sample 3")

# --- Print Analysis Results ---
cat("\n=== SPECTRAL DECOMPOSITION ANALYSIS ===\n\n")

for (analysis in list(analysis1, analysis2, analysis3)) {
  cat(sprintf("\n%s:\n", analysis$name))
  cat("Eigenvalues (λ):", paste(round(analysis$eigenvalues, 4), collapse = ", "), "\n")
  cat("Semi-axes lengths (c√λ):", paste(round(analysis$semi_axes, 4), collapse = ", "), "\n")
  cat("Proportion of variance:", paste(round(analysis$prop_var * 100, 2), "%", collapse = ", "), "\n")
  cat("Cumulative proportion:", paste(round(analysis$cum_prop_var * 100, 2), "%", collapse = ", "), "\n")
  cat("\nEigenvectors (columns):\n")
  print(round(analysis$eigenvectors, 4))
}

# --- 3D Visualization with Ellipsoids using rgl ---
open3d()
par3d(windowRect = c(0, 0, 1200, 800))

# Plot points
points3d(data1, col = "red", size = 5)
points3d(data2, col = "blue", size = 5)
points3d(data3, col = "darkgreen", size = 5)

# Plot ellipsoids
shade3d(analysis1$ellipsoid, col = "red", alpha = 0.2)
shade3d(analysis2$ellipsoid, col = "blue", alpha = 0.2)
shade3d(analysis3$ellipsoid, col = "darkgreen", alpha = 0.2)

# Add axes
axes3d()
title3d("3D Scatter Plot with 95% Confidence Ellipsoids", 
        xlab = "X Axis", ylab = "Y Axis", zlab = "Z Axis")

# Add legend
legend3d("topright", 
         legend = c("Sub-sample 1 (Spherical)", 
                   "Sub-sample 2 (Stretched Z)", 
                   "Sub-sample 3 (Correlated)"),
         col = c("red", "blue", "darkgreen"), 
         pch = 16)

# Save 3D plot
# Сохраняем в текущей директории (где запускается скрипт)
rgl.snapshot("Task1_3D_with_ellipsoids.png", fmt = "png")
cat("\n3D plot with ellipsoids saved as Task1_3D_with_ellipsoids.png\n")
cat("Note: If running from Task1/, file will be in Task1/ directory\n")

# --- Save analysis results to file for LaTeX report ---
sink("Task1_analysis_results.txt")
cat("=== COVARIANCE MATRICES ===\n\n")
cat("Sub-sample 1 (Spherical):\n")
print(sigma1)
cat("\nSub-sample 2 (Stretched Z):\n")
print(sigma2)
cat("\nSub-sample 3 (Correlated):\n")
print(sigma3)

cat("\n\n=== SPECTRAL DECOMPOSITION ===\n\n")
for (analysis in list(analysis1, analysis2, analysis3)) {
  cat(sprintf("\n%s:\n", analysis$name))
  cat("Eigenvalues:", paste(round(analysis$eigenvalues, 4), collapse = ", "), "\n")
  cat("Semi-axes:", paste(round(analysis$semi_axes, 4), collapse = ", "), "\n")
  cat("Prop. variance:", paste(round(analysis$prop_var * 100, 2), "%", collapse = ", "), "\n")
}
sink()

print("PDF generated successfully as Task1_Results.pdf")
print("Analysis results saved to Task1_analysis_results.txt")