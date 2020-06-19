# # Using Machine Learning Classifiers In Julia To Improve The Retention Rate Of Community College Students
#
# ## Introduction
#
# By Clarman Cruz
#
# March 2020
#
# Years ago, I had the opportunity to go to the university even though I had very low standardized test scores.  The State University of New York saw more than standardized tests on me.  My university accepted me by looking at other factors and correctly predicting I was going to complete the Bachelor Degree and Master Degree.  I have always been grateful for that. And, I have been paying city, state and federal taxes ever since completing the degrees..
#
# Community colleges in the United States are using data analytics in their admission process.  The community colleges are in the hunt to find students with great potential but who might not have great grades in high school.  One example is the project described in  https://www.sas.com/en_us/customers/des-moines-area-community-college.html  “Des Moines Area Community College uses analytics and data visualization to help students prosper in the classroom and beyond.  ... DMACC is using analytics and data visualization from SAS to access, integrate and manage data to help improve student enrollment, retention and graduation rates."
#
# There are three main sections of this jupyter lab.  One section is the "Before Entering the Community College."  The second section is the "While Attending the Community College."  The third section is the "After Graduating from the Community College."  There is a Julia machine learning model per section.  The three machine learning classifiers are chained to another.  It is the author's original modeling design.   The output of [K means](https://juliastats.org/Clustering.jl/stable/kmeans.html) model is the input of the binary [Support Vector Machine](https://www.csie.ntu.edu.tw/~cjlin/libsvm) model.  The output of the binary Support Vector Machine model is the input of the [Random Forrest](https://pkg.julialang.org/docs/DecisionTree/pEDeB/0.8.1) model.  The results of the Random Forest model in turn aid to improve the previous model.  The three machine learning classifiers guide a community college improve their service to students increasing the retention rate.
#
# In this jupyter lab, we assume the data is available for the machine learning models.  The kind of education information involved in this lab is personal and not available to the general public.  Therefore, we randomly create our datasets here.  Yes, random data is far from real educational information.  However, the emphasis here is the implementation of machine learning models, and how we use them to better retain community college students.
#
# ## MLJ Julia Package
#
# This jupyter lab is in [Julia](https://julialang.org) 1.31.  The machine learning models are implemented using the [MLJ](https://alan-turing-institute.github.io/MLJTutorials) Julia package.  The MLJ package is a very good machine learning framework.  The [Alan Turing Institute](https://www.turing.ac.uk) sponsors the package and MLJ supports most of the machine learning models in Julia.  MLJ "offers a consistent way to use, compose and tune machine learning models in Julia.  ... MLJ unlocks performance gains by exploiting Julia's support for parallelism, automatic differentiation, GPU, optimisation etc."  The MLJ Julia package is well documented and easy to use.  It allows model tuning, fit, predict, and transform.

using MLJ
using PrettyPrinting
import Random
import DataFrames: DataFrame, select!, nrow, Not, select

@load KMeans pkg = Clustering
@load PCA    pkg = MultivariateStats
@load SVC    pkg = LIBSVM
@load RandomForestClassifier pkg=DecisionTree

