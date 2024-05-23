import matplotlib.pyplot as plt
from matplotlib.ticker import FormatStrFormatter

motors = [
{
'name': 'EMRAX',
'weight_range_kg': [7, 40],
'power_range_kw': [28, 200],
'torque_range_nm': [89, 500]
},
{
'name': 'Joby',
'weight_range_kg': [2.7, 22],
'power_range_kw': [8, 60],
'torque_range_nm': [13, 255]
},
{
'name': 'LaunchPoint',
'weight_range_kg': [1.5, 7.0],
'power_range_kw': [6, 10],
'torque_range_nm': [10, 64]
},
{
'name': 'Neu Motor',
'weight_range_kg': [2],
'power_range_kw': [15],
'torque_range_nm': [24]
},
{
'name': 'MAGicALL',
'weight_range_kg': [2.8, 50],
'power_range_kw': [10, 240],
'torque_range_nm': [25, 1000]
},
{
'name': 'Rotex',
'weight_range_kg': [1.5, 23],
'power_range_kw': [3, 50],
'torque_range_nm': [5, 217]
},
{
'name': 'Thin Gap',
'weight_range_kg': [6, 18],
'power_range_kw': [13, 141],
'torque_range_nm': [50, 230]
},
{
'name': 'MagniX',
'weight_range_kg': [53],
'power_range_kw': [265],
'torque_range_nm': [1012]
},
{
'name': 'Siemens',
'weight_range_kg': [5, 50],
'power_range_kw': [200, 260],
'torque_range_nm': [1000, 1500]
},
{
'name': 'YASA P400',
'weight_range_kg': [24],
'power_range_kw': [60],
'torque_range_nm': [255]
},
{
'name': 'Brusa',
'weight_range_kg': [25],
'power_range_kw': [31],
'torque_range_nm': [53]
},
{
'name': 'TM4',
'weight_range_kg': [340],
'power_range_kw': [225],
'torque_range_nm': [1852]
},
{
'name': 'UQM',
'weight_range_kg': [85],
'power_range_kw': [150],
'torque_range_nm': [360]
},
{
'name': 'McLaren',
'weight_range_kg': [26],
'power_range_kw': [110, 230],
'torque_range_nm': [105, 200]
},
{
'name': 'Renault',
'weight_range_kg': [16],
'power_range_kw': [136],
'torque_range_nm': [35]
}
]

# Extract data from the motors list
names = [motor['name'] for motor in motors]
weights = [sum(motor['weight_range_kg'])/2 for motor in motors]
powers = [sum(motor['power_range_kw'])/2 for motor in motors]
torques = [sum(motor['torque_range_nm'])/2 for motor in motors]

plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"
# Create a figure with two subplots side by side
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(6, 4))


# Plot power vs weight
ax1.scatter(weights, powers, color='tab:blue')
ax1.set_xlabel('Weight /$kg$')
ax1.set_ylabel('Power $/kW$')
# ax1.set_title('Motor Power vs Weight')
ax1.set_xscale('log')
# ax1.set_yscale('log')
ax1.grid(True)
ax1.xaxis.set_minor_formatter(FormatStrFormatter(""))
ax1.yaxis.set_minor_formatter(FormatStrFormatter(""))
ax1.grid(which='major', alpha=0.5)
ax1.grid(which='minor', alpha=0.2)

ax1.tick_params(axis='both', which='major', width=1.2)
for spine in ax1.spines.values():
    spine.set_linewidth(1.2)

# Plot torque vs weight
ax2.scatter(weights, torques, color='tab:red')
ax2.set_xlabel('Weight /$kg$')
ax2.set_ylabel('Torque /$Nm$')
ax2.set_xscale('log')
# ax2.set_yscale('log')
# ax2.set_title('Motor Torque vs Weight')
ax2.grid(True)
ax2.xaxis.set_minor_formatter(FormatStrFormatter(""))
ax2.yaxis.set_minor_formatter(FormatStrFormatter(""))
ax2.grid(which='major', alpha=0.5)
ax2.grid(which='minor', alpha=0.2)

ax2.tick_params(axis='both', which='major', width=1.2)
for spine in ax2.spines.values():
    spine.set_linewidth(1.2)

# Adjust layout and spacing
plt.subplots_adjust(wspace=0.3)
fig.tight_layout()

# Show the plot
plt.show()