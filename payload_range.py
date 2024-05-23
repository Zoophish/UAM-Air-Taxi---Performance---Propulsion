import numpy as np
import matplotlib.pyplot as plt
from mission_energy import calculate_profile
from curved_text import CurvedText
from isa import ISA

V_cruise = 67
rho = ISA(3000)['density']

S = 13.3
CD0 = 0.038
b = 0.017665

C_upper_limit = 0.8
C_lower_limit = 0.3
reserve_energy = 145e6
C = 486e6 - reserve_energy

OWE = 2042
PL = np.linspace(0, 344, 10)
MTOW = (OWE + PL) * 9.81

# altitudes = np.linspace(3000, 500, 6)
altitudes = [3000]
rhos = {alt: ISA(alt)['density'] for alt in altitudes}

def binary_search_required_range(low, high, target_energy, w, alt, epsilon=.1):
    while high - low > epsilon:
        mid = (low + high) / 2
        mission_metrics = calculate_profile(
            cruise_speed=67,
            climb_speed_tas=50,
            clearance_altitude=20/0.3,
            hover_climb_speed=2.0,
            hover_climb_power=690e3,
            MTOW=w,
            disk_area=42.4,
            tilt_transition_time=10,
            departure_range=500,
            cruise_altitude=alt,
            include_diversion=False,
            required_range_miles=mid,
            climb_gradient=0.051,
            arrival_range=500,
            approach_speed=67,
            reserve_distance_miles=25,
            diversion_altitude=1500,
            S=13.33,
            C_LMAX=1.5,
            C_D0=0.0479,
            b=.0393,
            idle_power=0,
            plot=False
        )
        total_energy = mission_metrics['total_mission_energy']
        
        if total_energy < target_energy:
            low = mid
        else:
            high = mid
    
    return low


plt.figure(figsize=(6, 4))
plt.rcParams["font.family"] = "serif"
plt.rcParams["mathtext.fontset"] = "dejavuserif"


for alt in altitudes:
    R = []
    for mtow in MTOW:
        R.append(binary_search_required_range(0, 500, C, mtow, alt))
    plt.plot(R, PL, lw=1, color='tab:blue')
    text = CurvedText(
        R[::-1],
        PL[::-1],
        text=f'{alt : .0f} ft Cruise',
        va = 'bottom',
        axes = plt.gca(),
        color='black',
        size = 8)

plt.plot([0, R[-1]], [PL[-1], PL[-1]], lw=1.2, linestyle='--', color='black')
plt.text(5, 355, 'Max Payload\n   344 kg', size=8, fontname='serif')

plt.ylim(0, 400)
ax1 = plt.gca()
ax1.tick_params(axis='both', which='major', width=1.2)
for spine in ax1.spines.values():
    spine.set_linewidth(1.2)

plt.xlabel('Range /$miles$', fontsize=10, fontname='serif')
plt.ylabel('Payload /$kg$', fontsize=10, fontname='serif')
plt.xticks(fontsize=8, fontname='serif')
plt.yticks(fontsize=8, fontname='serif')

plt.grid(True, lw=0.5, linestyle='--', alpha=0.7)
plt.tight_layout()

plt.savefig('payload_range.eps', format='eps', dpi=600)
plt.show()