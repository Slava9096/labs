import matplotlib.pyplot as plt
import numpy as np


def scale(x):
    return (x - avg) / (maxElement - minElement)


def h(x1, x2):
    return 1 / (1 + np.exp(-(c0 + c1 * x1 + c2 * x2)))


# c0 + c1(x1 - avg1)/(max1 - min1) + c2(x2 - avg2)/(max2 - min2) = 0
# c2(x2 - avg2)/(max2 - min2) = - c0 - c1(x1 - avg1)/(max1 - min1)
# x2 = avg2 + (max2 - min2) / c2 * (-c0 - c1(x1 - avg1)/(max1 - min1))
def findx2(x):
    return avg2 + (max2 - min2) * (-c0 - c1 * (x - avg1) / (max1 - min1)) / c2


def getJ():
    result = 0
    for i in range(m):
        result += -y[i] * np.log(h(x1[i], x2[i])) - (1 - y[i]) * np.log(
            1 - h(x1[i], x2[i])
        )

    return result / m


def gradient0():
    def func():
        return h(x1, x2) - y

    vectorized_gradient = np.vectorize(func)
    return sum(vectorized_gradient())


def gradient1():
    def func():
        return (h(x1, x2) - y) * x1

    vectorized_gradient = np.vectorize(func)
    return sum(vectorized_gradient())


def gradient2():
    def func():
        return (h(x1, x2) - y) * x2

    vectorized_gradient = np.vectorize(func)
    return sum(vectorized_gradient())


x1 = []
x2 = []
y = []
with open("data3.txt") as file:
    for line in file:
        tmp = line.split(" ")
        x1.append(float(tmp[0]))
        x2.append(float(tmp[1]))
        y.append(float(tmp[2]))
m = len(x1)

x1 = np.array(x1)
x2 = np.array(x2)
y = np.array(y)

plt.plot(x1[y == 0], x2[y == 0], "ro")
plt.plot(x1[y == 1], x2[y == 1], "b^")

# Масштабирование

maxElement = max(x1)
minElement = min(x1)
avg = np.sum(x1) / len(x1)
scaledata = np.vectorize(scale)

x1 = scaledata(x1)

max1 = maxElement
min1 = minElement
avg1 = avg

maxElement = max(x2)
minElement = min(x2)
avg = np.sum(x2) / len(x2)

x2 = scaledata(x2)

max2 = maxElement
min2 = minElement
avg2 = avg

c0 = 0
c1 = 0
c2 = 0

step = 0.001
error = 0.0001
estimation = getJ()
while True:
    gradinetC0 = gradient0()
    gradinetC1 = gradient1()
    gradinetC2 = gradient2()
    c0 -= gradinetC0 * step
    c1 -= gradinetC1 * step
    c2 -= gradinetC2 * step
    lastEstimation = estimation
    estimation = getJ()
    if abs(lastEstimation - estimation) <= error:
        break

plt.plot([30, 100], [findx2(30), findx2(100)], "b")
print(c0, c1, c2, estimation, lastEstimation)
plt.show()
