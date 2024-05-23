import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.interpolate import griddata

# Read data from all sheets
num_sheets = 16
pitch_increment = 2.5

# Initialize lists to store data from all sheets
J_data = []
eta_data = []
ct_data = []
cp_data = []
pitch_data = []

for i in range(1, num_sheets + 1):
    sheet_data = pd.read_excel('BladePitch_20kW_Thrust.xlsx', sheet_name=f'Sheet{i}')
    J = sheet_data['v/(nD)'].values[2:-5]
    eta = sheet_data['η'].values[2:-5] / 100
    ct = sheet_data['Ct'].values[2:-5]
    cp = sheet_data['Cp'].values[2:-5]
    pitch_angle = (i - 1) * pitch_increment
    
    J_data.extend(J)
    eta_data.extend(eta)
    ct_data.extend(ct)
    cp_data.extend(cp)
    pitch_data.extend([pitch_angle] * len(J))

# Create a 3D surface plot
plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"
fig, ax = plt.subplots(figsize=(6, 4))
X, Y = np.meshgrid(np.unique(J_data), np.unique(pitch_data))
Z = griddata((J_data, pitch_data), eta_data, (X, Y), method='linear')
cf = ax.contour(X, Y, Z, 12,linewidths=0.4, colors='k')



cf = ax.contourf(X, Y, Z, 12)

# ax.axvline(0.1, color='red', linewidth=1.2)
# ax.axvline(0.8, color='red', linewidth=1.2)
# ax.axvline(2.65, color='red', linewidth=1.2)

ax.axvline(0.1, color='tab:red', linewidth=1.2, linestyle='-')
ax.text(0.11, 0.95, 'Hover', transform=ax.get_xaxis_transform(), fontsize=10, va='top', color='white')

ax.axvline(0.8, color='tab:red', linewidth=1.2, linestyle='-')
ax.text(0.81, 0.95, 'Climb', transform=ax.get_xaxis_transform(), fontsize=10, va='top', color='white')

ax.axvline(2.65, color='tab:red', linewidth=1.2, linestyle='-')
ax.text(2.66, 0.95, 'Cruise', transform=ax.get_xaxis_transform(), fontsize=10, va='top', color='white')


ax.set_xlabel('Advance Ratio J')
ax.set_ylabel('Blade Pitch /$°$')
cbar = fig.colorbar(cf, ax=ax)
cbar.ax.set_ylabel('η')
cbar.ax.tick_params(labelsize=12)
cbar.outline.set_linewidth(1.2)
ax.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
ax.tick_params(axis='both', which='major', labelsize=12)
for spine in ax.spines.values():
    spine.set_linewidth(1.2)

plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"
fig, ax = plt.subplots(figsize=(6, 4))
X, Y = np.meshgrid(np.unique(J_data), np.unique(pitch_data))
Z = griddata((J_data, pitch_data), ct_data, (X, Y), method='linear')
cf = ax.contour(X, Y, Z, 12,linewidths=0.4, colors='k')
cf = ax.contourf(X, Y, Z, 12)
ax.set_xlabel('Advance Ratio J')
ax.set_ylabel('Blade Pitch /°')
cbar = fig.colorbar(cf, ax=ax)
cbar.ax.set_ylabel('$C_t$')
cbar.ax.tick_params(labelsize=12)
cbar.outline.set_linewidth(1.2)
ax.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
ax.tick_params(axis='both', which='major', labelsize=12)
for spine in ax.spines.values():
    spine.set_linewidth(1.2)

plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"
fig, ax = plt.subplots(figsize=(6, 4))
X, Y = np.meshgrid(np.unique(J_data), np.unique(pitch_data))
Z = griddata((J_data, pitch_data), cp_data, (X, Y), method='linear')
cf = ax.contour(X, Y, Z, 12,linewidths=0.4, colors='k')
cf = ax.contourf(X, Y, Z, 12)
ax.set_xlabel('Advance Ratio J')
ax.set_ylabel('Blade Pitch /°')
cbar = fig.colorbar(cf, ax=ax)
cbar.ax.set_ylabel('$C_p$')
cbar.ax.tick_params(labelsize=12)
cbar.outline.set_linewidth(1.2)
ax.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)
ax.tick_params(axis='both', which='major', labelsize=12)
for spine in ax.spines.values():
    spine.set_linewidth(1.2)

# plt.tight_layout()
plt.show()