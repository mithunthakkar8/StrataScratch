from itertools import chain
from collections import Counter
def count_friends(user_ids):
    """
    :type user_ids: List[List[int]]
    :rtype: Dict[int, int]
    """
    output = Counter(chain(*user_ids))
    
    return output
