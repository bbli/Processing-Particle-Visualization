import pandas as pd
import datetime
import numpy as np

path1='/home/benson/Dropbox/Code/Projects/Mat259_3D/raw_data/programming_languages.csv'
path2='/home/benson/Dropbox/Code/Projects/Mat259_3D/raw_data/networking.csv'
path3='/home/benson/Dropbox/Code/Projects/Mat259_3D/raw_data/machine_learning.csv'
path4='/home/benson/Dropbox/Code/Projects/Mat259_3D/raw_data/software.csv'

paths = [path1, path2, path3, path4]


def data_extractor(path, number_of_days=4500):
    number = number_of_days 
    df = pd.read_csv(path)
    df['cin'] = df['cin'].shift(1)
    shifted_df= df.groupby('itemNumber').apply(lambda group: group.iloc[1:])


    ################################################################
    def stringToDatetime(string):
        return datetime.datetime.strptime(string, '%Y-%m-%d %H:%M:%S')

    shifted_df['cout_date']= shifted_df['cout'].apply(stringToDatetime)
    shifted_df['cin_date']= shifted_df['cin'].apply(stringToDatetime)
    shifted_df['time_diff_date']= shifted_df['cout_date']- shifted_df['cin_date']

    shifted_df['time_diff']= shifted_df['time_diff_date'].apply(lambda date: date.days)
    ################################################################
    ## Creating a new dataframe for better readability
    filtered_df = shifted_df[shifted_df.time_diff>0]
    cutoff = 90
    def frac_over(series):
        over_sum =0
        for s in series:
            if s>cutoff:
                over_sum += 1
        total = len(series)
        return over_sum/total

    # print frac to make sure we arn't cutting off too much
    print("If this percentage is too high, increase the cutoff variable (current value = {})in this script: {}".format(cutoff, frac_over(filtered_df.time_diff)))
    filtered_df = filtered_df[filtered_df.time_diff<cutoff]
    max_time_diff = filtered_df['time_diff'].max()
    print("Max time diff: {}".format(max_time_diff))
    supply = len(list(filtered_df['itemNumber'].unique()))
    print("Max supply: {}".format(supply))
    ################################################################
    def base_diff(string):
        start= datetime.datetime(2006,1,1,0,0)
        end = datetime.datetime.strptime(string, '%Y-%m-%d %H:%M:%S')
        diff=end-start
        return diff.days

    filtered_df['cout_time']= filtered_df['cout'].apply(base_diff)
    filtered_df['cin_time']= filtered_df['cin'].apply(base_diff)
    # get max time to make sure there is no error
    print("latest checkout time: {}".format(filtered_df['cout_time'].max()))
    print("latest checkout time: {}".format(filtered_df['cin_time'].max()))
    ################################################################
    def checkout_array():
        a=np.zeros(number, dtype ='float64')
        for time in filtered_df.cout_time:
            a[time] +=1
        return a
    def checkin_array():
        a=np.zeros(number, dtype = 'float64')
        for time in filtered_df.cin_time:
            a[time] +=1
        return a
    def timediffs_array():
        a=np.zeros(number, dtype = 'float64')
        for i,time in enumerate(filtered_df.cout_time):
            a[time] += filtered_df["time_diff"][i]
        return a

    checkouts = checkout_array()
    checkins = checkin_array()
    time_diffs = timediffs_array()
    final_time_diffs = np.divide(time_diffs, checkouts,
            out= np.zeros_like(time_diffs), where=(checkouts!=0))
    # checking with my jupyter notebook
    print("Average checkouts per day: {}".format(checkouts.mean()))
    print("Unnormalized time diffs average: {}".format(time_diffs.mean()))
    print("Normalized time diffs average: {}".format(final_time_diffs.mean()))

    influx = checkouts - checkins
    return influx, final_time_diffs, supply, max_time_diff

number_of_days = 4500
dataset= np.zeros((number_of_days,2*len(paths)), dtype='float64')

if __name__ == '__main__':
    global_max_time_diff =0
    global_max_supply =0
    for i,item in enumerate(paths):
        print("Logs for title {}".format(i))
        influx, final_time_diffs, supply, max_time_diff = data_extractor(item, number_of_days)
        dataset[:,2*i] = influx
        dataset[:,2*i+1] = final_time_diffs
################################################################
        if max_time_diff>global_max_time_diff:
            global_max_time_diff= max_time_diff
        if supply> global_max_supply:
            global_max_supply = supply
################################################################
    print("Change the max_supply variable in the Mat259_3D pde file to: {}".format(global_max_supply))
    print("Change the max_time_diff variable in the Mat259_3D pde file to: {}".format(global_max_time_diff))
    np.savetxt("dataset.csv", dataset, delimiter = ',')
        
