from math import pi
import matplotlib.pyplot as plt
from numpy import linspace
from curved_text import CurvedText
from isa import ISA


def prop_hover_attributes(
    aircraft_MTOW,
    t_w_ratio,
    figure_of_merit,
    n_rotors,
    disk_loading,
    air_density = 1.225):

    max_thrust = aircraft_MTOW * t_w_ratio
    max_thrust_per_rotor = max_thrust / n_rotors

    total_disk_area = max_thrust / disk_loading
    rotor_area = total_disk_area / n_rotors
    rotor_radius = (rotor_area / pi)**0.5

    # Actuator Disk Method - https://web.mit.edu/16.unified/www/FALL/thermodynamics/notes/node86.html
    max_power_ideal = max_thrust * (disk_loading / (2*air_density))**0.5

    max_power_real = max_power_ideal / figure_of_merit

    # hover_efficiency = T*(T/2*rho)*0.5 / P

    return {
        'total_disk_area': total_disk_area,
        'disk_loading': disk_loading,
        'max_total_thrust': max_thrust,
        'rotor_area': rotor_area,
        'rotor_radius': rotor_radius,
        'rotor_diameter': rotor_radius*2,
        'max_power_ideal': max_power_ideal,
        'max_power_real': max_power_real,
        'max_thrust': max_thrust,
        'max_thrust_per_rotor': max_thrust_per_rotor,
        'max_power_per_rotor': max_power_real / n_rotors
    }


# https://web.mit.edu/16.unified/www/FALL/thermodynamics/notes/node86.html
    # n_propulsive = 2 / (1 + (thrust / (area * ))**0.5)


# V_EAS cruise
def stall_speed(W, C_L, S, density=1.225):
    return (2 * W / (density*C_L*S))**0.5


def steady_level_power(V_eas, C_L, C_D, W):
    L_D = C_L / C_D
    D = W / L_D
    return V_eas * D


def ideal_power(
        dl_min,
        dl_max,
        t_w_ratio_min,
        t_w_ratio_max,
        figure_of_merit,
        MTOW,
        n_rotors,
        fixed_rpm,
        speed_of_sound):
    
    tw_ratios = linspace(t_w_ratio_min, t_w_ratio_max, 21)
    disk_loadings = linspace(dl_min, dl_max, 100)

    attribute_list = [[
        prop_hover_attributes
        (
            aircraft_MTOW = MTOW,
            t_w_ratio = twr,
            figure_of_merit= figure_of_merit,
            n_rotors = n_rotors,
            disk_loading = dl,
            air_density=hover_max_atm['density']
        )
        for dl in disk_loadings] for twr in tw_ratios]

    # plt.rcParams["font.family"] = "serif"
    # plt.rcParams["mathtext.fontset"] = "dejavuserif"

    fig, ax1 = plt.subplots()

    i = 5
    for twr, tw_attributes in zip(tw_ratios, attribute_list):
        ideal_powers = [attr['max_power_ideal'] / 1e3 for attr in tw_attributes]
        rotor_diameters = [attr['rotor_diameter'] for attr in tw_attributes]
        if (i % 5) == 0:
            ax1.plot(rotor_diameters, ideal_powers, lw = .6, color='black')
            text = CurvedText(
                rotor_diameters,
                ideal_powers,
                text=f'Hover T/W = {twr:.1f}',
                va = 'bottom',
                axes = ax1,
                color='black',
                size = 8)
        else:
            ax1.plot(rotor_diameters, ideal_powers, lw = .25, color='black')
        i += 1
    ax1.set_xlabel('Rotor Diameter /$m$')
    ax1.set_ylabel('Ideal Hover Power /$kW$')

    # Calculate Mach numbers based on rotor diameters and fixed RPM
    rotor_radii = [d / 2 for d in rotor_diameters]
    tip_speeds = [r * fixed_rpm * 2 * 3.14159 / 60 for r in rotor_radii]
    mach_numbers = [ts / speed_of_sound for ts in tip_speeds]

    # ax2 = ax1.twiny()
    # ax2.set_xlim(ax1.get_xlim())
    # tick_positions = [rotor_diameters[i] for i in range(0, len(rotor_diameters), 20)]
    # tick_labels = [f'{mach:.2f}' for mach in mach_numbers[::20]]
    # ax2.set_xticks(tick_positions)
    # ax2.set_xticklabels(tick_labels)
    # ax2.set_xlabel('Tip Speed Mach Number')

    ax1.tick_params(axis='both', which='major', width=1.2)
    for spine in ax1.spines.values():
        spine.set_linewidth(1.2)

    plt.grid(True)
    plt.tight_layout()
    plt.show()

def power_drag_velocity(C_D0, b, C_L, W, S, altitude):
    atm = ISA(altitude)
    v_tass = linspace(0, 100, 100)
    DVs = []
    Ps = []
    for v_tas in v_tass:
        C_D = C_D0 + b * C_L**2
        D = 0.5 * atm['density'] * v_tas**2 * S * C_D
        T = D
        DVs.append(D * v_tas)
        Ps.append(P)
    plt.plot(v_tass, Ps)
    plt.show()


def EAS(v_tas, density):
    sea_level_atm = ISA(0)
    return (v_tas**2 * density/sea_level_atm['density'])**0.5

def lift_coeff(W, density, v, S):
    return W / (0.5 * density * v**2 * S)

if __name__ == '__main__':

    # sizing
    MTOW = 2400 * 9.81  # N
    S = 13.3  # m^2

    DISK_LOADING = 73 #54.07  # kg/m^2
    TW_RATIO = 1.3

    # aerodynamics
    C_L_MAX = 1.5
    C_D = 0.046

    cruise_speed_tas = 150 * 1609.34 / 60**2

    # mission
    cruise_altitude = 3000  # ft
    cruise_atm = ISA(cruise_altitude)
    hover_max_altitude = 5000  # ft
    hover_max_atm = ISA(hover_max_altitude)

    attributes = prop_hover_attributes(
        aircraft_MTOW = MTOW,
        t_w_ratio = TW_RATIO,
        figure_of_merit = 0.7,
        n_rotors = 6,
        disk_loading = DISK_LOADING * 9.81,
        air_density=hover_max_atm['density'])

    v_cruise_stall_tas = stall_speed(MTOW, C_L_MAX, S, cruise_atm['density'])

    C_L_cruise = lift_coeff(MTOW, cruise_atm['density'], cruise_speed_tas, S)
    cruise_thrust = MTOW / (C_L_cruise / C_D)
    cruise_power = steady_level_power(cruise_speed_tas, C_L_cruise, C_D, MTOW)
    cruise_power_rotor = cruise_power / 6

    print("\n\nCruise Performance:")
    print(f"    Stall Speed EAS: {EAS(v_cruise_stall_tas, cruise_atm['density']) :.2f}")
    print(f"    Cruise Speed EAS: {EAS(cruise_speed_tas, cruise_atm['density']) :.2f}")
    print(f"    Cruise Speed TAS: {cruise_speed_tas :.2f}")

    print(f"    Cruise Thrust: {cruise_thrust : 1.2f}")
    print(f"    Cruise Power: {cruise_power :.2f}")
    print(f"    Cruise Power per Rotor: {cruise_power_rotor :.2f}")

    print("\nAircraft Propulsion Metrics")
    for key in attributes:
        print(f"    {key}: {attributes[key] :.2f}")

    # power_drag_velocity(.02, .05, 0.9, 2400*9.81, S, attributes['total_disk_area'], 3000)
    ideal_power(150*9.81, 20*9.81, 1.8, 1.0, 1, MTOW, 6, 1500, 343)