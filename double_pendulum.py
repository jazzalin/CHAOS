""" Numerical simulation of double pendulum supporting plotly streamingplots
    Ported over from FORTRAN-90
--------------------------------------------------------------------"""
import numpy as np
from numpy import sin, cos, pi


def rk4(state):
    """ fourth order Runge Kutta process """

    k1 = np.zeros(numeq, dtype=float)
    k2 = np.zeros(numeq, dtype=float)
    k3 = np.zeros(numeq, dtype=float)
    k4 = np.zeros(numeq, dtype=float)
    state2 = np.zeros(numeq, dtype=float)
    state3 = np.zeros(numeq, dtype=float)
    dydt = np.zeros(numeq, dtype=float)

    dydt = f(state)  # first step
    for i in range(0, numeq):
        k1[i] = h * dydt[i]
        state2[i] = state[i] + 0.5 * k1[i]

    dydt = f(state2)  # second step
    for i in range(0, numeq):
        k2[i] = h * dydt[i]
        state2[i] = state[i] + 0.5 * k2[i]

    dydt = f(state2)  # third step
    for i in range(0, numeq):
        k3[i] = h * dydt[i]
        state2[i] = state[i] + k3[i]

    dydt = f(state2)  # fourth step
    for i in range(0, numeq):
        k4[i] = h * dydt[i]
        state3[i] = state[i] + k1[i] / 6 + k2[i] / 3 + k3[i] / 3 + k4[i] / 6

    return state3


def f(state):
    """ Time derivatives (simplified expressions obtained with matlab) """

    # Initial derivative array (zeros)
    dxdt = np.zeros_like(state)
    delta = state[2] - state[0]  # difference in angles

    dxdt[0] = state[1]
    denom1 = (mass1 + mass2) * len1 - mass2 * len1 * cos(delta) * cos(delta)
    dxdt[1] = (mass2 * len1 * state[1] * state[1] * sin(delta) * cos(delta) +
               mass2 * g * sin(state[2]) * cos(delta) +
               mass2 * len2 * state[3] * state[3] * sin(delta) -
               (mass1 + mass2) * g * sin(state[0])) / denom1

    dxdt[2] = state[3]
    denom2 = (len2 / len1) * denom1
    dxdt[3] = (-mass2 * len2 * state[3] * state[3] * sin(delta) * cos(delta) +
               (mass1 + mass2) * g * sin(state[0]) * cos(delta) -
               (mass1 + mass2) * len1 * state[1] * state[1] * sin(delta) -
               (mass1 + mass2) * g * sin(state[2])) / denom2
    return dxdt


# main loop
if __name__ == '__main__':

    """ Variable definitions:
        t: array holding time increments dt
        state: array holding the values of theta1, theta2,
            omega1, omega2 for a given value of t
        N: number of increments
        numeq: number of equations to be simultaneously solved
        h: step size/increment
        len1: length of member 1 (upper pendulum)
        len2: length of member 2 (lower pendulum)
        mass1: mass 'at end of' member 1
        mass2: mass 'at end of' member 2
        g: acceleration due to gravity
        rad: one radian
        theta1: angle member 1 makes with the vertical
        theta2: angle member 2 makes with the vertical
        omega1: angular velocity of member 1
        omega2: angular velocity of member 2 """

    # Output file
    fid = open("dp_data.dat", "wb")

    len1 = 0.7
    len2 = 0.45
    mass1 = 1.5
    mass2 = 1
    g = 9.81
    rad = pi / 180
    N = 1000
    numeq = 4

    theta1 = np.zeros(N, dtype=float)
    theta2 = np.zeros(N, dtype=float)
    omega1 = np.zeros(N, dtype=float)
    omega2 = np.zeros(N, dtype=float)
    theta1[0] = 3.0
    theta2[0] = 0
    # omega1[0] = 0
    omega2[0] = 4.1
    statei = np.zeros(numeq, dtype=float)
    stateo = np.zeros(numeq, dtype=float)
    # new_state = state

    tmin = 0
    tmax = 100
    t = np.zeros(N, dtype=float)  # time values
    h = (tmax - tmin) / N
    for i in range(0, N):
        t[i] = tmin + h * i

    # Main loop
    for i in range(1, N):
        statei[0] = theta1[i - 1]
        statei[1] = omega1[i - 1]
        statei[2] = theta2[i - 1]
        statei[3] = omega2[i - 1]

        stateo = rk4(statei)

        theta1[i] = stateo[0]
        omega1[i] = stateo[1]
        theta2[i] = stateo[2]
        omega2[i] = stateo[3]

    # Write to output file
    thetas = np.array([t, theta1, theta2])
    thetas = thetas.T
    np.savetxt(fid, thetas)
    fid.close()
