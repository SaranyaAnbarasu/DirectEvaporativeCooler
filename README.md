# DirectEvaporativeCooler
Modelica model for direct evaporative cooler

Direct evaporative coolers (DECs) are a low-energy cooling alternative to conventional air
conditioning in hot-dry climates. The key component of DEC is the cooling pad/media, which
evaporatively cools the air passing through it. This repository contains two cooling pad models, 
DCE system model and few example models to demonstrate the usage as a pre-cooling component in an
AHU. The CoolingPadLumped model is based on the well known EnergyPlus Cel_Dek cooling pad model.
The physics-based model that is developed using the heat and mass transfer equations.

DirectEvaportiveCooler
   - CoolingPadLumped
   - CoolingPadPhysicsBased
   - BaseClasses
        - PartialCoolingPad
        - PartialDECSys
   - Examples
        - DECSys
        - DECPreCooling
