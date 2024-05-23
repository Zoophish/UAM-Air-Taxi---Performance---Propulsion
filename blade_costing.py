# Data for composite blades (combined)
blade_size = ["Small (3-4m)", "Medium (4-6m)", "Large (6+m)", "Small (1-2m)", "Large (2-4m)"]
blade_price = [30000, 70000, 120000, 10000, 35000]  # Prices in USD (estimated)

# Combine data into a single list of dictionaries
data = []
for i in range(len(blade_size)):
    data.append({"size": blade_size[i], "price": blade_price[i]})

# Print the data table (without categories)
print("Data Table (combined):")
for item in data:
    print(item)

# Import libraries for plotting
import matplotlib.pyplot as plt

# Extract data for plotting
diameters = []
prices = []
for item in data:
    diameters.append(float(item["size"].split()[1:-1][0]))  # Extract estimated diameter
    prices.append(item["price"])

# Create the scatter plot
plt.figure(figsize=(10, 6))
plt.scatter(diameters, prices, color='blue', alpha=0.7, s=100)  # Increase marker size
plt.xlabel("Estimated Diameter (meters)")
plt.ylabel("Price (USD)")
plt.title("Estimated Price Range of Composite Blades")
plt.grid(True)

# Display the plot
plt.tight_layout()
plt.show()
