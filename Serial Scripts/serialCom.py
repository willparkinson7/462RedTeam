import serial
ser = serial.Serial('/dev/ttyUSB0')  # open serial port, USB is the device found, may need to change the 0 to some other number
ser.baudrate = 115200
print(ser.name)         # check which port was really used
count = 0
bytestring = b'1'
while count < 4095:
    bytestring = bytestring+b'1'
    count += 1
print (bytestring)
numOfBytes = ser.write(bytestring)     # write a string
bytesRead = ser.read(bytestring.count)
if(numOfBytes == bytestring.count):
    print("Success")
else:
    print("Failed")
print("Bytes Read:")
print(bytesRead)
ser.close()             # close port
