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
        return {'y': True, 'n': False}

def process_package(dotfile_root, dirname, test=False):
    print(dirname)
    for src in glob.iglob(os.path.join(dotfile_root, dirname, '*.symlink*')):
        filename = os.path.basename(src)
        basename, variant = filename.rsplit('.symlink', 1)
        variant = variant.strip('._-')

        if variant == '':
            dst = os.path.join(os.path.expandvars('$HOME'), '.' + basename)
        elif variant == 'xdg':
            dst = os.path.join(os.path.expandvars('$XDG_CONFIG_HOME'), dirname, basename)
        else:
            raise ValueError('Unrecognized symlink variant {0}'.format(variant))

        if os.path.lexists(dst):
            if os.path.realpath(dst) == os.path.realpath(src):
                continue
            if confirm('Replace {0}?'.format(dst)):
                try:
                    if not os.path.islink(dst) and os.path.isdir(dst):
                        shutil.rmtree(dst)
                    else:
                        os.remove(dst)
                except OSError:
                    pass
            else:
                print('Skipping' + dst)

        parent = os.path.dirname(dst)
        if not os.path.exists(parent):
            os.makedirs(parent)

        os.symlink(src, dst)

def main(test=False):
    dotfile_root = os.path.abspath(os.path.dirname(__file__))
    for dirname in os.listdir(dotfile_root):
        if not os.path.isdir(os.path.join(dotfile_root, dirname)):
            continue
        if dirname in ('.git',):
            continue
        process_package(dotfile_root, dirname, test=test)

if __name__ == '__main__':
    # Use optparse to support old vanilla pythons
    import optparse 
    parser = optparse.OptionParser()
    parser.add_option('-n', '--test', action='store_true')      
    opts, args = parser.parse_args()
    if len(args) != 0:
        parser.error('Incorrect number of arguments! (expect 0, got {0})'.format(len(args)))
    main(**vars(opts))
