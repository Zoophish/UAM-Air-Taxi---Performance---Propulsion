# Import libraries
import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit

plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"

# Define the data for helicopter rotors
# Source: [6](https://www.helis.com/howflies/rotor.php)

radii = x = np.array([7.79, 5.97, 5.35, 5.5, 5.4, 7.01, 6.71, 6.4, 4.91, 5.5, 4.02, 7.32, 3.83, 4.09, 8.18, 12.04, 6.71, 6.65])
weights = y = np.array([58, 29, 23, 45, 31, 38, 83, 55, 19, 20, 8.81, 48, 8, 9, 72, 140, 28, 33])

# fit cx^2 due to area proportionality
func = lambda x, c, e: c*x**e
params = curve_fit(func, xdata=x, ydata=y)[0]

# Generate the x and y values for the line of best fit
x_fit = np.linspace(0, radii.max(), 100)
y_fit = np.array([func(xv, *params) for xv in x_fit])

# Plot the scatter plot and the line of best fit
plt.scatter(radii, weights)
plt.plot(x_fit, y_fit, color="black", lw=1)
plt.xlabel("Radius /$m$")
plt.ylabel("Weight /$kg$")
plt.title("Helicopter Blade Weight vs Radius")
plt.show()
