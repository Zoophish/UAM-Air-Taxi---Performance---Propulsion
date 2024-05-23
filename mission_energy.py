from numpy import cumsum
import numpy as np
from math import pi, sin, cos, asin
from scipy.optimize import root_scalar
import matplotlib.pyplot as plt
from isa import ISA
from curved_text import CurvedText

ft_m = 0.3048

def drag(C_D, density, S, V_tas):
    return C_D * 0.5 * density * S * V_tas**2

def lift_coeff(W, density, v, S):
    return W / (0.5 * density * v**2 * S)

def climb_calc(speed_tas, angle, start_alt, end_alt):
    climb_rate = speed_tas * sin(angle)  # get this from the climb optimisation
    climb_time = (end_alt - start_alt)*ft_m / climb_rate
    climb_distance = climb_time * speed_tas * cos(angle)
    return {
        'rate': climb_rate,
        'time': climb_time,
        'distance': climb_distance
    }

def calculate_profile(
    cruise_speed,
    clearance_altitude,
    hover_climb_speed,
    hover_climb_power,
    climb_speed_tas,
    MTOW,
    disk_area,
    tilt_transition_time,
    departure_range,
    cruise_altitude,
    required_range_miles,
    climb_gradient,
    arrival_range, 
    approach_speed,
    include_diversion,
    reserve_distance_miles,
    diversion_altitude,
    S,
    C_LMAX,
    C_D0,
    b,
    idle_power,
    plot=False):

    sea_level_atm = ISA(0)
    clearance_level_atm = ISA(clearance_altitude)
    cruise_level_atm = ISA(cruise_altitude)

    # Convert and calculate speeds
    m2mile = 1609.34

    depArrSpeed = approach_speed * 0.44704

    hover_descent_power = hover_climb_power
    hover_climb_time = clearance_altitude / hover_climb_speed

    # Calculate average transition power
    func = lambda w : w**4 + (w**3) * (2 * depArrSpeed * cos(0)) + (w**2) * (depArrSpeed**2) - (MTOW / (2 * clearance_level_atm['density'] * disk_area))**2
    induced_velocity = root_scalar(func, method='newton', x0=100).root
    transitionPower = MTOW * depArrSpeed * cos(0) + induced_velocity * MTOW
    avg_transition_accel_power = (hover_climb_power + transitionPower) / 2

    # Acceleration climb power (maximum power requirement would be at the top of the climb)
    sin_gamma = climb_gradient
    climb_angle = asin(sin_gamma)
    cos_gamma = 1 - sin_gamma**2
    CL_climb = lift_coeff(MTOW*cos_gamma, cruise_level_atm['density'], climb_speed_tas, S)
    CD_climb = C_D0 + b*CL_climb**2
    climb_drag = drag(CD_climb, cruise_level_atm['density'], S, climb_speed_tas) + MTOW * sin_gamma
    descent_drag = drag(CD_climb, cruise_level_atm['density'], S, climb_speed_tas) - MTOW * sin_gamma
    climb_power = climb_drag * climb_speed_tas
    # print(f"Climb Thrust {climb_drag}")
    # print(f"Climb Speed {climb_speed_tas}")
    descent_power = max(idle_power, descent_drag * climb_speed_tas)

    # Calculate transition time to reach the departure altitude
    # transition_time = ((clearance_altitude-clearance_altitude)* ft_m * MTOW) / avg_transition_accel_power # Double check
    transition_time = tilt_transition_time

    # Calculate arrival and departure ideal power
    # Calculate drag force (D) using lift-to-drag ratio (L/D)
    CL_deparr = lift_coeff(MTOW, clearance_level_atm['density'], depArrSpeed, S)
    ldr = CL_deparr / (C_D0 + b*CL_deparr**2)
    dragForce = MTOW / ldr
    # Calculate ideal departure and arrival power
    departure_power = dragForce * depArrSpeed
    approach_power = departure_power

    departure_altitude = clearance_altitude + 100
    approach_altitude = clearance_altitude + 100

    # Calculate ideal cruise power
    cruise_power = dragForce * cruise_speed

    # Calculate distances (m) and altitudes (ft) for each phase
    transition_distance = transition_time * depArrSpeed # Transition distance
    departure_distance = departure_range # Departure distance

    climb_info = climb_calc(climb_speed_tas, climb_angle, departure_altitude, cruise_altitude)
    descent_info = climb_calc(climb_speed_tas, climb_angle, departure_altitude, cruise_altitude)

    diversion_climb_info = climb_calc(climb_speed_tas, climb_angle, approach_altitude, diversion_altitude)
    diversion_descent_info = climb_calc(climb_speed_tas, climb_angle, approach_altitude, diversion_altitude)
    diversion_cruise_distance = reserve_distance_miles*m2mile - (diversion_climb_info['distance'] + diversion_descent_info['distance'])
    diversion_cruise_time = diversion_cruise_distance / cruise_speed

    # Arrival phase
    approach_distance = arrival_range # Arrival distance

    # Transition descent phase
    transition_descent_distance = transition_time * depArrSpeed # Transition descent distance

    avg_transition_descent_power = avg_transition_accel_power

    # Cruise phase
    cruise_distance = (required_range_miles * m2mile) - (climb_info['distance'] + descent_info['distance'])

    # Calculate times for each phase
    departure_time = departure_distance / depArrSpeed
    cruise_time = cruise_distance / cruise_speed
    approach_time = approach_distance / depArrSpeed
    transition_descent_time = transition_descent_distance / depArrSpeed
    hover_landing_time = hover_climb_time

    if not include_diversion:
        standard_mission = {
            'hover_climb': {
                'time': hover_climb_time,
                'power': hover_climb_power,
                'ground_distance': 0,
                'start_altitude': 0,
                'end_altitude': clearance_altitude
                },
            'transition_climb': {
                'time': transition_time,
                'power': avg_transition_accel_power,
                'ground_distance': transition_distance,
                'start_altitude': clearance_altitude,
                'end_altitude': departure_altitude
                },
            'departure': {
                'time': departure_time,
                'power': departure_power,
                'ground_distance': departure_distance,
                'start_altitude': departure_altitude,
                'end_altitude': departure_altitude,
                },
            'climb': {
                'time': climb_info['time'],
                'power': climb_power,
                'ground_distance': climb_info['distance'],
                'start_altitude': departure_altitude,
                'end_altitude': cruise_altitude
                },
            'cruise': {
                'time': cruise_time,
                'power': cruise_power,
                'ground_distance': cruise_distance,
                'start_altitude': cruise_altitude,
                'end_altitude': cruise_altitude
                },
            'descent': {
                'time': descent_info['time'],
                'power': descent_power,
                'ground_distance': descent_info['distance'],
                'start_altitude': cruise_altitude,
                'end_altitude': departure_altitude
                },
            'approach': {
                'time': approach_time,
                'power': approach_power,
                'ground_distance': approach_distance,
                'start_altitude': departure_altitude,
                'end_altitude': departure_altitude
                },
            'transition_descent': {
                'time': transition_descent_time,
                'power': avg_transition_descent_power,
                'ground_distance': transition_descent_distance,
                'start_altitude': departure_altitude,
                'end_altitude': clearance_altitude
                },
            'hover_descent': {
                'time': hover_landing_time,
                'power': hover_descent_power,
                'ground_distance': 0,
                'start_altitude': clearance_altitude,
                'end_altitude': 0
                }
        }

    else:
        standard_mission = {
            'hover_climb': {
                'time': hover_climb_time,
                'power': hover_climb_power,
                'ground_distance': 0,
                'start_altitude': 0,
                'end_altitude': clearance_altitude
                },
            'transition_climb': {
                'time': transition_time,
                'power': avg_transition_accel_power,
                'ground_distance': transition_distance,
                'start_altitude': clearance_altitude,
                'end_altitude': departure_altitude
                },
            'departure': {
                'time': departure_time,
                'power': departure_power,
                'ground_distance': departure_distance,
                'start_altitude': departure_altitude,
                'end_altitude': departure_altitude,
                },
            'climb': {
                'time': climb_info['time'],
                'power': climb_power,
                'ground_distance': climb_info['distance'],
                'start_altitude': departure_altitude,
                'end_altitude': cruise_altitude
                },
            'cruise': {
                'time': cruise_time,
                'power': cruise_power,
                'ground_distance': cruise_distance,
                'start_altitude': cruise_altitude,
                'end_altitude': cruise_altitude
                },
            'descent': {
                'time': descent_info['time'],
                'power': descent_power,
                'ground_distance': descent_info['distance'],
                'start_altitude': cruise_altitude,
                'end_altitude': departure_altitude
                },
            'approach': {
                'time': approach_time,
                'power': approach_power,
                'ground_distance': approach_distance,
                'start_altitude': departure_altitude,
                'end_altitude': departure_altitude
                },
            'diversion_climb': {
                'time': diversion_climb_info['time'],
                'power': climb_power,
                'ground_distance': diversion_climb_info['distance'],
                'start_altitude': departure_altitude,
                'end_altitude': diversion_altitude
                },
            'diversion_cruise': {
                'time': diversion_cruise_time,
                'power': cruise_power,
                'ground_distance': diversion_cruise_distance,
                'start_altitude': diversion_altitude,
                'end_altitude': diversion_altitude
                },
            'diversion_descent': {
                'time': diversion_descent_info['time'],
                'power': descent_power,
                'ground_distance': diversion_descent_info['distance'],
                'start_altitude': diversion_altitude,
                'end_altitude': approach_altitude
                },
            'diversion_approach': {
                'time': approach_time,
                'power': approach_power,
                'ground_distance': approach_distance,
                'start_altitude': departure_altitude,
                'end_altitude': departure_altitude
                },
            'diversion_transition_descent': {
                'time': transition_descent_time,
                'power': avg_transition_descent_power,
                'ground_distance': transition_descent_distance,
                'start_altitude': departure_altitude,
                'end_altitude': clearance_altitude
                },
            'diversion_hover_descent': {
                'time': hover_landing_time,
                'power': hover_descent_power,
                'ground_distance': 0,
                'start_altitude': clearance_altitude,
                'end_altitude': 0
                }
        }

    reserve_mission = {
        'diversion_climb': {
            'time': diversion_climb_info['time'],
            'power': climb_power,
            'ground_distance': diversion_climb_info['distance'],
            'start_altitude': departure_altitude,
            'end_altitude': diversion_altitude
            },
        'cruise': {
            'time': diversion_cruise_time,
            'power': cruise_power,
            'ground_distance': diversion_cruise_distance,
            'start_altitude': diversion_altitude,
            'end_altitude': diversion_altitude
            },
        'descent': {
            'time': diversion_descent_info['time'],
            'power': descent_power,
            'ground_distance': diversion_descent_info['distance'],
            'start_altitude': diversion_altitude,
            'end_altitude': approach_altitude
            },
        'approach': {
            'time': approach_time,
            'power': approach_power,
            'ground_distance': approach_distance,
            'start_altitude': departure_altitude,
            'end_altitude': departure_altitude
            },
        'transition_descent': {
            'time': transition_descent_time,
            'power': avg_transition_descent_power,
            'ground_distance': transition_descent_distance,
            'start_altitude': departure_altitude,
            'end_altitude': clearance_altitude
            },
        'hover_descent': {
            'time': hover_landing_time,
            'power': hover_descent_power,
            'ground_distance': 0,
            'start_altitude': clearance_altitude,
            'end_altitude': 0
            }
    }

    
    # New distances array combining all phases
    distances = cumsum([standard_mission[segment]['ground_distance'] for segment in standard_mission])
    assert distances[-1] == sum([standard_mission[segment]['ground_distance'] for segment in standard_mission])

    mission_time = sum([standard_mission[segment]['time'] for segment in standard_mission])
    reserve_mission_time = sum([reserve_mission[segment]['time'] for segment in reserve_mission])
    reserve_distances = cumsum([reserve_mission[segment]['ground_distance'] for segment in reserve_mission])

    # Calculate total energy for the mission
    total_mission_energy = sum([standard_mission[segment]['power'] * standard_mission[segment]['time'] for segment in standard_mission])
    reserve_energy = sum([reserve_mission[segment]['power'] * reserve_mission[segment]['time'] for segment in reserve_mission])

    non_cruise_segments = {segment for segment in standard_mission if segment != 'cruise'}
    non_cruise_energy = sum([standard_mission[segment]['power'] * standard_mission[segment]['time'] for segment in non_cruise_segments])

    if plot:
        print('Energy Calculations:')
        print(' Mission Segments:')
        for segment in standard_mission:
            print(f"    {segment}: {standard_mission[segment]['power'] * standard_mission[segment]['time'] / 1e6 :.2f} MJ")
            print(f"    {segment}: {standard_mission[segment]['time'] / 60 :.2f} mins")
        print(' Reserve Segments:')
        for segment in standard_mission:
            print(f"    {segment}: {standard_mission[segment]['power'] * standard_mission[segment]['time'] / 1e6 :.2f} MJ")
            print(f"    {segment}: {standard_mission[segment]['time'] / 60 :.2f} mins")

        print(f'\n    {required_range_miles :1.0f} Mile Mission Total Energy: {total_mission_energy / 1e6 :1.2f} MJ')
        print(f'        Reserve energy: {reserve_energy / 1e6 :1.2f} MJ')
        print('\n Time:')
        print(f'    Mission Time: {mission_time / 60 : 1.2f} minutes')
        print(f'    Reserve Mission Time: {reserve_mission_time / 60 : 1.2f} minutes')

        # plt.rcParams["font.family"] = "serif"
        # plt.rcParams["mathtext.fontset"] = "dejavuserif"

        total_distance = 0
        for segment in standard_mission:
            ground_distance = standard_mission[segment]['ground_distance']
            start_altitude = standard_mission[segment]['start_altitude']
            end_altitude = standard_mission[segment]['end_altitude']
            x = [total_distance / m2mile, (total_distance + ground_distance) / m2mile]
            total_distance += ground_distance
            y = [start_altitude, end_altitude]
            plt.plot(x, y, label=f'{segment}', color='black', lw=1)
            _ = CurvedText(
                x,
                y,
                text=segment,
                va = 'bottom',
                axes = plt.gca(),
                color='black',
                size = 8)
        
        plt.grid(False)
        ax1 = plt.gca()
        ax1.tick_params(axis='both', which='major', width=1.2)
        for spine in ax1.spines.values():
            spine.set_linewidth(1.2)
        plt.xlabel('Ground Distance /$miles$')
        plt.ylabel('Altitude /$ft$')
        # plt.tight_layout()
        plt.show()

    return {
        'total_mission_energy': total_mission_energy,
        'non_cruise_energy': non_cruise_energy,
        'reserve_energy': reserve_energy,
        'mission_time': mission_time,
        'segment_energies': {segment: standard_mission[segment]['power'] * standard_mission[segment]['time'] / 1e6 for segment in standard_mission}
    }


