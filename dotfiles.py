#!/usr/bin/env python
import os
import subprocess

### Python 2 compatability
try:
    input = raw_input
except NameError:
    pass


def get_git_root():
    p = subprocess.Popen('git rev-parse --show-toplevel',
            shell=True, cwd=os.path.dirname(os.path.abspath(__file__)),
            stdout=subprocess.PIPE)
    stdout, _ = p.communicate()
    return stdout.decode('utf-8').strip()
GIT_ROOT = get_git_root()

HOME = os.path.expanduser('~')

SPECIAL = {
    os.path.basename(__file__): None,
    'README.markdown': None,
    '.git': None,
    '.gitmodules': None,
    '.gitignore': None,
    'wmfs': '~/.config/wmfs',
    'conky': '~/.config/conky',
    'irssi': None,
    }


def _external(cmd, cwd=None):
    subprocess.check_call(cmd, shell=True, cwd=cwd)


def _install(src, dst):
    if os.path.lexists(dst):
        if os.path.islink(dst):
            os.remove(dst)
        else:
            candidate = '%s.bak' % dst
            i = 0
            while os.path.exists(candidate):
                candidate = '%s.bak.%d' % (dst, i)
                i += 1
            os.rename(dst, candidate)

    try:
        os.symlink(src, dst)
        print("Symlinked %s to %s" % (dst, src))
    except:
        print("Skipped %s" % dst)


def preprocess():
    _external('git submodule init', cwd=GIT_ROOT)
    _external('git submodule update', cwd=GIT_ROOT)


def symlink_dotfiles():
    for name in os.listdir(GIT_ROOT):
        src = os.path.join(GIT_ROOT, name)

        if name in SPECIAL:
            dst = SPECIAL[name]
        elif name.startswith('.'):
            dst = os.path.join(HOME, name)
        else:
            dst = os.path.join(HOME, '.' + name)

        if dst is not None:
            _install(src, os.path.expanduser(dst))


def postprocess():
    _external('git checkout master', cwd=os.path.join(GIT_ROOT, 'vim'))
    _external('git pull', cwd=os.path.join(GIT_ROOT, 'vim'))
    _external('rake', cwd=os.path.join(GIT_ROOT, 'vim'))


def main():
    preprocess()
    symlink_dotfiles()
    postprocess()

if __name__ == '__main__':
    main()
