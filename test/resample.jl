using TimeSeries: TimeArray
using TimeSeriesResampler: resample, TimeFrame, ohlc, mean, sum
using TimeFrames: Minutely

function variation(a; n=1)
    a[1+n:end] - a[1:end-n]
end

# Define a sample timeseries (prices for example)
idx = DateTime(2010,1,1):Dates.Minute(1):DateTime(2010,4,1)
idx = idx[1:end-1]
N = length(idx)
y = rand(-1.0:0.01:1.0, N)
y = 1000 + cumsum(y)
#df = DataFrame(Date=idx, y=y)
ta = TimeArray(collect(idx), y, ["y"])
#println("ta=")
#println(ta)

# Define how datetime should be grouped (timeframe)
a_tf = [
    TimeFrame(dt -> floor(dt, Dates.Minute(15))),  # using a lambda function
    TimeFrame(Minutely(15)),  # using a TimeFrame object (from TimeFrames.jl)
    TimeFrame("15T"),  # using a string TimeFrame shortcut to create a TimeFrame
    "15T",  # using a string TimeFrame shortcut 
]
for tf in a_tf
    println(tf)
    
    # resample using OHLC values
    ta_ohlc = ohlc(resample(ta, tf))
    #println("ta_ohlc=")
    #println(ta_ohlc)

    # resample using mean values
    ta_mean = mean(resample(ta, tf))
    #println("ta_mean=")
    #println(ta_mean)

    # Define an other sample timeseries (volume for example)
    vol = rand(0:0.01:1.0, N)
    ta_vol = TimeArray(collect(idx), vol, ["vol"])
    #println("ta_vol=")
    #println(ta_vol)

    # resample using sum values
    ta_vol_sum = sum(resample(ta_vol, tf))
    #println("ta_vol_sum=")
    #println(ta_vol_sum)

end