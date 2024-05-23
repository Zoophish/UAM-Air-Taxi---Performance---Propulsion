import numpy as np
import matplotlib.pyplot as plt

# Define the parameters
V_s = 0  # Stall speed
V_a = 5  # Maneuvering speed
V_c = 6  # Cruise speed
V_d = 7  # Dive speed
n_pos = 3.8  # Positive load factor limit
n_neg = -1.5  # Negative load factor limit

# Create an array of speeds for plotting
speeds = np.linspace(0, V_d, 100)

# Calculate the load factors for each speed
load_factors_pos = np.where(speeds <= V_a, n_pos * (speeds / V_a) ** 2, n_pos)
load_factors_neg = np.where(speeds <= V_a, n_neg * (speeds / V_a) ** 2, n_neg)

# Create the plot
fig, ax = plt.subplots()

# Plot the positive and negative load factor curves
ax.plot(speeds, load_factors_pos, 'k-')
ax.plot(speeds, load_factors_neg, 'k-')

# Plot the vertical lines for each speed
ax.axvline(V_s, color='k', linestyle='--')
ax.axvline(V_a, color='k', linestyle='--')
ax.axvline(V_c, color='k', linestyle='--')
ax.axvline(V_d, color='k', linestyle='--')

# Annotate the 'V' values on the plot
ax.annotate(f'$V_s$', xy=(V_s, 0), xytext=(V_s, 0.2), ha='center')
ax.annotate(f'$V_a$', xy=(V_a, 0), xytext=(V_a, 0.2), ha='center')
ax.annotate(f'$V_c$', xy=(V_c, 0), xytext=(V_c, 0.2), ha='center')
ax.annotate(f'$V_d$', xy=(V_d, 0), xytext=(V_d, 0.2), ha='center')

# Set the axis labels and title
ax.set_xlabel('Equivalent Airspeed')
ax.set_ylabel('Load Factor, n')
ax.set_title('Aircraft Maneuver Envelope')

# Set the axis limits
ax.set_xlim(0, V_d)
ax.set_ylim(n_neg - 0.5, n_pos + 0.5)

# Remove the legend
ax.legend().remove()

# Display the plot
plt.show()