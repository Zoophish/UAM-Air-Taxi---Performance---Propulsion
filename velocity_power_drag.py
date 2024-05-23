import numpy as np
from matplotlib import pyplot as plt
from curved_text import CurvedText
from isa import ISA

def plot(
rho = ISA(0)['density'], # Air density at sea level
S = 13.3, # Wing area
CL_max = 1.5,
CD0 = 0.038, # Drag coefficient
b = 0.017665,
W = 2400 * 9.81, # Weight
V_stall = 43.90,
max_power =814e3):
    V = np.linspace(20, 110, 100) # Airspeed in m/s

    C_L = W / (0.5 * rho * V**2 * S)
    CD = CD0 + b*C_L**2
    profile_drag = 0.5*rho*V**2*S*CD0
    induced_drag = 0.5*rho*V**2*S*b*C_L**2
    drag = 0.5*rho*V**2*S*CD
    P = drag*V

    specific_range_energy = P / V

    cruise_capacity = 355e6
    max_range = cruise_capacity / specific_range_energy / 1.6e3

    # plt.rcParams["font.family"] = "serif"
    # plt.rcParams["mathtext.fontset"] = "dejavuserif"

    # plt.plot(V, profile_drag, lw=1, color='black')
    # plt.plot(V, induced_drag, lw=1, color='black')
    # plt.plot(V, drag, lw=1, color='black')
    plt.plot(V, P, lw=0.6, color='black')
    text = CurvedText(
                V[50:],
                P[50:],
                text="Cruise Power",
                va = 'bottom',
                axes = plt.gca(),
                color='black',
                size = 8)

    # # plt.hlines([max_power], [min(V)], [max(V)], lw=1, color='black', linestyle='dashed')
    plt.axvline(V_stall, lw=1, color='gray', linestyle='dashed')
    plt.text(V_stall + 2, 2500, '$V_{stall}$', size=9)
    plt.text(50, max_power, 'Max Power', size=8)

    plt.xlabel('Airspeed EAS /$ms^{-1}$')
    plt.ylabel('Power /$W$')
    # plt.ylabel('Drag /$N$')

    ax1 = plt.gca()
    ax1.tick_params(axis='both', which='major', width=1.2)
    for spine in ax1.spines.values():
        spine.set_linewidth(1.2)

    ax2 = plt.twinx()
    ax2.plot(V, max_range, lw=1, color='black')
    text = CurvedText(
                V[49:],
                max_range[49:],
                text="Max Range",
                va = 'bottom',
                axes = plt.gca(),
                color='black',
                size = 8)
    ax2.set_ylabel("Max Range /$miles$")

    # text = CurvedText(
    #             V[40:],
    #             profile_drag[40:],
    #             text="Profile Drag",
    #             va = 'bottom',
    #             axes = plt.gca(),
    #             color='black',
    #             size = 8)
    # text = CurvedText(
    #             V[49:],
    #             induced_drag[49:],
    #             text="Lift-Induced Drag",
    #             va = 'bottom',
    #             axes = plt.gca(),
    #             color='black',
    #             size = 8)
    # text = CurvedText(
    #             V[49:],
    #             drag[49:],
    #             text="Total Drag",
    #             va = 'bottom',
    #             axes = plt.gca(),
    #             color='black',
    #             size = 8)
    plt.grid(True, lw=0.25)
    plt.show()


if __name__ == '__main__':
    plot()