# Define the function
def plot_battery_time_trace(battery_capacity, mission_energy, charge_rate, charge_time, reserve_energy):
    energy = [battery_capacity]
    cycles = [0]
    charge_energy = charge_rate * charge_time

    if charge_energy > mission_energy:
        missions = float('inf')
        print('Unlimited missions with current charging rate')
        return
    missions = 0

    charging = False

    while energy[-1] > reserve_energy:
        if charging:
            energy.append(min(energy[-1] + charge_energy, battery_capacity))
            cycles.append(cycles[-1] + 0.5)
            charging = False

        else:
            energy.append(energy[-1] - mission_energy)
            cycles.append(cycles[-1] + 0.5)

            missions += 1
            charging = True

    missions = missions - 1
    # Plot the energy vs time graph
    # plt.rcParams["font.family"] = "serif"
    # plt.rcParams["mathtext.fontset"] = "dejavuserif"

    plt.plot(cycles, [e / 1e6 for e in energy], color="blue", lw=.6)
    plt.xlabel("Trip Cycles")
    plt.ylabel("Battery Capacity /$MJ$")
    plt.ylim(bottom=0)
    # plt.title(f"End of Life Battery Performance with Trip Cycles\nNumber of missions completed: {missions}")
    plt.text(missions / 2.5, reserve_energy / 2e6, "Reserve Capacity", color='red')

    ax1 = plt.gca()
    ax1.tick_params(axis='both', which='major', width=1.2)
    for spine in ax1.spines.values():
        spine.set_linewidth(1.2)

    # Plot the reserve level as a light red rectangle
    plt.axhspan(reserve_energy / 1e6, 0, facecolor="red", alpha=0.1)
    plt.grid(True, lw=.25)
    plt.show()
    return missions




