!James Azzalini - 4th order Runge Kutta method implementation
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
                t = t + dt
              end do
      end program rk4

      function f (t,y)
              implicit none
              real(kind=kind(1.0D0)), intent(in) :: y,t
              real(kind=kind(1.0D0)) :: f
              ! function expression
      end function 
