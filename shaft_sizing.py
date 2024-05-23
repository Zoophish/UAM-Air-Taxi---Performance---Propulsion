import numpy as np
import matplotlib.pyplot as plt

if __name__ == '__main__':
    density = 7840
    yield_strength_steel = 350e6
    yield_strength_ti = 550e6
    T = 1800

    r_o = 24 * 1e-3
    t = np.linspace(1 * 1e-3, 24 * 1e-3)

    J = np.pi / 2 * (r_o**4 - (r_o - t)**4)
    A = np.pi * (r_o**2 - (r_o - t)**2)

    shear_max = T * r_o / J

    plt.rcParams["font.family"] = "serif"
    plt.rcParams["mathtext.fontset"] = "dejavuserif"
    ax = plt.gca()
    ax.plot(t * 1e3, shear_max, label='Max Shear Stress', lw=1)
    ax.set_xlabel('Annular Shaft Thickness $t$ /$mm$')
    ax.axhline(y=yield_strength_steel, lw=1)
    # ax.axhline(y=yield_strength_ti, lw=1)
    ax.set_ylabel('Max Shear Stress')

    ax2 = ax.twinx()
    ax2.plot(t * 1e3, A, linestyle='dashed', label='Area', lw=1)
    ax2.set_ylabel('Area /$mm^2$')
    
    ax.legend()
    ax2.legend()
    plt.show()

