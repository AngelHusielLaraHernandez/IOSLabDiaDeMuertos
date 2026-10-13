#!/usr/bin/env python3
"""Hace un commit solo de los Swift compartidos; no hace push."""
import argparse
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = 'OfrendaDiaDeMuertosProyecto/'
PATHSPEC = ':(glob)OfrendaDiaDeMuertosProyecto/**/*.swift'
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('mensaje', help='Mensaje del commit')
args = parser.parse_args()
if not args.mensaje.strip():
    parser.error('El mensaje no puede estar vacío.')

def git(*args, capture=False):
    return subprocess.run(['git', '-C', str(ROOT), *args], check=True,
                          stdout=subprocess.PIPE if capture else None)

branch = git('branch', '--show-current', capture=True).stdout.decode().strip()
if branch in ('', 'main', 'master'):
    sys.exit('Esta prueba debe hacerse en la rama beta o en tu rama de trabajo; cambia de rama primero.')
if git('diff', '--name-only', '--diff-filter=U', capture=True).stdout:
    sys.exit('Hay conflictos pendientes. Resuélvelos antes de preparar un commit.')

def swift_only(path):
    return path.startswith(SOURCE) and path.endswith('.swift')

staged = git('diff', '--cached', '--name-only', '--no-renames', '-z', capture=True).stdout
other = [p.decode() for p in staged.split(b'\0') if p and not swift_only(p.decode())]
if other:
    sys.exit('No se hizo el commit: hay archivos preparados que no son Swift.\n' + '\n'.join(other))
git('add', '-A', '--', PATHSPEC)
paths = git('diff', '--cached', '--name-only', '--no-renames', '-z', capture=True).stdout
if not paths:
    print('No hay cambios en los Swift compartidos. No se creó un commit.')
    sys.exit(0)
if any(not swift_only(p.decode()) for p in paths.split(b'\0') if p):
    sys.exit('No se hizo el commit: la selección contiene archivos que no son Swift.')
git('diff', '--cached', '--check')
git('commit', '-m', args.mensaje)
print('Commit creado únicamente con Swift. El push queda como un paso separado y explícito.')