# ## Before Entering the Community College
#
# The admission office needs a way to classify the high school students who are applying to the community college. Let's give them a machine learning model to do so.  We need a machine learning model that is easy to understand.  Also, the model should be easy to share among community college staff and high school administrators. A model that is graphically visual would be best.  K means is a great machine learning classifier because it is easy to interpret graphically.
#
# Let us assume that the community college has a strong relationship with the local high schools.  The high schools are collecting data on their students and sharing with the community college.  The first step for the community college is to clean up the collected high school data.  Delete any duplicated rows or rows with more than 70% missing values.   Delete any columns with more than 75% missing values.  Find any outliers in the numerical values, fix typos in string data, and ensure the categorical values are consistent within range.  Use mean or use regression with perturbation to impute values for the missing data.  Create some graphs to visualize the high school data.  Usually visualizations show outliers, data patterns, improper categories, or data inconsistencies.
#
# As stated before, due to privacy, we are making up the datasets in this lab.  Let us assume all of the the parents of the high school students have at least a GED because in the United States and Canada there is a law to provide K12 education to all students.  Wikipedia explains that "The General Educational Development (GED) tests are a group of four subject tests which, when passed, provide certification that the test taker has United States or Canadian high school-level academic skills."  We assume that parents with Master degrees are more likely to be employed than parents without a Master degree.  Do you agree with both assumptions?
#
# The K means model is efficient, and flexible. The K means classifier works best for numerical data because the algorithm computes a distance between data points.  We convert any categorical data to a number by converting categorical values to a set of binary values called one-hot-encoders.  Here, parents' employment status and single family become binary 0 or 1.  Let the parent’s education level be the highest grade completed by one of the parents.  For example, 16 is a Bachelor degree and 18 is a Master Degree.  The hobbies are a scale from 1 to 10 where 1 is low activity and 10 is high activity.
#
# In addition, we must normalize our data before we fit it to K means model and other machine learning models.  The result of normalization is to scale the original values to a range between 0 and 1.  We let the MLJ compute the [PCA](https://multivariatestatsjl.readthedocs.io/en/stable/index.html) and the normalization for us.
# Now it is time to create the random data set.

nStudents = 1000
dfHighSchoolStudents = DataFrame(
    ParentsEducationLevel = Int[],
    ParentsEmploymentStatus = Int[],
    SingleParentFamily = Int[],
    ZipCode = Int[],
    SiblingsInCollege = Int[],
    AbsentDays = Int[],
    TotalSchoolGrade = Int[],
    StandardizedTestScore = Int[],
    MathAverageGrade = Int[],
    ScienceAverageGrade = Int[],
    ReadingAverageGrade = Int[],
    WritingAverageGrade = Int[],
    CookingHobby = Int[],
    SportsHobby = Int[],
    MusicHobby = Int[],
    CommunityService = Int[],
    SocialMedia = Int[]
)

Random.seed!(20200226)
for s in 1:nStudents
    ParentsEducationLevel = rand(12:12+4+2+4) # K12 + Bachelor + Master + Doctorate
    ParentsEmploymentStatus = rand(0:1)
    if ParentsEducationLevel > 12+4+2  && ParentsEmploymentStatus == 0
        ParentsEmploymentStatus = rand(0:1)
    end
    SingleParentFamily = rand(0:1)
    ZipCode = rand(1:5)
    SiblingsInCollege = rand(0:4)
    AbsentDays = rand(0:13)
    TotalSchoolGrade = rand(50:100)
    StandardizedTestScore = rand(30:100)
    MathAverageGrade = rand(50:100)
    ScienceAverageGrade = rand(50:100)
    ReadingAverageGrade = rand(50:100)
    WritingAverageGrade = rand(50:100)
    CookingHobby = rand(1:10)
    SportsHobby = rand(1:10)
    MusicHobby = rand(1:10)
    CommunityService = rand(1:10)
    SocialMedia = rand(1:10)

    push!(dfHighSchoolStudents,
        (ParentsEducationLevel,
        ParentsEmploymentStatus,
        SingleParentFamily,
        ZipCode,
        SiblingsInCollege,
        AbsentDays,
        TotalSchoolGrade,
        StandardizedTestScore,
        MathAverageGrade,
        ScienceAverageGrade,
        ReadingAverageGrade,
        WritingAverageGrade,
        CookingHobby,
        SportsHobby,
        MusicHobby,
        CommunityService,
        SocialMedia)
    )
end

first(dfHighSchoolStudents, 3)

# And, let us define the scientific types for each column.  It is important that the machine learning algorithm handles our data correctly.  Each column is given a business-interpretation.

dfHighSchoolStudentsScientific = coerce(dfHighSchoolStudents,
    :ParentsEducationLevel   => OrderedFactor,
    :ParentsEmploymentStatus => OrderedFactor,
    :SingleParentFamily      => OrderedFactor,
    :ZipCode                 => OrderedFactor,
    :SiblingsInCollege       => Count,
    :AbsentDays              => Count,
    :TotalSchoolGrade        => Continuous,
    :StandardizedTestScore   => Continuous,
    :MathAverageGrade        => Continuous,
    :ScienceAverageGrade     => Continuous,
    :ReadingAverageGrade     => Continuous,
    :WritingAverageGrade     => Continuous,
    :CookingHobby            => Count,
    :SportsHobby             => Count,
    :MusicHobby              => Count,
    :CommunityService        => Count,
    :SocialMedia             => Count
)

