from pybemt.solver import Solver
import matplotlib.pyplot as plt


s = Solver('rotor.ini')
T, Q, P, section_df = s.run()

plt.plot(T, Q)
plt.show()
