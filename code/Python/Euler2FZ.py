from eulerangles import euler2matrix
import numpy as np
import os


def Euler2FZ(eulers):
    rotation_matrix = euler2matrix(eulers,
                               axes='zyz',
                               intrinsic=True,
                               right_handed_rotation=True)
    l, a, b = rotation_matrix.shape
    euler_fz = np.zeros([l,3])
    euler_fz[:, 0] = np.arctan2(rotation_matrix[:,2,0],-rotation_matrix[:,2,1])
    index = (euler_fz[:,0] < 0)
    while sum(index)>0:
        euler_fz[:,0] =  euler_fz[:,0] + index*2*3.1415926 
        index = (euler_fz[:,0] < 0)
    euler_fz[:, 1] =  np.arccos(rotation_matrix[:, 2, 2])
    euler_fz[:, 2] =  np.arctan2(rotation_matrix[:,0,2], rotation_matrix[:,1,2])
    index = (euler_fz[:,2] < 0)
    while sum(index)>0:
        euler_fz[:,2] =  euler_fz[:,2] + index*2*3.1415926
        index = (euler_fz[:,0] < 0) 
    
    return euler_fz

eulers = np.array([[30, 60, 75], [90, 90, 45 ]])
euler_fz = Euler2FZ(eulers)
print(euler_fz)


