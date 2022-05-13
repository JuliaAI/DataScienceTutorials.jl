21×3 DataFrame
 Row │ names             scitypes          types
     │ Symbol            DataType          DataType
─────┼──────────────────────────────────────────────────────────────────────
   1 │ customerID        Multiclass{7043}  CategoricalValue{String, UInt32}
   2 │ gender            Multiclass{2}     CategoricalValue{String, UInt32}
   3 │ SeniorCitizen     Continuous        Float64
   4 │ Partner           Multiclass{2}     CategoricalValue{String, UInt32}
   5 │ Dependents        Multiclass{2}     CategoricalValue{String, UInt32}
   6 │ tenure            Continuous        Float64
   7 │ PhoneService      Multiclass{2}     CategoricalValue{String, UInt32}
   8 │ MultipleLines     Multiclass{3}     CategoricalValue{String, UInt32}
   9 │ InternetService   Multiclass{3}     CategoricalValue{String, UInt32}
  10 │ OnlineSecurity    Multiclass{3}     CategoricalValue{String, UInt32}
  11 │ OnlineBackup      Multiclass{3}     CategoricalValue{String, UInt32}
  12 │ DeviceProtection  Multiclass{3}     CategoricalValue{String, UInt32}
  13 │ TechSupport       Multiclass{3}     CategoricalValue{String, UInt32}
  14 │ StreamingTV       Multiclass{3}     CategoricalValue{String, UInt32}
  15 │ StreamingMovies   Multiclass{3}     CategoricalValue{String, UInt32}
  16 │ Contract          Multiclass{3}     CategoricalValue{String, UInt32}
  17 │ PaperlessBilling  Multiclass{2}     CategoricalValue{String, UInt32}
  18 │ PaymentMethod     Multiclass{4}     CategoricalValue{String, UInt32}
  19 │ MonthlyCharges    Continuous        Float64
  20 │ TotalCharges      Continuous        Float64
  21 │ Churn             OrderedFactor{2}  CategoricalValue{String, UInt32}