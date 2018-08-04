import matplotlib
try:
 get_ipython().config
except NameError:
 matplotlib.use("Agg")
