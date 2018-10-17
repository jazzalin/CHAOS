!James Azzalini - 4th order Runge Kutta method implementation
!DEPRECATED
        module parameters
              implicit none

              real, parameter :: m1 = 1.5, m2 = 1, L1 = 0.7, L2 = 0.45
              real, parameter :: g = 9.81

        end module parameters

        program rk4
              implicit none

              interface
                  function f (t,y)
                     implicit none
                     real(kind=kind(1.0D0)), intent(in) :: y,t
                     real(kind=kind(1.0D0)) :: f
                  end function
              end interface

              real(kind=kind(1.0D0)), parameter :: dt,ti,tf
              real(kind=kind(1.0D0)) :: t
              real(kind=kind(1.0D0)) :: y,h1,h2,h3,h4

              ti = 0.0D0
              tf = 10.0D0
              dt = 0.1D0
              !Need initial condition: y = ?
              t = ti
              do while (t .lt. tf)
                ! RK4 code
                h1 = f(t,y)
                h2 = f(t + 0.5D0 * dt, y + 0.5D0 * dt * h1)
                h3 = f(t + 0.5D0 * dt, y + 0.5D0 * dt * h2)
                h4 = f(t + dt, y + dt * h3)
                y = y + dt * (h1 + 2.0D0 * (h2 + h3) + h4)/ 6.0D0
                t = t + dt
              end do
      end program rk4

      function f (t,y)
              use parameters
              implicit none

              real(kind=kind(1.0D0)), intent(in) :: y,t
              real(kind=kind(1.0D0)) :: f
              real(kind=kind(1.0D0)) :: th1,th2,w1,w2
                        
              ! function expression
      end function 
