# Solution for http://projecteuler.net/problem=48
# Author: Angelo Poerio <angelo.poerio@gmail.com>

sum = 0
for i in range(1, 1000 + 1):
	sum += i**i

print "Answer is {0}".format(str(sum)[-10:]) # 9110846700
