#!/usr/bin/env python
import os
import sys
import inspect
import subprocess

class DotfileInstaller:
    def __init__(self):
        all_methods = inspect.getmembers(self, predicate=inspect.ismethod)
        self.installables = [(name,fn) for (name,fn) in all_methods if name != 'run' and name[0] != '_']

    def bashrc(self):
        self._install('.bashrc')
        self._install('.bash_profile')

    def Xresources(self):
        self._install('.Xresources')

    def xinitrc(self):
        self._install('.xinitrc')

    def vim(self):
        self._install('.vim-pathogen/autoload', '.vim/autoload')
        self._install('.vimrc')
        self._install('.vim')

    def subtle(self):
        print("Not implemented!")

    def awesome(self):
        print("Not implemented!")

    def _install(self, src, dst=None):
        if dst is None:
            dst = os.path.join(os.path.expanduser('~'), src)
        src = os.path.realpath(src)

        if os.path.lexists(dst):
            if os.path.islink(dst):
                print("\tRemoving old symlink!")
                os.remove(dst)
            else:
                print("\t[Warning] %s already exists as a non-link. Renaming!" % dst)
                os.rename(dst, '%s.bak' % dst)
        print("\tSymlinking %s to %s" % (dst, src))
        os.symlink(src, dst)

    def _confirm(self, prompt, default=True):
        sys.stdout.write("%s [Y/n] " % prompt)
        response = input()
        if response == "" or response[0].lower() == 'y':
            return True
        elif response[0].lower() == 'n':
            return False
        else:
            return self._confirm(prompt, default=default)

    def _external(self, cmd, indent=1):
        p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        stdoutdata, _stderrdata = p.communicate()
        for l in stdoutdata.decode('utf-8').splitlines():
            print("%s%s" % ('\t' * indent, l))

    def run(self):
        print("Updating submodules")
        self._external('git submodule init')
        self._external('git submodule update')

        for name,method in self.installables:
            if self._confirm("Install %s?" % name):
                print("Installing %s:" % name)
                method()
                print()

def main():
    di = DotfileInstaller()
    di.run()

if __name__ == '__main__':
    main()
