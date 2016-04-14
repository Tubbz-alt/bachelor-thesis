import matplotlib.pyplot as plt
import matplotlib.pylab as mpl
import matplotlib
import numpy as np
import commpy
import scipy.signal





def awgn(input_signal, snr_dB, rate=1.0):
    """
    Addditive White Gaussian Noise (AWGN) Channel.
    Parameters
    ----------
    input_signal : 1D ndarray of floats
        Input signal to the channel.
    snr_dB : float
        Output SNR required in dB.
    rate : float
        Rate of the a FEC code used if any, otherwise 1.
    Returns
    -------
    output_signal : 1D ndarray of floats
        Output signal from the channel with the specified SNR.
    """

    avg_energy = sum(input_signal * input_signal)/len(input_signal)
    snr_linear = 10**(snr_dB/10.0)
    noise_variance = avg_energy/(2*rate*snr_linear)

    if input_signal.dtype is complex:
        noise = (sqrt(noise_variance) * np.random.randn(len(input_signal))) + (np.sqrt(noise_variance) * np.random.randn(len(input_signal))*1j)
    else:
        noise = np.sqrt(2*noise_variance) * np.random.randn(len(input_signal))

    output_signal = input_signal + noise

    return output_signal






fs = 1000
t100ms = np.arange(0, .1, 1.0/fs)
t200ms = np.arange(0, .2, 1.0/fs)
t800ms = np.arange(0, .8, 1.0/fs)
t900ms = np.arange(0, .9, 1.0/fs)
f0 = 77.5
phi = 0
Alow = .25
Ahigh = 1.0

startbit = Ahigh*np.sin(2*np.pi*f0*np.arange(0, 1, 1.0/fs))
startbitn = Ahigh*np.sin(2*np.pi*f0*np.arange(0, 1, 1.0/fs)+np.pi)
one = startbit * np.append(np.ones(fs/10)*.25, np.ones(fs*(9/10)))
onen = startbitn * np.append(np.ones(fs/10)*.25, np.ones(fs*(9/10)))
#zero = np.append(Alow*np.sin(2*np.pi*f0*t100ms), Ahigh*np.sin(2*np.pi*f0*t900ms))
#one = Ahigh*np.sin(2*np.pi*f0*np.arange(0, 1, 1.0/fs)) * (np.append()

s = startbit

a = np.sin(2*np.pi*77.5*np.arange(0,1,1.0/fs))
aa = np.sin(2*np.pi*77.5*np.arange(0,1,1.0/fs)+np.pi)
b = np.sin(2*np.pi*100*np.arange(0,1,1.0/fs))

s = awgn(s, -30)

plt.subplot(6,2,1)
plt.margins(0.05)
plt.grid()
plt.plot(s)

plt.subplot(6,2,2)
plt.margins(0.05)
plt.grid()
plt.plot(abs(np.fft.fft(s))[:fs/2])

filtered =s
taps = scipy.signal.firwin(fs, [.147, .164], window='hamming', pass_zero=False)
filtered = np.convolve(filtered, taps, mode='same')
#filtered=awgn(filtered, 10)

plt.subplot(6,2,3)
plt.margins(0.05)
plt.grid()
plt.plot(filtered)

plt.subplot(6,2,4)
plt.margins(0.05)
plt.grid()
plt.plot(abs(np.fft.fft(filtered))[:fs/2])

def Rxy(inx, iny):
	sx = np.size(inx)
	sy = np.size(iny)
	rxy = np.zeros(sx)
	for t in range(sx):
		tmp = 0
		for n in range(fs):
			if (n+t < sx):
				tmp += inx[n]*iny[n+t]
		rxy[t] = tmp
	return rxy

def Rxx(inx):
	return Rxy(inx, inx)

sr = Rxx(filtered)

plt.subplot(6,2,5)
plt.margins(0.05)
plt.grid()
plt.plot(sr)


plt.subplot(6,2,6)
plt.margins(0.05)
plt.grid()
plt.plot(abs(np.fft.fft(sr))[:fs/2])

sr = Rxx(sr)

plt.subplot(6,2,7)
plt.margins(0.05)
plt.grid()
plt.plot(sr)


plt.subplot(6,2,8)
plt.margins(0.05)
plt.grid()
plt.plot(abs(np.fft.fft(sr))[:fs/2])


sr = Rxx(sr)

plt.subplot(6,2,9)
plt.margins(0.05)
plt.grid()
plt.plot(sr)


plt.subplot(6,2,10)
plt.margins(0.05)
plt.grid()
plt.plot(abs(np.fft.fft(sr))[:fs/2])


plt.tight_layout()
plt.show()

