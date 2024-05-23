import matplotlib.pyplot as plt
import matplotlib as mpl

# Set the font family to serif
mpl.rcParams['font.family'] = 'serif'

# Define the RPM values for x-axis
rpm = [0, 1000, 2000, 3000, 4000, 5000, 5800]

# Define the power and torque values for y-axis
continuous_power = [0, 25, 50, 100, 130, 125, 90]
peak_power = [0, 50.0, 100.0, 160, 210, 200, 150]
continuous_torque = [290, 290, 290, 300, 310, 210, 170]
peak_torque = [480, 480, 500, 510, 510, 400, 260]

# Create a new figure
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(6, 5))

# Plot the power curves
ax1.plot(rpm, continuous_power, 'tab:blue', linewidth=1, marker='s', markersize=4)
ax1.plot(rpm, peak_power, 'tab:red', linewidth=1, marker='^', markersize=4)
ax1.set_xlabel('Speed /min$^{-1}$')
ax1.set_ylabel('Power /kW')
ax1.legend(['Continuous', 'Peak'], loc='upper left')
ax1.grid(True)

# Plot the torque curves
ax2.plot(rpm, continuous_torque, 'tab:blue', linewidth=1, marker='s', markersize=4)
ax2.plot(rpm, peak_torque, 'tab:red', linewidth=1, marker='^', markersize=4)
ax2.set_xlabel('Speed /min$^{-1}$')
ax2.set_ylabel('Torque /Nm')
ax2.grid(True)

ax1.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
ax2.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)

# Adjust the spacing between subplots
plt.tight_layout()

# Increase the thickness of the box borders
for ax in [ax1, ax2]:
    for spine in ax.spines.values():
        spine.set_linewidth(1.2)

# Display the plot
plt.show()