if __name__ == '__main__':

    # ---- SIZING BATTERY ON LIMITING CASE ----
    mission_metrics = calculate_profile(
        cruise_speed=67,
        climb_speed_tas=50,
        clearance_altitude=20/0.3,
        hover_climb_speed=2.0,
        hover_climb_power=690e3,
        MTOW = 2386 * 9.81,
        disk_area=42.4,
        tilt_transition_time=10,
        departure_range=500,
        cruise_altitude=3000,
        include_diversion=False,
        required_range_miles=25,
        climb_gradient=0.0514,
        arrival_range=500,
        approach_speed=67,
        reserve_distance_miles=25,
        diversion_altitude=1500,
        S = 13.33,
        C_LMAX = 1.5,
        C_D0 = 0.0479,
        b = .0393,
        idle_power=0,
        plot=True
    )

    # ---- OPERATIONAL ENERGY USAGE ----

    # num_cycles = plot_battery_time_trace(
    #     battery_capacity=591e6, #467095008,  # this is the 60 mile and diversion energy including figures of merit
    #     mission_energy=145.4e6,  # this is the 25 mile mission energy without diversion
    #     charge_rate=220e3,
    #     charge_time=10*60,
    #     reserve_energy=103.5e6
    # )
    
    # print(num_cycles)

