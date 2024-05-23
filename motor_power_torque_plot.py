# Import libraries
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import Ellipse
from matplotlib.transforms import Affine2D


# Define data
power = np.array([100, 80, 100, 120, 125, 70, 188, 200, 236]) # Power in kW
torque = np.array([900, 500, 700, 1000, 450, 400, 1200, 1400, 1800]) # Torque in Nm
weight = [22, 24, 7, 9, 14, 13, 58, 82, 18, 11, 28]
labels = ["Magnax", "YASA", "EMRAX", "Phi-Power", "Equipmake", "Ashwoods", "Turntide", "Magnax", "Joby S4"]

plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"

fig, ax1 = plt.subplots(figsize=(9, 6))

# Create scatter plot
ax1.scatter(power, torque, c="blue", marker="o", zorder=2.5)
ax1.set_xlabel("Continuous Power (kW)")
ax1.set_ylabel("Peak Torque (Nm)")
plt.title("Axial Flux Motors: Power & Torque")

# Add labels to points
for i, label in enumerate(labels):
    ax1.annotate(label, (power[i] + 2, torque[i] + 5))

# Calculate line of best fit
slope, intercept = np.polyfit(power, torque, 1)

ellipse = Ellipse(xy=(165, 1200), width=200, height=35, angle=0, alpha=0.2, color="blue")
# Rotate ellipse by the same angle as the line
angle = np.arctan(slope) * 180 / np.pi # Convert radians to degrees
transform = Affine2D().rotate_deg_around(165, 1200, angle) + plt.gca().transData
ellipse.set_transform(transform)
plt.gca().add_patch(ellipse)

text = plt.text(165, 1200, "Requirement", ha="center", va="center", fontsize=8)
# text.set_transform(transform)
# text.set_transform_rotates_text(True)

# Create second y-axis for weight
ax2 = ax1.twinx()
ax2.set_ylabel("Weight (kg)")
ax2.set_ylim(0, 100)
# Draw horizontal lines to show weight
for i in range(len(power)):
    ax2.vlines(power[i], 0, weight[i], colors=plt.cm.Set2(i / len(power)))


# Show plot
plt.show()
