# This file was generated, do not modify it. # hide
unwanted = [:peripheral_pulse, :nasogastric_tube, :nasogastric_reflux,
        :nasogastric_reflux_ph, :feces, :abdomen, :abdomcentesis_appearance, :abdomcentesis_total_protein]
select!(datac, Not(unwanted));