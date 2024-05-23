from ambiance import Atmosphere

def ISA(alt):
    """
    Returns the ISA air properties.
    @param alt: float, The altitude in feet
    """
    atmosphere = Atmosphere(alt * 0.3048)
    return {
        'density': atmosphere.density[0],
        'temperature': atmosphere.temperature[0],
        'pressure': atmosphere.pressure[0]
    }