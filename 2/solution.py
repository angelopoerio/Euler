# Solution for http://projecteuler.net/problem=2
# Author: Angelo Poerio <angelo.poerio@gmail.com>

prev_1 = 1
prev_2 = 2
sm = 2
while True:
	new_term = prev_1 + prev_2

	if new_term > 4 * 10**6:
		break

	if new_term % 2 == 0:
		sm += new_term

	prev_1 = prev_2
	prev_2 = new_term

print "Answer is {0}".format(sm) # 4613732