first(dfHighSchoolStudentsScientific, 3)

# Very quickly, we are ready to use K means to classify the high school students who are applying to the community college. K means clustering with K = 4.  The four clusters are “strong” students,  “good” students, “fair” students, and “at-risk” students.  The main and only emphasis is not standardized scores and high school total grade.  About 85% of the variance is explained with 7 PCA dimensions.

@pipeline SPCA(std = Standardizer(),
               pca = PCA(),
               hot = OneHotEncoder(),
               km  = KMeans(k=4))
X = dfHighSchoolStudentsScientific
pipe = SPCA()
Kmeans = machine(pipe, X)
fit!(Kmeans)

mach = report(Kmeans).machines
pca_idx = findfirst(m -> m.model isa PCA, mach) # 3
pca_report = report(Kmeans).report_given_machine[mach[pca_idx]]

km_report = report(Kmeans).report_given_machine[first(mach)]
assignments = km_report.assignments

cs = cumsum(pca_report.principalvars ./ pca_report.tvar)

figure(figsize=(8, 6))
bar(1:length(cs), cs)
xlabel("Number of principal components", fontsize=14)
ylabel("Proportion of explained variance", fontsize=14)
xticks(1:length(cs), fontsize=12)
xlim([0, length(cs)+1])
yticks(fontsize=12)

savefig(joinpath(@OUTPUT, "EX-community-pca1.svg")) # hide

# Next, the cluster assignments from the K mean model are mapped to the high school students.

dfKmeans = copy(dfHighSchoolStudentsScientific)
dfKmeans.cluster = categorical(assignments)

hobbies = [:SportsHobby, :CookingHobby, :MusicHobby]
dfKmeans.Hobby_mean = sum(eachcol(dfKmeans[:, hobbies])) / length(hobbies)

social = [:CommunityService, :SocialMedia]
dfKmeans.Social_mean = sum(eachcol(dfKmeans[:, social])) / 2

group1 = dfKmeans.cluster .== 1

first(dfKmeans[group1, :], 3)

# Let's try to assess how these clusters compare in terms of grades:

for c in 1:pipe.km.k
    mask = dfKmeans.cluster .== c
    mean_score = round(mean(dfKmeans[mask, :StandardizedTestScore]), digits=1)
    std_score = round(std(dfKmeans[mask, :StandardizedTestScore]), digits=1)
    println("Cluster $c: $mean_score ($std_score)")
end

# Not much difference here but you could investigate further inspecting whether for instance there are more or less absent days in a given cluster and mark the clusters as "strong students", "good", "fair" or "at-risk".

# ## While Attending the Community College
#
# The above shows a four-way classification of high school students who are applying to the community college.
# The  community college staff needs a way to monitor all the students while in the community college.
# Let's give them a machine learning model to do so. We need a machine learning model that is easy to understand. Also, the model should be easy to share among community college teachers and staff.
#
# We feed the four K means cluster to our next machine learning model. Our next model is the binary Support Vector Machine (SVM).  Let us keep more attention to “fair”,  “at-risk” students than to “strong” and “good” students.  The goal is to detect as early as possible students who are in need.  The Support Vector Machine (SVM) classifies which community college students need help or not.  SVM is effective in high dimensional spaces.
#
# The community college runs the binary SVM model at least every month.  Ideally, we should run the SVM classifier weekly. The training data for the SVM model is updated before each run.  In this matter, the community college closely tracks the needs of their students.
#
# Now it is time to create the random data set.  High schools students who were accepted to the community collage are chosen randomly.  Just like K means, SVM requires scientic types for each column., and normalized data.  An important factor is the difference between last semester total grade and the current sementer total grade so far.  Is the student doing better this semester than last semester?  Community college students working part time to pay for school might need more attention for the college.   Lastly, high school related columns are dropped and community college related collumns are added to data set.

rng = Random.MersenneTwister(20200229)

