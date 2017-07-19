agent_function args = _createlist 0 args
                      where
                      _createlist t args = (_sublogic t args):_createlist (t+1)
                      _sublogic   t args = recurrance_relation