def binary_search_climb_gradient(low, high, target_energy, epsilon=1e-6):
    while high - low > epsilon:
        mid = (low + high) / 2
        mission_metrics = calculate_profile(
            cruise_speed=67,
            climb_speed_tas=50,
            clearance_altitude=20/0.3,
            hover_climb_speed=2.0,
            hover_climb_power=690e3,
            MTOW=2386 * 9.81,
            disk_area=42.4,
            tilt_transition_time=10,
            departure_range=500,
            cruise_altitude=3000,
            include_diversion=False,
            required_range_miles=60,
            climb_gradient=mid,
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
        total_energy = mission_metrics['total_mission_energy'] + mission_metrics['reserve_energy']
        
        if total_energy < target_energy:
            low = mid
        else:
            high = mid
    
    return low

def plot_segment_energies(segment_energies):
    segments = list(segment_energies.keys())
    energies = list(segment_energies.values())

    # Reformat segment labels
    formatted_segments = [segment.replace('_', ' ').title() for segment in segments]

    plt.rcParams["font.family"] = "serif"
    plt.rcParams["mathtext.fontset"] = "dejavuserif"
    plt.figure(figsize=(6, 4))

    # Customize bar chart appearance
    bars = plt.bar(formatted_segments, energies, color='#1f77b4', edgecolor='black', linewidth=0.8)
    plt.xlabel('Mission Segments', fontsize=10)
    plt.ylabel('Energy /$MJ$', fontsize=10)
    plt.xticks(rotation=45, ha='right', fontsize=8)
    plt.yticks(fontsize=8)
    plt.grid(True, axis='y', linestyle='--', alpha=0.7, linewidth=0.5)

    # Add value labels on top of each bar
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2, height, f'{height:.2f}',
                 ha='center', va='bottom', fontsize=8)

    # Remove top and right spines
    ax = plt.gca()
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    # Increase the width of the remaining spines
    ax.spines['bottom'].set_linewidth(1.2)
    ax.spines['left'].set_linewidth(1.2)

    # Customize tick appearance
    ax.tick_params(width=1.2)

    # Add a box around the plot
    ax.spines['top'].set_visible(True)
    ax.spines['right'].set_visible(True)
    ax.spines['top'].set_linewidth(1.2)
    ax.spines['right'].set_linewidth(1.2)

    plt.tight_layout()
    plt.show()

# plot_segment_energies(mission_metrics['segment_energies'])

# # Example usage
# target_energy = 486e6
# low_climb_gradient = 0.0
# high_climb_gradient = 1.0
# epsilon = 1e-6

# climb_gradient = binary_search_climb_gradient(low_climb_gradient, high_climb_gradient, target_energy, epsilon)
# print(f"Climb gradient: {climb_gradient}")