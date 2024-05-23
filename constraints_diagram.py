import numpy as np
from matplotlib import pyplot as plt
from curved_text import CurvedText
from isa import ISA

def plot(
    sea_level_atm=ISA(0),
    cruise_atm=ISA(3000 * 0.3),
    V=67,
    V_stall=43.9,
    CL_max=1.5,
    W=2386 * 9.81,
    AR=12.3,
    CD0=0.038,  # Drag coefficient
    e=.728):

    k = 1 / (np.pi * AR * e)

    WS = np.linspace(80, 2000, 100)
    WS_stall = 0.5 * sea_level_atm['density'] * V_stall**2 * CL_max
    S_landing = 1000
    WS_landing = CL_max * sea_level_atm['density'] * S_landing / 2

    plt.rcParams["font.family"] = "serif"
    plt.rcParams["mathtext.fontset"] = "dejavuserif"

    fig, ax = plt.subplots(figsize=(6, 4))

    ax.axvline(x=WS_stall, lw=1, color='black', linestyle='--', alpha=0.7)
    ax.axvline(x=WS_landing, lw=1, color='black', linestyle='--', alpha=0.7)
    ax.text(WS_stall + 50, 1.0, 'Stall', size=8, fontfamily='serif')
    ax.text(WS_landing + 50, 1.0, '1km Runway Landing', size=8, fontfamily='serif')

    # ---- CRUISE ----
    n = 1
    dh_dt = 0
    q = 0.5 * cruise_atm['density'] * V**2
    TW = q * CD0 / WS + (k * n**2 / q) * WS + (1 / V) * dh_dt
    ax.plot(WS, TW, lw=0.8, color='black')
    ax.fill_between(WS, ax.get_ylim()[0], TW, facecolor='green', alpha=0.3)
    text = CurvedText(
        WS[50:],
        TW[50:],
        text="Cruise",
        va='bottom',
        axes=ax,
        color='black',
        size=8,
        fontfamily='serif'
    )

    # ---- CLIMB ----
    n = 1
    dh_dt = 4.35
    q = 0.5 * sea_level_atm['density'] * V**2
    TW = q * CD0 / WS + (k * n**2 / q) * WS + (1 / V) * dh_dt
    ax.plot(WS, TW, lw=0.8, color='black')
    text = CurvedText(
        WS[50:],
        TW[50:],
        text="Climb",
        va='bottom',
        axes=ax,
        color='black',
        size=8,
        fontfamily='serif'
    )

    # ---- TURN ----
    dh_dt = 0
    n = 3.5
    q = 0.5 * sea_level_atm['density'] * V**2
    TW = q * CD0 / WS + (k * n**2 / q) * WS + (1 / V) * dh_dt
    ax.plot(WS, TW, lw=0.8, color='black')
    text = CurvedText(
        WS[50:],
        TW[50:],
        text="3.5g Maneouvre",
        va='bottom',
        axes=ax,
        color='black',
        size=8,
        fontfamily='serif'
    )

    ax.set_xlabel('$W/S$ /$Nm^{-2}$', fontsize=10, fontfamily='serif')
    ax.set_ylabel('$T/W$', fontsize=10, fontfamily='serif')
    # ax.set_title("Forward Flight Constraints", fontsize=12, fontfamily='serif')
    ax.grid(True, linestyle='--', linewidth=0.5, alpha=0.7)

    for spine in ax.spines.values():
        spine.set_linewidth(1.2)

    plt.tight_layout()
    plt.show()

plot()