# Solution for http://projecteuler.net/problem=52
# Author: Angelo Poerio <angelo.poerio@gmail.com>
import itertools

def extract_digits(num):
	digs = []
	pows = [1, 10, 10**2, 10**3, 10**4, 10**5, 10**6]
	for pw in pows:
		digs.append((num / pw) % 10)
	digs.sort()
	return digs

def solve():
	for i in itertools.count(2):
		t_digs = [extract_digits(num * i) for num in range(2,7)]
		if all(n == t_digs[0] for n in t_digs):
			return i

n = solve()
print "Answer is {0}".format(n) # 142857

