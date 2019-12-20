Rotary double inverted pendulum
=============================

Setup
-----

1. Run ```setup_dbip.m``` to initialize setup and load state-space model from ```DBIP_ABCD_eqns.m``` into the workspace
2. Open the Simulink controller ```q_dbip.mdl```
3. Select **QUARC > Build** to compile the controller code
4. Connect Simulink interface to hardware by clicking **Connect to target**
5. Turn on amplifier switch (ensure it is set to 1x amplifier gain)
6. Start the controller by clicking **Run** in Simulink
7. Stop the controller by clicking **Stop** (make sure to catch the pendulum if in high-high position)


