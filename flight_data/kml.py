import csv
from datetime import datetime, timedelta


last_dt = None
# ascent/descent in meters per second
ascent_in_ms = 5.32
descent_in_ms = 9.417 

max_height = 26990
burst_seconds_since_launch = max_height / ascent_in_ms

elev = 0
burst = False
launch_dt = None
burst_dt = None
with open('flight.csv') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        # 10:25:57 AM
        dt = datetime.strptime(row['Time'], '%I:%M:%S %p')
        if not launch_dt:
            launch_dt = dt
#        print dt
#        print(row['Latitude'], row['Longitude'], row['Time'])
#        if not last_dt:
#            last_dt = dt
#            burst_time = dt + timedelta(seconds=burst_seconds_since_launch)


        if "Burst" == row['Event Type']:
            burst = True
            burst_dt = dt
        e = 0
        if burst:
            td = dt - burst_dt 
            #print "Elevation is:", max_height - (td.seconds *  descent_in_ms)
            e = max_height - (td.seconds *  descent_in_ms)
        else:
            td = dt - launch_dt 
            e = (td.seconds *  ascent_in_ms)
        print row['Longitude'] + "," + row['Latitude'] + "," + str(e)

