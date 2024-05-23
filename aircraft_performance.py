# calculations and plots
from isa import ISA
import propulsion
import climb_plot
import velocity_power_drag
import constraints_diagram
import mission_energy


if __name__ == '__main__':

    # ---- PRESCRIBED ATTRIBUTES ----
    # sizing
    MTOW = 2400 * 9.81  # N
    S = 13.3  # m^2

    # ---- AERODYNAMICS ----
    C_L_MAX = 1.5
    C_D = 0.046

    # ---- PERFORMANCE ----
    cruise_speed_tas = 150 * 1609.34 / 60**2

    # ---- MISSION ----
    cruise_altitude = 3000  # ft
    cruise_atm = ISA(cruise_altitude)
    hover_max_altitude = 5000  # ft
    hover_max_atm = ISA(hover_max_altitude)

    attributes = propulsion.prop_hover_attributes(
        aircraft_MTOW = MTOW,
        t_w_ratio = 1.5,
        figure_of_merit = 0.7,
        n_rotors = 6,
        disk_loading = 50 * 9.81,
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
    # ideal_power(150*9.81, 20*9.81, 1.5, 1.1, 0.7, MTOW, 6)