import numpy as np

file_name = 'RF_data.txt'
a = np.random.randint(low = 0, high = 2**32-1,size = 31)
with open('RF_data.txt','w') as f :
	f.write('0x00000000' + '\n')
	for i in a :
		f.write(str(hex(i))[2:].zfill(8)+'\n')
a = np.arange(1024)
with open('imem_data.txt','w') as f:
	for i in a :
		f.write(str(hex(i))[2:].zfill(8)+'\n')
with open('imem_init.coe','w') as f:
	f.write('memory_initialization_radix=16'+';'+'\n')
	f.write('memory_initialization_vector=')
	for i in a:
		f.write('\n'+str(hex(i))[2:].zfill(8)+',')
	f.write(';')
with open('dmem_data.txt','w') as f:
	for i in a :
		f.write(str(hex(i))[2:].zfill(8)+'\n')