dfCommunity = copy(dfKmeans)
dfCommunity.Accepted = Random.bitrand(rng, nStudents)
filter!(row -> row[:Accepted] == true, dfCommunity);

select!(dfCommunity,[
        :ParentsEducationLevel,
        :ParentsEmploymentStatus,
        :SingleParentFamily,
        :ZipCode,
        :SiblingsInCollege,
        :AbsentDays,
        :TotalSchoolGrade,
        :CommunityService,
        :cluster
        ])

function randomVector( size, range)
     return [rand(range) for r in 1:size]
end


dfCommunity.StudentId = collect(1:nrow(dfCommunity))
dfCommunity.AbsentDays = randomVector( nrow(dfCommunity), collect(0:13))
dfCommunity.TotalSchoolGrade = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.CommunityService = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.TotalMajorGrade = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.TotalNonMajorGrade = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.Major = categorical(randomVector( nrow(dfCommunity), collect(1:8)))
dfCommunity.CounselorVisits = randomVector( nrow(dfCommunity), collect(0:15))
dfCommunity.TeacherOfficeHoursVisits = randomVector( nrow(dfCommunity), collect(0:15))
dfCommunity.ClassesUntilGraduation = randomVector( nrow(dfCommunity), collect(0:16))
dfCommunity.ParttimeWork = categorical(randomVector( nrow(dfCommunity), collect(0:1)))
dfCommunity.TotalPreviousSemesterGrade = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.TotatCurrentSemesterGrade = randomVector( nrow(dfCommunity), collect(50:100))
dfCommunity.SemesterGradeDiffernce = dfCommunity.TotatCurrentSemesterGrade .- dfCommunity.TotalPreviousSemesterGrade

dfCommunityScientific = coerce(dfCommunity,
    :TotalSchoolGrade           => Continuous,
    :TotalMajorGrade            => Continuous,
    :TotalNonMajorGrade         => Continuous,
    :TotalPreviousSemesterGrade => Continuous,
    :TotatCurrentSemesterGrade  => Continuous,
    :SemesterGradeDiffernce     => Continuous)

schema(dfCommunityScientific)

# K means is a unsupervised machine learning model.  K means groups data by  similar features.  On the other hand, SVM is a supervised machine learning model.  SVM requires already known answers to predict future answers.  The previously known answers is the train subset.  The community college administrators kept track of students in need in previous semesters.  Then, they use that previous data to train the current semester's SVM model.  They also incorporate the current semester data so far before running the SVM model.
#
# In this lab, we must make up the training subset for the SVM machine learning model.  We are using SVM machine learning model as a binary classifier.   Thus, we need to make up binary answers.  Let's use K means to classify some of the students in the community college.  Divide the data into two halves.  Train the SVM model with the K means classified half.  Then,  predict with the SVM model the other half.
#
# Jason Brownlee says that a [semi-supervised model](https://machinelearningmastery.com/supervised-and-unsupervised-machine-learning-algorithms) is where some of the previous answers are not known.  In this case, "a mixture of supervised and unsupervised techniques can be used.  Many real world machine learning problems fall into this area. This is because it can be expensive or time-consuming to label data as it may require access to domain experts. Whereas unlabeled data is cheap and easy to collect and store."

dfSVM = copy(dfCommunityScientific)
dfSVM.SVM = categorical(randomVector( nrow(dfSVM), collect(1:2)))

@pipeline SPCA2(std = Standardizer(),
                pca = PCA(),
                hot = OneHotEncoder(),
                km  = KMeans(k=2))
X = select(dfSVM, Not([:SVM,:StudentId]))
y = dfSVM.SVM

train, pred = partition(eachindex(y), 0.5, shuffle=true, rng=20200303)

pipe = SPCA2()
Kmeans = machine(pipe, X)
fit!(Kmeans, rows=train)

# XXX XXX


assignments = report(Kmeans).reports[1].assignments
dfSVM[train,:SVM] = categorical(assignments)

r  = report(Kmeans).reports[3]  # 2 or 3
cs = cumsum(r.principalvars ./ r.tvar)

println("Cumulative Variance Explained: ", cs, "\n")
println("K means assignments:  ", assignments)
fitted_params(Kmeans) |> pprint
