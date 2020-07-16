# This file was generated, do not modify it. # hide
using MLJ
using PrettyPrinting
import DataFrames
import Statistics
using CSV
using PyPlot
ioff() # hide
using HTTP
using StableRNGs

MLJ.color_off() # hide

req = HTTP.get("https://raw.githubusercontent.com/rupakc/UCI-Data-Analysis/master/Airfoil%20Dataset/airfoil_self_noise.dat");

df = CSV.read(req.body; header=[
                  "Frequency","Attack_Angle","Chord+Length",
                  "Free_Velocity","Suction_Side","Scaled_Sound"
              ]
       );
df[1:5, :] |> pretty