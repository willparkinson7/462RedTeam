import serial
print("Enter the COM number for the FPGA please, this will be an int")
devNum = input()
dev = 'COM' + devNum
print(dev)
ser = serial.Serial(dev)  # open serial port, USB is the device found, may need to change the 0 to some other number
ser.baudrate = 115200
print(ser)         # check which port was really used
count = 0
#bytestring = b'1'
while count < 4095:
    instr = input().encode()
    strLen= ser.write(instr)
    ser.read(strLen)
    print("\nString: ")
    print(instr.decode())
    print("Length: ")
    print(strLen)
    count+= strLen
#while count < 4095:
#    bytestring = bytestring+b'1'
#    count += 1
#print (bytestring)
#numOfBytes = ser.write(bytestring)     # write a string
#print("numOfBytes, bytestringCount: ")
#print(numOfBytes)
#print(len(bytestring))

#if(numOfBytes == len(bytestring)):
#    print("Success")
#else:
#    print("Failed")

#bytesRead = ser.read(numOfBytes)
#print("Bytes Read:")
#print(len(bytesRead))
ser.close()             # close port
