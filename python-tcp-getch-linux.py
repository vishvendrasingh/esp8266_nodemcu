import socket
import sys, tty, termios, time

def getch():
	fd = sys.stdin.fileno()
	old_settings = termios.tcgetattr(fd)
	try:
		tty.setraw(sys.stdin.fileno())
		ch = sys.stdin.read(1)
	finally:
		termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
	return ch

host = '192.168.1.100'
port = 9003                   # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
while True:
	try:
		n = getch()
		print n
		if n == "8":
			s.sendall(b'1')
		elif n == "2":
			s.sendall(b'2')
		elif n == "4":
			s.sendall(b'3')
		elif n == "6":
			s.sendall(b'4')
		elif n == "0":
			s.sendall(b'0')
		elif n == "5":
			s.sendall(b'0')
		elif n == "q":
			s.sendall(b'0')
			s.close()
			destroy()
		elif n == "Q":
			s.sendall(b'0')
			s.close()
			destroy()
	except KeyboardInterrupt:  # When 'Ctrl+C' is pressed, the child program destroy() will be  executed.#
		destroy()
s.close()
destroy()
