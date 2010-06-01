from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension("bloopsa", ["ext/python/bloopsaphone.pyx"],
                         include_dirs=["c"],
                         libraries=["bloopsaphone", "portaudio"],
                         library_dirs=["."])]

setup(
  name = 'bloopsaphone',
  cmdclass = {'build_ext': build_ext},
  ext_modules = ext_modules
)
