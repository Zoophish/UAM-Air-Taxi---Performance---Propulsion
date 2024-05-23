# Import libraries
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from curved_text import CurvedText

def plot(
# Define constants
rho = 1.225, # Air density at sea level
S = 13.3, # Wing area
CD0 = 0.038, # Drag coefficient
b = 0.017665,
W = 2400 * 9.81, # Weight
stall_speed = 43,
max_power=780
):
    gammas = np.deg2rad(np.linspace(0, 15, 21))
    grads = np.sin(gammas)

    # Define range of airspeeds
    V = np.linspace(40, 100, 100) # Airspeed in m/s

    # Calculate power required for each airspeed and gradient
    Preq = np.zeros((len(gammas), len(V))) # Power required in watts
    Dreq = np.zeros((len(gammas), len(V)))
    for i in range(len(gammas)):
        C_L = W / (0.5 * rho * V**2 * S)
        CD = CD0 + b*C_L**2
        drag = 0.5*rho*V**2*S*CD
        weight_component = W*np.sin(gammas[i])
        Dreq[i] = drag + weight_component
        Preq[i] = Dreq[i] * V / 1e3


    # Plot power required versus airspeed for each gradient
    # plt.rcParams["font.family"] = "serif"
    # plt.rcParams["mathtext.fontset"] = "dejavuserif"
    plt.figure()
    i = 0
    for grad, preq in zip(grads, Preq):
        if i % 5 == 0:
            plt.plot(V, preq, color='black', lw=.6)
            text = CurvedText(
                    V[65:],
                    preq[65:],
                    text=f'{grad * 100 :1.1f}%',
                    va = 'bottom',
                    axes = plt.gca(),
                    color='black',
                    size = 9)
        else:
            plt.plot(V, preq, color='black', lw=.25)
        i += 1

    plt.text(60, max_power + 10, 'Maximum Continuous Power', color='black', size=9)
    plt.axhline(max_power, lw=0.6, color='black', ls='--')

    # acceptable_a = [(v, p) for v, p in zip(V, Preq[0]) if v > 50 and v < 60]
    # acceptable_b = [(v, p) for v, p in zip(V, Preq[1]) if v > 50 and v < 60]
    # plt.fill_between(acceptable_a[:][0], acceptable_a[:][1], acceptable_b[:][1], alpha=0.2, color="blue")

    ax1 = plt.gca()
    ax1.tick_params(axis='both', which='major', width=1.2)
    for spine in ax1.spines.values():
        spine.set_linewidth(1.2)

    plt.xlabel('Airspeed EAS /$ms^{-1}$')
    plt.ylabel('Power /$kW$')
    plt.grid(True, lw=0.5)
    plt.xlim(40, 100)

    plt.show()

plot()