from collections import deque

def modify_array(arr):
    arr.sort()
    arr = deque(arr)  
    arr2 = []
    
    while arr:
        arr2.append(arr.popleft()) 
        if arr:
            arr2.append(arr.pop())  
    
    return arr2
