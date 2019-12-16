#!/usr/bin/env Rscript

# Sensitivty analysis code

# Odds Ratios

# Contingency table (crude)
A1p = 16
A0p = 103
B1p = 128
B0p = 844
N1p = 144
N0p = 947

# OR for dz given exp
ORdx = (A1p/B1p) / (A0p/B0p)

# Confounder based on prevalence (Z)
PZ1 = 0.85 # prevalence of confounder in exposed
PZ0 = 0.50 # Prevalence of confounder in unexposed
ORdz = 3.0 # Given OR of dz given confounder

# OR exp given confounder Z
ORxz = (PZ1 * (1-PZ0)) / ((1-PZ1) * PZ0)

# Confounder analysis by Greenland (Z = 1)
B11 = PZ1 * B1p
A11 = (ORdz * A1p * B11) / (ORdz * B11 + B1p - B11)
B01 = PZ0 * B0p
A01 = (ORdz * A0p * B01) / (ORdz * B01 + B0p - B01)
N11 = A11 + B11
N01 = A01 + B01
M11 = A11 + A01
M01 = B11 + B01

# Confounder analysis by Greenland (Z = 0)
A10 = A1p - A11
A00 = A0p - A01
B10 = B1p - B11
B00 = B0p - B01
M10 = A10 + A00
M00 = B10 + B00
N10 = A10 + B10
N00 = A00 + B00

# Bias-adjusted OR by confounder (Z = 1 or 0)
ORdxz1 = (A11/B11) / (A01/B01)
ORdxz0 = (A10/B10) / (A00/B00)

