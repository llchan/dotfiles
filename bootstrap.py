#!/usr/bin/env python

import os
import glob
import shutil

def confirm(prompt='Confirm', default=False):
    default_str = {True: '[Y/n]', False: '[y/N]'}[default]
    while True:
        response = raw_input('{0} {1}: '.format(prompt, default_str)).lower()
        if not response:
            return default
        if response not in ('y', 'n'):
            print('Please enter y or n')
            continue
        return {'y': True, 'n': False}[response]

def process_package(dotfile_root, dirname, test=False):
    print('+--------')
    print('| ' + dirname + (' (dryrun)' if test else ''))
    print('+--------')
    for src in glob.iglob(os.path.join(dotfile_root, dirname, '*.symlink*')):
        filename = os.path.basename(src)
        basename, variant = filename.rsplit('.symlink', 1)
        variant = variant.strip('._-')

        if variant == '':
            dst = os.path.join(os.path.expandvars('$HOME'), '.' + basename)
        elif variant == 'xdg':
            xch = os.environ.get('XDG_CONFIG_HOME', None)
            if xch is None:
                print('| Skipping ' + src)
                continue
            dst = os.path.join(xch, dirname, basename)
        else:
            raise ValueError('Unrecognized symlink variant {0}'.format(variant))

        if os.path.lexists(dst):
            if os.path.realpath(dst) == os.path.realpath(src):
                continue
            if os.path.islink(dst):
                prompt = 'Replace {0}? ({1})'.format(dst, os.readlink(dst))
            else:
                prompt = 'Replace {0}?'.format(dst)
            if not os.path.exists(dst) or confirm(prompt):
                try:
                    if not os.path.islink(dst) and os.path.isdir(dst):
                        print('| rm -rf ' + dst)
                        if not test:
                            shutil.rmtree(dst)
                    else:
                        print('| Would rm ' + dst)
                        if not test:
                            os.remove(dst)
                except OSError:
                    pass
            else:
                print('| Skipping ' + dst)
                continue

        parent = os.path.dirname(dst)
        if not os.path.exists(parent):
            print('| mkdir ' + parent)
            if not test:
                os.makedirs(parent)

        print('| Symlink ' + dst + ' -> ' + src)
        if not test:
            os.symlink(src, dst)
    print('+--------')

def main(packages, test=False):
    packages = set(packages)
    dotfile_root = os.path.abspath(os.path.dirname(__file__))
    for dirname in os.listdir(dotfile_root):
        if not os.path.isdir(os.path.join(dotfile_root, dirname)):
            continue
        if dirname in ('.git',):
            continue
        if not packages or dirname in packages:
            process_package(dotfile_root, dirname, test=test)

if __name__ == '__main__':
    # Use optparse to support old vanilla pythons
    import optparse 
    parser = optparse.OptionParser()
    parser.add_option('-n', '--test', action='store_true')      
    opts, args = parser.parse_args()
    main(args, **vars(opts))
