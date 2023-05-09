import cv2
import numpy as np

f = cv2.imread(r"C:\Users\xiaoshuyui\Desktop\aaaaaaaaaaa.png")
print(np.max(f))
print(np.min(f))

f1 = cv2.imread(r"C:\Users\xiaoshuyui\Desktop\bbbbbbbbbbbb.png")
print(np.max(f1))
print(np.min(f1))