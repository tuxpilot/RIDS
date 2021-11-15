#!/usr/bin/env python3
import serial,time

if __name__ == '__main__':
    with serial.Serial("/dev/ttyARDUINO", 9600, timeout=1) as arduino:
        time.sleep(0.1) #wait for serial to open
        if arduino.isOpen():
            print("{} connected!".format(arduino.port))

    ser = serial.Serial('/dev/ttyARDUINO', 9600, timeout=1)
    ser.flush()
    while True:
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            #print(line)
            f = open('arduino_capture.txt', 'a')
            f.write(line+"\n")
            f.close()



