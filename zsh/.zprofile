# Setting PATH for Python 3.10 (macOS only)
# The original version is saved in .zprofile.pysave
if [[ "$OSTYPE" == "darwin"* ]]; then
  PATH="/Library/Frameworks/Python.framework/Versions/3.10/bin:${PATH}"
  export PATH
fi
export PYENV_ROOT="$HOME/.pyenv"
